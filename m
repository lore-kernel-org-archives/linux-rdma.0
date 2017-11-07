From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Tue, 7 Nov 2017 09:55:39 -0700
Message-ID: <20171107165539.GB7063@ziepe.ca>
References: <20171107163326.23881-1-leon@kernel.org>
 <20171107164632.GA7063@ziepe.ca>
 <065e66ff-e901-bd5c-674d-173eab720989@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <065e66ff-e901-bd5c-674d-173eab720989-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 10:52:11AM -0600, Daniel Jurgens wrote:
> On 11/7/2017 10:46 AM, Jason Gunthorpe wrote:
> > On Tue, Nov 07, 2017 at 06:33:26PM +0200, Leon Romanovsky wrote:
> >
> >> -	bool special_qp = (qp->qp_type == IB_QPT_SMI ||
> >> -			   qp->qp_type == IB_QPT_GSI ||
> >> -			   qp->qp_type >= IB_QPT_RESERVED1);
> >> +	struct ib_qp *real_qp = qp->real_qp;
> >> +	bool special_qp = (real_qp->qp_type == IB_QPT_SMI ||
> >> +			   real_qp->qp_type == IB_QPT_GSI ||
> >> +			   real_qp->qp_type >= IB_QPT_RESERVED1);
> > This QPT_RESERVED stuff was not supposed to be visible to the core
> > layer, so why are we adding checks in security????
> 
> The checks exclude those QPs from security enforcement.  They've
> been there the whole time, you reviewed this previously right?

Nope

.. and they shouldn't be there, those reserved QPTs are totally banned
from user space so it shouldn't matter for security

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
