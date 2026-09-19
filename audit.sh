#!/data/data/com.termux/files/usr/bin/bash
# audit-securite-termux - Outil Défensif par mcdlguy7-cmyk
# Usage: uniquement pour analyser TON propre téléphone

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

banniere() {
    clear
    echo -e "${GREEN}"
    echo "  ___   _   _  ___ _____ "
    echo " / _ \ | | | ||   |_ _|_   _|"
    echo "| | | || | | || | | | | | |  "
    echo "| |_| || |_| || | | | | | |  "
    echo " \___/  \___/ |___|___| |_|  "
    echo -e "${NC}"
    echo " AUDIT SECURITE - Mode Défensif"
    echo " Utilisateur: mcdlguy7-cmyk"
    echo "--------------------------------"
}

check_systeme() {
    echo -e "${YELLOW}[*] Infos Système${NC}"
    echo "Modèle: $(getprop ro.product.model)"
    echo "Android: $(getprop ro.build.version.release)"
    echo "Mise à jour sécurité: $(getprop ro.build.version.security_patch)"
    echo ""
    echo "Stockage:"
    df -h | grep -E "data|storage"
    echo ""
    echo "Pourcentage batterie: $(dumpsys battery | grep level | cut -d: -f2)"
}

check_reseau_local() {
    echo -e "${YELLOW}[*] Réseau WiFi local (ton réseau uniquement)${NC}"
    echo "Ton IP locale: $(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')"
    echo "Passerelle: $(ip route | grep default | awk '{print $3}')"
    echo ""
    echo "Note: Pour voir qui est sur ton WiFi, utilise l'appli officielle Fing"
}

nettoyeur_malware() {
    echo -e "${YELLOW}[*] === NETTOYEUR ANTI-MALWARE ===${NC}"
    echo "Cette fonction nettoie uniquement les applis QUE TU AS INSTALLÉES."
    echo ""
    echo "Liste de TES applis non-système:"
    # Commande compatible Android 12+
    cmd package list packages -3 2>/dev/null || pm list packages -3 2>/dev/null || echo "Android bloque la liste. Va dans Paramètres > Applis manuellement."
    echo ""
    read -p "Entre le nom du package à nettoyer (ex: com.exemple.app) ou laisse vide pour annuler: " PACKAGE
    if [ -z "$PACKAGE" ]; then
        echo "[!] Annulé"
        return
    fi
    echo -e "${RED}[*] Arrêt de $PACKAGE...${NC}"
    am force-stop $PACKAGE 2>/dev/null
    echo "[*] Suppression des données temporaires..."
    cmd package clear $PACKAGE 2>/dev/null || pm clear $PACKAGE 2>/dev/null
    echo -e "${GREEN}[OK] Nettoyage des données fait. Pour désinstaller, fais-le depuis Paramètres > Applis > $PACKAGE > Désinstaller pour être sûr.${NC}"
    echo "Redémarre ton téléphone après."
}

menu() {
    while true; do
        banniere
        echo "1. Vérifier système & mises à jour"
        echo "2. Vérifier réseau local"
        echo "3. Vérifier permissions dangereuses (manuel)"
        echo "4. NETTOYER une appli suspecte"
        echo "5. Quitter"
        echo ""
        read -p "Choix [1-5]: " choix
        case $choix in
            1) check_systeme ;;
            2) check_reseau_local ;;
            3) echo ""; echo "Va dans Paramètres > Applications > Permission Manager pour voir les applis qui ont accès à SMS, Localisation, Micro";;
            4) nettoyeur_malware ;;
            5) exit 0 ;;
            *) echo "Choix invalide" ;;
        esac
        echo ""
        read -p "Appuie sur ENTRÉE pour continuer..."
    done
}

menu

