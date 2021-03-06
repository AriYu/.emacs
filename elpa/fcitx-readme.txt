Chinese version of README: https://github.com/cute-jumper/fcitx.el/blob/master/README-zh.org

#+TITLE: fcitx.el
Make [[https://github.com/fcitx/fcitx/][fcitx]] better in Emacs.

This package provides a set of functions to make fcitx work better in Emacs.

* Setup
  : (add-to-list 'load-path "/path/to/fcitx.el")
  : (require 'fcitx)

  Recommended though optional:
  : M-x fcitx-default-setup

  Alternatively, you can use a more aggressive setup:
  : M-x fcitx-aggressive-setup

  The differences between these two setups will be illustrated later.

  Calling =fcitx-default-setup= will enable all the features that this
  package provides and use default settings. See the following sections for
  details.

  Note that for every feature, there are both =*-turn-on= and =*-turn-off=
  functions defined, which can enable and disable the corresponding feature,
  respectively.

* Disable Fcitx by Prefix Keys
  If you've enabled fcitx, then you can't easily change your buffer by "C-x b"
  because the second key "b" will be blocked by fcitx(and you need to press
  "enter" in order to send "b" to emacs). This package provides a way
  to define the prefix keys after which you can temporarily disable fcitx.

  For example, you want to temporarily disable fcitx after you press "C-x" so
  that you can directly type "b" after "C-x" and after you press "b", fcitx will
  be activated again so you can still type Chinese buffer name. To define "C-x"
  to be the prefix key that can temporarily disable fcitx:
  : (fcitx-prefix-keys-add "C-x")

  Usually, defining "C-x" and "C-c" to be such prefix keys is enough for most
  users. You can simply use following command:
  : (fcitx-prefix-keys-setup)
  to add "C-x" and "C-c".

  After defining prefix keys, you need to call
  : (fcitx-prefix-keys-turn-on)
  to enable this feature.

  Of course, you can use
  : (fcitx-prefix-keys-turn-off)
  to disable this feature.

  Note if you use =M-x fcitx-default-setup=, then it already does all the
  above things, i.e. adding "C-x" and "C-c" to be prefix keys and enabling this
  feature, for you.

* Evil Support
  To disable fcitx when you exiting "insert mode" and enable fcitx after
  entering "insert mode" if originally you enable it in "insert mode":
  : (fcitx-evil-turn-on)

  It currently should work well for "entering" and "exiting" the insert state.
  It will also disable fcitx if you use =switch-to-buffer= or =other-window= to
  switch to a buffer which is not in insert state or Emacs state. For example,
  if you're currently in insert mode in buffer =A= and you've enabled fcitx,
  then you call =switch-to-buffer= to switch to another buffer =B=, which is
  currently, say, in normal mode, then fcitx will be disabled in buffer =B=.

  Note that currently the Evil support is not perfect. If you come across any
  bugs, consider file an issue or creating a pull request.

  Similarly, =M-x fcitx-default-setup= enables this feature.

* =M-x=, =M-!=, =M-&= and =M-:= Support
  Usually you don't want to type Chinese when you use =M-x=, =M-!=
  (=shell-command=), =M-&= (=async-shell-command=) or =M-:= (=eval-expression=).
  You can use:
  : (fcitx-M-x-turn-on)
  : (fcitx-shell-command-turn-on)
  : (fcitx-eval-expression-turn-on)
  to disable fcitx temporarily in these commands.

  =M-x= should work with the original =M-x= (=execute-extended-command=), =smex=
  and =helm-M-x=.

  Again, =M-x fcitx-default-setup= enables all these three features.

  Note: If you rebind =M-x= to =smex= or =helm-M-x=, then you should call
  =fcitx-default-setup= or =fcitx-M-x-turn-on= *after* the rebinding.

* Aggressive setup
  For me, I personally don't need to type Chinese in minibuffer, so I would like
  to temporarily disable fcitx in minibuffer, no matter in what kind of command.
  If you are the same as me, then you could choose this setup.

  Basically, =fcitx-aggressive-setup= would setup prefix keys feature and Evil
  support as =fcitx-default-setup= does, but it would not turn on =M-x=, =M-!=,
  =M-&= and =M-:= support. Instead, it will call
  =fcitx-aggressive-minibuffer-turn-on= to temporarily disable fcitx in all
  commands that use minibuffer as a source of input, including, but not limited
  to, =M-x=, =M-!=, =M-&= and =M-:=. That is why this is called
  "aggressive-setup". For example, if you press "C-x b" to switch buffer, or
  press "C-x C-f" to find file, fcitx will be disabled when you are in the
  minibuffer. I prefer this setup because I don't use Chinese in my filename or
  buffer name.

* TODO TODO
  - Better Evil support
  - Add =key-chord= support

  For more features, pull requests are always welcome!
