From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 3/7] RDMA: Annotate create QP callers
Date: Sun, 14 Jan 2018 14:27:04 -0700
Message-ID: <20180114212704.GE9088@ziepe.ca>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111153132.11143-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 05:31:28PM +0200, Leon Romanovsky wrote:
> @@ -1538,6 +1537,7 @@ int ib_destroy_qp(struct ib_qp *qp)
>  	if (!qp->uobject)
>  		rdma_rw_cleanup_mrs(qp);
>  
> +	rdma_restrack_del(&qp->res, RDMA_RESTRACK_QP);
>  	ret = qp->device->destroy_qp(qp);
>  	if (!ret) {
>  		if (pd)

This hunk belongs in a different patch right?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
