From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 5/9] IB/srp: Introduce srp_finish_mapping()
Date: Wed, 07 May 2014 13:41:54 +0300
Message-ID: <536A0DF2.1050900@dev.mellanox.co.il>
References: <5368DA5B.80609@acm.org> <5368DB58.6070502@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DB58.6070502-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/6/2014 3:53 PM, Bart Van Assche wrote:
> This patch does not change any functionality.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 37 +++++++++++++++++++++++++------------
>   1 file changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 5fb607b..ba434d6 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -935,16 +935,6 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
>   	struct ib_pool_fmr *fmr;
>   	u64 io_addr = 0;
>   
> -	if (!state->npages)
> -		return 0;
> -
> -	if (state->npages == 1) {
> -		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
> -			     target->rkey);
> -		state->npages = state->fmr_len = 0;
> -		return 0;
> -	}
> -
>   	fmr = ib_fmr_pool_map_phys(dev->fmr_pool, state->pages,
>   				   state->npages, io_addr);
>   	if (IS_ERR(fmr))
> @@ -954,10 +944,33 @@ static int srp_map_finish_fmr(struct srp_map_state *state,
>   	state->nfmr++;
>   
>   	srp_map_desc(state, 0, state->fmr_len, fmr->fmr->rkey);
> -	state->npages = state->fmr_len = 0;
> +
>   	return 0;
>   }
>   
> +static int srp_finish_mapping(struct srp_map_state *state,
> +			      struct srp_target_port *target)
> +{
> +	int ret = 0;
> +
> +	if (state->npages == 0)
> +		return 0;
> +
> +	if (state->npages == 1) {
> +		srp_map_desc(state, state->base_dma_addr, state->fmr_len,
> +			     target->rkey);
> +	} else {
> +		ret = srp_map_finish_fmr(state, target);
> +	}
> +

Nit, can lose the brackets.
Other than that, Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
