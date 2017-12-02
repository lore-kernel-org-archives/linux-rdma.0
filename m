From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: possible core cq bug
Date: Sat, 2 Dec 2017 13:19:37 -0600
Message-ID: <052101d36ba2$7e5b4120$7b11c360$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If an application creates its cq for DIRECT poll mode using ib_create_cq()
instead of ib_alloc_cq(),  and then uses ib_drain_qp() to drain its qp,
ib_drain_sq/rq() will always hang forever because cq->wc is NULL.  IE
ib_create_cq() doesn't allocate cq->wc, and ib_alloc_cq() does.  Yet the
__ib_process_cq() requires cq->wc to actually complete any completions and
calling the cqe_done function.

Is this a bug in the CQ core code or the application?

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
