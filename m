From: sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Thu, 6 Mar 2014 17:32:54 +0200
Message-ID: <53189526.2010704@mellanox.com>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53183B71.4090609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/6/2014 11:10 AM, Bart Van Assche wrote:
> On 02/27/14 12:32, Sagi Grimberg wrote:
>> As I recall  (need to re-confirm this), the problem was that in unstable
>> ports condition srp_abort is
>> called invoking srp_free_req (unmap call #1) and reconnect process (or
>> reset_device or terminate_io)
>> finishes all requests in the request ring (unmap call #2). when FMRs are
>> used then nfmr goes to zero
>> the first time, but when FMRs are not supported nfmr goes from 0 to -1
>> causing the crash since nfmr condition
>> is not safe.
> Hello Sagi,
>
> Thinking further about this, it looks to me like the only way to avoid
> that srp_terminate_io() triggers a race condition with the error path
> in srp_queuecommand() is to set req->scmnd only if srp_post_send() has
> succeeded. How about the patch below ? That patch should ensure that
> srp_unmap_data() is only called once for each request and hence should
> avoid triggering the crash you mentioned.

Hey Bart, Thanks for taking the time to think on this issue.

I see your point, and it might work. let me try it out (if I won't get 
to it today I'll do it on Sunday)
and reply if that resolves the issue.

Sagi.

> Thanks,
>
> Bart.
>
> [PATCH] IB/srp: Fix a race condition between fast failing I/O and I/O queueing
>
> Avoid that srp_unmap_data() can get invoked concurrently by
> srp_terminate_io() and from the error path in srp_queuecommand()
> if srp_post_send() fails.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 46 +++++++++++++++++++++----------------
>   1 file changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 7858240..85eb59f 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -783,6 +783,7 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
>    * srp_claim_req - Take ownership of the scmnd associated with a request.
>    * @target: SRP target port.
>    * @req: SRP request.
> + * @sdev: If not NULL, only take ownership for this SCSI device.
>    * @scmnd: If NULL, take ownership of @req->scmnd. If not NULL, only take
>    *         ownership of @req->scmnd if it equals @scmnd.
>    *
> @@ -791,16 +792,17 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
>    */
>   static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
>   				       struct srp_request *req,
> +				       struct scsi_device *sdev,
>   				       struct scsi_cmnd *scmnd)
>   {
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&target->lock, flags);
> -	if (!scmnd) {
> +	if (req->scmnd &&
> +	    (!sdev || req->scmnd->device == sdev) &&
> +	    (!scmnd || req->scmnd == scmnd)) {
>   		scmnd = req->scmnd;
>   		req->scmnd = NULL;
> -	} else if (req->scmnd == scmnd) {
> -		req->scmnd = NULL;
>   	} else {
>   		scmnd = NULL;
>   	}
> @@ -827,9 +829,10 @@ static void srp_free_req(struct srp_target_port *target,
>   }
>   
>   static void srp_finish_req(struct srp_target_port *target,
> -			   struct srp_request *req, int result)
> +			   struct srp_request *req, struct scsi_device *sdev,
> +			   int result)
>   {
> -	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
> +	struct scsi_cmnd *scmnd = srp_claim_req(target, req, sdev, NULL);
>   
>   	if (scmnd) {
>   		srp_free_req(target, req, scmnd, 0);
> @@ -845,7 +848,7 @@ static void srp_terminate_io(struct srp_rport *rport)
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		srp_finish_req(target, req, DID_TRANSPORT_FAILFAST << 16);
> +		srp_finish_req(target, req, NULL, DID_TRANSPORT_FAILFAST << 16);
>   	}
>   }
>   
> @@ -882,7 +885,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		srp_finish_req(target, req, DID_RESET << 16);
> +		srp_finish_req(target, req, NULL, DID_RESET << 16);
>   	}
>   
>   	INIT_LIST_HEAD(&target->free_tx);
> @@ -1290,7 +1293,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
>   		complete(&target->tsk_mgmt_done);
>   	} else {
>   		req = &target->req_ring[rsp->tag];
> -		scmnd = srp_claim_req(target, req, NULL);
> +		scmnd = srp_claim_req(target, req, NULL, NULL);
>   		if (!scmnd) {
>   			shost_printk(KERN_ERR, target->scsi_host,
>   				     "Null scmnd for RSP w/tag %016llx\n",
> @@ -1509,7 +1512,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	struct srp_cmd *cmd;
>   	struct ib_device *dev;
>   	unsigned long flags;
> -	int len, result;
> +	int len, result, ret = 0;
>   	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
>   
>   	/*
> @@ -1552,8 +1555,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	cmd->tag    = req->index;
>   	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
>   
> -	req->scmnd    = scmnd;
> -	req->cmd      = iu;
> +	req->cmd = iu;
>   
>   	len = srp_map_data(scmnd, target, req);
>   	if (len < 0) {
> @@ -1565,7 +1567,14 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
>   				      DMA_TO_DEVICE);
>   
> -	if (srp_post_send(target, iu, len)) {
> +	spin_lock_irqsave(&target->lock, flags);
> +	if (srp_post_send(target, iu, len) == 0)
> +		req->scmnd = scmnd;
> +	else
> +		ret = SCSI_MLQUEUE_HOST_BUSY;
> +	spin_unlock_irqrestore(&target->lock, flags);
> +
> +	if (ret) {
>   		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
>   		goto err_unmap;
>   	}
> @@ -1574,7 +1583,7 @@ unlock_rport:
>   	if (in_scsi_eh)
>   		mutex_unlock(&rport->mutex);
>   
> -	return 0;
> +	return ret;
>   
>   err_unmap:
>   	srp_unmap_data(scmnd, target, req);
> @@ -1588,10 +1597,8 @@ err_iu:
>   err_unlock:
>   	spin_unlock_irqrestore(&target->lock, flags);
>   
> -	if (in_scsi_eh)
> -		mutex_unlock(&rport->mutex);
> -
> -	return SCSI_MLQUEUE_HOST_BUSY;
> +	ret = SCSI_MLQUEUE_HOST_BUSY;
> +	goto unlock_rport;
>   }
>   
>   /*
> @@ -2008,7 +2015,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>   
>   	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
>   
> -	if (!req || !srp_claim_req(target, req, scmnd))
> +	if (!req || !srp_claim_req(target, req, NULL, scmnd))
>   		return SUCCESS;
>   	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>   			      SRP_TSK_ABORT_TASK) == 0)
> @@ -2039,8 +2046,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		if (req->scmnd && req->scmnd->device == scmnd->device)
> -			srp_finish_req(target, req, DID_RESET << 16);
> +		srp_finish_req(target, req, scmnd->device, DID_RESET << 16);
>   	}
>   
>   	return SUCCESS;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
