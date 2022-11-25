
## Basic tests



## Within a commented block


## Within a center block

The following included file will be centered:



## Within a blockquote

This is similar to the center block:

> Before
> After

## Within an example block, it should not be possible to include a file.

#+INCLUDE: "./spec/html_examples/only-list.org"

## Within a list

 * A list that has an included file directive
  * Only go to the first level
   * when included it always goes to the first level and absorbs next list items
 * 3rd level
 * 3rd level, though it should be a different list

## Within a table, cannot be included

| One                                             | Two   | Three |
| #+INCLUDE: "./spec/html_examples/only-list.org" | Five  | Six   |
| Seven                                           | Eight | Nine  |


## When including a file as an example


## When including a file as an quote

