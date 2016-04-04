From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: Adding queue drain functions
Date: Mon, 4 Apr 2016 10:01:49 -0500
Message-ID: <03e901d18e82$ea2067e0$be6137a0$@opengridcomputing.com>
References: <20160329175837.GA9868@TENIKOLO-MOBL2> <046801d189fc$7697f890$63c7e9b0$@opengridcomputing.com> <20160331011902.GC2670@leon.nu> <01b501d18e79$92ddee20$b899ca60$@opengridcomputing.com> <20160404145254.GE5264@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404145254.GE5264-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > The iWARP Verbs spec mandates that when the QP is in ERROR, post_send() and
> > post_recv() must, at some point, fail synchronously.  See:
> >
> > http://tools.ietf.org/html/draft-hilland-rddp-verbs-00#section-6.2.4
> 
> OK,
> I see it, the iWARP devices need to flush QP before moving to
> drain(error) state.
> 
> This leads to another question, why don't we have common specific
> functions for iWARP devices? Right now, we have two drivers with the
> similar code.
> 

Based on the initial review/discussion of the drain API, it was agreed that the
drain logic wouldn't have IB and IW cases, but rather a common and
device-specific case. 

> The suggested refactoring can be as follows:
> 
> post_marker_func(..)
> {
>     post_send ....
> }
> 
> ib_drain_qp(..)
> {
>     move_to_error
>     call_post_marker_func
> }
> 
> iw_drain_qp(..)
> {
>     call_to_post_marker_func
>     move_to_drain
> }
>

This won't work if the QP is already in out of RTS which happens as part of
rdma_disconnect().  And currently the ULP usage is to disconnect and then drain.

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
