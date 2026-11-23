# The ARKOS fork of Chatwoot

This repository is the Chatwoot build that L'Eina (`ARKOS-MGMT/onboarding`) runs
against. L'Eina is where staff read and answer; Chatwoot is the engine underneath
it (messages, contacts, inboxes and channels), with its own screens kept as a
fallback. The design is the integration plan of 22 November 2026 and the decision
records in `ARKOS-MGMT/onboarding/docs/decisions/`.

## How this fork is worked

- **Pull requests follow ARKOS practice, not upstream's.** A pull request here names
  the decision record or change request in `ARKOS-MGMT/onboarding` it belongs to.
  The Linear rule in `AGENTS.md` is upstream's own process and does not apply to
  this fork. Everything else in `AGENTS.md` (lint, specs, Rails rules) does.
- **Stay as close to upstream as possible.** Every fork change is listed below. A
  feature that can live in L'Eina, in a bridge service, or in stock Chatwoot
  configuration (webhooks, API channels, custom attributes, labels) does not go here.
- **Upstream merges.** Merge the next upstream release tag into `develop`, keep the
  changes below, run their specs, and update the tested version here and in
  `docs/CHATWOOT_INTEGRATION.md` of L'Eina.

## Tested version

Upstream 4.20.1 (`VERSION_CW`).

## Fork changes

| Change | Where | Why |
| --- | --- | --- |
| "Known contacts only" email inboxes | `Channel::Email#known_contacts_only`, `Imap::ImapMailbox#skipped_as_unknown_contacts_mail?`, inbox settings page | An operator's private mailbox is synced into an inbox, and only mail from, to or copying an address already on file may be stored. Stock IMAP sync stores every message. L'Eina keeps Chatwoot contacts in step with the addresses on file. |
| Own container image | `.github/workflows/publish_arkos_image.yml`; upstream's Docker Hub workflows only run in `chatwoot/chatwoot` | L'Eina deploys this repository's code, not upstream's image. |

## Container image

Every push to `develop` publishes `ghcr.io/illaylegal/chatwoot:develop` and
`ghcr.io/illaylegal/chatwoot:sha-<commit>`; a tag `arkos-vX.Y.Z` publishes
`ghcr.io/illaylegal/chatwoot:arkos-vX.Y.Z`. The image is the community edition
(the `enterprise/` folder is removed at build time, as upstream does for its CE image).

L'Eina's deployment pins one of these tags (`CHATWOOT_IMAGE`). Deploy a released
`arkos-v*` tag to production, never `develop`.

## Not changed here

- Telegram personal accounts and Telegram groups arrive through the Telegram bridge
  in `ARKOS-MGMT/onboarding` (`telegrambridge/`), which feeds an API-channel inbox.
- WhatsApp groups arrive through the same bridge from Wazzup.
- Links between conversations and L'Eina's Entities, Cases and Deals live in L'Eina
  and are written back as custom attributes and labels through the stock API.
