From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 15/26] IB/srp: Split srp_map_sg
Date: Fri, 25 Sep 2015 09:15:28 -0700
Message-ID: <56057320.4010905@sandisk.com>
References: <1443116118-10730-1-git-send-email-sagig@mellanox.com>
 <1443116118-10730-16-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116118-10730-16-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/24/2015 10:35 AM, Sagi Grimberg wrote:
> This is a perparation patch for the new registration API
             ^ preparation ?

> conversion. It splits srp_map_sg per registration strategy
> (srp_map_sg[fmr|fr|dma]. On its own it adds some code duplication,
> but it makes the API switch easier to comprehend.
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 156 ++++++++++++++++++++++++------------
>   1 file changed, 105 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index f8b9c18da03d..74748d1075fc 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1286,6 +1286,17 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
>   	if (WARN_ON_ONCE(state->fmr.next >= state->fmr.end))
>   		return -ENOMEM;
>
> +	WARN_ON_ONCE(!dev->use_fmr);
> +
> +	if (state->npages == 0)
> +		return 0;
> +
> +	if (state->npages == 1 && target->global_mr) {
> +		srp_map_desc(state, state->base_dma_addr, state->dma_len,
> +			     target->global_mr->rkey);
> +		return 0;
> +	}
> +

The above is not correct. The npages and dma_len variables have to be 
reset before returning. How about changing the "return 0" statement into 
"goto reset_state" and adding a "reset_state" label ?

>   	fmr = ib_fmr_pool_map_phys(ch->fmr_pool, state->pages,
>   				   state->npages, io_addr);
>   	if (IS_ERR(fmr))
> @@ -1297,6 +1308,9 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
>   	srp_map_desc(state, state->base_dma_addr & ~dev->mr_page_mask,
>   		     state->dma_len, fmr->fmr->rkey);
>
> +	state->npages = 0;
> +	state->dma_len = 0;
> +
>   	return 0;
>   }
>
> @@ -1309,10 +1323,23 @@ static int srp_map_finish_fr(struct srp_map_state *state,
>   	struct ib_fast_reg_wr wr;
>   	struct srp_fr_desc *desc;
>   	u32 rkey;
> +	int err;
> +
>
>   	if (WARN_ON_ONCE(state->fr.next >= state->fr.end))
>   		return -ENOMEM;
>
> +	WARN_ON_ONCE(!dev->use_fast_reg);
> +
> +	if (state->npages == 0)
> +		return 0;
> +
> +	if (state->npages == 1 && target->global_mr) {
> +		srp_map_desc(state, state->base_dma_addr, state->dma_len,
> +			     target->global_mr->rkey);
> +		return 0;
> +	}
> +

Same comment here. npages and dma_len have to be reset before returning.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
