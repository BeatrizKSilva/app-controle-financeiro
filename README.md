# Vinta Finanças - Controle Financeiro

Um aplicativo de controle financeiro pessoal desenvolvido em Flutter, focado na gestão de receitas e despesas com armazenamento na nuvem e conversão de moedas em tempo real.

## Integrantes e Divisão de Tarefas

* **Carlos Tito:** Implementação da arquitetura de Autenticação (Google Sign-In), persistência de sessão de usuário, consumo de API Web (AwesomeAPI) com integração de variáveis de ambiente (`.env`), e conversão automática de moedas na inserção de valores.
* **Beatriz Silva:** Desenvolvimento da interface de categorias, integração com recursos nativos do dispositivo (Câmera/Galeria via `image_picker`) e gestão ponta a ponta de arquivos e comprovantes no Firebase Storage (upload e limpeza de imagens órfãs).

## Funcionalidades e Tecnologias

* **Firebase Auth & Firestore:** Autenticação de usuários e persistência de dados em tempo real.
* **Consumo de API Externa:** Integração com a AwesomeAPI para cotações em tempo real do Dólar (USD) e Euro (EUR), realizando a conversão automática para Real (BRL) no momento do lançamento da transação.
* **Recursos Nativos:** Utilização da câmera e galeria nativas do dispositivo para anexar comprovantes de pagamento, que são guardados no Firebase Storage.
* **Transações Recorrentes:** Lógica para adição automatizada de transações repetitivas ao longo dos meses.

## Como executar o projeto (Instruções de Instalação)

Para executar este projeto em um novo ambiente, siga os passos abaixo:

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/BeatrizKSilva/app-controle-financeiro.git](https://github.com/BeatrizKSilva/app-controle-financeiro.git)
   ```

2. **Configuração da API de Cotação:**
   * Use a chave de api enviada junto com o link do github.
   * Na raiz do projeto, crie um arquivo oculto chamado `.env` (utilize o `.env.example` como base).
   * Adicione a sua chave no formato: `AWESOME_API_KEY = chave`.

3. **Instalar dependências e executar:**
   ```bash
   flutter pub get
   flutter run
   ```

## Bugs Conhecidos e Funcionalidades Faltantes

* **Bug Visual do Teclado:** Ao adicionar uma transação e selecionar uma moeda estrangeira no menu suspenso, existe um conflito nativo de perda de foco que causa o fechamento abrupto do teclado, provocando um pequeno ressalto na interface.
* **Melhoria Futura:** Neste momento, não existe uma funcionalidade para a edição ou exclusão em lote de transações recorrentes.