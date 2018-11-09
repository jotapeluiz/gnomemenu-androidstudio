#!/bin/bash

####################################################################
# Script que cria uma entrada no meu Gnome para o Android Studio
# É necessário tornar o script executável com o comando:
# chmod +x android_setup.sh
####################################################################

clear

# recupera a linguagem usada pelo sistema
function getLang() {
    language=$(locale | grep LANG | cut -d= -f2)

    echo ${language:0:5}
}
# traduz a mensagem a partir da linguagem do sistema
function getMsg() {
    lang=$(getLang)
    
    if [ $lang = "pt_BR" ]
    then
        echo "Permissão negada"
    elif [ $lang = "en_US" ]
    then
        echo "Permission denied"    
    else 
        echo ""
    fi 
}

message=$(getMsg)

if [ -z "$message" ]
then
    echo "Nao foi possivel determinar a linguagem usada pelo sistema"
    exit 2
else
    echo "Aguarde pesquisando o binario do android studio..."
    # pesquisa o arquivo binario do android studio
    bin=$(find -O3 / -name "studio.sh" 2>&1 | grep -v "$message")

    if [ -z "$bin" ]
    then
        echo "Binario studio.sh nao encontrado. Encerrando execucao"
        exit 1
    else 
        # armazena o diretorio que o binario se encontra
        path=${bin/\/studio.sh/}
        file="/usr/share/applications/android.desktop"
        
        echo "Binario encontrado em: $bin"
        echo "Criando atalho gnome"

        echo "[Desktop Entry]" > $file
        echo "Encoding=UTF-8" >> $file
        echo "Name=Android Studio" >> $file
        echo "Comment=Android Studio provides the fastest tools for building apps on every type of Android device" >> $file
        echo "Exec=$path/studio.sh" >> $file
        echo "Icon=$path/studio.png" >> $file
        echo "Categories=Application;Development;Android;IDE" >> $file
        echo "Version=1.0" >> $file
        echo "Type=Application" >> $file
        echo "Terminal=0" >> $file
        
        echo "Concluido! Atalho criado em $file"
    fi
fi
