From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] IB/srp: minimal support for SRP_CRED_REQ and SRP_AER_REQ
Date: Wed, 06 Jan 2010 15:20:17 -0800
Message-ID: <adaaawqstvy.fsf@roland-alpha.cisco.com>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
	<1262568846.13289.4.camel@obelisk.thedillows.org>
	<1262569417-20341-2-git-send-email-dave@thedillows.org>
	<adar5q2sy5q.fsf@roland-alpha.cisco.com>
	<1262818979.2265.13.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262818979.2265.13.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org> (David Dillow's
	message of "Wed, 06 Jan 2010 18:02:59 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Is there a good function to dump SCSI sense data? If so, then it makes
 > sense to dump it, yeah. Better yet, inject it into the SCSI mid-layer.

A quick look doesn't find any sense-dumping function.  Probably not
worth worrying about it until someone starts seeing async errors anyway.

 > Only srp_aer_req needs packing I think -- u32 reserved on an 8 byte
 > boundary followed by __be64 lun.

Yup, correct on that -- I missed that one.

 > Makes sense, or we could pass in the request type and do
 > 
 > if (reqtype != SRP_REQ_RESPONSE)
 > 	--req_limit;

Works as well ... even stash away the request type when allocating a tx
iu, so we don't have to pass around the type more.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
