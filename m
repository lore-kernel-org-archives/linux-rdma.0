From: Joe Perches <joe@perches.com>
Subject: Re: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get
 rid of page operation after dma_alloc_coherent)
Date: Thu, 20 Dec 2018 21:12:43 -0800
Message-ID: <b906bec0fd12d25474561263087a26b8b0519fe4.camel@perches.com>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
         <20181220174318.GA21404@ziepe.ca> <20181220174448.GA21149@lst.de>
         <1545328145.185366.500.camel@acm.org>
         <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
         <20181221033159.GF23877@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221033159.GF23877@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-12-20 at 20:31 -0700, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 06:25:05PM -0800, Joe Perches wrote:
> 
> > I agree it's not a very good message nor is bool use
> > of structure members a real problem except in very
> > few cases.
> 
> I think the issue is that the link it shows lacks the context of the
> discussion thread - and the actual guidance here is more
> complicated.
> 
> A discussion in coding style would probably be better.

Perhaps so.

Care to submit a coding_style.rst patch or
improve the one below this?

> - Don't put multiple true/false fields in a single struct (be it bool,
>   u8, int, etc) - use bit-fields instead.

I'm not of the opinion this is always true.

rmw sometimes has a cost that bool does not.

Maybe 5 or more consecutive bools, but fewer
than that probably has no significant cost
when used consecutively in a struct.

Except maybe on the odd architecture. (alpha, etc)

> - Don't use bool if cache line layout matters, its size and alignment
>   varies

Completely right and that is the primary reason
to avoid bool use in structs IMO.

> - Do use bool to clearly express that the variable, parameter or
>   structure member can only take on a true/false value.

Yes absolutely, but that does conflict with the
first bullet point

> .. and I also seem to remember there is a small performance downside
> to bool stores in some ABIs as the compiler has to cannonize stores to
> 0 or 1? But this also eliminates certain bug classes..

Cannonize?  Canonicalize?
I think it's interesting when compilers go boom.

Anyway, both of those points are very true too.

cheers, Joe

Maybe this patch to coding-style.rst is a starting point?
---
 Documentation/process/coding-style.rst | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
index b78dd680c038..752bead24d4a 100644
--- a/Documentation/process/coding-style.rst
+++ b/Documentation/process/coding-style.rst
@@ -921,7 +921,25 @@ result.  Typical examples would be functions that return pointers; they use
 NULL or the ERR_PTR mechanism to report failure.
 
 
-17) Don't re-invent the kernel macros
+17) Using bool
+--------------
+
+bool function return types are always fine to use whenever appropriate.
+bool structure members are more complicated.
+
+If memory utilization or alignment is a concern, please do not use bool
+structure members.  Do not use bool if cache line layout matters, its size
+and alignment varies based on the compiled architecture.
+
+Do use bool to clearly express that the variable, parameter or structure
+member can only take on a true/false value.
+
+There can be a small performance downside to bool stores in some ABIs as
+the compiler has to canonicalize stores to 0 or 1.  But doing so can also
+eliminates certain bug classes.
+
+
+18) Don't re-invent the kernel macros
 -------------------------------------
 
 The header file include/linux/kernel.h contains a number of macros that
@@ -944,7 +962,7 @@ need them.  Feel free to peruse that header file to see what else is already
 defined that you shouldn't reproduce in your code.
 
 
-18) Editor modelines and other cruft
+19) Editor modelines and other cruft
 ------------------------------------
 
 Some editors can interpret configuration information embedded in source files,
@@ -978,7 +996,7 @@ own custom mode, or may have some other magic method for making indentation
 work correctly.
 
 
-19) Inline assembly
+20) Inline assembly
 -------------------
 
 In architecture-specific code, you may need to use inline assembly to interface
@@ -1010,7 +1028,7 @@ the next instruction in the assembly output:
 	     : /* outputs */ : /* inputs */ : /* clobbers */);
 
 
-20) Conditional Compilation
+21) Conditional Compilation
 ---------------------------
 
 Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c
