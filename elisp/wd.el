;;; elisp/wd.el -*- lexical-binding: t; -*-


(defun qi/wd-search-word ()
  (interactive)
  (let ((default-directory temporary-file-directory))
    (let ((shell-output (shell-command-to-string
                       (concat "wd " (thing-at-point 'word 'no-properties)))))
      (popup-tip
       (replace-regexp-in-string "\033\\[[0-9;]*[mK]" "" shell-output)))))

 (map! :leader
      :desc "search word by wd"          "z" #'qi/wd-search-word)
