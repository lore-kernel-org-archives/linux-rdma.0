From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 13 Jan 2010 12:52:29 -0700
Message-ID: <20100113195229.GD16490@obsidianresearch.com>
References: <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com> <adavdfapimb.fsf@roland-alpha.cisco.com> <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com> <ada3a2bp7ow.fsf@roland-alpha.cisco.com> <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com> <adavdf7nd7k.fsf@roland-alpha.cisco.com> <20100112232421.GA16490@obsidianresearch.com> <e2e108261001122323p695d8a9cscd992eda25fdba89@mail.gmail.com> <20100113181615.GC16490@obsidianresearch.com> <e2e108261001131057g339fc80fn638109f2d441f13a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2e108261001131057g339fc80fn638109f2d441f13a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 13, 2010 at 07:57:26PM +0100, Bart Van Assche wrote:
> On Wed, Jan 13, 2010 at 7:16 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >
> > On Wed, Jan 13, 2010 at 08:23:27AM +0100, Bart Van Assche wrote:
> > > On Wed, Jan 13, 2010 at 12:24 AM, Jason Gunthorpe
> > > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > > > [ ... ]
> > > >
> > > > Also, I couldn't tell for sure from a cursory examination of the
> > > > patch, but the initiator must be designed to not stall processing the
> > > > RQ dependent on the SQ or the credit level, when using a credit scheme
> > > > like this. Or you will deadlock.
> > > >
> > > > For instance it isn't clear to me how the control flow around
> > > > srp_process_cred_req is ment to work - it tries to send a reply, but
> > > > if it can't due to srp_get_txp_iu failing it just gives up forever?
> > >
> > > For a standards-conforming SRP target, srp_get_txp_iu() will never
> > > fail. A quote from section 5.5.2 of the SRP r16a document:
> >
> > What guarantees that that the send completion for the reply is
> > processed before a receive completion for the next request?
> 
> Did you notice that I increased the number of receive slots reserved
> for target-initiated requests from one to two ?

Yes, but I don't see how more receive slots helps exhausting send
slots.

The IBA doesn't guarentee ordering between completions originating
from different work queues. Getting a receive completion does not
guarantee that a related send completion has been received. Even if
the work queues are mapped to the same CQ.

Since srp_get_txp_iu depends on txp_head/tail which is incremented by
send completions, but srp_get_txp_iu is called on the receive
completion path, it is possible to call srp_get_txp_iu multiple times
before the send completions are generated - even though the target is
only generating new request sends in response to reply receives.

The two main causes are ack coalescing algorithms and lost ack
packets.

That said, with SRP_TXP_SIZE set to 2, I think it would be really hard
to break this in real life, with current hardware.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
