From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Thu, 19 Jan 2012 15:38:16 -0500
Message-ID: <20120119203816.GA8574@kroah.com>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120119194641.1391553.39048.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2012 at 08:46:41PM +0100, Bernd Schubert wrote:
> We have just been investigating kernel panics related to
> cq->ibcq.event_handler() completion calls.
> 
> Reason is that ib_destroy_qp() fails with -EBUSY. Further investigation
> revealed qp->usecnt is not initialized. This counter was introduced
> in linux-3.2 by commit 0e0ec7e0638ef48e0c661873dfcc8caccab984c6
> and is only initialized for IB_QPT_XRC_TGT, but also checked in ib_destroy_qp()
> for any qp type.
> 
> Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> Signed-off-by: Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
