From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 13 Jan 2010 10:32:57 +0100
Message-ID: <e2e108261001130132x1688d993kefeb9e37bcccfbf0@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	 <adak4vuqrcw.fsf@roland-alpha.cisco.com>
	 <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	 <adavdfapimb.fsf@roland-alpha.cisco.com>
	 <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
	 <ada3a2bp7ow.fsf@roland-alpha.cisco.com>
	 <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com>
	 <adavdf7nd7k.fsf@roland-alpha.cisco.com>
	 <20100112232421.GA16490@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112232421.GA16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 13, 2010 at 12:24 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I'd actually think that the decline caused by exhausting credit on
> the initiator side is far worse than ib_post_recv.. If ib_post_recv
> really is noticable then maybe just force loading the RQ after XX
> unposted are outstanding.

The performance penalty of exhausting credit on the initiator side is
indeed far worse than that of a single ib_post_recv() call at the
target side. But in a realistic setup such credit exhaustion happens
at a rate of about once an hour, while ib_post_recv() is called once
for every request. It is easy to set up an SRP I/O test where
ib_post_recv() is called more than 250.000 times per second.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
