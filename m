From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 01/20] ib_srp: Fix a race condition
Date: Mon, 13 Aug 2012 23:19:46 -0400
Message-ID: <1344914386.31833.45.camel@obelisk.thedillows.org>
References: <5023DA39.7020000@acm.org> <5023DAA1.1040507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DAA1.1040507-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-09 at 15:43 +0000, Bart Van Assche wrote:
> Avoid that the scmnd->scsi_done(scmnd) call in srp_process_rsp()
> can trigger a crash by being invoked with scsi_done == NULL. That
> could happen if a reply is received during or after a command abort.

Please leave the call trace out of the commit message; it adds nothing.

> +static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
> +				       struct srp_request *req,
> +				       struct scsi_cmnd *scmnd,
> +				       s32 req_lim_delta)
>  {
>  	unsigned long flags;
>  
> -	srp_unmap_data(req->scmnd, target, req);
>  	spin_lock_irqsave(&target->lock, flags);
>  	target->req_lim += req_lim_delta;

I still think that adding credits back before putting the request on the
free list is a crash waiting to happen. We don't check to see if the
free request list is empty in srp_queuecommand(), so this creates a new
race window where we get a response that gives us credits back, but we
don't have a free request to back them.

Arguably, we need to check for that anyway to protect against buggy
targets giving us back more credits than we have used...

Or am I missing something obvious?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
