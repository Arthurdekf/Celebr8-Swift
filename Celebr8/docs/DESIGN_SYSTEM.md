
# CELEBR8 — Design System

## Visão

O CELEBR8 para iOS é uma implementação nativa desenvolvida em SwiftUI.

A interface deve seguir as Human Interface Guidelines da Apple e aproveitar os componentes modernos do iOS, mantendo o evento e sua fotografia como protagonistas.

## Princípios

- O evento é o protagonista.
- A capa do evento é o principal elemento visual.
- A interface deve parecer concebida originalmente para iOS.
- Componentes nativos têm prioridade sobre componentes personalizados.
- Conteúdo tem prioridade sobre decoração.
- Cada tela deve possuir um foco principal claro.
- Liquid Glass, animações e materiais devem reforçar a hierarquia, sem competir com o conteúdo.
- Light Mode e Dark Mode devem ser suportados desde o início.
- A tela de detalhes do evento possui uma atmosfera própria baseada nas cores da capa.

## Tipografia

Usar os estilos semânticos do sistema:

- largeTitle
- title
- title2
- title3
- headline
- subheadline
- body
- callout
- footnote
- caption
- caption2

A tipografia deve respeitar Dynamic Type.

A fonte Galada será usada exclusivamente na marca “Celebr8”.

## Cores

Priorizar cores semânticas do sistema:

- primary
- secondary
- tertiary
- systemBackground
- secondarySystemBackground
- tertiarySystemBackground
- separator
- tint

A cor própria da marca será usada de forma controlada em identidade visual e ações principais.

Cores não devem ser inseridas diretamente nas Views.

## Espaçamento

Escala padrão:

- 4
- 8
- 12
- 16
- 20
- 24
- 32
- 40
- 48
- 64

## Raios

- small: 8
- medium: 16
- large: 24
- extraLarge: 32

## Liquid Glass e materiais

Usar principalmente em:

- navegação
- busca
- toolbars
- controles flutuantes
- overlays
- sheets

Evitar usar vidro como fundo indiscriminado em todos os componentes.

## Fotografia

- Capas devem possuir alta relevância visual.
- Evitar cortes que prejudiquem o assunto principal da imagem.
- A tela de detalhes deve extrair sua atmosfera visual da capa do evento.
- Texto sobre imagem deve manter contraste suficiente.

## Ícones

Usar SF Symbols sempre que houver símbolo adequado.

## Acessibilidade

- Dynamic Type
- VoiceOver
- contraste adequado
- áreas de toque apropriadas
- suporte a Reduce Motion
- textos não dependentes apenas de cor

## Componentes iniciais

- BrandLogo
- EventCard
- CategoryPill
- SectionHeader
- PrimaryButton
- ProfileAvatar
- EmptyStateView
- LoadingView
