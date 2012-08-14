From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 01/20] ib_srp: Fix a race condition
Date: Tue, 14 Aug 2012 13:21:38 +0000
Message-ID: <502A50E2.9020804@acm.org>
References: <5023DA39.7020000@acm.org> <5023DAA1.1040507@acm.org> <1344914386.31833.45.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344914386.31833.45.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/14/12 03:19, David Dillow wrote:
> On Thu, 2012-08-09 at 15:43 +0000, Bart Van Assche wrote:
>> +static struct scsi_cmnd *srp_claim_req(struct srp_target_port *target,
>> +				       struct srp_request *req,
>> +				       struct scsi_cmnd *scmnd,
>> +				       s32 req_lim_delta)
>>  {
>>  	unsigned long flags;
>>  
>> -	srp_unmap_data(req->scmnd, target, req);
>>  	spin_lock_irqsave(&target->lock, flags);
>>  	target->req_lim += req_lim_delta;
> 
> I still think that adding credits back before putting the request on the
> free list is a crash waiting to happen. We don't check to see if the
> free request list is empty in srp_queuecommand(), so this creates a new
> race window where we get a response that gives us credits back, but we
> don't have a free request to back them.

I've just posted an updated patch in which the above comment has been
addressed, and I've also pushed out a rebased and retested tree to
http://github.com/bvanassche/linux/tree/srp-ha.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
