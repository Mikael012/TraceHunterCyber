
#!/bin/bash
# tracehunter-Forensic Collector
# autor: Mikael Araujo Pochini
# Data: 19/02/2025
# descrição: script para coleta de informações forenses no sistema.

# verificação de Permissões
if  [[ $EUID -ne 0 ]]; then
    echo -e " \e[31mErro: 0 script deve ser executado como root!\e[0m"
    exit 1
fi

#Criação de diretorio para coleta
COLLECTED_DIR='Collected_files'
mkdir -p "$COLLECTED_DIR"

# Mensagem de inicio
echo -e "\e[35;1mColetando arquivos do sistema...\e[0m"

# Coleta de Informações do Sistema sobre discos e partições...\e[0m"
echo -e "\e[35mListando informações sobre discos e partições...\e[0m"
lsblk > "$COLLECTED_DIR/disk_info..txt"

# Coleta de Conexões de Rede
echo -e "\e[35mColetando informações de rede...\e[0m"
ss -tunapl > "$COLLECTED_DIR/active_connections.txt"
netstat -tulnp > "$COLLECTED_DIR/open_ports.txt"

# Coleta de processos 
echo -e "/e35mColetando lista de processos...\e[0m"
ps aux > "$COLLECTED_DIR/process_list.txt"

# Coleta de registros  do Sistema 
echo -e "/e[35mColetando logs do sistema...\e[0m"
cp /var//log/syslog "$COLLECTED_DIR/syslog.log"
cp /var/log/auth.log "$COLLECTED_DIR/auth.log"
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log"

# Coleta de Arquivos de Configuração
echo -e "\e[35mColetando arquivos de configuração ...\e[0m"
cp -r /etc "$COLLECTED_DIR/etc_backup"

# Coleta de Lista de Arquivo no Diretorio Raiz
echo -e "\e[35mListando diretorio raiz...\e[0m"
ls -lah / > "$COLLECTED_DIR/rooot_dir_list.txt"

# Compactação e Nomeação do Arquivo de Saida
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
tar -czf "tracehunter_${HOSTNAME}_${TIMESTAMP}.tar.gz" "$COLLECTED_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo -e '\e[32mColeta concluida!\e[0m'
echo -e '\e[32mArquivo salvo como tracehunter_${HOSTNAME}_${TIMESTAMP}.tar.gz\e[0m'
