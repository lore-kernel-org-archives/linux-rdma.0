From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Adding queue drain functions
Date: Mon, 4 Apr 2016 17:52:54 +0300
Message-ID: <20160404145254.GE5264@leon.nu>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
 <046801d189fc$7697f890$63c7e9b0$@opengridcomputing.com>
 <20160331011902.GC2670@leon.nu>
 <01b501d18e79$92ddee20$b899ca60$@opengridcomputing.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01b501d18e79$92ddee20$b899ca60$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 04, 2016 at 08:54:57AM -0500, Steve Wise wrote:
> > On Tue, Mar 29, 2016 at 03:49:18PM -0500, Steve Wise wrote:
> > > >
> > > > Adding sq and rq drain functions, which block until all
> > > > previously posted wr-s in the specified queue have completed.
> > > > A completion object is signaled to unblock the thread,
> > > > when the last cqe for the corresponding queue is processed.
> > > >
> > > > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Looks good to me.  No locking needed though?
> > >
> > > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > 
> > Steve,
> > I see that this implementation follows your reference implementation of
> > iw_cxgb4 which was iWARP specific. Can you point me to the relevant
> > information which explain why this specific case exists?
> 
> The iWARP Verbs spec mandates that when the QP is in ERROR, post_send() and
> post_recv() must, at some point, fail synchronously.  See:
> 
> http://tools.ietf.org/html/draft-hilland-rddp-verbs-00#section-6.2.4

OK, 
I see it, the iWARP devices need to flush QP before moving to
drain(error) state.

This leads to another question, why don't we have common specific
functions for iWARP devices? Right now, we have two drivers with the
similar code.

The suggested refactoring can be as follows:

post_marker_func(..)
{
    post_send ....
}

ib_drain_qp(..)
{
    move_to_error
    call_post_marker_func
}

iw_drain_qp(..)
{
    call_to_post_marker_func
    move_to_drain
}

What do you think?

> 
> Steve.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
