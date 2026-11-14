# 🎮 Kath's Memories

## 📖 Sobre o projeto

**Kath's Memories** é um jogo 2D desenvolvido utilizando a Godot Engine, com GDScript.

O projeto apresenta uma experiência interativa com exploração, personagens, diálogos, animações, interações com objetos e minigames.

O jogo foi desenvolvido como um projeto pessoal, com foco em narrativa, mecânicas interativas e desenvolvimento de jogos 2D.

## 🔗 Repositório

GitHub: https://github.com/EduardoBabetto/Kaths-memories

Para clonar o projeto:

```bash
git clone https://github.com/EduardoBabetto/Kaths-memories.git
```

## 🛠️ Tecnologias utilizadas

- **Godot Engine 4.x:** Engine utilizada para desenvolvimento e exportação.
- **GDScript:** Linguagem de programação utilizada nos sistemas do jogo.
- **Git:** Controle de versão.
- **GitHub:** Hospedagem do código-fonte.

## 📋 Requisitos para desenvolvimento

Para abrir e executar o projeto pelo editor, é necessário:

1. Windows, Linux ou macOS.
2. Godot Engine 4, preferencialmente na mesma versão utilizada no desenvolvimento.
3. Git (opcional, caso o projeto seja baixado diretamente pelo GitHub).
4. Os arquivos de recursos externos necessários ao projeto, caso existam.

Download da Godot: https://godotengine.org/download/

## 🚀 Como baixar e executar o projeto

### 1. Clonar o repositório

Abra um terminal na pasta em que deseja armazenar o projeto e execute:

```bash
git clone https://github.com/EduardoBabetto/Kaths-memories.git
```

Entre na pasta:

```bash
cd Kaths-memories
```

### 2. Abrir na Godot Engine

1. Abra a Godot Engine.
2. Clique em **Import**.
3. Localize a pasta `Kaths-memories`.
4. Selecione o arquivo `project.godot`.
5. Aguarde a importação dos recursos.

### 3. Executar o jogo pelo editor

Depois de abrir o projeto:

- **F5:** Executa o jogo a partir da cena principal.
- **F6:** Executa somente a cena atualmente aberta.

A cena principal é definida nas configurações do projeto.

---

## 📦 Como exportar o jogo

Para gerar uma versão executável do Kath's Memories para Windows, siga os passos abaixo.

### 1. Instalar os Export Templates

Os Export Templates são necessários para gerar uma versão executável do jogo.

Na Godot:

1. Abra o projeto.
2. Acesse **Editor → Manage Export Templates**.
3. Caso os templates não estejam instalados, selecione a opção para baixá-los e instalá-los.
4. Utilize os templates correspondentes à versão da Godot utilizada no projeto.

Não é necessário instalar templates de todas as plataformas. Para gerar o jogo para Windows, basta instalar os templates correspondentes ao Windows.

### 2. Configurar a exportação

1. Acesse **Project → Export**.
2. Clique em **Add...**.
3. Selecione **Windows Desktop**.
4. Configure as opções de exportação conforme necessário.

Para computadores Windows convencionais, utilize a arquitetura `x86_64`.

### 3. Exportar o jogo

Na janela de exportação:

1. Selecione a predefinição **Windows Desktop**.
2. Defina o caminho de saída do executável.
3. Escolha um nome para o arquivo, por exemplo:

```text
Kath's Memories.exe
```

4. Clique em **Export Project**.
5. Aguarde a conclusão do processo.

A Godot poderá gerar dois arquivos principais:

```text
Kath's Memories/
│
├── Kath's Memories.exe
└── Kath's Memories.pck
```

O arquivo `.exe` contém o executável do jogo, enquanto o `.pck` contém os recursos e dados necessários para sua execução.

**Importante:** mantenha os dois arquivos na mesma pasta. Não é necessário incorporar o `.pck` ao executável para que o jogo funcione.

### 4. Estrutura recomendada para distribuição

Depois da exportação, organize os arquivos em uma pasta própria:

```text
Kath's Memories - Windows/
│
├── Kath's Memories.exe
└── Kath's Memories.pck
```

Se houver outros arquivos externos necessários para o funcionamento do jogo, eles também deverão acompanhar a distribuição.

Para compartilhar o jogo, compacte a pasta inteira em `.zip`.

---

## 🕹️ Como executar a versão `.exe`

Para jogar a versão exportada, não é necessário instalar a Godot Engine.

Siga as instruções:

1. Baixe o arquivo `.zip` disponibilizado com a versão do jogo.
2. Extraia todo o conteúdo para uma pasta.
3. Abra a pasta extraída.
4. Localize o arquivo `Kath's Memories.exe`.
5. Dê dois cliques no executável para iniciar o jogo.

**Atenção:** não execute o `.exe` diretamente de dentro do arquivo compactado. Extraia todos os arquivos primeiro e mantenha o `.pck` junto do executável.

Caso o Windows apresente um aviso de segurança, verifique se o arquivo foi obtido de uma fonte confiável antes de permitir sua execução.

---

## 📁 Organização dos arquivos

O projeto utiliza uma organização de recursos e scripts separados por funcionalidades.

Entre os principais elementos desenvolvidos estão:

- **Scenes:** cenas, ambientes e elementos do jogo.
- **Scripts:** lógica e funcionalidades implementadas em GDScript.
- **Assets:** recursos visuais e sonoros.
- **Addons:** extensões utilizadas pelo projeto, caso existam.
- **project.godot:** arquivo principal de configuração do projeto.

## 🎮 Sistemas implementados

O projeto conta com os seguintes sistemas:

### Movimentação do personagem
- Movimentação horizontal.
- Pulo e pulo duplo.
- Estados de animação: parado, andando, pulando e caindo.

### Sistema de diálogos
- Exibição de diálogos entre personagens.
- Efeito de digitação.
- Retratos e identificação dos personagens.
- Efeitos sonoros durante as conversas.
- Controle de movimentação durante diálogos e cutscenes.

### Sistema de interação
- Interação com objetos do cenário.
- Identificação de objetos interativos.
- Eventos e diálogos específicos para cada interação.

### Sistema de minigames
- Gerenciamento independente dos minigames.
- Minigame de ritmo musical.
- Minigame de combate com ondas de inimigos.

### Animações e efeitos
- Animações de personagens e objetos.
- Efeitos de iluminação.
- Transições entre cenas.
- Efeitos sonoros e músicas.

---

## 📂 Arquivos ignorados pelo Git

O projeto utiliza um `.gitignore` para evitar o envio de arquivos temporários, caches e arquivos muito grandes.

Entre os arquivos ignorados estão:

```gitignore
.godot/
.import/
*.tmp
*.log
*.tpz
```

**Observação sobre arquivos `.tpz`:** arquivos com essa extensão não são enviados pelo Git. Caso sejam necessários para o desenvolvimento, deverão ser disponibilizados separadamente. Os Export Templates podem ser instalados diretamente pelo gerenciador da Godot.

Os arquivos originais necessários para o funcionamento do jogo devem estar disponíveis para que a importação e a exportação sejam realizadas corretamente.

---

## 👨‍💻 Desenvolvimento e colaboração

Para realizar alterações no projeto:

1. Faça um fork ou clone do repositório.
2. Crie uma branch para suas alterações.
3. Implemente as funcionalidades desejadas.
4. Teste o funcionamento do jogo.
5. Faça o commit das alterações.
6. Envie suas alterações para o GitHub.

Exemplo:

```bash
git checkout -b minha-feature

git add .

git commit -m "Adiciona nova funcionalidade"

git push origin minha-feature
```

---
## ⬇️ Download do jogo

Você pode baixar a versão jogável de **Kath's Memories** diretamente pela página de Releases do GitHub.

1. Acesse a página de [Releases](https://github.com/EduardoBabetto/Kaths-memories/releases).
2. Localize a versão mais recente do jogo.
3. Baixe o arquivo `.zip` disponibilizado nos anexos.
4. Extraia os arquivos para uma pasta.
5. Execute `Kath's Memories.exe` para iniciar o jogo.

**Observação:** mantenha o arquivo `.pck` na mesma pasta do executável para garantir o funcionamento correto do jogo.

Não é necessário instalar a Godot Engine para jogar a versão exportada.

## 📚 Documentação oficial

- [Godot Engine](https://godotengine.org/)
- [Documentação da Godot](https://docs.godotengine.org/pt-br/4.x/)
- [Exportação de projetos](https://docs.godotengine.org/pt-br/4.x/tutorials/export/exporting_projects.html)
- [Exportação para Windows](https://docs.godotengine.org/pt-br/4.x/tutorials/export/exporting_for_windows.html)

---

**Kath's Memories**

*Desenvolvido com Godot Engine e GDScript.*
