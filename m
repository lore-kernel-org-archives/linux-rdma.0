From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3] coding-style: Clarify the expectations around bool
Date: Mon, 07 Jan 2019 14:50:30 -0800
Message-ID: <1546901430.83374.28.camel@acm.org>
References: <20190107211117.GA24142@ziepe.ca>
         <8ec3603317f477fe9923b87499a33da7a2cf81ff.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8ec3603317f477fe9923b87499a33da7a2cf81ff.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Jason Gunthorpe <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-01-07 at 14:10 -0800, Joe Perches wrote:
+AD4 On Mon, 2019-01-07 at 14:11 -0700, Jason Gunthorpe wrote:
+AD4 +AD4 There has been some confusion since checkpatch started warning about bool
+AD4 +AD4 use in structures, and people have been avoiding using it.
+AD4 +AD4 
+AD4 +AD4 Many people feel there is still a legitimate place for bool in structures,
+AD4 +AD4 so provide some guidance on bool usage derived from the entire thread that
+AD4 +AD4 spawned the checkpatch warning.
+AD4 
+AD4 Thanks Jason.
+AD4 
+AD4 It'd be nice to combine this with some better
+AD4 checkpatch warning or even a removal of that
+AD4 misleading warning from checkpatch altogether.
+AD4 
+AD4 With a couple minor nits below and and Ack if
+AD4 you want one:
+AD4 
+AD4 Acked-by: Joe Perches +ADw-joe+AEA-perches.com+AD4
+AD4 
+AD4 +AD4 diff --git a/Documentation/process/coding-style.rst b/Documentation/process/coding-style.rst
+AD4 
+AD4 +AFsAXQ
+AD4 +AD4 +AEAAQA -921,7 +-921,37 +AEAAQA result.  Typical examples would be functions that return pointers+ADs they use
+AD4 +AD4  NULL or the ERR+AF8-PTR mechanism to report failure.
+AD4 +AD4  
+AD4 +AD4  
+AD4 +AD4 -17) Don't re-invent the kernel macros
+AD4 +AD4 +-17) Using bool
+AD4 +AD4 +---------------
+AD4 +AD4 +-
+AD4 +AD4 +-The Linux kernel uses the C99 standard for the bool type. bool values can only
+AD4 
+AD4 Maybe
+AD4 
+AD4 The Linux kernel bool type is the C99 +AF8-Bool type.

Or maybe +ACI-The Linux kernel bool type is an alias for the C99 +AF8-Bool type.+ACI

+AD4 +AD4 +-evaluate to 0 or 1, and implicit or explicit conversion to bool automatically
+AD4 +AD4 +-converts the value to true or false. When using bool types the +ACEAIQ construction
+AD4 +AD4 +-is not needed, which eliminates a class of bugs.
+AD4 +AD4 +-
+AD4 +AD4 +-When working with bool values the true and false labels should be used instead
+AD4 
+AD4 true and false are not labels but +ACM-defines

With these refinements, feel free to add:

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
