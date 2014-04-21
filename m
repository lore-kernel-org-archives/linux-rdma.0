From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
Date: Mon, 21 Apr 2014 10:16:20 -0500
Message-ID: <002701cf5d74$a6202df0$f26089d0$@opengridcomputing.com>
References: <1398092562-11116-1-git-send-email-christophjaeger@linux.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398092562-11116-1-git-send-email-christophjaeger-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Jaeger' <christophjaeger-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Christoph Jaeger [mailto:christophjaeger-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org]
> Sent: Monday, April 21, 2014 10:03 AM
> To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Jaeger
> Subject: [PATCH] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
> 
> c4iw_alloc() bails out without freeing the storage that 'devp' points to.
> 
> Picked up by Coverity - CID 1204241.
> 
> Fixes: fa658a98a2 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
> Signed-off-by: Christoph Jaeger <christophjaeger-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

thanks!



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
