# Inline Formatting test for emphasis
## Simple feature test

__bold__

_italic_

`code`

`verbatim`

*underline*

~~strikethrough~~

[http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com)

http://www.gmail.com

[helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com)

## All together in one line

__bold__ _italic_ `code` `verbatim` *underline*  ~~strikethrough~~ [http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com) http://www.gmail.com [helpful text link](http://www.xkcd.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com)

## Within code test

```
emphasis_tests = [
"*bold*",
"/italic/",
"=code=",
"~verbatim~",
"_underline_ ",
"+strikethrough+",
"[[http://www.bing.com]]",
"[[http://www.google.com]]",
"[[http://www.xkcd.com][helpful text link]]",
"[[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg]]",
"[[http://www.xkcd.com][http://imgs.xkcd.com/comics/t_cells.png]]",
"<http://www.google.com>",
]

all = emphasis_tests.map do |a|
  emphasis_tests.map do |b|
    [b, ' ', a, ' ', b, "\n\n"].join('')
  end
end

all.each {|e| puts e}
```

## Mixed together test

```
emphasis_tests = ["*","/","=","~","_","+"]

all = emphasis_tests.map do |a|
  emphasis_tests.map do |b|
    [[a, 'Answer: ', b, '42', b, ' ',a, "\n\n"].join(''),
     [a, 'Answer: ', b, '42', b, '',a, "\n\n"].join('')].flatten
  end
end

all.each {|e| puts e}
```

__Answer: *42__ *

__Answer: *42*__

*Answer: _42_ *

__Answer: /42/__

*Answer: `42` *

__Answer: =42=__

*Answer: `42` *

__Answer: ~42~__

*Answer: *42* *

__Answer: _42___

*Answer: ~~42~~ *

__Answer: +42+__

/Answer: __42__ /

_Answer: *42*_

_Answer: /42_ /

_Answer: /42/_

/Answer: `42` /

_Answer: =42=_

/Answer: `42` /

_Answer: ~42~_

/Answer: *42* /

_Answer: _42__

/Answer: ~~42~~ /

_Answer: +42+_

=Answer: __42__ =

`Answer: *42*`

=Answer: _42_ =

`Answer: /42/`

`Answer: =42` =

`Answer: =42=`

=Answer: `42` =

`Answer: ~42~`

=Answer: *42* =

`Answer: _42_`

=Answer: ~~42~~ =

`Answer: +42+`

~Answer: __42__ ~

`Answer: *42*`

~Answer: _42_ ~

`Answer: /42/`

~Answer: `42` ~

`Answer: =42=`

`Answer: ~42` ~

`Answer: ~42~`

~Answer: *42* ~

`Answer: _42_`

~Answer: ~~42~~ ~

`Answer: +42+`

_Answer: __42__ _

*Answer: *42**

_Answer: _42_ _

*Answer: /42/*

_Answer: `42` _

*Answer: =42=*

_Answer: `42` _

*Answer: ~42~*

*Answer: _42* _

*Answer: _42_*

_Answer: ~~42~~ _

*Answer: +42+*

+Answer: __42__ +

~~Answer: *42*~~

+Answer: _42_ +

~~Answer: /42/~~

+Answer: `42` +

~~Answer: =42=~~

+Answer: `42` +

~~Answer: ~42~~~

+Answer: *42* +

~~Answer: _42_~~

~~Answer: +42~~ +

~~Answer: +42+~~

## Multiline support test :: one line

```
emphasis_tests = ["*","/","=","~","_","+"]

all = emphasis_tests.map do |a|
  emphasis_tests.map do |b|
    [a, 'Starting the line here ', "\n", b, 'and continuing here to close', b, a, "\n\n"].join('')
  end
end

all.each {|e| puts e}
```

__Starting the line here
*and continuing here to close*__

__Starting the line here
/and continuing here to close/__

__Starting the line here
=and continuing here to close=__

__Starting the line here
~and continuing here to close~__

__Starting the line here
_and continuing here to close___

__Starting the line here
+and continuing here to close+__

_Starting the line here
*and continuing here to close*_

_Starting the line here
/and continuing here to close/_

_Starting the line here
=and continuing here to close=_

_Starting the line here
~and continuing here to close~_

_Starting the line here
_and continuing here to close__

_Starting the line here
+and continuing here to close+_

`Starting the line here
*and continuing here to close*`

`Starting the line here
/and continuing here to close/`

`Starting the line here
=and continuing here to close=`

`Starting the line here
~and continuing here to close~`

`Starting the line here
_and continuing here to close_`

`Starting the line here
+and continuing here to close+`

`Starting the line here
*and continuing here to close*`

`Starting the line here
/and continuing here to close/`

`Starting the line here
=and continuing here to close=`

`Starting the line here
~and continuing here to close~`

`Starting the line here
_and continuing here to close_`

`Starting the line here
+and continuing here to close+`

*Starting the line here
*and continuing here to close**

*Starting the line here
/and continuing here to close/*

*Starting the line here
=and continuing here to close=*

*Starting the line here
~and continuing here to close~*

*Starting the line here
_and continuing here to close_*

*Starting the line here
+and continuing here to close+*

~~Starting the line here
*and continuing here to close*~~

~~Starting the line here
/and continuing here to close/~~

~~Starting the line here
=and continuing here to close=~~

~~Starting the line here
~and continuing here to close~~~

~~Starting the line here
_and continuing here to close_~~

~~Starting the line here
+and continuing here to close+~~

## Multiline support test :: two lines

```
emphasis_tests = ["*","/","=","~","_","+"]

all = emphasis_tests.map do |a|
  emphasis_tests.map do |b|
    [a, 'Starting the line here ', "\n", b, 'and continuing here', "\n", 'to close', b, a, "\n\n"].join('')
  end
end

all.each {|e| puts e}
```

*Starting the line here
__and continuing here
to close*__

*Starting the line here
/and continuing here
to close/*

*Starting the line here
=and continuing here
to close=*

*Starting the line here
~and continuing here
to close~*

*Starting the line here
_and continuing here
to close_*

*Starting the line here
+and continuing here
to close+*

/Starting the line here
*and continuing here
to close*/

/Starting the line here
_and continuing here
to close/_

/Starting the line here
=and continuing here
to close=/

/Starting the line here
~and continuing here
to close~/

/Starting the line here
_and continuing here
to close_/

/Starting the line here
+and continuing here
to close+/

=Starting the line here
*and continuing here
to close*=

=Starting the line here
/and continuing here
to close/=

=Starting the line here
`and continuing here
to close=`

=Starting the line here
~and continuing here
to close~=

=Starting the line here
_and continuing here
to close_=

=Starting the line here
+and continuing here
to close+=

~Starting the line here
*and continuing here
to close*~

~Starting the line here
/and continuing here
to close/~

~Starting the line here
=and continuing here
to close=~

~Starting the line here
`and continuing here
to close~`

~Starting the line here
_and continuing here
to close_~

~Starting the line here
+and continuing here
to close+~

_Starting the line here
*and continuing here
to close*_

_Starting the line here
/and continuing here
to close/_

_Starting the line here
=and continuing here
to close=_

_Starting the line here
~and continuing here
to close~_

_Starting the line here
*and continuing here
to close_*

_Starting the line here
+and continuing here
to close+_

+Starting the line here
*and continuing here
to close*+

+Starting the line here
/and continuing here
to close/+

+Starting the line here
=and continuing here
to close=+

+Starting the line here
~and continuing here
to close~+

+Starting the line here
_and continuing here
to close_+

+Starting the line here
~~and continuing here
to close+~~

## Together in same paragraph test

__bold__ __bold__ __bold__

_italic_ __bold__ _italic_

`code` __bold__ `code`

`verbatim` __bold__ `verbatim`

*underline*  __bold__ *underline*

~~strikethrough~~ __bold__ ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) __bold__ [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) __bold__ [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) __bold__ [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) __bold__ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) __bold__ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) __bold__ [http://www.google.com](http://www.google.com)

__bold__ _italic_ __bold__

_italic_ _italic_ _italic_

`code` _italic_ `code`

`verbatim` _italic_ `verbatim`

*underline*  _italic_ *underline*

~~strikethrough~~ _italic_ ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) _italic_ [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) _italic_ [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) _italic_ [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) _italic_ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) _italic_ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) _italic_ [http://www.google.com](http://www.google.com)

__bold__ `code` __bold__

_italic_ `code` _italic_

`code` `code` `code`

`verbatim` `code` `verbatim`

*underline*  `code` *underline*

~~strikethrough~~ `code` ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) `code` [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) `code` [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) `code` [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `code` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `code` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) `code` [http://www.google.com](http://www.google.com)

__bold__ `verbatim` __bold__

_italic_ `verbatim` _italic_

`code` `verbatim` `code`

`verbatim` `verbatim` `verbatim`

*underline*  `verbatim` *underline*

~~strikethrough~~ `verbatim` ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) `verbatim` [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) `verbatim` [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) `verbatim` [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `verbatim` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `verbatim` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) `verbatim` [http://www.google.com](http://www.google.com)

__bold__ *underline*  __bold__

_italic_ *underline*  _italic_

`code` *underline*  `code`

`verbatim` *underline*  `verbatim`

*underline*  *underline*  *underline*

~~strikethrough~~ *underline*  ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) *underline*  [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) *underline*  [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) *underline*  [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) *underline*  [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) *underline*  ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) *underline*  [http://www.google.com](http://www.google.com)

__bold__ ~~strikethrough~~ __bold__

_italic_ ~~strikethrough~~ _italic_

`code` ~~strikethrough~~ `code`

`verbatim` ~~strikethrough~~ `verbatim`

*underline*  ~~strikethrough~~ *underline*

~~strikethrough~~ ~~strikethrough~~ ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) ~~strikethrough~~ [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) ~~strikethrough~~ [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) ~~strikethrough~~ [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ~~strikethrough~~ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ~~strikethrough~~ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) ~~strikethrough~~ [http://www.google.com](http://www.google.com)

__bold__ [http://www.bing.com](http://www.bing.com) __bold__

_italic_ [http://www.bing.com](http://www.bing.com) _italic_

`code` [http://www.bing.com](http://www.bing.com) `code`

`verbatim` [http://www.bing.com](http://www.bing.com) `verbatim`

*underline*  [http://www.bing.com](http://www.bing.com) *underline*

~~strikethrough~~ [http://www.bing.com](http://www.bing.com) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) [http://www.bing.com](http://www.bing.com) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) [http://www.bing.com](http://www.bing.com) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.bing.com](http://www.bing.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.bing.com](http://www.bing.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com)

__bold__ [http://www.google.com](http://www.google.com) __bold__

_italic_ [http://www.google.com](http://www.google.com) _italic_

`code` [http://www.google.com](http://www.google.com) `code`

`verbatim` [http://www.google.com](http://www.google.com) `verbatim`

*underline*  [http://www.google.com](http://www.google.com) *underline*

~~strikethrough~~ [http://www.google.com](http://www.google.com) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)

__bold__ [helpful text link](http://www.xkcd.com) __bold__

_italic_ [helpful text link](http://www.xkcd.com) _italic_

`code` [helpful text link](http://www.xkcd.com) `code`

`verbatim` [helpful text link](http://www.xkcd.com) `verbatim`

*underline*  [helpful text link](http://www.xkcd.com) *underline*

~~strikethrough~~ [helpful text link](http://www.xkcd.com) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) [helpful text link](http://www.xkcd.com) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) [helpful text link](http://www.xkcd.com) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [helpful text link](http://www.xkcd.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [helpful text link](http://www.xkcd.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com)

__bold__ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) __bold__

_italic_ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) _italic_

`code` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `code`

`verbatim` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `verbatim`

*underline*  [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) *underline*

~~strikethrough~~ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com)

__bold__ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) __bold__

_italic_ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) _italic_

`code` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `code`

`verbatim` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `verbatim`

*underline*  ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) *underline*

~~strikethrough~~ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com)

__bold__ [http://www.google.com](http://www.google.com) __bold__

_italic_ [http://www.google.com](http://www.google.com) _italic_

`code` [http://www.google.com](http://www.google.com) `code`

`verbatim` [http://www.google.com](http://www.google.com) `verbatim`

*underline*  [http://www.google.com](http://www.google.com) *underline*

~~strikethrough~~ [http://www.google.com](http://www.google.com) ~~strikethrough~~

[http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com)

[http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)

[helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com)

[http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg)

![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)

[http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)

## Together within a table

| __bold__ __bold__                                                        | _italic_ __bold__                                                        | `code` __bold__                                                        | `verbatim` __bold__                                                        | *underline*  __bold__                                                        | ~~strikethrough~~ __bold__                                                        | [http://www.bing.com](http://www.bing.com) __bold__                                                        | [http://www.google.com](http://www.google.com) __bold__                                                        | [helpful text link](http://www.xkcd.com) __bold__                                                        | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) __bold__                                                        | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) __bold__                                                        | [http://www.google.com](http://www.google.com) __bold__                                                        |
| __bold__ _italic_                                                      | _italic_ _italic_                                                      | `code` _italic_                                                      | `verbatim` _italic_                                                      | *underline*  _italic_                                                      | ~~strikethrough~~ _italic_                                                      | [http://www.bing.com](http://www.bing.com) _italic_                                                      | [http://www.google.com](http://www.google.com) _italic_                                                      | [helpful text link](http://www.xkcd.com) _italic_                                                      | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) _italic_                                                      | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) _italic_                                                      | [http://www.google.com](http://www.google.com) _italic_                                                      |
| __bold__ `code`                                                        | _italic_ `code`                                                        | `code` `code`                                                        | `verbatim` `code`                                                        | *underline*  `code`                                                        | ~~strikethrough~~ `code`                                                        | [http://www.bing.com](http://www.bing.com) `code`                                                        | [http://www.google.com](http://www.google.com) `code`                                                        | [helpful text link](http://www.xkcd.com) `code`                                                        | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `code`                                                        | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `code`                                                        | [http://www.google.com](http://www.google.com) `code`                                                        |
| __bold__ `verbatim`                                                    | _italic_ `verbatim`                                                    | `code` `verbatim`                                                    | `verbatim` `verbatim`                                                    | *underline*  `verbatim`                                                    | ~~strikethrough~~ `verbatim`                                                    | [http://www.bing.com](http://www.bing.com) `verbatim`                                                    | [http://www.google.com](http://www.google.com) `verbatim`                                                    | [helpful text link](http://www.xkcd.com) `verbatim`                                                    | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) `verbatim`                                                    | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) `verbatim`                                                    | [http://www.google.com](http://www.google.com) `verbatim`                                                    |
| __bold__ *underline*                                                   | _italic_ *underline*                                                   | `code` *underline*                                                   | `verbatim` *underline*                                                   | *underline*  *underline*                                                   | ~~strikethrough~~ *underline*                                                   | [http://www.bing.com](http://www.bing.com) *underline*                                                   | [http://www.google.com](http://www.google.com) *underline*                                                   | [helpful text link](http://www.xkcd.com) *underline*                                                   | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) *underline*                                                   | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) *underline*                                                   | [http://www.google.com](http://www.google.com) *underline*                                                   |
| __bold__ ~~strikethrough~~                                               | _italic_ ~~strikethrough~~                                               | `code` ~~strikethrough~~                                               | `verbatim` ~~strikethrough~~                                               | *underline*  ~~strikethrough~~                                               | ~~strikethrough~~ ~~strikethrough~~                                               | [http://www.bing.com](http://www.bing.com) ~~strikethrough~~                                               | [http://www.google.com](http://www.google.com) ~~strikethrough~~                                               | [helpful text link](http://www.xkcd.com) ~~strikethrough~~                                               | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ~~strikethrough~~                                               | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ~~strikethrough~~                                               | [http://www.google.com](http://www.google.com) ~~strikethrough~~                                               |
| __bold__ [http://www.bing.com](http://www.bing.com)                                           | _italic_ [http://www.bing.com](http://www.bing.com)                                           | `code` [http://www.bing.com](http://www.bing.com)                                           | `verbatim` [http://www.bing.com](http://www.bing.com)                                           | *underline*  [http://www.bing.com](http://www.bing.com)                                           | ~~strikethrough~~ [http://www.bing.com](http://www.bing.com)                                           | [http://www.bing.com](http://www.bing.com) [http://www.bing.com](http://www.bing.com)                                           | [http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com)                                           | [helpful text link](http://www.xkcd.com) [http://www.bing.com](http://www.bing.com)                                           | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.bing.com](http://www.bing.com)                                           | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.bing.com](http://www.bing.com)                                           | [http://www.google.com](http://www.google.com) [http://www.bing.com](http://www.bing.com)                                           |
| __bold__ [http://www.google.com](http://www.google.com)                                         | _italic_ [http://www.google.com](http://www.google.com)                                         | `code` [http://www.google.com](http://www.google.com)                                         | `verbatim` [http://www.google.com](http://www.google.com)                                         | *underline*  [http://www.google.com](http://www.google.com)                                         | ~~strikethrough~~ [http://www.google.com](http://www.google.com)                                         | [http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com)                                         | [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)                                         | [helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com)                                         | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com)                                         | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com)                                         | [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)                                         |
| __bold__ [helpful text link](http://www.xkcd.com)                                             | _italic_ [helpful text link](http://www.xkcd.com)                                             | `code` [helpful text link](http://www.xkcd.com)                                             | `verbatim` [helpful text link](http://www.xkcd.com)                                             | *underline*  [helpful text link](http://www.xkcd.com)                                             | ~~strikethrough~~ [helpful text link](http://www.xkcd.com)                                             | [http://www.bing.com](http://www.bing.com) [helpful text link](http://www.xkcd.com)                                             | [http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com)                                             | [helpful text link](http://www.xkcd.com) [helpful text link](http://www.xkcd.com)                                             | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [helpful text link](http://www.xkcd.com)                                             | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [helpful text link](http://www.xkcd.com)                                             | [http://www.google.com](http://www.google.com) [helpful text link](http://www.xkcd.com)                                             |
| __bold__ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | _italic_ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | `code` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | `verbatim` [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | *underline*  [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | ~~strikethrough~~ [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | [http://www.bing.com](http://www.bing.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | [http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | [helpful text link](http://www.xkcd.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) | [http://www.google.com](http://www.google.com) [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) |
| __bold__ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | _italic_ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | `code` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | `verbatim` ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | *underline*  ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | ~~strikethrough~~ ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | [http://www.bing.com](http://www.bing.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | [http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | [helpful text link](http://www.xkcd.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       | [http://www.google.com](http://www.google.com) ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png)                       |
| __bold__ [http://www.google.com](http://www.google.com)                                       | _italic_ [http://www.google.com](http://www.google.com)                                       | `code` [http://www.google.com](http://www.google.com)                                       | `verbatim` [http://www.google.com](http://www.google.com)                                       | *underline*  [http://www.google.com](http://www.google.com)                                       | ~~strikethrough~~ [http://www.google.com](http://www.google.com)                                       | [http://www.bing.com](http://www.bing.com) [http://www.google.com](http://www.google.com)                                       | [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)                                       | [helpful text link](http://www.xkcd.com) [http://www.google.com](http://www.google.com)                                       | [http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg](http://farm7.static.flickr.com/6078/6084185195_552aa270b2.jpg) [http://www.google.com](http://www.google.com)                                       | ![http://imgs.xkcd.com/comics/t_cells.png](http://imgs.xkcd.com/comics/t_cells.png) [http://www.google.com](http://www.google.com)                                       | [http://www.google.com](http://www.google.com) [http://www.google.com](http://www.google.com)                                       |
