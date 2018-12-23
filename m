From: Gal Pressman <galpress@amazon.com>
Subject: Re: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get rid
 of page operation after dma_alloc_coherent)
Date: Sun, 23 Dec 2018 18:42:20 +0200
Message-ID: <dc6d4923-63bd-e133-310b-7b164b0c92f5@amazon.com>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
 <20181220174318.GA21404@ziepe.ca> <20181220174448.GA21149@lst.de>
 <1545328145.185366.500.camel@acm.org>
 <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
 <20181221033159.GF23877@ziepe.ca>
 <b906bec0fd12d25474561263087a26b8b0519fe4.camel@perches.com>
 <20181221235230.GC13168@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181221235230.GC13168@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 22-Dec-18 01:52, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 09:12:43PM -0800, Joe Perches wrote:
>> Care to submit a coding_style.rst patch or
>> improve the one below this?
> 
> I took yours and revised it a little bit. I spent some time looking at
> assembly and decided to drop the performance note, the number of cases
> that run into overhead seems pretty small and probably already
> requires !! to be correct. There is also an equally unlikely gain, ie
> 'if (a & b)' optimizes a tiny bit better for bool types.
> 
> I also added a small intro on bool, as I know some people are
> unfamiliar with C11 _Bool and might think bool is just '#define bool
> u8'
> 
> (for those added to the cc) I'm looking at cases, like the patch that
> spawned this, where the struct has a single bool and no performance
> considerations. As CH said, seeing that get converted to int due to
> checkpatch is worse than having used bool. Using u8 won't make this
> struct smaller or faster.
> 
> Cheers,
> Jason
> 
> From c5e2c887f6326e1c4369876f39996417da5e90cc Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgg@mellanox.com>
> Date: Fri, 21 Dec 2018 16:29:22 -0700
> Subject: [PATCH] coding-style: Clarify the expectations around bool
> 
> There has been some confusion since checkpatch started warning about bool
> use in structures, and people have been avoiding using it.
> 
> Many people feel there is still a legitimate place for bool in structures,
> so provide some guidance on bool usage derived from the entire thread that
> spawned the checkpatch warning.

Since a "Using bool" section is added, perhaps it's worth documenting the bool
usage as a function parameter [1]?

[1] https://www.spinics.net/lists/linux-rdma/msg72336.html

> 
> Link: https://lkml.kernel.org/r/CA+55aFwVZk1OfB9T2v014PTAKFhtVan_Zj2dOjnCy3x6E4UJfA@mail.gmail.com
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  Documentation/process/coding-style.rst | 33 ++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
> index 4e7c0a1c427a9a..efdb1d32035fe1 100644
> --- a/Documentation/process/coding-style.rst
> +++ b/Documentation/process/coding-style.rst
> @@ -918,7 +918,32 @@ result.  Typical examples would be functions that return pointers; they use
>  NULL or the ERR_PTR mechanism to report failure.
>  
>  
> -17) Don't re-invent the kernel macros
> +17) Using bool
> +--------------
> +
> +The Linux kernel uses the C11 standard for the bool type. bool values can only
> +evaluate to 0 or 1, and implicit or explicit conversion to bool automatically
> +converts the value to true or false. When using bool types the !! construction
> +is not needed, which eliminates a class of bugs.
> +
> +When working with bool values the true and false labels should be used instead
> +of 0 and 1.
> +
> +bool function return types, arguments and stack variables are always fine to
> +use whenever appropriate. Use of bool is encouraged to improve readability and
> +is often a better option than 'int' for storing boolean values.
> +
> +Do not use bool if cache line layout or size of the value matters, its size
> +and alignment varies based on the compiled architecture. Structures that are
> +optimized for alignment and size should not use bool.
> +
> +If a structure has many true/false values, consider consolidating them into a
> +bitfield with 1 bit members, or using an appropriate fixed width type, such as
> +u8.
> +
> +Otherwise limited use of bool in structures does improve readability.
> +
> +18) Don't re-invent the kernel macros
>  -------------------------------------
>  
>  The header file include/linux/kernel.h contains a number of macros that
> @@ -941,7 +966,7 @@ need them.  Feel free to peruse that header file to see what else is already
>  defined that you shouldn't reproduce in your code.
>  
>  
> -18) Editor modelines and other cruft
> +19) Editor modelines and other cruft
>  ------------------------------------
>  
>  Some editors can interpret configuration information embedded in source files,
> @@ -975,7 +1000,7 @@ own custom mode, or may have some other magic method for making indentation
>  work correctly.
>  
>  
> -19) Inline assembly
> +20) Inline assembly
>  -------------------
>  
>  In architecture-specific code, you may need to use inline assembly to interface
> @@ -1007,7 +1032,7 @@ the next instruction in the assembly output:
>  	     : /* outputs */ : /* inputs */ : /* clobbers */);
>  
>  
> -20) Conditional Compilation
> +21) Conditional Compilation
>  ---------------------------
>  
>  Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c
> 
