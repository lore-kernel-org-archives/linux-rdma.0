From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: New shared RDMA tree location
Date: Mon, 4 Dec 2017 20:47:10 -0700
Message-ID: <20171205034710.GB32241@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new cannonical location for the RDMA git tree is:

git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

There are two branches of interest to most people

'for-next' contains patches accepted and waiting to be pulled into
the next merge window by Linus.

'for-rc' contains -rc acceptable bug fixes only, and is regularly
sent to Linus. If you are doing -rc testing you should probably merge
thsi with Linus's -rc

These branches are intended to be non-rebased, except under duress.

Note the 'k.o/' prefix has been dropped.

The 'for-next' tag points to the commit being merged into Stephen
Rothwell's for-next tree.

The 'master' branch simply tracks Linus's tree and is not interesting.

Cheers,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
