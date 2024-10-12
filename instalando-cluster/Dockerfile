# Use a imagem base Ubuntu 24.04
FROM ubuntu:24.04

# Atualizar o sistema e instalar o OpenSSH
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Configurar o SSH para aceitar conexões remotas
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Definir uma senha para o root (por segurança, evite isso em produção)
RUN echo 'root:root' | chpasswd

# Expor a porta 22 do container (essa é a porta padrão do SSH dentro do container)
EXPOSE 22

# Iniciar o serviço de SSH
CMD ["/usr/sbin/sshd", "-D"]

# Mapear a porta 22 do container para a porta 2222 do host
# Você pode usar o seguinte comando ao rodar o container:
# docker run -p 2222:22 nome-da-imagem
