From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 10:48:47 -0800
Message-ID: <adasjww3ai8.fsf@cisco.com>
References: <adalj2q587i.fsf@cisco.com>
	<1294854748.15826.26.camel@lap75545.ornl.gov>
	<ada8vyq57bq.fsf@cisco.com>
	<1294861341.15826.38.camel@lap75545.ornl.gov>
	<adaoc7l52hy.fsf@cisco.com> <adak4i952bk.fsf@cisco.com>
	<1294866460.15826.41.camel@lap75545.ornl.gov>
	<AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Thu, 13 Jan 2011 12:19:34 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes, I like something like the patch below much more.  (Dave's comments
make sense also though)

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
 >  	spin_unlock_irqrestore(&target->lock, flags);
 > 
 >  err:
 > 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
