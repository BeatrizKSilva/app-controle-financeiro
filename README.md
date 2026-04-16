# Vinta Finanças

**Vinta Finanças** é uma aplicação de controle financeiro pessoal desenvolvida em Flutter. O projeto foi estruturado com foco na usabilidade e organização de código, seguindo padrões de arquitetura modernos para a disciplina de Análise e Desenvolvimento de Sistemas.

## Autores
* **Beatriz Silva**
* **Carlos Tito**

---

## Funcionalidades

Nesta primeira fase, o foco foi a construção de uma interface robusta (UI), navegação fluida e tratamento de dados em memória.

* **Dashboard Principal:** Exibição de Saldo, Receitas e Despesas calculados dinamicamente.
* **Calendário Customizado:** Seleção de mês e ano com sincronização global entre os ecrãs de início e gráficos.
* **Gráficos Interativos:** Visualização de gastos por categoria através de gráficos de tarte dinâmicos (biblioteca `fl_chart`).
* **Gestão de Transações:** Listagem de itens com suporte a gestos de arrastar (*Slidable*) para edição e exclusão.
* **Gestão de Categorias:** Ecrãs para criar, editar e excluir categorias personalizadas com ícones e cores.
* **Segurança e Validação:** Fluxo completo de Login e Registo com validação de campos e mensagens de feedback ao utilizador.

---

## Arquitetura do Projeto

O projeto utiliza o padrão **MVC (Model-View-Controller)** para garantir a separação de responsabilidades:

* **Views (`lib/views/`):** Contém todas as interfaces do utilizador e a estrutura visual da aplicação.
* **Controllers (`lib/controllers/`):** Gere a lógica de negócio e a manipulação das listas de categorias e estados.
* **Repositories/Mocks (`lib/repositories/`):** Simula a persistência de dados em memória (Utilizadores e Categorias estáticas) conforme os requisitos rigorosos desta etapa.
* **Widgets (`lib/widgets/`):** Componentes isolados e reutilizáveis da interface.

---

## Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) - Framework de UI.
* [Dart](https://dart.dev/) - Linguagem de programação.
* [fl_chart](https://pub.dev/packages/fl_chart) - Biblioteca para a criação de gráficos dinâmicos e responsivos.
* [flutter_slidable](https://pub.dev/packages/flutter_slidable) - Pacote para interações avançadas de listas (swipe-to-delete).

---

## Como Executar

1. Certifique-se de que tem o ambiente Flutter configurado na sua máquina.
2. Clone este repositório.
3. Abra o terminal na raiz do projeto e instale as dependências:
   ```bash
   flutter pub get
4. Inicie a aplicação no seu emulador ou dispositivo físico:
   ```bash
   flutter run