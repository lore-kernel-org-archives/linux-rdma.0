From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 02/14] IB/srp: Fix race between srp_queuecommand() and
 srp_claim_req()
Date: Wed, 12 Jun 2013 16:58:04 +0200
Message-ID: <51B88C7C.4030209@profitbricks.com>
References: <51B87501.4070005@acm.org> <51B875EE.3030702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B875EE.3030702-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wait a minute, so you've changed this commit to also hold that target
lock in the following functions in error case:

srp_unmap_data(),
srp_put_tx_iu()

This is different from:
https://github.com/bvanassche/ib_srp-backport/commit/6ce0e30dbb69973926df84292239f0c20f6a2d6c

srp_unmap_data() calls ib_fmr_pool_unmap() which uses an own spin lock
(pool->pool_lock).

srp_put_tx_iu() acquires the target lock as well (target->lock). That's
spin lock in spin lock. I would say that this dead locks.

I like the other version more.

Cheers,
Sebastian


On 12.06.2013 15:21, Bart Van Assche wrote:
> Avoid that srp_claim_command() can claim a command while
> srp_queuecommand() is still busy queueing the same command.
> Found this via source reading.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 368d160..9c638dd 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1367,7 +1367,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>  
>  	req = list_first_entry(&target->free_reqs, struct srp_request, list);
>  	list_del(&req->list);
> -	spin_unlock_irqrestore(&target->lock, flags);
>  
>  	dev = target->srp_host->srp_dev->dev;
>  	ib_dma_sync_single_for_cpu(dev, iu->dma, target->max_iu_len,
> @@ -1401,6 +1400,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>  		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
>  		goto err_unmap;
>  	}
> +	spin_unlock_irqrestore(&target->lock, flags);
>  
>  	return 0;
>  
> @@ -1409,8 +1409,6 @@ err_unmap:
>  
>  err_iu:
>  	srp_put_tx_iu(target, iu, SRP_IU_CMD);
> -
> -	spin_lock_irqsave(&target->lock, flags);
>  	list_add(&req->list, &target->free_reqs);
>  
>  err_unlock:
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
