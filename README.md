# 🃏 meme-joker

> **A stand-up set disguised as a skill.**
> Zoomer slang, deadpan irony, harmless dark humor, and punchlines you can't predict.

```
You: why doesn't my code work?
Bot: `undefined` isn't a value. It's a diagnosis.
```

An [OpenCode](https://opencode.ai) skill that turns the chat into a stage. Not a joke dispenser — a storyteller who happens to know how to code.

**EN** · [RU](#-русский) · [LT](#-lietuviškai)

---

## The one law

Everything in this skill is decoration around a single rule:

> **A joke is a prediction that gets broken.**

Build an expectation. Let it set. Snap it at the last word. If the reader can guess the punchline, there is no punchline — there is a summary.

That's why there's an **anti-cliché rule** baked in: *could a mediocre model have written this exact line? If yes, delete it.* Predictability is the only unforgivable sin.

One real surprise beats ten jokes. If there's no surprise to find, the bot doesn't perform. Silence is funnier than filler.

## What's inside

| Section | What it does |
| --- | --- |
| **Posture** | tired but kind, never above you, part of the joke |
| **The engine** | surprise, anti-cliché, never reuse a move |
| **10 mechanics** | bait-and-switch, scale jump, absurd specificity, wrong register, literalization, deadpan, broken triad, rhetorical question, callback, anti-joke |
| **Voice** | zoomer slang as *seasoning* — 2–3 per message, one 💀 max |
| **Dark humor** | allowed list and hard limits — systems and entropy, never people |
| **Auto-off** | incidents, medical/legal/financial, angry users, and **all code artifacts** |
| **Dosage** | at least one unexpected turn per reply, 1–2 jokes max |
| **Volume knob** | `chill` / default / `harder` / `no jokes` |

## Install

### Global (every project)

```powershell
# Windows
git clone https://github.com/<you>/meme-joker.git
cd meme-joker
.\install.ps1 -Lang ru -Always
```

```bash
# macOS / Linux
git clone https://github.com/<you>/meme-joker.git
cd meme-joker
./install.sh --lang ru --always
```

### Manual (30 seconds, no scripts)

Copy the skill folder into your OpenCode skills directory:

| Scope | Path |
| --- | --- |
| Global | `~/.config/opencode/skills/meme-joker/` |
| Project | `.opencode/skills/meme-joker/` |

```powershell
Copy-Item -Recurse .\skills\meme-joker "$HOME\.config\opencode\skills\"
```

### Make it always-on

A skill is *discoverable*, not *loaded* — the model only sees the name and description until it decides to open the body. If you want the vibe **always**, add one line to your global `opencode.json(c)`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["~/.config/opencode/instructions/meme-joker.md"]
}
```

…and put this in that file:

```markdown
Always keep the tone and humor rules from the `meme-joker` skill, in casual conversation.
Humor lives in chat only — never in code, commits, PRs, configs, docs, or error messages.
```

`-Always` / `--always` does this for you (and refuses to touch a config it can't parse).

## Languages

| Skill ID | Language | Flavor |
| --- | --- | --- |
| `meme-joker` | 🇬🇧 English | dry British-adjacent stand-up |
| `meme-joker-ru` | 🇷🇺 Русский | стендап-монолог, зумерский сленг, тлен |
| `meme-joker-lt` | 🇱🇹 Lietuvių | sausas humoras, tamsa 15:40, „viskas gerai“ |

All three are full adaptations, not translations. The Lithuanian one has opinions about the weather.

## The volume knob

Just tell it:

| You say | It does |
| --- | --- |
| `chill` / `полегче` / `čil` | light irony, one joke, rest is work |
| *(nothing)* | the default chaos |
| `harder` / `жёстче` / `stipriau` | dense stand-up, substance intact |
| `no jokes` / `без шуток` / `be juokelių` | **off.** Not one wink. |

## What it will never do

- Joke about real deaths, illness, tragedies, suicide, or violence.
- Joke about nationality, religion, orientation, gender, disability, appearance.
- Joke about *you* — your family, body, or private life.
- Put memes in code, commits, PRs, configs, docs, or error messages.
- Trade accuracy for a laugh.
- Explain the joke.

If production is down, it stops performing and helps. That's not a limitation, that's the point.

## Structure

```
meme-joker/
├── skills/
│   ├── meme-joker/SKILL.md       # EN
│   ├── meme-joker-ru/SKILL.md    # RU
│   └── meme-joker-lt/SKILL.md    # LT
├── instructions/
│   └── meme-joker.md             # compact always-on layer
├── install.ps1
├── install.sh
├── LICENSE
└── README.md
```

## Uninstall

```powershell
Remove-Item -Recurse "$HOME\.config\opencode\skills\meme-joker*"
```

And delete the `instructions` line from `opencode.json`. That's it. No registry, no telemetry, no feelings.

## License

MIT. Do whatever. Attribution is nice, not required.

---

## 🇷🇺 Русский

**Стендап, замаскированный под скилл.**

Зумерский сленг, сухая ирония, безобидный чёрный юмор и панчлайны, которые не угадать.

Главный закон один: **шутка — это сломанное предсказание**. Строишь ожидание, даёшь ему застыть, ломаешь на последнем слове. Если панчлайн можно угадать — панчлайна нет, есть пересказ.

Установка:

```powershell
.\install.ps1 -Lang ru -Always
```

Или вручную: папку `skills/meme-joker-ru` → в `~/.config/opencode/skills/`.

Регулятор громкости: `чилл` / по умолчанию / `жёстче` / `без шуток`.

Юмор живёт в чате. В коде — ноль мемов. Прод упал — сначала помощь, потом шутки. Если вообще.

---

## 🇱🇹 Lietuviškai

**Stand-upas, persirengęs skillsu.**

Sausas humoras, zoomerio žargonas, nekenksmingas juodas humoras ir pankčlainai, kurių neatspėsi.

Vienas įstatymas: **juokas — tai lūkestis, kuris lūžta**. Pastatai laukimą, leidi sustingt, nulauži paskutiniame žodyje. Jei pankčlainą galima atspėti — pankčlaino nėra, yra santrauka.

```powershell
.\install.ps1 -Lang lt -Always
```

Arba rankiniu būdu: `skills/meme-joker-lt` → į `~/.config/opencode/skills/`.

Garso reguliatorius: `čil` / pagal nutylėjimą / `stipriau` / `be juokelių`.

Humoras gyvena pokalbyje. Kode — nulis memų. Prod'as nukrito — pirmiausia pagalba. Viskas gerai.

---

<p align="center">
  <i>Built for people who talk to their terminal and want it to talk back with personality.</i>
</p>
