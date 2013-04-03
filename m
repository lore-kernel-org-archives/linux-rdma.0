From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: XRC and ib_poll_cq
Date: Wed, 3 Apr 2013 00:35:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F36A119@ORSMSX101.amr.corp.intel.com>
References: 1828884A29C6694DAF28B7E6B8A823736F369FCB () ORSMSX101 ! amr !
 corp ! intel ! com <515B393F.2080405@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515B393F.2080405-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Thanks, it seems that I asked the question in a wrong way.
> The context is what I need eventually but in order to find it I first
> need to recover the QP or the XRC SRQ.
> Per core there may be several QP and SRQ using the same CQ.
> When doing ib_poll_cq on the CQ the WQE in hand has only an ib_qp pointer.

Correct - dereference the qp pointer to get the context, srq, and srq_context.

struct ib_wc wc;

ib_poll_cq(...&wc)
my_qp = wc.qp;
my_qp_context = wc.qp->qp_context;
my_srq = wc.qp->srq;
my_srq_context = wc.qp->srq->srq_context;

this tells you what QP/SRQ the completion is related to.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
