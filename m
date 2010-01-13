From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 13 Jan 2010 08:58:01 -0800
Message-ID: <adaeilundra.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<ada4omyud7c.fsf@roland-alpha.cisco.com>
	<e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	<adak4vuqrcw.fsf@roland-alpha.cisco.com>
	<e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	<adavdfapimb.fsf@roland-alpha.cisco.com>
	<e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
	<ada3a2bp7ow.fsf@roland-alpha.cisco.com>
	<e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com>
	<adavdf7nd7k.fsf@roland-alpha.cisco.com>
	<e2e108261001122329u698f13ecibf42c1dc60b5cc04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001122329u698f13ecibf42c1dc60b5cc04-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Wed, 13 Jan 2010 08:29:57 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > The impact of the ib_post_recv() call is small but measurable. I'll
 > publish measurement results soon.

Interesting.  If there is overhead you could amortize it by keeping some
number of spare buffers posting, and batching your calls to
ib_post_recv() (eg post a list of 8 buffers every 8 commands, and keep 7
spare buffers posted).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
