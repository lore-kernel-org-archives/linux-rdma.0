From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 10:07:09 -0500
Message-ID: <571F841D.3010909@opengridcomputing.com>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461682538-19647-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/26/2016 9:55 AM, Sagi Grimberg wrote:
> SRQ attached QPs will fail receive work posts does not
> have a receive queue that needs to be drained, the receive
> queue is shared.

NIT: I can't quite parse that sentence.

Maybe something like:

SRQ attached QPs don't have a private RQ and don't need to be drained.



>
> Fixes: 765d67748bcf ("IB: new common API for draining queues")
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>   drivers/infiniband/core/verbs.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 769b000e8360..566bfb31cadb 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1897,6 +1897,7 @@ EXPORT_SYMBOL(ib_drain_rq);
>   void ib_drain_qp(struct ib_qp *qp)
>   {
>   	ib_drain_sq(qp);
> -	ib_drain_rq(qp);
> +	if (!qp->srq)
> +		ib_drain_rq(qp);
>   }
>   EXPORT_SYMBOL(ib_drain_qp);

Good catch!

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
