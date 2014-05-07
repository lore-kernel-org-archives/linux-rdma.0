From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 6/9] IB/srp: Make srp_alloc_req_data() reallocate request
 data
Date: Wed, 07 May 2014 13:50:31 +0300
Message-ID: <536A0FF7.7050608@dev.mellanox.co.il>
References: <5368DA5B.80609@acm.org> <5368DB90.9050209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368DB90.9050209-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/6/2014 3:54 PM, Bart Van Assche wrote:
> This patch is needed by the patch that adds fast registration support.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 41 ++++++++++++++++++++++++-------------
>   1 file changed, 27 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index ba434d6..1c4b0d3 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -574,17 +574,18 @@ static void srp_disconnect_target(struct srp_target_port *target)
>   	}
>   }
>   
> -static void srp_free_req_data(struct srp_target_port *target)
> +static void srp_free_req_data(struct srp_target_port *target,
> +			      struct srp_request *req_ring)
>   {

Something here feels wrong (or partially right).

>   	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
>   	struct srp_request *req;
>   	int i;
>   
> -	if (!target->req_ring)
> +	if (!req_ring)
>   		return;
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
> -		req = &target->req_ring[i];
> +		req = &req_ring[i];

You loop for {ring A size} and operates on ring B elements. They will 
probably be the same but the notion seems buggy.
Will it be better to untie this routine from srp_target_port at all?

>   		kfree(req->fmr_list);
>   		kfree(req->map_page);
>   		if (req->indirect_dma_addr) {
> @@ -595,27 +596,34 @@ static void srp_free_req_data(struct srp_target_port *target)
>   		kfree(req->indirect_desc);
>   	}
>   
> -	kfree(target->req_ring);
> -	target->req_ring = NULL;
> +	kfree(req_ring);
>   }
>   
> +/**
> + * srp_alloc_req_data() - allocate or reallocate request data
> + * @target: SRP target port.
> + *
> + * If target->req_ring was non-NULL before this function got invoked it will
> + * also be non-NULL after this function has finished.
> + */
>   static int srp_alloc_req_data(struct srp_target_port *target)
>   {
>   	struct srp_device *srp_dev = target->srp_host->srp_dev;
>   	struct ib_device *ibdev = srp_dev->dev;
> -	struct srp_request *req;
> +	struct list_head free_reqs;
> +	struct srp_request *req_ring, *req;
>   	dma_addr_t dma_addr;
>   	int i, ret = -ENOMEM;
>   
> -	INIT_LIST_HEAD(&target->free_reqs);
> +	INIT_LIST_HEAD(&free_reqs);
>   
> -	target->req_ring = kzalloc(target->req_ring_size *
> -				   sizeof(*target->req_ring), GFP_KERNEL);
> -	if (!target->req_ring)
> +	req_ring = kzalloc(target->req_ring_size * sizeof(*req_ring),
> +			   GFP_KERNEL);
> +	if (!req_ring)
>   		goto out;
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
> -		req = &target->req_ring[i];
> +		req = &req_ring[i];
>   		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
>   					GFP_KERNEL);
>   		req->map_page = kmalloc(SRP_FMR_SIZE * sizeof(void *),
> @@ -632,11 +640,16 @@ static int srp_alloc_req_data(struct srp_target_port *target)
>   
>   		req->indirect_dma_addr = dma_addr;
>   		req->index = i;
> -		list_add_tail(&req->list, &target->free_reqs);
> +		list_add_tail(&req->list, &free_reqs);
>   	}
> +	swap(target->req_ring, req_ring);
> +	INIT_LIST_HEAD(&target->free_reqs);
> +	list_splice(&free_reqs, &target->free_reqs);
>   	ret = 0;
>   
>   out:
> +	srp_free_req_data(target, req_ring);
> +
>   	return ret;
>   }
>   
> @@ -669,7 +682,7 @@ static void srp_remove_target(struct srp_target_port *target)
>   	srp_free_target_ib(target);
>   	cancel_work_sync(&target->tl_err_work);
>   	srp_rport_put(target->rport);
> -	srp_free_req_data(target);
> +	srp_free_req_data(target, target->req_ring);
>   
>   	spin_lock(&target->srp_host->target_lock);
>   	list_del(&target->list);
> @@ -2750,7 +2763,7 @@ err_free_ib:
>   	srp_free_target_ib(target);
>   
>   err_free_mem:
> -	srp_free_req_data(target);
> +	srp_free_req_data(target, target->req_ring);
>   
>   err:
>   	scsi_host_put(target_host);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
