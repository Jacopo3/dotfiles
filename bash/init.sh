# --- Banner personale con info di sistema ---
# Mostra solo in shell interattive
case $- in
  *i*) ;;
  *) return ;;
esac

get_public_ip() {
  # Prova 1: hostname -I
  if command -v hostname >/dev/null 2>&1; then
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -n "$ip" ]; then
      echo "$ip"
      return 0
    fi
  fi

  # Prova 2: ip route (molto affidabile)
  if command -v ip >/dev/null 2>&1; then
    ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '/src/ {print $7; exit}')
    if [ -n "$ip" ]; then
      echo "$ip"
      return 0
    fi
  fi

  # Fallback
  echo "N/D"
}

get_private_ip() {
  # Prova 1
  if command -v ip >/dev/null 2>&1; then
    dev=$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}')
    if [[ -n "$dev" ]]; then
      ip=$(ip -4 addr show "$dev" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)
      if [[ -n "$ip" ]]; then
        echo "$ip"; return 0
      fi
    fi
    # Fallback: primo indirizzo globale
    ip=$(ip -4 addr show scope global 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)
    if [[ -n "$ip" ]]; then
      echo "$ip"; return 0
    fi
  fi
  # Fallback con ifconfig
  if command -v ifconfig >/dev/null 2>&1; then
    ip=$(ifconfig 2>/dev/null | awk '/inet / && $2 != "127.0.0.1" {print $2; exit}')
    if [[ -n "$ip" ]]; then
      echo "$ip"; return 0
    fi
  fi
  echo "N/D"
}

get_hostname() {
  if command -v hostnamectl >/dev/null 2>&1; then
    hn=$(hostnamectl --static 2>/dev/null)
    [[ -n "$hn" ]] && { echo "$hn"; return 0; }
  fi
  if command -v hostname >/dev/null 2>&1; then
    hn=$(hostname 2>/dev/null)
    [[ -n "$hn" ]] && { echo "$hn"; return 0; }
  fi
  echo "N/D"
}

get_temperatures() {
  # Metodo 1: sensors con la magia
  if command -v sensors >/dev/null 2>&1; then
    temps=$(sensors 2>/dev/null | awk '
      /(^Core [0-9]+:)|(^Tctl:)|(^Package id [0-9]+:)|(^CPU Temp)|(^temp1:)/ {
        # cattura solo il valore tra +...°C
        for(i=1;i<=NF;i++){
          if($i ~ /^\+?[0-9]+\.[0-9]+°C$/ || $i ~ /^\+?[0-9]+°C$/){
            printf "%s %s\n", $1, $i
          }
        }
      }')
    if [[ -n "$temps" ]]; then
      echo "$temps"; return 0
    fi
  fi

  # Metodo 2: /sys/class/thermal (generico Linux)
  if ls /sys/class/thermal/thermal_zone*/temp >/dev/null 2>&1; then
    out=""
    for z in /sys/class/thermal/thermal_zone*/temp; do
      label="zone$(basename "$(dirname "$z")" | tr -cd '0-9')"
      [[ -f "$(dirname "$z")/type" ]] && label=$(cat "$(dirname "$z")/type")
      t=$(cat "$z" 2>/dev/null)
      # alcune distro riportano millesimi di grado C (es. 42000 = 42.0°C)
      if [[ "$t" =~ ^[0-9]+$ ]]; then
        if (( t > 1000 )); then
          printf -v ctemp "%.1f°C" "$(awk "BEGIN {print $t/1000}")"
        else
          printf -v ctemp "%.1f°C" "$t"
        fi
        out+="${label}: ${ctemp}\n"
      fi
    done
    if [[ -n "$out" ]]; then
      # rimuovi ultima newline
      echo -e "${out%\\n}"; return 0
    fi
  fi

  # Metodo 3: Raspberry Pi (vcgencmd)
  if command -v vcgencmd >/dev/null 2>&1; then
    t=$(/usr/bin/vcgencmd measure_temp 2>/dev/null | sed -E 's/[^0-9\.]//g')
    [[ -n "$t" ]] && { echo "SoC: ${t}°C"; return 0; }
  fi

  echo "N/D"
}


# Dati di sistema
KERNEL_VER=$(uname -r 2>/dev/null)
UPTIME_HUMAN=$(uptime -p 2>/dev/null)
PUBLIC_IP=$(get_public_ip)
PRIVATE_IP=$(get_private_ip)
HOST_NAME=$(get_hostname)
TEMPS=$(get_temperatures)


# Stampa ASCII art + info
cat <<'ASCII'

        88888 888888888.  8888888888.  
        `888  888'   `88b `888'  `888. 
         888  888.   .88P  888.  .888' 
         8J8  8888B88888'  888R88888'  
         888  888'   `88b  888'88b.    
         888  888.   .88P  888  `88b.  
     .8. 88P  88888888P'  o888o  '888b 
     `8888P                            
        [ Configurazione Personale ]   

ASCII

printf "%-12s %s \n" "Hostname:" "${HOST_NAME:-N/D}"
printf "%-12s %s \n" "IP locale:" "${PRIVATE_IP:-N/D}"
printf "%-12s %s \n" "IP online:" "${PUBLIC_IP:-N/D}"
printf "%-12s %s \n" "Kernel:" "${KERNEL_VER:-N/D}"
printf "%-12s %s \n" "Uptime:" "${UPTIME_HUMAN:-N/D}"

# Temperature (multi-riga se presenti)
if [[ -n "$TEMPS" && "$TEMPS" != "N/D" ]]; then
  echo -e "\nTemperature:"
  # Indenta ogni riga delle temperature
  while IFS= read -r line; do
    printf "  %s \n" "$line"
  done <<< "$TEMPS"
else
  printf "%-12s %s \n" "Temperature:" "N/D (installa 'lm-sensors' o verifica /sys)"
fi
echo

