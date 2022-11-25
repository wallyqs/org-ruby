
Org-mode export supports a lot of link features. I've covered "simple"
HTML links elsewhere. Now let's cover links to other org files, other
sections within documents, etc.

## Links to other org files

This is a link to the `code-comment.org` file in the same
directory. In `emacs`, if you click it, the other file opens. We
want the same behavior in the HTML export.

[Code Comment](file:code-comment.org)

## Search links

This is a search link into code-comment.org.

[Code Comment](file:code-comment.org::*Code%20Comment)

## Correct handling of .org URIs in HTML markup routine (thanks @rayl!)

 * [foo.com website](http://foo.com)

 * [foo.org website](http://foo.org)

 * [foo.org/foo.org](http://foo.org/foo.org)

 * [localhost:4567/foo.org](http://localhost:4567/foo.org)

## In these links, .org is converted to .html

 * [file:path.org label](file:path.org)

 * [file:notes/path.org label](file:notes/path.org)

## Links abbreviations

URLs can be abbreviated by a LINK definition in the org file


[This is an abbreviated link example](example)
