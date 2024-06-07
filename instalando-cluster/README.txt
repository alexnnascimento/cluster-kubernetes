Requisitos:

Ansible: Versão 2.19 ou superior

Configuração:

Clone o Repositório:

Primeiro, clone o repositório que contém o playbook Ansible. Execute o comando abaixo no seu terminal:

git clone https://example.com/seu-repositorio.git
cd seu-repositorio

Crie o Arquivo de Inventário (hosts) na raiz com conteúdo abaixo:

[control_plane]
144.197.243.215

[worker]
3.235.95.159

Execute o seguinte comando para rodar o playbook Ansible (k8s.yaml), especificando o inventário (hosts), o usuário SSH e o caminho para a chave privada:

sudo ansible-playbook k8s.yaml -i hosts -u ubuntu --private-key ~/.ssh/id_rsa

