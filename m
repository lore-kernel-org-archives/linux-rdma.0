From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 10:21:11 -0500
Message-ID: <1294932071.3667.5.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov> <ada8vyq57bq.fsf@cisco.com>
 <1294861341.15826.38.camel@lap75545.ornl.gov> <adaoc7l52hy.fsf@cisco.com>
 <adak4i952bk.fsf@cisco.com> <1294866460.15826.41.camel@lap75545.ornl.gov>
 <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-13 at 06:19 -0500, Bart Van Assche wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> b/drivers/infiniband/ulp/srp/ib_srp.c
> index 4b62105..3164c4d 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1132,16 +1132,12 @@ static int srp_queuecommand(struct Scsi_Host
> *shost, struct scsi_cmnd *scmnd)
> 
>  	spin_lock_irqsave(&target->lock, flags);
>  	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
> -	if (iu) {
> -		req = list_first_entry(&target->free_reqs, struct srp_request,
> -				      list);
> -		list_del(&req->list);
> -	}
> +	if (unlikely(!iu))

Please drop the unlikely -- it isn't at all unlikely on the hardware and
loads I run.

> +		goto err_unlock;
> +	req = list_first_entry(&target->free_reqs, struct srp_request, list);
> +	list_del(&req->list);
>  	spin_unlock_irqrestore(&target->lock, flags);
> 
> -	if (!iu)
> -		goto err;
> -
>  	dev = target->srp_host->srp_dev->dev;
>  	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
>  				   DMA_TO_DEVICE);
> @@ -1185,6 +1181,7 @@ err_iu:
> 
>  	spin_lock_irqsave(&target->lock, flags);
>  	list_add(&req->list, &target->free_reqs);
> +err_unlock:

Please add a line before the label.

>  	spin_unlock_irqrestore(&target->lock, flags);
> 
>  err:

If Roland would like to rebase his tree and substitute your patch for my
quickie, then I'm fine with that and you can have my Acked-by with the
above changes. If not, then make it relative to the uninit var change
and I'll be happy to put it in my pull request once the workqueue stuff
is sorted.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
