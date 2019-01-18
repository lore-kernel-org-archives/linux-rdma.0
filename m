From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5] coding-style: Clarify the expectations around bool
Date: Fri, 18 Jan 2019 15:50:47 -0700
Message-ID: <20190118225047.GH4759@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

There has been some confusion since checkpatch started warning about bool
use in structures, and people have been avoiding using it.

Many people feel there is still a legitimate place for bool in structures,
so provide some guidance on bool usage derived from the entire thread that
spawned the checkpatch warning.

Link: https://lkml.kernel.org/r/CA+55aFwVZk1OfB9T2v014PTAKFhtVan_Zj2dOjnCy3x6E4UJfA@mail.gmail.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Joe Perches <joe@perches.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Joey Pabalinas <joeypabalinas@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 Documentation/process/coding-style.rst | 38 +++++++++++++++++++++++---
 scripts/checkpatch.pl                  | 13 ---------
 2 files changed, 34 insertions(+), 17 deletions(-)

v5:
 - Wording updates from JoeyP, MatthewW, FedericoV

diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
index b78dd680c03809..de889deaf29c42 100644
--- a/Documentation/process/coding-style.rst
+++ b/Documentation/process/coding-style.rst
@@ -921,7 +921,37 @@ result.  Typical examples would be functions that return pointers; they use
 NULL or the ERR_PTR mechanism to report failure.
 
 
-17) Don't re-invent the kernel macros
+17) Using bool
+--------------
+
+The Linux kernel bool type is an alias for the C99 _Bool type. bool values can
+only evaluate to 0 or 1, and implicit or explicit conversion to bool
+automatically converts the value to true or false. When using bool types the
+!! construction is not needed, which eliminates a class of bugs.
+
+When working with bool values the true and false definitions should be used
+instead of 1 and 0.
+
+bool function return types and stack variables are always fine to use whenever
+appropriate. Use of bool is encouraged to improve readability and is often a
+better option than 'int' for storing boolean values.
+
+Do not use bool if cache line layout or size of the value matters, as its size
+and alignment varies based on the compiled architecture. Structures that are
+optimized for alignment and size should not use bool.
+
+If a structure has many true/false values, consider consolidating them into a
+bitfield with 1 bit members, or using an appropriate fixed width type, such as
+u8.
+
+Similarly for function arguments, many true/false values can be consolidated
+into a single bitwise 'flags' argument and 'flags' can often be a more
+readable alternative if the call-sites have naked true/false constants.
+
+Otherwise limited use of bool in structures and arguments can improve
+readability.
+
+18) Don't re-invent the kernel macros
 -------------------------------------
 
 The header file include/linux/kernel.h contains a number of macros that
@@ -944,7 +974,7 @@ need them.  Feel free to peruse that header file to see what else is already
 defined that you shouldn't reproduce in your code.
 
 
-18) Editor modelines and other cruft
+19) Editor modelines and other cruft
 ------------------------------------
 
 Some editors can interpret configuration information embedded in source files,
@@ -978,7 +1008,7 @@ own custom mode, or may have some other magic method for making indentation
 work correctly.
 
 
-19) Inline assembly
+20) Inline assembly
 -------------------
 
 In architecture-specific code, you may need to use inline assembly to interface
@@ -1010,7 +1040,7 @@ the next instruction in the assembly output:
 	     : /* outputs */ : /* inputs */ : /* clobbers */);
 
 
-20) Conditional Compilation
+21) Conditional Compilation
 ---------------------------
 
 Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b737ca9d720441..d62abd032885a1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6368,19 +6368,6 @@ sub process {
 			}
 		}
 
-# check for bool bitfields
-		if ($sline =~ /^.\s+bool\s*$Ident\s*:\s*\d+\s*;/) {
-			WARN("BOOL_BITFIELD",
-			     "Avoid using bool as bitfield.  Prefer bool bitfields as unsigned int or u<8|16|32>\n" . $herecurr);
-		}
-
-# check for bool use in .h files
-		if ($realfile =~ /\.h$/ &&
-		    $sline =~ /^.\s+bool\s*$Ident\s*(?::\s*d+\s*)?;/) {
-			CHK("BOOL_MEMBER",
-			    "Avoid using bool structure members because of possible alignment issues - see: https://lkml.org/lkml/2017/11/21/384\n" . $herecurr);
-		}
-
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
-- 
2.20.1
