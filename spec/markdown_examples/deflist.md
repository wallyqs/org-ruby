
a :: hello
b :: world

Text

## Asterisk can be used for lists

One :: The first number.
Two :: The second number.
Three :: The second number.

## Corner cases of definition lists

The following examples show how org-ruby behave
when handling some cases of definition lists.
(Many thanks to [vonavi](https://github.com/vonavi) for his contributions here)

### Definition List Items

 * Regular list
Key :: Value (k1)
Key :: Value (k2)
Key :: Value (k3)

 * Semicolon as part of key
K::e::y :: Value (k1)
K::e::y :: Value (k2)

 * Paragraph break after key
Key ::
Value (k1)
Key ::
Value (k2)

 * Many semicolons in same line
Key :: Value :: Still value (k1)
Key :: Value :: Still value (k2)

 * Semicolon placement cases
  * Case 1
Key ::MoreKey :: Value (k1)
  * Case 2
Key:: MoreKey :: Value (k2)
  * Case 3
:: Key :: Value (k3)

### Not Definition List Items

The following cases will not be considered as definition lists
but just regular lists.

 * Key:: Value (n1)
 * Key ::Value (n2)
 * Key::Value (n3)
 * Key::
Value (n4)
 * Key
:: Value (n5)

### Definition List Item without Definition

??? will be shown in this case

 * Example list
Key :: Value :: Still value (k1)
Paragraph :: with :: no value
Key :: Value :: Still value (k1) ::
Paragraph :: with :: no value ::
::
Paragraph :: with :: no value
