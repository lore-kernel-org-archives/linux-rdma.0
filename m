From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Convert pr_info to pr_warn
Date: Wed, 19 Jul 2017 22:54:06 +0300
Message-ID: <20170719195405.GA12367@yuvallap>
References: <20170718203539.6777-1-yuval.shaia@oracle.com>
 <20170719060908.GN3259@mtr-leonro.local>
 <CAG9sBKNXfndf8Lxa97Z8Cc=Ntg+=NoZ9-35CbY0X=0f2aXRx8w@mail.gmail.com>
 <20170719075119.GO3259@mtr-leonro.local>
 <20170719110441.GA26265@yuvallap>
 <20170719172613.GS3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719172613.GS3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 19, 2017 at 08:26:13PM +0300, Leon Romanovsky wrote:
> On Wed, Jul 19, 2017 at 02:04:42PM +0300, Yuval Shaia wrote:
> > On Wed, Jul 19, 2017 at 10:51:19AM +0300, Leon Romanovsky wrote:
> > > On Wed, Jul 19, 2017 at 10:11:50AM +0300, Moni Shoua wrote:
> > > > > How this code can be executed? IB/core ensures that port_num is in range.
> > > > > You can remove this check.
> > > > >
> > > > In this case ah_attr can come from the application and a validity
> > > > check is necessary.
> > >
> > > It is a bug if it comes directly without rdma_is_port_valid() check in the
> > > IB/core. Currently modify_qp and create_ah are checking it and ensuring that
> > > user won't provide illegal port number.
> >
> > Not sure i see the whole picture but something does not fit, will
> > appreciate a guidance here.
> >
> > 1. Application calls ibv_modify_qp which in turn fills out a cmd object and
> > "calls" ib_uverbs.ib_uverbs_modify_qp.
> > 2. ib_uverbs_modify_qp copy the cmd from userspace and calls modify_qp.
> > 3. modify_qp, among some other stuff, verifies port validity (which prove
> > your point) and calls driver's modify_qp hook (in our case rxe_modify_qp).
> >
> > Is the above correct?
> >
> > What i do not understand is the check that is done in step #2 since
> > port_num is not set when moving from state INIT to state RTR.
> > RXE on the other hands validate port_num only when needed (mask &
> > IB_QP_AV).
> >
> > Looks like the check in step #2 is wrong.
> > What am i missing here?
> 
> Maybe you missing the Mustafa's patch?
> https://patchwork.kernel.org/patch/9841241/

Exactly!! :)
Thanks,

So, will post v1 of this patch with the removal of the redundant check.

> 
> Thanks
> 
> >
> > Yuval
> >
> > >
> > > Thanks
> >
> >


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
