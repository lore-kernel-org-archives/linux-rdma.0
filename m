From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 3/3] Provide remote XRC SRQ number in
 kernel post_send.
Date: Mon, 19 Sep 2016 11:12:36 +0200
Message-ID: <1474276356.24045.93.camel@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
         <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang@oracle.com>
         <20160919052911.GF3273@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919052911.GF3273-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-09-19 at 08:29 +0300, Leon Romanovsky wrote:
> On Sat, Sep 17, 2016 at 05:59:13AM +0200, Knut Omang wrote:
> > 
> > Also proper end align the ibv_kern_send_wr struct.
> > 
> > Requires a corresponding kernel change.
> > 
> > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/infiniband/kern-abi.h | 1 +
> >  src/cmd.c                     | 2 ++
> >  2 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> > index 8bdeef5..7b1d310 100644
> > --- a/include/infiniband/kern-abi.h
> > +++ b/include/infiniband/kern-abi.h
> > @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
> >  	union {
> >  		struct {
> >  			__u32 remote_srqn;
> > +			__u32 reserved;
> >  		} xrc;
> >  	} qp_type;
> >  };
> > diff --git a/src/cmd.c b/src/cmd.c
> > index a418ee1..a4e2f75 100644
> > --- a/src/cmd.c
> > +++ b/src/cmd.c
> > @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
> >  			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
> >  			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
> >  		} else {
> > +			if (ibqp->qp_type == IBV_QPT_XRC_SEND)
> > +				tmp->qp_type.xrc.remote_srqn = i->qp_type.xrc.remote_srqn;
> It will be checked for all QPTs and for all consumers. Any chances to
> optimize it?

All QPTs except UD, yes.

The easiest is perhaps just to remove the test (and set the attribute in all cases), which will work fine
as long as the qp_type union is not used for anything else, but is it worth 
the loss of intuitiveness/future potential correctness of the code?

Note that this is for user mode post_send implemented by the kernel, not the "fast path"
pure user mode.

Knut

> > 
> >  			switch (i->opcode) {
> >  			case IBV_WR_RDMA_WRITE:
> >  			case IBV_WR_RDMA_WRITE_WITH_IMM:
> > --
> > git-series 0.8.10
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
