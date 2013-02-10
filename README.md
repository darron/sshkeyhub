sshkeyhub
=========

What is this?
-------------

This is just a way to associate an email address with a Github username. With a Github username, your public ssh keys can be downloaded easily.

Is this safe?
-------------

We never store any of your private information, the Github login is handled via oAuth. We only store your verified email addresses and the associated login. 

How does it work?
-----------------
First - [sign into Github](http://sskeyhub.org/auth/github).

Then, put your email address at the end of the URL - your keys will be downloaded - as an example:

[http://sshkeyhub.org/darron@froese.org](http://sshkeyhub.org/darron@froese.org)

But I've changed my public keys - do I need to do anything?
-----------------------------------------------------------

No - we ask Github for your keys every time - they will automatically update.


Thanks
======
Started from: [https://gist.github.com/cthiel/4df21cf628cc3a8f1568](https://gist.github.com/cthiel/4df21cf628cc3a8f1568)

Login button from: [/samcollins/css-social-buttons/](https://github.com/samcollins/css-social-buttons/)