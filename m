From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Tue, 7 Nov 2017 09:46:32 -0700
Message-ID: <20171107164632.GA7063@ziepe.ca>
References: <20171107163326.23881-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107163326.23881-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 06:33:26PM +0200, Leon Romanovsky wrote:

> -	bool special_qp = (qp->qp_type == IB_QPT_SMI ||
> -			   qp->qp_type == IB_QPT_GSI ||
> -			   qp->qp_type >= IB_QPT_RESERVED1);
> +	struct ib_qp *real_qp = qp->real_qp;
> +	bool special_qp = (real_qp->qp_type == IB_QPT_SMI ||
> +			   real_qp->qp_type == IB_QPT_GSI ||
> +			   real_qp->qp_type >= IB_QPT_RESERVED1);

This QPT_RESERVED stuff was not supposed to be visible to the core
layer, so why are we adding checks in security????

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
