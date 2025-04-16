;;; $DOOMDIR/config.el -*- lexical-binding: tnts in Doom:
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
;;(setq doom-font (font-spec :family "Fira Code" :size 20 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 18))
(setq doom-font (font-spec :size 20))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'dichromacy)
(setq doom-theme 'ef-light)

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

(setq org-roam-directory "~/Nextcloud/org-roam/daily/2024")

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
(add-hook 'scheme-mode-hook #'rainbow-delimiters-mode)
;; (add-hook 'org-mode-hook #'rainbow-delimiters-mode)

(use-package! paredit
  :after (clojure-mode)
  :config
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode))

(use-package! apheleia)


(setq auth-sources '("~/.authinfo"))
(use-package! forge
  :after magit
  :config
  (setq
        forge-alist
        '(("gitlab.ictrek.local" "gitlab.ictrek.local/api/v4" "gitlab.ictrek.local" forge-gitlab-repository)
        ("github.com" "api.github.com" "github.com" forge-github-repository)
        ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository))
        )
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local/api/v4")
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local/api")
  (add-to-list 'ghub-insecure-hosts "gitlab.ictrek.local")
  :bind
  (:map magit-mode-map  ("C-c C-r" . forge-topic-set-review-requests)))

(use-package! code-review
  :after forge
  :config
  (setq code-review-auth-login-marker 'forge)
  (setq code-review-gitlab-base-url "gitlab.ictrek.local")
  (setq code-review-gitlab-host "gitlab.ictrek.local/api")
  (setq code-review-gitlab-graphql-host "gitlab.ictrek.local/api"))

;;(use-package! org-media-note)

;; files
(load! "elisp/hy")
(load! "elisp/wd")

;; (map!
;;  :map emacs-everywhere-mode-map
;;  "C-c C-c" #'emacs-everywhere--finish-or-ctrl-c-ctrl-c)

(defvar-local my/flycheck-local-cache nil)

(defun my/flycheck-checker-get (fn checker property)
  (or (alist-get property (alist-get checker my/flycheck-local-cache))
      (funcall fn checker property)))

(advice-add 'flycheck-checker-get :around 'my/flycheck-checker-get)

(add-hook 'lsp-managed-mode-hook
          (lambda ()
            (when (and (string= nil (file-remote-p default-directory))
                       (derived-mode-p 'python-mode))
              (setq my/flycheck-local-cache '((lsp . ((next-checkers . (python-flake8)))))))))

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

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

;; dap-mode settings
(after! dap-mode
  (setq dap-python-debugger 'debugpy)
  (defun dap-python--pyenv-executable-find (command)
    (executable-find command)))

(setq! python-shell-remote-exec-path '("/opt/vision-storage/bin"))

(defvar poetry-venv-list '()
  "List of known poetry virtualenvs.")

(defvar poetry-saved-venv nil
  "Virtualenv activated before changed it.
Allow to re-enable the previous virtualenv when leaving the poetry project.")

(defun my/track-python-virtualenv (&optional _)
  (interactive)
  (when (and buffer-file-name
             (string= nil (file-remote-p default-directory)))
    (cond ((locate-dominating-file default-directory "pyproject.toml")
           (if-let ((poetry-current-project-venv (cdr (assq '(locate-dominating-file default-directory "pyproject.toml") poetry-venv-list))))
               (when (not (equal python-shell-virtualenv-path poetry-current-project-venv))
                 (pyvenv-activate poetry-current-project-venv))
             (let ((poetry-project-path (locate-dominating-file default-directory "pyproject.toml"))
                   (poetry-venv-path (s-trim (shell-command-to-string "env -u VIRTUAL_ENV poetry env info -p"))))
               (pyvenv-activate poetry-venv-path)
               (add-to-list 'poetry-venv-list (cons poetry-project-path poetry-venv-path)))))
          ((locate-dominating-file default-directory ".venv")
           (pyvenv-activate (concat (locate-dominating-file default-directory ".venv") ".venv")))
          (t (pyvenv-deactivate)))))

(add-to-list 'window-buffer-change-functions 'my/track-python-virtualenv)
(add-hook 'python-mode-hook 'my/track-python-virtualenv)


(defun my/run-python-unittest ()
  (interactive)
  (async-shell-command "python3 -m unittest -v" "*Messages*"))

(map! :map python-mode-map
      :leader
      :prefix ("mt" . "test")
      :desc "run unittest"          "u" #'my/run-python-unittest)

;;(add-hook 'window-setup-hook #'toggle-frame-fullscreen)


;(defun save-with-title ()
;;   "Save the current buffer with the name taken from the #+TITLE: property in the document.
;;    Keep the original date prefix in the file name."
;;   (interactive)
;;   (when (eq major-mode 'org-mode)
;;     (save-excursion
;;       (goto-char (point-min))
;;       (if (re-search-forward "^#\\+TITLE: \\(.*\\)$" nil t)
;;           (let ((title (match-string 1)))
;;             (let* ((date-prefix (file-name-base buffer-file-name))
;;                    (new-file-name (concat (file-name-directory buffer-file-name)
;;                                           date-prefix "-" title ".org")))
;;               (unless (string-equal buffer-file-name new-file-name)
;;                 (rename-file buffer-file-name new-file-name 1)
;;                 (set-visited-file-name new-file-name t t)
;;                 (message "File renamed to %s" new-file-name))))))))

;; ;; Add the function to the `before-save-hook` for org-mode
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'save-with-title nil t)))



(defun my/org-roam-garden-dashboard--build-item (node)
  (concat "\n** " (org-roam-node-title node) "\n[[" (org-roam-node-file node) "]]"))

(defun my/org-roam-garden-dashboard ()
  (interactive)
  (with-current-buffer (get-buffer-create "*Garden*")
    (erase-buffer)
    (let ((node-list (org-roam-node-list)))
      (insert "* 🌱 seedling")
      (insert (string-join (mapcar #'my/org-roam-garden-dashboard--build-item
                                   node-list))))
    (org-mode)
    (switch-to-buffer (current-buffer))))



(use-package kubernetes)
(use-package kubernetes-evil
  :ensure t
  :after kubernetes)
(use-package poke-line
  :ensure t)

(defun my/kubernetes-buff-yaml-highlight ()
  (require 'yaml-mode)
  (setq font-lock-defaults '(yaml-font-lock-keywords))
  (font-lock-update))

(add-hook 'kubernetes-mode-hook #'my/kubernetes-buff-yaml-highlight)


(defvar aaii-code-session nil)

(defun aaii-region-request (beg end)
  (interactive "r")
  (unless aaii-code-session
    (let ((session-uuid (uuidgen-4)))
      (message (concat "Build new session " session-uuid))
      (setq aaii-code-session session-uuid)
      (request
        "https://aaii.southfox.gay/abcfox/generate_session"
        :type "POST"
        :headers '(("Content-Type" . "application/json"))
        :data (json-encode `(("session_uuid" . ,session-uuid)
                             ("model" . "gemini-1.5-pro")))
        :error (cl-function
                  (lambda (&key data &allow-other-keys)
                    (message "Build new session error.")
                    (setq aaii-code-session nil)))
        :sync t)))

  (let ((prompt (concat "解释下面这段代码，并使用 markdown 格式化输出：\n" (buffer-substring-no-properties beg end))))
    (with-current-buffer (get-buffer-create "*AAII*")
      (goto-char (point-min))
      (insert (concat "# 询问\n" prompt "\n")))
    (request
      "https://aaii.southfox.gay/abcfox/generate_text_stream"
      :type "POST"
      :headers '(("Content-Type" . "application/json"))
      :data (json-encode `(("session_uuid" . ,aaii-code-session) ("prompt" . ,prompt)))
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (with-current-buffer (get-buffer-create "*AAII*")
                    (goto-char (point-min))
                    (insert (concat "# AAII 回答\n" data "\n"))
                    (switch-to-buffer-other-window (current-buffer))
                    (markdown-mode)
                    (goto-char (point-min))))))))
