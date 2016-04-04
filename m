From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Adding queue drain functions
Date: Mon, 4 Apr 2016 20:21:57 +0300
Message-ID: <20160404172157.GF5264@leon.nu>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
 <046801d189fc$7697f890$63c7e9b0$@opengridcomputing.com>
 <20160331011902.GC2670@leon.nu>
 <01b501d18e79$92ddee20$b899ca60$@opengridcomputing.com>
 <20160404145254.GE5264@leon.nu>
 <03e901d18e82$ea2067e0$be6137a0$@opengridcomputing.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <03e901d18e82$ea2067e0$be6137a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 04, 2016 at 10:01:49AM -0500, Steve Wise wrote:
> > The suggested refactoring can be as follows:
> > 
> > post_marker_func(..)
> > {
> >     post_send ....
> > }
> > 
> > ib_drain_qp(..)
> > {
> >     move_to_error
> >     call_post_marker_func
> > }
> > 
> > iw_drain_qp(..)
> > {
> >     call_to_post_marker_func
> >     move_to_drain
> > }
> >
> 
> This won't work if the QP is already in out of RTS which happens as part of
> rdma_disconnect().  And currently the ULP usage is to disconnect and then drain.

Ok, just to summarize it.

It is not enough do not transfer QP to error state, but also we
can't send work requests. The RDMA disconnect serves as a gate keeper
which protects from new work requests to entry into drained QP.

Thank you for the explanation.

> 
> Steve.
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
