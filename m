From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Thu, 27 Feb 2014 13:32:46 +0200
Message-ID: <530F225E.5070500@dev.mellanox.co.il>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530B6444.1000805-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/24/2014 5:24 PM, Bart Van Assche wrote:
> On 02/24/14 15:30, Sagi Grimberg wrote:
>> When unmapping request data, it is unsafe automatically
>> decrement req->nfmr regardless of it's value. This may
>> happen since IO and reconnect flow may run concurrently
>> resulting in req->nfmr = -1 and falsely call ib_fmr_pool_unmap.
>>
>> Fix the loop condition to be greater than zero (which
>> explicitly means that FMRs were used on this request)
>> and only increment when needed.
>>
>> This crash is easily reproduceable with ConnectX VFs OR
>> Connect-IB (where FMRs are not supported)
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c |    5 ++++-
>>   1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 529b6bc..0e20bfb 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -766,8 +766,11 @@ static void srp_unmap_data(struct scsi_cmnd *scmnd,
>>   		return;
>>   
>>   	pfmr = req->fmr_list;
>> -	while (req->nfmr--)
>> +
>> +	while (req->nfmr > 0) {
>>   		ib_fmr_pool_unmap(*pfmr++);
>> +		req->nfmr--;
>> +	}
>>   
>>   	ib_dma_unmap_sg(ibdev, scsi_sglist(scmnd), scsi_sg_count(scmnd),
>>   			scmnd->sc_data_direction);
>>
> Hello Sagi,
>
> If srp_unmap_data() got invoked twice for the same request that means
> that a race condition has been hit. I would like to see the root cause
> of that race condition fixed instead of making it safe to invoke
> srp_unmap_data() multiple times. It would be appreciated if you could
> verify whether the following patch is a valid alternative for the above
> patch:

Hey Bart, Sorry for the late response,

It's been a while since I did this, but as I recall the problem wasn't 
in srp_post_send failure path.
Moreover I don't think a spinlock on srp_post_send is a good idea unless 
it is absolutely needed
(I don't think so).

As I recall  (need to re-confirm this), the problem was that in unstable 
ports condition srp_abort is
called invoking srp_free_req (unmap call #1) and reconnect process (or 
reset_device or terminate_io)
finishes all requests in the request ring (unmap call #2). when FMRs are 
used then nfmr goes to zero
the first time, but when FMRs are not supported nfmr goes from 0 to -1 
causing the crash since nfmr condition
is not safe.

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index b753a7a..2c75f95 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2141,8 +2141,7 @@ static int SRP_QUEUECOMMAND(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	cmd->tag    = req->index;
>   	memcpy(cmd->cdb, scmnd->cmnd, scmnd->cmd_len);
>   
> -	req->scmnd    = scmnd;
> -	req->cmd      = iu;
> +	req->cmd = iu;
>   
>   	len = srp_map_data(scmnd, ch, req);
>   	if (len < 0) {
> @@ -2160,7 +2159,12 @@ static int SRP_QUEUECOMMAND(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   	ib_dma_sync_single_for_device(dev, iu->dma, target->max_iu_len,
>   				      DMA_TO_DEVICE);
>   
> -	if (srp_post_send(ch, iu, len)) {
> +	spin_lock_irqsave(&ch->lock, flags);
> +	req->scmnd = scmnd;
> +	ret = srp_post_send(ch, iu, len) ? SCSI_MLQUEUE_HOST_BUSY : 0;
> +	spin_unlock_irqrestore(&ch->lock, flags);
> +
> +	if (ret) {
>   		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
>   		goto err_unmap;
>   	}
>
> Thanks,
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
