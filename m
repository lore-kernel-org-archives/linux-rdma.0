From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 3/3] Provide remote XRC SRQ number in
 kernel post_send.
Date: Tue, 20 Sep 2016 15:38:46 +0200
Message-ID: <1474378726.20134.140.camel@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
         <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang@oracle.com>
         <20160919052911.GF3273@leon.nu> <1474276356.24045.93.camel@oracle.com>
         <20160920101839.GF26673@leon.nu> <1474368210.8837.3.camel@oracle.com>
         <20160920110115.GJ26673@leon.nu> <1474369715.8837.19.camel@oracle.com>
         <20160920121741.GL26673@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920121741.GL26673-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2016-09-20 at 15:17 +0300, Leon Romanovsky wrote:
> On Tue, Sep 20, 2016 at 01:08:35PM +0200, Knut Omang wrote:
> > On Tue, 2016-09-20 at 14:01 +0300, Leon Romanovsky wrote:
> > > On Tue, Sep 20, 2016 at 12:43:30PM +0200, Knut Omang wrote:
> > > >
> > > > On Tue, 2016-09-20 at 13:18 +0300, Leon Romanovsky wrote:
> > > > >
> > > > > On Mon, Sep 19, 2016 at 11:12:36AM +0200, Knut Omang wrote:
> > > > > >
> > > > > >
> > > > > > On Mon, 2016-09-19 at 08:29 +0300, Leon Romanovsky wrote:
> > > > > > >
> > > > > > >
> > > > > > > On Sat, Sep 17, 2016 at 05:59:13AM +0200, Knut Omang wrote:
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > Also proper end align the ibv_kern_send_wr struct.
> > > > > > > >
> > > > > > > > Requires a corresponding kernel change.
> > > > > > > >
> > > > > > > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > > > > Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > > > > > ---
> > > > > > > >  include/infiniband/kern-abi.h | 1 +
> > > > > > > >  src/cmd.c                     | 2 ++
> > > > > > > >  2 files changed, 3 insertions(+), 0 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> > > > > > > > index 8bdeef5..7b1d310 100644
> > > > > > > > --- a/include/infiniband/kern-abi.h
> > > > > > > > +++ b/include/infiniband/kern-abi.h
> > > > > > > > @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
> > > > > > > >  	union {
> > > > > > > >  		struct {
> > > > > > > >  			__u32 remote_srqn;
> > > > > > > > +			__u32 reserved;
> > > > > > > >  		} xrc;
> > > > > > > >  	} qp_type;
> > > > > > > >  };
> > > > > > > > diff --git a/src/cmd.c b/src/cmd.c
> > > > > > > > index a418ee1..a4e2f75 100644
> > > > > > > > --- a/src/cmd.c
> > > > > > > > +++ b/src/cmd.c
> > > > > > > > @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
> > > > > > > >  			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
> > > > > > > >  			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
> > > > > > > >  		} else {
> > > > > > > > +			if (ibqp->qp_type == IBV_QPT_XRC_SEND)
> > > > > > > > +				tmp->qp_type.xrc.remote_srqn = i->qp_type.xrc.remote_srqn;
> > > > > > > It will be checked for all QPTs and for all consumers. Any chances to
> > > > > > > optimize it?
> > > > > > All QPTs except UD, yes.
> > > > > >
> > > > > > The easiest is perhaps just to remove the test (and set the attribute in all cases), which will work fine
> > > > > > as long as the qp_type union is not used for anything else, but is it worth 
> > > > > > the loss of intuitiveness/future potential correctness of the code?
> > > > > Let's concentrate on the present and as far as I see there are no kernel users who
> > > > > need this field xrc.remote_srqn field.
> > > > So I assume then that you are ok with this code, given my explanation?
> > > Partially,
> > >
> > > I'm fine with the claim about readability and the fact that
> > > this code is not in data-path relaxed me a little bit.
> >
> > Good!
> >
> > > I'm not fine with the part that this code doesn't do anything in kernel.
> >
> > I know, I have two big patch sets one kernel and one for the new "rdma consolidated" 
> > in the queue that should fix that, just want to save a few versions of those 
> > ~32000 lines of code by preparing the baseline :-)
> 
> It won't save. We DO believe you that this this new addition to UAPI is really
> needed, but we NEED to see that it is unavoidable.
> 
> The proper flow for submission is driver->kernel_core->libraries and not
> kernel_core->libraries->driver.

Ok, got it..

Knut

> Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
