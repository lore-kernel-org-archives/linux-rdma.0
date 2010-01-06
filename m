From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] IB/srp: minimal support for SRP_CRED_REQ and
 SRP_AER_REQ
Date: Wed, 06 Jan 2010 18:02:59 -0500
Message-ID: <1262818979.2265.13.camel@lap75545.ornl.gov>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
 <1262568846.13289.4.camel@obelisk.thedillows.org>
 <1262569417-20341-2-git-send-email-dave@thedillows.org>
 <adar5q2sy5q.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <adar5q2sy5q.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-01-06 at 13:48 -0800, Roland Dreier wrote:
> Looks pretty good; a few minor comments:
> 
>  > +static int srp_response_common(struct srp_target_port *target, s32 req_delta,
>  > +			       void *rsp, int len);
> 
> Didn't check -- can we reorder things to avoid this forward declaration?

I don't think we can without a lot of code heft. We'd need to pull
__srp_post_send and _get_tx_iu up. I ordered it the way I did to avoid
having two declarations instead of the one.

I'll take another look, perhaps it can be done.

>  > +	shost_printk(KERN_ERR, target->scsi_host, PFX
>  > +		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));
> 
> I wonder if we should dump the sense data here, while we're at it.  Do
> any targets even send this?

I've never seen it in the field, but I've only got two HW vendors worth
to look at.

Is there a good function to dump SCSI sense data? If so, then it makes
sense to dump it, yeah. Better yet, inject it into the SCSI mid-layer.

>  >  static int __srp_post_send(struct srp_target_port *target,
>  > -			   struct srp_iu *iu, int len)
>  > +			   struct srp_iu *iu, int len, int credits)
> 
> I wonder if this would be slightly clearer/safer if we made the
> parameter "bool consume_credit" or something like that?  Since we should
> never pass in anything except 0 or 1, right?

Makes sense, or we could pass in the request type and do

if (reqtype != SRP_REQ_RESPONSE)
	--req_limit;

>  > +	/* SRP_RESP_RESV sets the number of queue entries reserved for
>  > +	 * unsolicited messages from the target and the responses to them.
>  > +	 */
>  > +	SRP_RESP_RESV		= 2,
> 
> Looking at this -- where does the value 2 come from?  We currently
> always keep one receive posted, right?  I guess the issue is that we
> might get a CRED_REQ and a logout request or something like that, but
> that should work OK if we process them one at a time.
> 
> Or is this change important too?

I think it should be adjusted, probably in the first patch, to make
things a bit more clear -- the way things are in the patch, we set
SRP_RESP_RESV to 2, but really reserve 3 RX entries (and post 2 --
BUG!). It should be at least one to always keep a reply posted, but I
worried about handling multiple messages without room on the TX ring. I
wanted us to have more room to avoid a drop, but I'll admit I haven't
thought it completely through.

> 
>  > +} __attribute__((packed));
> 
> I don't think any of the new structures need to be packed actually.

Only srp_aer_req needs packing I think -- u32 reserved on an 8 byte
boundary followed by __be64 lun.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
