# Raw html can be embedded

The following will render the tag as is:


And this will render some Javascript:


## HTML blocks

They behave as follows:


## Cases on which html should be escaped

This should be escaped: `<html><script type="text/javascript">(function(){})</script></html>`

This should be escaped: `<html><script type`"text/javascript">(function(){})</script></html>=

This should be escaped: `@@html:<script type="text/javascript">@@(function(){})@@html:</script>@@`

This should be escaped: `@@html:<script type`"text/javascript">@@(function(){})@@html:</script>@@=
