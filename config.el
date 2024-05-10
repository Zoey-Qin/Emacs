;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'ef-spring)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq org-roam-directory "~/Nextcloud/org-roam")

(use-package! rime
  :custom
  (default-input-method "rime")
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding))
  :config
  (setq rime-show-candidate 'posframe)
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-after-alphabet-char-p
          rime-predicate-space-after-cc-p
          rime-predicate-current-uppercase-letter-p
          rime-predicate-punctuation-line-begin-p)))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
                                        ;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
                                        ;         a hookable mode anymore, you're advised to pick something yourself
                                        ;         if you don't care about startup time, use
                                        ;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(setq org-roam-capture-templates
      '(("m" "main" plain
         "%?"
         :if-new (file+head "main/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+date: %T\n#+hugo_auto_set_lastmod: t\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "references" plain "%?"
         :if-new
         (file+head "references/%<%Y%m%d%H%M%S>-${title}.org" "#+title: ${title}\n#+date: %T\n#+hugo_auto_set_lastmod: t\n")
         :immediate-finish t
         :unnarrowed t)
        ("a" "article" plain "%?"
         :if-new
         (file+head "articles/%<%Y%m%d%H%M%S>-${title}.org" "#+title: ${title}\n#+date: %T\n#+filetags: :article: :publish:\n#+hugo_auto_set_lastmod: t\n")
         :immediate-finish t
         :unnarrowed t)))


(add-hook 'python-mode-hook  #'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)

(use-package! paredit
  :after (clojure-mode)
  :config
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode))

(use-package! apheleia)

(use-package! forge
  :after magit
  :config
  (setq
        forge-alist
        '(("gitlab.ictrek.local" "gitlab.ictrek.local/api/v4" "gitlab.ictrek.local" forge-gitlab-repository)
        ("github.com" "api.github.com" "github.com" forge-github-repository)
        ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository))
        )
  (setq auth-sources '("~/.authinfo"))
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local/api/v4")
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local/api")
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local"))

(setq code-review-auth-login-marker 'forge)

;;(use-package! org-media-note)

;; files
(load! "elisp/hy")
(load! "elisp/wd")

;; (map!
;;  :map emacs-everywhere-mode-map
;;  "C-c C-c" #'emacs-everywhere--finish-or-ctrl-c-ctrl-c)

;; (defvar-local my/flycheck-local-cache nil)

;; (defun my/flycheck-checker-get (fn checker property)
;;   (or (alist-get property (alist-get checker my/flycheck-local-cache))
;;       (funcall fn checker property)))

;; (advice-add 'flycheck-checker-get :around 'my/flycheck-checker-get)

;; (add-hook 'lsp-managed-mode-hook
;;           (lambda ()
;;             (when (derived-mode-p 'python-mode)
;;               (setq my/flycheck-local-cache '((lsp . ((next-checkers . (python-pylint)))))))))

(use-package! ellama
  :init
  (setopt ellama-language "English")
  (setopt ellama-keymap-prefix "C-c e")
  (require 'llm-ollama)
  (setopt ellama-ollama-binary "/ssh:work:/usr/bin/ollama")
  (setq ellama-provider
        (make-llm-ollama
         :host "192.168.100.132"
         :port 11434
         :chat-model "zephyr"
         :embedding-model "zephyr")))



(setq ement-save-sessions t
      ement-room-message-format-spec "%B%r%R%t")
(map! :map ement-room-mode-map
      :n "c e" #'ement-room-edit-message
      :n "c m" #'ement-room-send-message
      :n "c r" #'ement-room-send-reaction
      :n "c i" #'ement-room-send-image
      :n "c f" #'ement-room-send-file
      :n "q"   #'kill-current-buffer
      )
(map! :map ement-room-list-mode-map
      :n "RET" #'ement-room-list-RET
      :n "q"   #'kill-current-buffer)
