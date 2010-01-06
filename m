From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 06 Jan 2010 13:38:43 -0800
Message-ID: <adazl4qsyl8.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<1262568846.13289.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org> (David Dillow's
	message of "Sun, 03 Jan 2010 20:34:06 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I agree that we should add support for SRP_CRED_REQ, but I'm not
 > thrilled with the mix of changes in the patch, as well as the general
 > aesthetics of the result. How about something like the following series
 > -- posted as a follow up to this message -- with proper credit for Bart?
 > I'll sign off on them once we're happy with a direction and Bart acks.

Thanks very much for doing this!  I agree that splitting up this way
makes the patches much easier to review, and is the right way to do this.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
