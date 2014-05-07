From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/9] IB/srp: Introduce srp_map_fmr()
Date: Wed, 07 May 2014 13:39:46 +0300
Message-ID: <536A0D72.4010105@dev.mellanox.co.il>
References: <5368DA5B.80609@acm.org> <5368DB2F.8020506@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DB2F.8020506-HInyCGIudOg@public.gmane.org>
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
>   drivers/infiniband/ulp/srp/ib_srp.c | 77 ++++++++++++++++++++++---------------
>   1 file changed, 45 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index f41cc8c..5fb607b 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1047,12 +1047,54 @@ static int srp_map_sg_entry(struct srp_map_state *state,
>   	return ret;
>   }
>   
> +static void srp_map_fmr(struct srp_map_state *state,
> +			struct srp_target_port *target, struct srp_request *req,
> +			struct scatterlist *scat, int count)
> +{
> +	struct srp_device *dev = target->srp_host->srp_dev;
> +	struct ib_device *ibdev = dev->dev;
> +	struct scatterlist *sg;
> +	int i, use_fmr;
> +
> +	state->desc	= req->indirect_desc;
> +	state->pages	= req->map_page;
> +	state->next_fmr	= req->fmr_list;
> +
> +	use_fmr = dev->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
> +
> +	for_each_sg(scat, sg, count, i) {
> +		if (srp_map_sg_entry(state, target, sg, i, use_fmr)) {
> +			/* FMR mapping failed, so backtrack to the first
> +			 * unmapped entry and continue on without using FMR.
> +			 */
> +			dma_addr_t dma_addr;
> +			unsigned int dma_len;
> +
> +backtrack:
> +			sg = state->unmapped_sg;
> +			i = state->unmapped_index;
> +
> +			dma_addr = ib_sg_dma_address(ibdev, sg);
> +			dma_len = ib_sg_dma_len(ibdev, sg);
> +			dma_len -= (state->unmapped_addr - dma_addr);
> +			dma_addr = state->unmapped_addr;
> +			use_fmr = SRP_MAP_NO_FMR;
> +			srp_map_desc(state, dma_addr, dma_len, target->rkey);
> +		}
> +	}
> +
> +	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(state, target))
> +		goto backtrack;
> +
> +	req->nfmr = state->nfmr;
> +}
> +
>   static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
>   			struct srp_request *req)
>   {
> -	struct scatterlist *scat, *sg;
> +	struct scatterlist *scat;
>   	struct srp_cmd *cmd = req->cmd->buf;
> -	int i, len, nents, count, use_fmr;
> +	int len, nents, count;
>   	struct srp_device *dev;
>   	struct ib_device *ibdev;
>   	struct srp_map_state state;
> @@ -1111,35 +1153,7 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
>   				   target->indirect_size, DMA_TO_DEVICE);
>   
>   	memset(&state, 0, sizeof(state));
> -	state.desc	= req->indirect_desc;
> -	state.pages	= req->map_page;
> -	state.next_fmr	= req->fmr_list;
> -
> -	use_fmr = dev->fmr_pool ? SRP_MAP_ALLOW_FMR : SRP_MAP_NO_FMR;
> -
> -	for_each_sg(scat, sg, count, i) {
> -		if (srp_map_sg_entry(&state, target, sg, i, use_fmr)) {
> -			/* FMR mapping failed, so backtrack to the first
> -			 * unmapped entry and continue on without using FMR.
> -			 */
> -			dma_addr_t dma_addr;
> -			unsigned int dma_len;
> -
> -backtrack:
> -			sg = state.unmapped_sg;
> -			i = state.unmapped_index;
> -
> -			dma_addr = ib_sg_dma_address(ibdev, sg);
> -			dma_len = ib_sg_dma_len(ibdev, sg);
> -			dma_len -= (state.unmapped_addr - dma_addr);
> -			dma_addr = state.unmapped_addr;
> -			use_fmr = SRP_MAP_NO_FMR;
> -			srp_map_desc(&state, dma_addr, dma_len, target->rkey);
> -		}
> -	}
> -
> -	if (use_fmr == SRP_MAP_ALLOW_FMR && srp_map_finish_fmr(&state, target))
> -		goto backtrack;
> +	srp_map_fmr(&state, target, req, scat, count);
>   
>   	/* We've mapped the request, now pull as much of the indirect
>   	 * descriptor table as we can into the command buffer. If this
> @@ -1147,7 +1161,6 @@ backtrack:
>   	 * guaranteed to fit into the command, as the SCSI layer won't
>   	 * give us more S/G entries than we allow.
>   	 */
> -	req->nfmr = state.nfmr;
>   	if (state.ndesc == 1) {
>   		/* FMR mapping was able to collapse this to one entry,
>   		 * so use a direct descriptor.
Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
