From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Mon, 23 Nov 2009 11:09:15 -0800
Message-ID: <adak4xh3vok.fsf@roland-alpha.cisco.com>
References: <4B06C0EA.2070501@systemfabricworks.com>
	<e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com>
	<E102E8F5252B43318544B660CF6B78F7@amr.corp.intel.com>
	<e2e108260911210317t323adfe0k4aa3e821d3a1c63c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911210317t323adfe0k4aa3e821d3a1c63c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sat, 21 Nov 2009 12:17:32 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > Thanks for the feedback. I have two further questions:
 > - Where can IB driver developers find detailed specifications of the
 > verbs API they should implement ? I learned about the details of the
 > behavior of the ib_post_send() call by reading the mlx4 source code.
 > Shouldn't this behavior be documented in include/rdma/ib_verbs.h
 > instead ?

As usual things are designed by an ad hoc mixture of the various specs
mixed with experience from real implementations, with some details
ending up as folklore only documented in mailing list threads.  Of
course it would be good to improve the documentation, but at the moment
many details did not end up getting explicitly written.

 > - Does walking twice over the WR list always result in inferior
 > performance compared to walking once over this list ? Both the iSER
 > protocol and the SRP protocol allow to send large sg lists (e.g.
 > containing 128 elements) at once over the wire. When using
 > asynchronous (buffered) I/O, this maximum is often reached. One
 > interesting performance optimization is to send all 128 sg elements at
 > once using one ib_post_send() call and to request a completion
 > notification for the last WR only. But if the ib_post_send() call
 > returns an immediate error and has sent part of the WR list, no
 > completion notification will be received. So code that calls
 > ib_post_send() has to request a completion notification for each WR,
 > which has a negative performance impact. My opinion is that the
 > current behavior makes ib_post_send() easier to implement, while the
 > behavior specified in the IBAS is more interesting for applications
 > that use the verbs API.

I think that yes, walking a list of work requests twice, once to look
for immediate errors and once to actually post them is probably going to
perform somewhat worse.  Also, all of the immediate errors that can be
returned are really things that the consumer can avoid -- too many SG
entries, invalid opcode, WQ overflow.  So error handling in the consumer
for this can probably become BUG() or the equivalent.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
