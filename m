From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3] coding-style: Clarify the expectations around bool
Date: Mon, 07 Jan 2019 14:10:22 -0800
Message-ID: <8ec3603317f477fe9923b87499a33da7a2cf81ff.camel@perches.com>
References: <20190107211117.GA24142@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107211117.GA24142@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-01-07 at 14:11 -0700, Jason Gunthorpe wrote:
> There has been some confusion since checkpatch started warning about bool
> use in structures, and people have been avoiding using it.
> 
> Many people feel there is still a legitimate place for bool in structures,
> so provide some guidance on bool usage derived from the entire thread that
> spawned the checkpatch warning.

Thanks Jason.

It'd be nice to combine this with some better
checkpatch warning or even a removal of that
misleading warning from checkpatch altogether.

With a couple minor nits below and and Ack if
you want one:

Acked-by: Joe Perches <joe@perches.com>

> diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
[]
> @@ -921,7 +921,37 @@ result.  Typical examples would be functions that return pointers; they use
>  NULL or the ERR_PTR mechanism to report failure.
>  
>  
> -17) Don't re-invent the kernel macros
> +17) Using bool
> +--------------
> +
> +The Linux kernel uses the C99 standard for the bool type. bool values can only

Maybe

The Linux kernel bool type is the C99 _Bool type.

> +evaluate to 0 or 1, and implicit or explicit conversion to bool automatically
> +converts the value to true or false. When using bool types the !! construction
> +is not needed, which eliminates a class of bugs.
> +
> +When working with bool values the true and false labels should be used instead

true and false are not labels but #defines
