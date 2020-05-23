As a rule, I absolutely loathe Bash. And yet, I can't stop myself from writing
it constantly.

When building this site, I decided I would rather roll my own static site
generator using Bash and Pandoc than use something like Jekyll. So I did. The
code to do so, as of this writing, is 100 lines counting the build script, the
minimal Makefile, and a single Pandoc Lua filter, including all comments and 
whitespace. I knocked it out in a few hours over an afternoon. Most of the work
is offloaded to pandoc. My main contribution is the build script, which handles
generating headers, footers, and a table of contents, which is quite simple but
works well. For me, this is just as good and much easier to use than what I've
found with other static site generators.

As much as I loathe Bash, it just gets shit done.

It's really good at working with command line interfaces, which tend to be
simpler and more convenient (but, of course, more constrained) than a lot of
programming APIs. As a language, it's so constrained that I get both the joy of
esoteric programming as well as the clarity of not having a fuckton of language
features and third party libraries to worry about.

On the flip side, it encourages bad practices and requires boilerplate to
produce decent, robust code. It is 
[dangerous and easy to mess up](https://mywiki.wooledge.org/BashPitfalls), 
making it risky for anything important. It lacks a lot of developer convenience
features as well as a strong community of practice. Interacting with many
command line utilities is not convenient and it often requires kludgey solutions
to parse the output of one utility and munge it into a form another utility can
take.
