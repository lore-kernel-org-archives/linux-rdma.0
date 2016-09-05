From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs 3/3] Provide remote XRC SRQ number in kernel
 post_send.
Date: Mon, 05 Sep 2016 17:50:16 +0200
Message-ID: <1473090616.26625.68.camel@oracle.com>
References: <1472713193-22397-1-git-send-email-knut.omang@oracle.com>
         <1472713193-22397-4-git-send-email-knut.omang@oracle.com>
         <67f23338-1a5c-5080-d346-8441afb47670@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <67f23338-1a5c-5080-d346-8441afb47670-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 12:00 +0300, Yishai Hadas wrote:
> On 9/1/2016 9:59 AM, Knut Omang wrote:
> > Also proper end align the ibv_kern_send_wr struct.
> > 
> > Requires a corresponding kernel change.

https://www.spinics.net/lists/linux-rdma/msg39884.html

Knut

> 
> Again, usually starting from a kernel patch then coming with a matching 
> user one.
> 
> > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/infiniband/kern-abi.h | 1 +
> >  src/cmd.c                     | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> > index 8bdeef5..7b1d310 100644
> > --- a/include/infiniband/kern-abi.h
> > +++ b/include/infiniband/kern-abi.h
> > @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
> >  	union {
> >  		struct {
> >  			__u32 remote_srqn;
> > +			__u32 reserved;
> >  		} xrc;
> >  	} qp_type;
> >  };
> > diff --git a/src/cmd.c b/src/cmd.c
> > index a418ee1..a4e2f75 100644
> > --- a/src/cmd.c
> > +++ b/src/cmd.c
> > @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
> >  			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
> >  			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
> >  		} else {
> > +			if (ibqp->qp_type == IBV_QPT_XRC_SEND)
> > +				tmp->qp_type.xrc.remote_srqn = i->qp_type.xrc.remote_srqn;
> >  			switch (i->opcode) {
> >  			case IBV_WR_RDMA_WRITE:
> >  			case IBV_WR_RDMA_WRITE_WITH_IMM:
> > 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
