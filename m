From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Wed, 12 Aug 2015 09:31:57 +0300
Message-ID: <55CAE85D.7010602@dev.mellanox.co.il>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
 <55C8BB38.1060808@sandisk.com> <55CA09E5.2070208@dev.mellanox.co.il>
 <55CA1BC1.3060609@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CA1BC1.3060609-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On second thought ... with your patch, if the "goto err_qp" branch in
> srp_create_ch_ib() is taken upon return ch->qp, ch->recv_cq and
> ch->send_cq will be dangling pointers. That will have bad consequences
> in the subsequent srp_free_ch_ib() call. How about replacing the above
> patch with the (untested) patch below ?
>
> Thanks,
>
> Bart.
>
> [PATCH] IB/srp: Avoid that a completion during reconnect causes a crash
>
> Untested.
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 2968b7b..1f9ed68 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -554,9 +554,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
>   				     "FR pool allocation failed (%d)\n", ret);
>   			goto err_qp;
>   		}
> -		if (ch->fr_pool)
> -			srp_destroy_fr_pool(ch->fr_pool);
> -		ch->fr_pool = fr_pool;
>   	} else if (!dev->use_fast_reg && dev->has_fmr) {
>   		fmr_pool = srp_alloc_fmr_pool(target);
>   		if (IS_ERR(fmr_pool)) {
> @@ -565,9 +562,6 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
>   				     "FMR pool allocation failed (%d)\n", ret);
>   			goto err_qp;
>   		}
> -		if (ch->fmr_pool)
> -			ib_destroy_fmr_pool(ch->fmr_pool);
> -		ch->fmr_pool = fmr_pool;
>   	}
>
>   	if (ch->qp)
> @@ -577,6 +571,16 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
>   	if (ch->send_cq)
>   		ib_destroy_cq(ch->send_cq);
>
> +	if (dev->use_fast_reg && dev->has_fr) {
> +		if (ch->fr_pool)
> +			srp_destroy_fr_pool(ch->fr_pool);
> +		ch->fr_pool = fr_pool;
> +	} else if (!dev->use_fast_reg && dev->has_fmr) {
> +		if (ch->fmr_pool)
> +			ib_destroy_fmr_pool(ch->fmr_pool);
> +		ch->fmr_pool = fmr_pool;
> +	}
> +
>   	ch->qp = qp;
>   	ch->recv_cq = recv_cq;
>   	ch->send_cq = send_cq;
>

Looks better, I'll resubmit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
