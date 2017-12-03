From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: possible core cq bug
Date: Sun, 3 Dec 2017 11:17:35 -0600
Message-ID: <007c01d36c5a$9d20df30$d7629d90$@opengridcomputing.com>
References: <052101d36ba2$7e5b4120$7b11c360$@opengridcomputing.com> <be658098-28a6-e5a8-cebf-5865096f99ce@grimberg.me> <006c01d36c4a$c79cfb50$56d6f1f0$@opengridcomputing.com> <e7782921-b55a-a628-02d4-874d88049ec5@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e7782921-b55a-a628-02d4-874d88049ec5-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Yes, but it ends up calling __ib_process_cq() which doesn't actually poll
> the CQ because cq->wc is NULL.
> 
> Do you mean that the CQ allocation wasn't done with ib_alloc_cq? That
> indeed would be a bug. We can WARN on it as well so the application
> will know to allocate its CQ with ib_alloc_cq.

Yes, the application used ib_create_cq().

> 
> Does something like this makes sense?
>

That would at least log the issue, but the thread in ib_drain_qp() will be stuck forever continually blocking for 1/10sec and then polling.  Perhaps the drain logic should detect this, and then return?

Is there a reason we don't get rid of ib_create_cq()?   Or just make it call ib_alloc_cq()...

> --
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index f2ae75fa3128..90eac56b5f1a 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -69,7 +69,7 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
>    */
>   int ib_process_cq_direct(struct ib_cq *cq, int budget)
>   {
> -       WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
> +       WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT || !cq->wc);
> 
>          return __ib_process_cq(cq, budget);
>   }
> --

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
