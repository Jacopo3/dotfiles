# ─────────────────────────────────────────────
# Funzione: compresspdf
# Uso:
#   compresspdf file.pdf                        → sovrascrive con /ebook
#   compresspdf file.pdf /screen                → sovrascrive con /screen
#   compresspdf file.pdf /printer output.pdf    → salva in output.pdf con /printer
#   compresspdf file.pdf output.pdf             → salva in output.pdf con /ebook
# ─────────────────────────────────────────────
compresspdf() {
    # ── Colori per i messaggi ──────────────────
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local NC='\033[0m' # No Color

    # ── Help ──────────────────────────────────
    if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
        echo -e "${CYAN}Uso:${NC}"
        echo -e "  compresspdf ${YELLOW}<file.pdf>${NC} [${YELLOW}pdfsetting${NC}] [${YELLOW}output.pdf${NC}]"
        echo ""
        echo -e "${CYAN}Argomenti:${NC}"
        echo -e "  ${YELLOW}<file.pdf>${NC}       File PDF da comprimere (obbligatorio)"
        echo -e "  ${YELLOW}[pdfsetting]${NC}     Qualità: /screen /ebook /printer /prepress (default: /ebook)"
        echo -e "  ${YELLOW}[output.pdf]${NC}     File di output (default: sovrascrive l'originale)"
        echo ""
        echo -e "${CYAN}Esempi:${NC}"
        echo -e "  compresspdf documento.pdf"
        echo -e "  compresspdf documento.pdf /screen"
        echo -e "  compresspdf documento.pdf /printer output.pdf"
        echo -e "  compresspdf documento.pdf output.pdf"
        return 0
    fi

    # ── Variabili ─────────────────────────────
    local input="$1"
    local setting="/ebook"   # default
    local output=""
    local overwrite=false

    # ── Validazione input ─────────────────────
    if [[ ! -f "$input" ]]; then
        echo -e "${RED}✗ Errore: file non trovato → '$input'${NC}"
        return 1
    fi

    if [[ "${input##*.}" != "pdf" && "${input##*.}" != "PDF" ]]; then
        echo -e "${RED}✗ Errore: il file non è un PDF → '$input'${NC}"
        return 1
    fi

    # ── Parsing argomenti 2 e 3 ───────────────
    # Arg 2 può essere: un pdfsetting (/screen ecc.) oppure un file output
    # Arg 3 può essere: un file output (solo se arg2 era un pdfsetting)

    local valid_settings=("/screen" "/ebook" "/printer" "/prepress" "/default")

    if [[ -n "$2" ]]; then
        if [[ " ${valid_settings[*]} " == *" $2 "* ]]; then
            # Arg 2 è un pdfsetting
            setting="$2"
            if [[ -n "$3" ]]; then
                # Arg 3 è il file di output
                output="$3"
            fi
        else
            # Arg 2 è il file di output, pdfsetting rimane default
            output="$2"
        fi
    fi

    # ── Gestione overwrite ────────────────────
    if [[ -z "$output" ]]; then
        overwrite=true
        output="$(dirname "$input")/__compresspdf_tmp_$$.pdf"
    fi

    # ── Info pre-compressione ─────────────────
    local size_before
    size_before=$(du -h "$input" | cut -f1)
    echo -e "${CYAN}⟳ Compressione in corso...${NC}"
    echo -e "  File:     ${YELLOW}$input${NC}"
    echo -e "  Setting:  ${YELLOW}$setting${NC}"
    echo -e "  Output:   ${YELLOW}$( $overwrite && echo "sovrascrittura" || echo "$output" )${NC}"

    # ── Esecuzione Ghostscript ─────────────────
    gs \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS="$setting" \
        -dNOPAUSE -dQUIET -dBATCH \
        -sOutputFile="$output" \
        "$input" 2>/dev/null

    local gs_exit=$?

    if [[ $gs_exit -ne 0 ]]; then
        echo -e "${RED}✗ Ghostscript ha restituito un errore (codice: $gs_exit)${NC}"
        [[ -f "$output" ]] && rm -f "$output"
        return 1
    fi

    # ── Sovrascrittura ────────────────────────
    if $overwrite; then
        mv "$output" "$input"
        output="$input"
    fi

    # ── Info post-compressione ────────────────
    local size_after
    size_after=$(du -h "$output" | cut -f1)

    echo -e "${GREEN}✓ Completato!${NC}"
    echo -e "  Peso prima:  ${YELLOW}$size_before${NC}"
    echo -e "  Peso dopo:   ${YELLOW}$size_after${NC}"
    echo -e "  Salvato in:  ${YELLOW}$output${NC}"
}
