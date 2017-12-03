From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: possible core cq bug
Date: Sun, 3 Dec 2017 13:51:18 +0200
Message-ID: <be658098-28a6-e5a8-cebf-5865096f99ce@grimberg.me>
References: <052101d36ba2$7e5b4120$7b11c360$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <052101d36ba2$7e5b4120$7b11c360$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve,

> If an application creates its cq for DIRECT poll mode using ib_create_cq()
> instead of ib_alloc_cq(),  and then uses ib_drain_qp() to drain its qp,
> ib_drain_sq/rq() will always hang forever because cq->wc is NULL.  IE
> ib_create_cq() doesn't allocate cq->wc, and ib_alloc_cq() does.  Yet the
> __ib_process_cq() requires cq->wc to actually complete any completions and
> calling the cqe_done function.
> 
> Is this a bug in the CQ core code or the application?

Take a look in __ib_drain_rq/__ib_drain_sq for
cq->poll_ctx == IB_POLL_DIRECT. The drain routine polls
the completion queue from time to time...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
