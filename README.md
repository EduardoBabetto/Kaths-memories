# 🎮 Projeto Godot

## Sobre o projeto

Este repositório contém um projeto de desenvolvimento de um jogo 2D desenvolvido utilizando a Godot Engine.

O projeto conta com sistemas de movimentação, interação com objetos, diálogos, animações, efeitos sonoros e minigames.

## 🛠️ Tecnologias utilizadas

- **Godot Engine 4.x** – Engine utilizada no desenvolvimento.
- **GDScript** – Linguagem de programação dos scripts.
- **Git e GitHub** – Controle de versão e gerenciamento do código-fonte.

## 📋 Requisitos

Para executar o projeto, é necessário:

1. Ter o [Godot Engine 4](https://godotengine.org/download/) instalado.
2. Ter acesso aos arquivos do repositório.
3. Possuir os assets necessários para a execução do jogo.

Não é necessário instalar dependências Python, Node.js ou outras bibliotecas externas para executar o projeto.

## 🚀 Como executar o projeto

### 1. Clonar o repositório

Abra um terminal e execute:

```bash
git clone URL_DO_REPOSITORIO
```

Entre na pasta do projeto:

```bash
cd NOME_DO_PROJETO
```

### 2. Abrir o projeto na Godot

1. Abra a Godot Engine.
2. Selecione a opção **Import**.
3. Localize a pasta onde o repositório foi clonado.
4. Selecione o arquivo `project.godot`.
5. Aguarde a importação dos arquivos e recursos do projeto.

### 3. Executar o jogo

Após a importação:

1. Abra o projeto na Godot.
2. Pressione **F6** para executar a cena atual.
3. Pressione **F5** para executar o projeto a partir da cena principal.

A tecla F5 utiliza a cena principal configurada nas propriedades do projeto.

## 📁 Estrutura do projeto

A organização dos arquivos segue a seguinte estrutura:

```text
Projeto/
│
├── addons/
│   └── Plugins e extensões do projeto
│
├── assets/
│   ├── images/
│   ├── audio/
│   ├── sprites/
│   └── fonts/
│
├── scenes/
│   ├── rooms/
│   ├── characters/
│   └── minigames/
│
├── scripts/
│   ├── player/
│   ├── dialogs/
│   └── interactions/
│
├── project.godot
├── .gitignore
└── README.md
```

*Observação: a estrutura acima representa uma organização de referência. Os diretórios podem variar conforme a organização atual do projeto.*

## 🎮 Sistemas implementados

O projeto possui diferentes sistemas desenvolvidos em GDScript:

- **Movimentação:** controle do personagem, incluindo caminhada e pulo.
- **Sistema de diálogos:** exibição de conversas entre personagens, com efeitos de digitação, áudio e retratos.
- **Sistema de interação:** interação com objetos e elementos do cenário.
- **Sistema de animações:** gerenciamento de animações dos personagens e objetos.
- **Sistema de minigames:** gerenciamento e execução de minigames independentes.
- **Sistema de carregamento:** transições entre cenas e efeitos de carregamento.

## 📦 Arquivos e recursos

Alguns arquivos utilizados durante o desenvolvimento podem possuir tamanho elevado.

Arquivos temporários e caches gerados pela Godot não precisam ser versionados, pois são recriados automaticamente durante a importação do projeto.

O diretório `.godot/` é ignorado pelo Git.

Arquivos com extensão `.tpz` também são ignorados pelo repositório através do `.gitignore`.

**Importante:** caso algum arquivo externo seja necessário para executar o projeto, ele deverá ser disponibilizado separadamente e colocado no caminho esperado pelo jogo.

## 🔄 Atualizando o projeto

Para obter as últimas alterações do repositório, execute:

```bash
git pull origin main
```

Caso a branch principal possua outro nome, substitua `main` pelo nome correspondente.

## 👨‍💻 Desenvolvimento

Para contribuir com o projeto:

1. Clone o repositório.
2. Crie uma nova branch para suas alterações.
3. Realize as modificações necessárias.
4. Teste o funcionamento do projeto na Godot.
5. Faça o commit das alterações.
6. Envie suas alterações para o repositório.

Exemplo:

```bash
git checkout -b minha-feature

git add .

git commit -m "Adiciona nova funcionalidade"

git push origin minha-feature
```

---

**Projeto desenvolvido utilizando Godot Engine e GDScript.**
