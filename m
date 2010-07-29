From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: avoid NULL pointer dereference when processing
 invalid SRP_RSP
Date: Thu, 29 Jul 2010 13:21:46 -0400
Message-ID: <1280424106.20975.11.camel@lap75545.ornl.gov>
References: <201007291756.31172.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201007291756.31172.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-07-29 at 17:56 +0200, Bart Van Assche wrote:
> If an SRP target sends an invalid SRP_RSP information unit to the SRP
> initiator this can cause a NULL pointer dereference on the initiator system.
> This patch avoids such NULL pointer dereferences and makes sure the SRP
> inititator keeps working.

While I'm all for increasing the robustness of the initiator, I'm
curious how you would hit this -- I don't see where we would send a SRP
request without an associated SCSI command.

I'm also not sure you're doing the right thing here -- you seem to skip
the cleanup of the associated SRP request. I suppose that may be handled
for you if/when srp_abort() gets called for a missed SCSI request, but
again, we should never be in the situation where a request doesn't have
a SCSI command. And if srp_abort() doesn't get called, we've leaked a
request and possibly a DMA mapping, no?

> Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index ed3f9eb..330452c 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -834,10 +834,12 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
>  		complete(&req->done);
>  	} else {
>  		scmnd = req->scmnd;
> -		if (!scmnd)
> +		if (!scmnd) {
>  			shost_printk(KERN_ERR, target->scsi_host,
>  				     "Null scmnd for RSP w/tag %016llx\n",
>  				     (unsigned long long) rsp->tag);
> +			goto out_unlock;
> +		}
>  		scmnd->result = rsp->status;
>  
>  		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
> @@ -861,6 +863,7 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
>  			req->cmd_done = 1;
>  	}
>  
> +out_unlock:
>  	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
>  }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
