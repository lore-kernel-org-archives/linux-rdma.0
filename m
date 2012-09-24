From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/8] libibverbs: Introduce XRC domains
Date: Mon, 24 Sep 2012 23:00:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8F087@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8E7FB@ORSMSX101.amr.corp.intel.com>
 <20120924203618.GC9472@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F01C@ORSMSX101.amr.corp.intel.com>
 <20120924211911.GA11120@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8F05F@ORSMSX101.amr.corp.intel.com>
 <20120924220912.GA12418@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120924220912.GA12418-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Verbs doesn't allocate the structures, so it can't store anything.
> 
> Well, that is the point, verbs shouldn't be storing things, any change
> to the object state must go through the provider.

Verbs does stuff like this:

        qp = context->ops.create_qp(pd, (struct ibv_qp_init_attr *)
                                        qp_init_attr_ex);

        if (qp) {
                qp->context          = context;
                qp->qp_context       = qp_init_attr_ex->qp_context;
                qp->pd               = pd;
                qp->send_cq          = qp_init_attr_ex->send_cq;
                qp->recv_cq          = qp_init_attr_ex->recv_cq;
                qp->srq              = qp_init_attr_ex->srq;
                qp->qp_type          = qp_init_attr_ex->qp_type;
                qp->state            = IBV_QPS_RESET;
                qp->events_completed = 0;
                pthread_mutex_init(&qp->mutex, NULL);
                pthread_cond_init(&qp->cond, NULL);

and this:

        if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
                return errno;

        (void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);

        qp->handle                = resp->qp_handle;
        qp->qp_num                = resp->qpn;
        qp->context               = context;


> 
> > Adding a bunch of get/set calls seems worse to me than just placing
> > the items in a structure.
> 
> Really?
> 
>  if (cq->comp_mask & IBV_CQ_COMP_MASK_SRQ_NUM)
>    srq_num = cq->srq_num
> 
> vs
> 
>  ibv_cq_get_srq_num(cq); // Returns 0 on error
> 
> Betcha at least 50% of apps would do the first one wrong....

An app which uses XRC just needs to access srq->srq_num.  No other checks are needed.  If they have an XRC SRQ, the SRQ number must be valid.  The mask seems pointless to me.

If you're suggesting that verbs.h remains untouched (for patch 1 of this series), but that new structures are defined between the verbs and the provider only, that seems reasonable.  It would likely result in a bunch of typecasts everywhere.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
