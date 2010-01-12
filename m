From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Tue, 12 Jan 2010 09:13:51 -0800
Message-ID: <ada3a2bp7ow.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<ada4omyud7c.fsf@roland-alpha.cisco.com>
	<e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	<adak4vuqrcw.fsf@roland-alpha.cisco.com>
	<e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	<adavdfapimb.fsf@roland-alpha.cisco.com>
	<e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001100234k7dcb45cescb9ae133c0cdc256-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sun, 10 Jan 2010 11:34:06 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Note: I do not know of any SRP targets that implement approach (2). As
 > far as I know all SRP targets use approach (1).

But no other SRP targets send SRP_CRED_REQ -- and that includes all
native IB storage arrays that I know of.  So there must be some other
way around this (and having separate buffers for command receives and
response sends does seem like a sensible way to design a target anyway).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
