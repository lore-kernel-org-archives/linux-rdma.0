From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Thu, 13 Mar 2014 09:42:46 +0200
Message-ID: <53216176.2080406@dev.mellanox.co.il>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org> <53189526.2010704@mellanox.com> <53189DDE.7090003@dev.mellanox.co.il> <53197FC5.4090102@acm.org> <531F11B8.5030202@dev.mellanox.co.il> <531F14D0.7010608@acm.org> <531F18A7.1000907@dev.mellanox.co.il> <531F1DBD.9070505@acm.org> <531F2221.2090403@dev.mellanox.co.il> <531F2501.9090005@acm.org> <531F2C2C.7080306@dev.mellanox.co.il> <53205E1E.3070304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53205E1E.3070304-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/12/2014 3:16 PM, Bart Van Assche wrote:
> On 03/11/14 16:30, Sagi Grimberg wrote:
>> State FAIL_FAST must come *after* stated BLOCKED. Do you think that
>> taking the lock
>> once the rport transitions to state BLOCKED suffices? I'm aiming to
>> avoid this lock in
>> the sunny-day flow. Taking this lock always to protect against some
>> error flow
>> that might occur feels somewhat wrong to me.
> Hello Sagi,
>
> I agree that today the SRP initiator only invokes srp_terminate_io()
> after having quiesced I/O first so from that point of view it is not
> necessary to add more locking in srp_queuecommand(). However, since
> this is nontrivial I'd like to trigger a kernel warning if
> srp_terminate_io() is ever invoked concurrently with
> srp_queuecommand(). Additionally, I think the code in
> srp_reset_device() can trigger a race with the I/O completion path. How
> about addressing all this with the patch below ?
>
> Thanks,
>
> Bart.
>
> [PATCH] IB/srp: Fix a race condition between failing I/O and I/O completion
>
> Avoid that srp_terminate_io() can access req->scmnd after it has been
> cleared by the I/O completion code. Do this by protecting req->scmnd
> accesses from srp_terminate_io() via locking
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 33 ++++++++++++++++++++++-----------
>   1 file changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a64e469..66a908b 100644
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
> @@ -841,11 +844,20 @@ static void srp_finish_req(struct srp_target_port *target,
>   static void srp_terminate_io(struct srp_rport *rport)
>   {
>   	struct srp_target_port *target = rport->lld_data;
> +	struct Scsi_Host *shost = target->scsi_host;
> +	struct scsi_device *sdev;
>   	int i;
>   
> +	/*
> +	 * Invoking srp_terminate_io() while srp_queuecommand() is running
> +	 * is not safe. Hence the warning statement below.
> +	 */
> +	shost_for_each_device(sdev, shost)
> +		WARN_ON_ONCE(sdev->request_queue->request_fn_active);
> +
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		srp_finish_req(target, req, DID_TRANSPORT_FAILFAST << 16);
> +		srp_finish_req(target, req, NULL, DID_TRANSPORT_FAILFAST << 16);
>   	}
>   }
>   
> @@ -882,7 +894,7 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		srp_finish_req(target, req, DID_RESET << 16);
> +		srp_finish_req(target, req, NULL, DID_RESET << 16);
>   	}
>   
>   	INIT_LIST_HEAD(&target->free_tx);
> @@ -1290,7 +1302,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
>   		complete(&target->tsk_mgmt_done);
>   	} else {
>   		req = &target->req_ring[rsp->tag];
> -		scmnd = srp_claim_req(target, req, NULL);
> +		scmnd = srp_claim_req(target, req, NULL, NULL);
>   		if (!scmnd) {
>   			shost_printk(KERN_ERR, target->scsi_host,
>   				     "Null scmnd for RSP w/tag %016llx\n",
> @@ -2008,7 +2020,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>   
>   	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
>   
> -	if (!req || !srp_claim_req(target, req, scmnd))
> +	if (!req || !srp_claim_req(target, req, NULL, scmnd))
>   		return SUCCESS;
>   	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>   			      SRP_TSK_ABORT_TASK) == 0)
> @@ -2039,8 +2051,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
>   
>   	for (i = 0; i < target->req_ring_size; ++i) {
>   		struct srp_request *req = &target->req_ring[i];
> -		if (req->scmnd && req->scmnd->device == scmnd->device)
> -			srp_finish_req(target, req, DID_RESET << 16);
> +		srp_finish_req(target, req, scmnd->device, DID_RESET << 16);
>   	}
>   
>   	return SUCCESS;

Acked-by: Sagi Grimberg  <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
