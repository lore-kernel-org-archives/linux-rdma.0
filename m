From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Tue, 12 Jan 2010 14:57:35 -0800
Message-ID: <adavdf7nd7k.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<ada4omyud7c.fsf@roland-alpha.cisco.com>
	<e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	<adak4vuqrcw.fsf@roland-alpha.cisco.com>
	<e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	<adavdfapimb.fsf@roland-alpha.cisco.com>
	<e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
	<ada3a2bp7ow.fsf@roland-alpha.cisco.com>
	<e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001120923w4b405736v8b8e8ae41322823b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Tue, 12 Jan 2010 18:23:22 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Having separate buffer sets for command receives and response sends
 > might seem a sensible way to design a target. But calling
 > ib_post_recv() before sending a response back to the initiator is not
 > acceptable because this increases communication latency. When a target
 > uses separate buffer sets, sends back SRP_RSP before responses before
 > ib_post_recv() is called, and when it processes SRP_CMD requests in
 > parallel, it still can happen that a sequence of RL - 2 SRP_RSP
 > responses is sent back to the initiator all with the REQUEST LIMIT
 > DELTA field set to zero. So even with separate buffer sets there is a
 > need for SRP_CRED_REQ support in the initiator.

I doubt you could benchmark the overhead of calling ib_post_recv() in
the full SRP protocol.  Really, I bet it's less than 100 nanoseconds to
form the work request and call ib_post_recv().  Maybe I'm wrong but I
really expect the overhead of actually doing IO (even to a ramdisk
buffer or something) is going to be much higher than posting a receive.

Or maybe you did benchmark it and I'm wrong?

 > I'm surprised by all this opposition against adding SRP_CRED_REQ
 > support in the initiator, a feature defined in the SRP standard ?

As I said I agree we should implement support for SRP_CRED_REQ.  However
I think it would be better if the SCST target could be made to work
reliably with pre-2.6.34 initiators as well.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
