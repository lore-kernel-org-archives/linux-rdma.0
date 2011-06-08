From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdma_cm and PSNs
Date: Wed, 8 Jun 2011 05:25:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373019453@ORSMSX101.amr.corp.intel.com>
References: <201106041737.16482.kerr.g@husky.neu.edu>
 <1828884A29C6694DAF28B7E6B8A82373012DA1@ORSMSX101.amr.corp.intel.com>
 <201106072107.31735.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106072107.31735.kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > Node 1:
> > > RQ_PSN is 464684127
> > > SQ_PSN is 2204625
> > >
> > > Node 2:
> > > RQ_PSN is 1327604689
> > > SQ_PSN is 11699295
> >

> {
>   JNOTE("********* WRAPPER for ibv_modify_qp");
>   if (attr_mask & IBV_QP_RQ_PSN) {
>     printf("RQ_PSN is %ju\n", attr->rq_psn);
>   }
>   if (attr_mask & IBV_QP_SQ_PSN) {
>     printf("SQ_PSN is %ju\n", attr->sq_psn);
>   }

PSN values are only 24-bits.  The values above check out okay if you drop the upper most bit.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
