From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] IB/srp: minimal support for SRP_CRED_REQ and SRP_AER_REQ
Date: Wed, 06 Jan 2010 13:48:01 -0800
Message-ID: <adar5q2sy5q.fsf@roland-alpha.cisco.com>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
	<1262568846.13289.4.camel@obelisk.thedillows.org>
	<1262569417-20341-2-git-send-email-dave@thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262569417-20341-2-git-send-email-dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> (David
	Dillow's message of "Sun, 3 Jan 2010 20:43:36 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks pretty good; a few minor comments:

 > +static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 > +			       void *rsp, int len);

Didn't check -- can we reorder things to avoid this forward declaration?

 > +	shost_printk(KERN_ERR, target->scsi_host, PFX
 > +		     "ignoring AER for LUN %llu\n", be64_to_cpu(req->lun));

I wonder if we should dump the sense data here, while we're at it.  Do
any targets even send this?

 >  static int __srp_post_send(struct srp_target_port *target,
 > -			   struct srp_iu *iu, int len)
 > +			   struct srp_iu *iu, int len, int credits)

I wonder if this would be slightly clearer/safer if we made the
parameter "bool consume_credit" or something like that?  Since we should
never pass in anything except 0 or 1, right?

 > +	/* SRP_RESP_RESV sets the number of queue entries reserved for
 > +	 * unsolicited messages from the target and the responses to them.
 > +	 */
 > +	SRP_RESP_RESV		= 2,

Looking at this -- where does the value 2 come from?  We currently
always keep one receive posted, right?  I guess the issue is that we
might get a CRED_REQ and a logout request or something like that, but
that should work OK if we process them one at a time.

Or is this change important too?

 > +} __attribute__((packed));

I don't think any of the new structures need to be packed actually.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
