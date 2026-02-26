# RailsMail

A polished mailer preview UI for Rails — inspired by [React Email](https://react.email). Drop it in and your `/rails/mailers` preview route gets a modern dark/light interface with viewport controls, source inspection, CSS compatibility checks, and spam scoring.

Zero configuration. No build step. Works with your existing `ActionMailer::Preview` classes.

---

## Features

- **Dark & light theme** — toggle anytime, preference saved in localStorage
- **Dark mode email rendering** — LCH-based color inversion (same algorithm as React Email)
- **Viewport presets** — Mobile (375px), Tablet (768px), Desktop (1280px), Email (600px), or custom
- **Source viewer** — toggle between rendered preview and raw HTML / plain-text source
- **Headers panel** — view From, To, Subject, Date, Reply-To, CC, BCC at a glance
- **CSS compatibility checker** — detects unsupported properties (Flexbox, Grid, CSS variables, animations…) with the affected clients listed
- **Spam score** — runs your email through Postmark's SpamAssassin API and shows a score out of 10
- **Download as .eml** — grab the full RFC 822 message for local testing
- **Locale selector** — switch preview locale without leaving the page
- **Collapsible sidebar** — more room for your email when you need it

---

## Requirements

- Ruby >= 3.1
- Rails >= 7.0
- ActionMailer previews enabled (`config.action_mailer.show_previews = true` in development)

---

## Installation

Add to your `Gemfile`:

```ruby
gem "rails_mail"
```

Then run:

```
bundle install
```

That's it. No generators, no initializers, no configuration files needed.

> **Note:** Make sure `config.action_mailer.show_previews = true` is set in `config/environments/development.rb`. Rails enables this by default in development, so you probably don't need to touch anything.

---

## Usage

Start your Rails server and visit:

```
http://localhost:3000/rails/mailers
```

Your existing `ActionMailer::Preview` classes appear in the left sidebar. Click any email action to open the preview.

### Preview classes

RailsMail works with standard ActionMailer previews. Place them in `test/mailers/previews/` (or wherever `config.action_mailer.preview_paths` points):

```ruby
# test/mailers/previews/user_mailer_preview.rb
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.first).welcome_email
  end

  def password_reset
    UserMailer.with(user: User.first).password_reset
  end
end
```

### Spam check

The Spam tab sends the full RFC 822 message (headers + body) to [Postmark's SpamAssassin API](https://spamcheck.postmarkapp.com). No API key required. An internet connection is needed when running the check.

The score is displayed as **X / 10** (higher is better). The individual SpamAssassin rules that fired are shown below the score, sorted by impact.

---

## Tabs reference

| Tab | What it shows |
|---|---|
| **Headers** | From, To, Subject, Date, Reply-To, CC, BCC; locale switcher |
| **Compatibility** | CSS properties in the email that are unsupported by major clients |
| **Spam** | SpamAssassin score and the rules that contributed to it |
| **Attachments** | Files attached to the email with download links |

---

## Keyboard / UI controls

| Control | Action |
|---|---|
| Sidebar toggle (☰) | Collapse / expand the mailer list |
| Preview / Source buttons | Switch between rendered and raw views |
| Desktop / Mobile buttons | Switch between full-width and 375 px mobile viewport |
| Viewport dropdown | Fine-grained presets: Mobile, Tablet, Desktop, Email (600 px), Custom |
| Theme toggle (☀/☾) | Switch dark ↔ light; saved across sessions |
| ↓ Download | Download the email as an `.eml` file |
| ∨ (panel header) | Collapse / expand the bottom info panel |

---

## How it works

RailsMail is a Rails Engine that:

1. Prepends its own views to `Rails::MailersController`, replacing the default preview templates without touching the controller itself.
2. Adds a single new route — `GET /rails/mailers/spam_check/*path` — prepended before ActionMailer's wildcard so it is matched first.
3. Includes a controller extension that handles the spam check request: it calls your preview, serialises the result to a full RFC 822 string via `email.to_s`, and forwards it to Postmark's SpamAssassin API over TLS.

No monkey-patching, no middleware, no asset pipeline involvement. Everything is rendered as inline ERB (CSS and JS embedded in partials).

---

## Development

Clone the repo and install dependencies:

```bash
git clone https://github.com/your-org/rails_mail.git
cd rails_mail
bundle install
```

The `test/dummy` directory contains a minimal Rails app with sample mailers. Run it with:

```bash
cd test/dummy
bundle exec rails server
```

Then open `http://localhost:3000/rails/mailers`.

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b my-feature`)
3. Commit your changes (`git commit -m 'Add my feature'`)
4. Push to the branch (`git push origin my-feature`)
5. Open a pull request

Please keep changes focused. Bug fixes and improvements to existing features are welcome. For larger changes, open an issue first to discuss the approach.

---

## License

MIT. See [LICENSE](LICENSE) for details.
