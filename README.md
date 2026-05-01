# 📌 Sistema de Quit (Estilo FiveM) - MTA:SA

Sistema que exibe informações quando um jogador sai do servidor, mostrando dados no mundo (3D) e notificando jogadores próximos.

---

## 🚀 Funcionalidades

- Texto 3D no local onde o player quitou  
- Exibe ID e motivo da saída  
- Notificação no chat para players próximos  
- Sistema de distância configurável  
- Tempo de duração do texto configurável  
- Integração com Discord (webhook)  
- Compatível com interior e dimensão  

---

## 📂 Arquivos

- `server.lua` → Lógica do servidor  
- `client.lua` → Renderização e exibição  
- `settings.lua` → Configurações gerais  

---

## ⚙️ Configuração

No arquivo `settings.lua`:

```lua
settings = {
    ['gerais'] = {
        ['data_id'] = 'ID', -- elementdata do ID do player

        ['color:rgb'] = {255, 77, 77}, -- cor do texto

        ['distancia'] = {
            ['quit'] = 10, -- distância para ver o texto 3D
            ['chat'] = 10, -- distância para mensagem no chat
        },

        ['tempo'] = 1, -- tempo (em minutos) que o texto permanece
    },

    ['type:disconnect'] = {
        ['Unknown'] = 'Desconhecido',
        ['Quit'] = 'Deslogou',
        ['Kicked'] = 'Expulso(a)',
        ['Banned'] = 'Banido(a)',
        ['Bad Connection'] = 'Conexão ruim',
        ['Timed out'] = 'Tempo esgotado',
    },

    ['webhook'] = 'SEU_WEBHOOK_AQUI'
}
