# Gerenciador de segredos

Este repositório contém uso da ferramenta Vault relacionado ao curso **"[Learning HashiCorp Vault](https://www.linkedin.com/learning/learning-hashicorp-vault)"** da plataforma Linkedin Learning

## Recomendações

* **[Docker](https://www.docker.com/products/docker-desktop/)** em versão mínima de 4.22.x
* **[Vault](https://developer.hashicorp.com/vault/downloads)** instalado em versão mínima de 1.14.x (opcional)
* **[Jenkins](https://www.jenkins.io/download/)** em versão mínima de 2.414.x (opcional)

## Instruções de uso

## Primeiros passos

**1.** Inicie o servidor do Vault em modo de desenvolvimento

```shell
vault server -dev
```

> **Nota:** será gerado um token de acesso no terminal. O servidor vai estar na porta **8200**
>
> **AVISO:** mantenha o servidor executando, pois no modo de desenvolvimento, o Vault executa e guarda todos os dados em memória

**1.1.0** Exporte o endereço do servidor e token do Vault

```shell
export VAULT_ADDR='http://[IP]:8200' && export VAULT_TOKEN='[token]'
```

> **Dica:** ao executar o passo anterior, no terminal há uma sugestão para exportar esta variável contendo o IP local da sua máquina

**1.1.1** Verifique o status do servidor do Vault

```shell
vault status
```

> **Dica:** para ver a lista de secrets, execute `vault secrets list`

**1.2** Crie uma dado secreto incluindo chave e valor

```shell
vault kv put [engine]/[pasta] [chave]=[valor]
```

**1.2.1** Cheque a existência deste dado

```shell
vault kv get [engine]/[pasta]
```

> **Lembrete:** se uma lista de informações foi retornada, quer dizer que o dado foi criado e lido sem problemas
>
> **Dica:** você pode ver em formato JSON digitando `vault kv get -format=json [engine]/[pasta]`

## Criando e habilitando uma secrets engine

**2.** Habilite a engine KV

```shell
  vault secrets enable -path=[nome-engine/pasta] kv
```

**Dica:** existem engines e pastas com nomes específicos que recebem suporte adicional e estão na [documentação oficial do Vault](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-help)

## Autenticação com Vault

**3.** Liste os métodos de autenticação

```shell
vault auth list
```

**3.1** Crie e habilite um método de autenticação predefinido

```shell
vault auth enable userpass
```

> **Aviso:** o método `userpass` é predefinido e reconhecido pelo Vault, no qual também obriga a seguir métodos de uso. Métodos fora destes parâmetros poderão ter um nome customizado

**3.1.1** Crie um usuário fictício

```shell
vault write auth/userpass/users/vaultuser password=[valor]
```

**3.1.2** Inicie uma sessão com o método predefinido para obter o token de acesso

```shell
vault login -method=userpass username=vaultuser password=[valor]
```

## Políticas do Vault

**4.** Liste as políticas disponíveis

```shell
vault policy list
```

**4.1** Visualize uma política específica

```shell
vault policy read [nome]
```

> **Nota:** neste caso, iremos ler a política padrão (*default*)

**4.2** Crie uma nova política e em seguida habilite o método userpass

```shell
vault policy write [nome] - << EOF
path "secret/data/[nome]" {
  capabilities = ["create", "update"]
}

path "secret/data/[nome]" {
  capabilities = ["read"]
}
EOF
```

**4.3** Autentique a política

```shell
vault write auth/userpass/users/app password=[valor] policies=[nome]
```

**4.4** Faça login com método userpass

```shell
vault login -method=userpass username=[valor] password=[valor]
```

> **Dica:** execute o comando `vault token capabilities [pasta]`

**4.5** Crie uma secret

```shell
vault kv put secret/[caminho] [chave]=[valor]
```

> **Lembrete:** esta secret será associada à política de uso criada

## Usando o Vault em produção

**5** Crie um arquivo de configuração básico

```json
// vault-config.hcl

storage "raft" {
  path    = "[DIRETÓRIO]"
  node_id = "node1"
}

listener "tcp" {
  address     = "[IP]:[PORTA]"
  tls_disable = true
}

api_addr = "http://[IP]:[PORTA]"
cluster_addr = "https://[IP]:[PORTA]"
disable_mlock = true
ui = true
```

**5.1.1** Crie um diretório para armazenamento referente ao *path* no arquivo de configuração

```shell
mkdir -p [caminho]
```

**5.1.2** Inicie o servidor em produção

```shell
vault server -config=[arquivo].hcl
```

**5.2** Inicialize o Vault para obter as key shards e token de acesso

```shell
vault operator init
```

> **⚠️  Alerta:** As 5 shards (fragmentos) da chave-mestra e devem ser mantidas em um diretório separado e seguro

**5.3** Faça abertura do Vault com 3 shards

```shell
vault operator unseal [shard]
```

> Caso não tenha compreendido, você terá que repetir este processo 3 vezes com fragmentos de chave diferente

**5.4** Inicie a sessão

```shell
vault login [token]
```

> **Dica:** para confirmar, execute o comando `vault secrets list`
