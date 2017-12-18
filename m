From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Sun, 17 Dec 2017 22:00:17 -0800
Message-ID: <1513576817.31581.58.camel@perches.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20171218050043.GA1307@ziepe.ca>
Sender: linux-kbuild-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Knut Omang <knut.omang@oracle.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Nicolas Palix <nicolas.palix@imag.fr>, Jonathan Corbet <corbet@lwn.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Shuah Khan <shuah@kernel.org>, linux-kbuild@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, Julia Lawall <Julia.Lawall@lip6.fr>, John Haxby <john.haxby@oracle.com>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold@oracle.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ke
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-12-17 at 22:00 -0700, Jason Gunthorpe wrote:
> On Sun, Dec 17, 2017 at 03:14:10AM +0100, Knut Omang wrote:
> 
> > > I like the ability to add more checkers and keep then in the main
> > > upstream tree. But adding overrides for specific subsystems goes against
> > > the policy that all subsystems should be treated equally.
> > 
> > This is a tool to enable automated testing for as many checks as
> > possible, as soon as possible. Like any tool, it can be misused, but
> > that's IMHO an orthogonal problem that I think the maintainers will
> > be more than capable of preventing.
> > 
> > Think of this as a tightening screw: We eliminate errors class by
> > class or file by file, and in the same commit narrows in the list of
> > exceptions. That way we can fix issues piece by piece while avoiding
> > a lot of regressions in already clean parts.
> 
> Since you used drivers/infiniband as an example for this script..
> 
> I will say I agree with this idea.
> 
> It is not that we *want* infiniband to be different from the rest of
> the kernel, it is that we have this historical situation where we
> don't have a code base that already passes the various static checker
> things.
> 
> I would like it very much if I could run 'make static checker' and see
> no warnings. This helps me know that I when I accept patches I am not
> introducing new problems to code that has already been cleaned up.
> 
> Today when we run checkers we get so many warnings it is too hard to
> make any sense of it.

Here is a list of the checkpatch messages for drivers/infiniband
sorted by type.

Many of these might be corrected by using

$ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
  $(git ls-files drivers/infiniband/)

   5243 CHECK:CAMELCASE
   4487 WARNING:LONG_LINE
   1755 CHECK:PARENTHESIS_ALIGNMENT
   1664 CHECK:SPACING
    910 WARNING:FUNCTION_ARGUMENTS
    742 CHECK:OPEN_ENDED_LINE
    685 CHECK:BRACES
    643 CHECK:UNNECESSARY_PARENTHESES
    478 WARNING:SIZEOF_PARENTHESIS
    361 WARNING:UNSPECIFIED_INT
    342 WARNING:LONG_LINE_COMMENT
    338 ERROR:SPACING
    338 CHECK:LINE_SPACING
    306 WARNING:SPLIT_STRING
    278 WARNING:SPACING
    242 WARNING:SYMBOLIC_PERMS
    194 WARNING:BLOCK_COMMENT_STYLE
    175 CHECK:BIT_MACRO
    158 WARNING:SPACE_BEFORE_TAB
    154 WARNING:LINE_SPACING
    139 CHECK:MACRO_ARG_REUSE
    133 CHECK:UNCOMMENTED_DEFINITION
    122 CHECK:AVOID_BUG
    103 CHECK:COMPARISON_TO_NULL
    101 WARNING:ENOSYS
     89 WARNING:BRACES
     78 WARNING:PREFER_PR_LEVEL
     74 WARNING:MULTILINE_DEREFERENCE
     59 CHECK:TYPO_SPELLING
     52 WARNING:EMBEDDED_FUNCTION_NAME
     52 CHECK:MULTIPLE_ASSIGNMENTS
     50 CHECK:PREFER_KERNEL_TYPES
     45 WARNING:RETURN_VOID
     39 WARNING:UNNECESSARY_ELSE
     38 ERROR:POINTER_LOCATION
     37 WARNING:ALLOC_WITH_MULTIPLY
     36 CHECK:ALLOC_SIZEOF_STRUCT
     35 CHECK:AVOID_EXTERNS
     34 WARNING:PRINTK_WITHOUT_KERN_LEVEL
     33 ERROR:CODE_INDENT
     32 WARNING:PREFER_PACKED
     32 CHECK:LOGICAL_CONTINUATIONS
     29 WARNING:MEMORY_BARRIER
     29 WARNING:LEADING_SPACE
     28 WARNING:DEEP_INDENTATION
     27 CHECK:USLEEP_RANGE
     23 WARNING:SUSPECT_CODE_INDENT
     23 ERROR:TRAILING_STATEMENTS
     21 WARNING:LONG_LINE_STRING
     20 WARNING:CONSIDER_KSTRTO
     18 WARNING:CONSTANT_COMPARISON
     18 ERROR:OPEN_BRACE
     15 WARNING:QUOTED_WHITESPACE_BEFORE_NEWLINE
     14 WARNING:VOLATILE
     14 ERROR:SWITCH_CASE_INDENT_LEVEL
     11 WARNING:OOM_MESSAGE
     11 WARNING:INCLUDE_LINUX
     10 WARNING:SSCANF_TO_KSTRTO
     10 WARNING:INDENTED_LABEL
      9 ERROR:GLOBAL_INITIALISERS
      9 ERROR:COMPLEX_MACRO
      9 ERROR:ASSIGN_IN_IF
      8 WARNING:UNNECESSARY_BREAK
      6 WARNING:PRINTF_L
      6 WARNING:MISORDERED_TYPE
      6 ERROR:INITIALISED_STATIC
      5 WARNING:TABSTOP
      5 WARNING:SINGLE_STATEMENT_DO_WHILE_MACRO
      5 WARNING:NAKED_SSCANF
      4 WARNING:NEEDLESS_IF
      4 ERROR:RETURN_PARENTHESES
      4 CHECK:BOOL_COMPARISON
      3 WARNING:TRAILING_SEMICOLON
      3 WARNING:STATIC_CONST_CHAR_ARRAY
      3 ERROR:TRAILING_WHITESPACE
      2 WARNING:UNNECESSARY_PARENTHESES
      2 WARNING:MISSING_SPACE
      2 WARNING:LOGGING_CONTINUATION
      2 CHECK:ARCH_DEFINES
      1 WARNING:TYPECAST_INT_CONSTANT
      1 WARNING:PREFER_DEV_LEVEL
      1 WARNING:NR_CPUS
      1 WARNING:NEW_TYPEDEFS
      1 WARNING:MINMAX
      1 WARNING:MACRO_WITH_FLOW_CONTROL
      1 WARNING:LINE_CONTINUATIONS
      1 WARNING:DO_WHILE_MACRO_WITH_TRAILING_SEMICOLON
      1 WARNING:DEFAULT_NO_BREAK
      1 WARNING:CONST_STRUCT
      1 WARNING:CONSIDER_COMPLETION
      1 ERROR:WHILE_AFTER_BRACE
      1 ERROR:ELSE_AFTER_BRACE
      1 CHECK:REDUNDANT_CODE

