From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Sat, 09 Jan 2010 22:41:00 -0800
Message-ID: <adavdfapimb.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<ada4omyud7c.fsf@roland-alpha.cisco.com>
	<e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	<adak4vuqrcw.fsf@roland-alpha.cisco.com>
	<e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001070003y6881eac7g3e8129e44b78a475-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Thu, 7 Jan 2010 09:03:15 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > The patch I posted is really fixing the original bug. The problem was
 > that neither the SRP target nor the SRP initiator had support for
 > SRP_CRED_REQ. Support for SRP_CRED_REQ has to be added to both
 > software components in order to fix this bug.

There's no way for the target to return credits through responses?  I
agree that we should implement the full SRP spec in the initiator but it
seems unfortunate to force both an initiator and target upgrade to fix
what really appears to be a target bug.  This means anyone running a
pre-2.6.34 kernel won't be able to use the SCST SRP target reliably.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
