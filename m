From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add support for draining Shared receive
 queues
Date: Wed, 24 Jan 2018 08:39:20 +0200
Message-ID: <11f8c447-065f-ee0c-f88e-ee3a006f8571@grimberg.me>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
 <1516197178-26493-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197178-26493-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Max,

> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 7868727..7604450 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -886,8 +886,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>   		if (qp_init_attr->recv_cq)
>   			atomic_inc(&qp_init_attr->recv_cq->usecnt);
>   		qp->srq = qp_init_attr->srq;
> -		if (qp->srq)
> +		if (qp->srq) {
>   			atomic_inc(&qp_init_attr->srq->usecnt);
> +			init_completion(&qp->srq_completion);
> +		}
>   	}

How about initializing the completion at ib_drain_srq and complete it
always in last wqe reached event in the core instead of relying on ULPs
to call ib_notify_qp?

The simplest way I can think of is to have the core register its own
event handler for that..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
