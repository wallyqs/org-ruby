
`Org-ruby` supports "smart double quotes," 'smart single quotes,'
apostrophes for contractions like won't and can't, and other
things... like elipses. Oh -- and dashes.

 * Question: What does org-mode do for ampersands, like R&R? or &lt;?
 * Answer: Those get escaped, too. ☺

# <Even in headlines! funner & funner!>

« They α should β be γ
able δ to η exist θ in ε
the same line √ ».

```
\laquo They won't appear in in example blocks. \raquo
```

⌈ — — — — — — ⌉

Though they appear in center blocks

⌊ — — — — — — ⌋

To work they have to be separated, like ♥ ♥, not like ♥\hearts.

# List of entities supported

```
# Script to generate the list of currently supported entities
require 'org-ruby'

Orgmode::HtmlEntities.each_pair do |entity, _|
  puts "- Writing =\\#{entity}=, results in: \\#{entity}"
end
```

```
bundle exec ruby /tmp/print_entities.rb
```

 * Writing `\Agrave`, results in: À
 * Writing `\agrave`, results in: à
 * Writing `\Aacute`, results in: Á
 * Writing `\aacute`, results in: á
 * Writing `\Acirc`, results in: Â
 * Writing `\acirc`, results in: â
 * Writing `\Atilde`, results in: Ã
 * Writing `\atilde`, results in: ã
 * Writing `\Auml`, results in: Ä
 * Writing `\auml`, results in: ä
 * Writing `\Aring`, results in: Å
 * Writing `\AA`, results in: Å
 * Writing `\aring`, results in: å
 * Writing `\AElig`, results in: Æ
 * Writing `\aelig`, results in: æ
 * Writing `\Ccedil`, results in: Ç
 * Writing `\ccedil`, results in: ç
 * Writing `\Egrave`, results in: È
 * Writing `\egrave`, results in: è
 * Writing `\Eacute`, results in: É
 * Writing `\eacute`, results in: é
 * Writing `\Ecirc`, results in: Ê
 * Writing `\ecirc`, results in: ê
 * Writing `\Euml`, results in: Ë
 * Writing `\euml`, results in: ë
 * Writing `\Igrave`, results in: Ì
 * Writing `\igrave`, results in: ì
 * Writing `\Iacute`, results in: Í
 * Writing `\iacute`, results in: í
 * Writing `\Icirc`, results in: Î
 * Writing `\icirc`, results in: î
 * Writing `\Iuml`, results in: Ï
 * Writing `\iuml`, results in: ï
 * Writing `\Ntilde`, results in: Ñ
 * Writing `\ntilde`, results in: ñ
 * Writing `\Ograve`, results in: Ò
 * Writing `\ograve`, results in: ò
 * Writing `\Oacute`, results in: Ó
 * Writing `\oacute`, results in: ó
 * Writing `\Ocirc`, results in: Ô
 * Writing `\ocirc`, results in: ô
 * Writing `\Otilde`, results in: Õ
 * Writing `\otilde`, results in: õ
 * Writing `\Ouml`, results in: Ö
 * Writing `\ouml`, results in: ö
 * Writing `\Oslash`, results in: Ø
 * Writing `\oslash`, results in: ø
 * Writing `\OElig`, results in: Œ
 * Writing `\oelig`, results in: œ
 * Writing `\Scaron`, results in: Š
 * Writing `\scaron`, results in: š
 * Writing `\szlig`, results in: ß
 * Writing `\Ugrave`, results in: Ù
 * Writing `\ugrave`, results in: ù
 * Writing `\Uacute`, results in: Ú
 * Writing `\uacute`, results in: ú
 * Writing `\Ucirc`, results in: Û
 * Writing `\ucirc`, results in: û
 * Writing `\Uuml`, results in: Ü
 * Writing `\uuml`, results in: ü
 * Writing `\Yacute`, results in: Ý
 * Writing `\yacute`, results in: ý
 * Writing `\Yuml`, results in: Ÿ
 * Writing `\yuml`, results in: ÿ
 * Writing `\fnof`, results in: ƒ
 * Writing `\real`, results in: ℜ
 * Writing `\image`, results in: ℑ
 * Writing `\weierp`, results in: ℘
 * Writing `\Alpha`, results in: Α
 * Writing `\alpha`, results in: α
 * Writing `\Beta`, results in: Β
 * Writing `\beta`, results in: β
 * Writing `\Gamma`, results in: Γ
 * Writing `\gamma`, results in: γ
 * Writing `\Delta`, results in: Δ
 * Writing `\delta`, results in: δ
 * Writing `\Epsilon`, results in: Ε
 * Writing `\epsilon`, results in: ε
 * Writing `\varepsilon`, results in: ε
 * Writing `\Zeta`, results in: Ζ
 * Writing `\zeta`, results in: ζ
 * Writing `\Eta`, results in: Η
 * Writing `\eta`, results in: η
 * Writing `\Theta`, results in: Θ
 * Writing `\theta`, results in: θ
 * Writing `\thetasym`, results in: ϑ
 * Writing `\vartheta`, results in: ϑ
 * Writing `\Iota`, results in: Ι
 * Writing `\iota`, results in: ι
 * Writing `\Kappa`, results in: Κ
 * Writing `\kappa`, results in: κ
 * Writing `\Lambda`, results in: Λ
 * Writing `\lambda`, results in: λ
 * Writing `\Mu`, results in: Μ
 * Writing `\mu`, results in: μ
 * Writing `\nu`, results in: ν
 * Writing `\Nu`, results in: Ν
 * Writing `\Xi`, results in: Ξ
 * Writing `\xi`, results in: ξ
 * Writing `\Omicron`, results in: Ο
 * Writing `\omicron`, results in: ο
 * Writing `\Pi`, results in: Π
 * Writing `\pi`, results in: π
 * Writing `\Rho`, results in: Ρ
 * Writing `\rho`, results in: ρ
 * Writing `\Sigma`, results in: Σ
 * Writing `\sigma`, results in: σ
 * Writing `\sigmaf`, results in: ς
 * Writing `\varsigma`, results in: ς
 * Writing `\Tau`, results in: Τ
 * Writing `\Upsilon`, results in: Υ
 * Writing `\upsih`, results in: ϒ
 * Writing `\upsilon`, results in: υ
 * Writing `\Phi`, results in: Φ
 * Writing `\phi`, results in: φ
 * Writing `\Chi`, results in: Χ
 * Writing `\chi`, results in: χ
 * Writing `\acutex`, results in: 𝑥́
 * Writing `\Psi`, results in: Ψ
 * Writing `\psi`, results in: ψ
 * Writing `\tau`, results in: τ
 * Writing `\Omega`, results in: Ω
 * Writing `\omega`, results in: ω
 * Writing `\piv`, results in: ϖ
 * Writing `\partial`, results in: ∂
 * Writing `\alefsym`, results in: ℵ
 * Writing `\ETH`, results in: Ð
 * Writing `\eth`, results in: ð
 * Writing `\THORN`, results in: Þ
 * Writing `\thorn`, results in: þ
 * Writing `\dots`, results in: …
 * Writing `\hellip`, results in: …
 * Writing `\middot`, results in: ·
 * Writing `\iexcl`, results in: ¡
 * Writing `\iquest`, results in: ¿
 * Writing `\shy`, results in: 
 * Writing `\ndash`, results in: –
 * Writing `\mdash`, results in: —
 * Writing `\quot`, results in: "
 * Writing `\acute`, results in: ´
 * Writing `\ldquo`, results in: “
 * Writing `\rdquo`, results in: ”
 * Writing `\bdquo`, results in: „
 * Writing `\lsquo`, results in: ‘
 * Writing `\rsquo`, results in: ’
 * Writing `\sbquo`, results in: ‚
 * Writing `\laquo`, results in: «
 * Writing `\raquo`, results in: »
 * Writing `\lsaquo`, results in: ‹
 * Writing `\rsaquo`, results in: ›
 * Writing `\circ`, results in: ˆ
 * Writing `\vert`, results in: |
 * Writing `\brvbar`, results in: ¦
 * Writing `\sect`, results in: §
 * Writing `\amp`, results in: &
 * Writing `\lt`, results in: <
 * Writing `\gt`, results in: >
 * Writing `\tilde`, results in: ~
 * Writing `\slash`, results in: /
 * Writing `\plus`, results in: +
 * Writing `\under`, results in: _
 * Writing `\equal`, results in: =
 * Writing `\asciicirc`, results in: ^
 * Writing `\dagger`, results in: †
 * Writing `\Dagger`, results in: ‡
 * Writing `\nbsp`, results in:  
 * Writing `\ensp`, results in:  
 * Writing `\emsp`, results in:  
 * Writing `\thinsp`, results in:  
 * Writing `\curren`, results in: ¤
 * Writing `\cent`, results in: ¢
 * Writing `\pound`, results in: £
 * Writing `\yen`, results in: ¥
 * Writing `\euro`, results in: €
 * Writing `\EUR`, results in: €
 * Writing `\EURdig`, results in: €
 * Writing `\EURhv`, results in: €
 * Writing `\EURcr`, results in: €
 * Writing `\EURtm`, results in: €
 * Writing `\copy`, results in: ©
 * Writing `\reg`, results in: ®
 * Writing `\trade`, results in: ™
 * Writing `\minus`, results in: −
 * Writing `\pm`, results in: ±
 * Writing `\plusmn`, results in: ±
 * Writing `\times`, results in: ×
 * Writing `\frasl`, results in: ⁄
 * Writing `\div`, results in: ÷
 * Writing `\frac12`, results in: ½
 * Writing `\frac14`, results in: ¼
 * Writing `\frac34`, results in: ¾
 * Writing `\permil`, results in: ‰
 * Writing `\sup1`, results in: ¹
 * Writing `\sup2`, results in: ²
 * Writing `\sup3`, results in: ³
 * Writing `\radic`, results in: √
 * Writing `\sum`, results in: ∑
 * Writing `\prod`, results in: ∏
 * Writing `\micro`, results in: µ
 * Writing `\macr`, results in: ¯
 * Writing `\deg`, results in: °
 * Writing `\prime`, results in: ′
 * Writing `\Prime`, results in: ″
 * Writing `\infin`, results in: ∞
 * Writing `\infty`, results in: ∞
 * Writing `\prop`, results in: ∝
 * Writing `\proptp`, results in: ∝
 * Writing `\not`, results in: ¬
 * Writing `\neg`, results in: ¬
 * Writing `\land`, results in: ∧
 * Writing `\wedge`, results in: ∧
 * Writing `\lor`, results in: ∨
 * Writing `\vee`, results in: ∨
 * Writing `\cap`, results in: ∩
 * Writing `\cup`, results in: ∪
 * Writing `\int`, results in: ∫
 * Writing `\there4`, results in: ∴
 * Writing `\sim`, results in: ∼
 * Writing `\cong`, results in: ≅
 * Writing `\simeq`, results in: ≅
 * Writing `\asymp`, results in: ≈
 * Writing `\approx`, results in: ≈
 * Writing `\ne`, results in: ≠
 * Writing `\neq`, results in: ≠
 * Writing `\equiv`, results in: ≡
 * Writing `\le`, results in: ≤
 * Writing `\ge`, results in: ≥
 * Writing `\sub`, results in: ⊂
 * Writing `\subset`, results in: ⊂
 * Writing `\sup`, results in: ⊃
 * Writing `\supset`, results in: ⊃
 * Writing `\nsub`, results in: ⊄
 * Writing `\sube`, results in: ⊆
 * Writing `\nsup`, results in: ⊅
 * Writing `\supe`, results in: ⊇
 * Writing `\forall`, results in: ∀
 * Writing `\exist`, results in: ∃
 * Writing `\exists`, results in: ∃
 * Writing `\empty`, results in: ∅
 * Writing `\emptyset`, results in: ∅
 * Writing `\isin`, results in: ∈
 * Writing `\in`, results in: ∈
 * Writing `\notin`, results in: ∉
 * Writing `\ni`, results in: ∋
 * Writing `\nabla`, results in: ∇
 * Writing `\ang`, results in: ∠
 * Writing `\angle`, results in: ∠
 * Writing `\perp`, results in: ⊥
 * Writing `\sdot`, results in: ⋅
 * Writing `\cdot`, results in: ⋅
 * Writing `\lceil`, results in: ⌈
 * Writing `\rceil`, results in: ⌉
 * Writing `\lfloor`, results in: ⌊
 * Writing `\rfloor`, results in: ⌋
 * Writing `\lang`, results in: ⟨
 * Writing `\rang`, results in: ⟩
 * Writing `\larr`, results in: ←
 * Writing `\leftarrow`, results in: ←
 * Writing `\gets`, results in: ←
 * Writing `\lArr`, results in: ⇐
 * Writing `\Leftarrow`, results in: ⇐
 * Writing `\uarr`, results in: ↑
 * Writing `\uparrow`, results in: ↑
 * Writing `\uArr`, results in: ⇑
 * Writing `\Uparrow`, results in: ⇑
 * Writing `\rarr`, results in: →
 * Writing `\to`, results in: →
 * Writing `\rightarrow`, results in: →
 * Writing `\rArr`, results in: ⇒
 * Writing `\Rightarrow`, results in: ⇒
 * Writing `\darr`, results in: ↓
 * Writing `\downarrow`, results in: ↓
 * Writing `\dArr`, results in: ⇓
 * Writing `\Downarrow`, results in: ⇓
 * Writing `\harr`, results in: ↔
 * Writing `\leftrightarrow`, results in: ↔
 * Writing `\hArr`, results in: ⇔
 * Writing `\Leftrightarrow`, results in: ⇔
 * Writing `\crarr`, results in: ↵
 * Writing `\hookleftarrow`, results in: ↵
 * Writing `\arccos`, results in: arccos
 * Writing `\arcsin`, results in: arcsin
 * Writing `\arctan`, results in: arctan
 * Writing `\arg`, results in: arg
 * Writing `\cos`, results in: cos
 * Writing `\cosh`, results in: cosh
 * Writing `\cot`, results in: cot
 * Writing `\coth`, results in: coth
 * Writing `\csc`, results in: csc
 * Writing `\det`, results in: det
 * Writing `\dim`, results in: dim
 * Writing `\exp`, results in: exp
 * Writing `\gcd`, results in: gcd
 * Writing `\hom`, results in: hom
 * Writing `\inf`, results in: inf
 * Writing `\ker`, results in: ker
 * Writing `\lg`, results in: lg
 * Writing `\lim`, results in: lim
 * Writing `\liminf`, results in: liminf
 * Writing `\limsup`, results in: limsup
 * Writing `\ln`, results in: ln
 * Writing `\log`, results in: log
 * Writing `\max`, results in: max
 * Writing `\min`, results in: min
 * Writing `\Pr`, results in: Pr
 * Writing `\sec`, results in: sec
 * Writing `\sin`, results in: sin
 * Writing `\sinh`, results in: sinh
 * Writing `\tan`, results in: tan
 * Writing `\tanh`, results in: tanh
 * Writing `\bull`, results in: •
 * Writing `\bullet`, results in: •
 * Writing `\star`, results in: ⋆
 * Writing `\lowast`, results in: ∗
 * Writing `\ast`, results in: *
 * Writing `\odot`, results in: ʘ
 * Writing `\oplus`, results in: ⊕
 * Writing `\otimes`, results in: ⊗
 * Writing `\checkmark`, results in: ✓
 * Writing `\para`, results in: ¶
 * Writing `\ordf`, results in: ª
 * Writing `\ordm`, results in: º
 * Writing `\cedil`, results in: ¸
 * Writing `\oline`, results in: ‾
 * Writing `\uml`, results in: ¨
 * Writing `\zwnj`, results in: ‌
 * Writing `\zwj`, results in: ‍
 * Writing `\lrm`, results in: ‎
 * Writing `\rlm`, results in: ‏
 * Writing `\smile`, results in: ⌣
 * Writing `\smiley`, results in: ☺
 * Writing `\blacksmile`, results in: ☻
 * Writing `\sad`, results in: ☹
 * Writing `\clubs`, results in: ♣
 * Writing `\clubsuit`, results in: ♣
 * Writing `\spades`, results in: ♠
 * Writing `\spadesuit`, results in: ♠
 * Writing `\hearts`, results in: ♥
 * Writing `\heartsuit`, results in: ♥
 * Writing `\diams`, results in: ♦
 * Writing `\diamondsuit`, results in: ♦
 * Writing `\Diamond`, results in: ⋄
 * Writing `\loz`, results in: ◊

# Some special cases

In case nothing matches, the string is returned as is.

\for \example \this \wont \break
