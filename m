From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 13 Jan 2010 11:16:15 -0700
Message-ID: <20100113181615.GC16490@obsidianresearch.com>
References: <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com> <adak4vuqrcw.fsf@roland-alpha.cisco.com> <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com> <adavdfapimb.fsf@roland-alpha.cisco.com> <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com> <ada3a2bp7ow.fsf@roland-alpha.cisco.com> <e2e108261001120923w4b405736v8b8e8ae41322823b@mail.gmail.com> <adavdf7nd7k.fsf@roland-alpha.cisco.com> <20100112232421.GA16490@obsidianresearch.com> <e2e108261001122323p695d8a9cscd992eda25fdba89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2e108261001122323p695d8a9cscd992eda25fdba89-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 13, 2010 at 08:23:27AM +0100, Bart Van Assche wrote:
> On Wed, Jan 13, 2010 at 12:24 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > [ ... ]
> >
> > Also, I couldn't tell for sure from a cursory examination of the
> > patch, but the initiator must be designed to not stall processing the
> > RQ dependent on the SQ or the credit level, when using a credit scheme
> > like this. Or you will deadlock.
> >
> > For instance it isn't clear to me how the control flow around
> > srp_process_cred_req is ment to work - it tries to send a reply, but
> > if it can't due to srp_get_txp_iu failing it just gives up forever?
> 
> For a standards-conforming SRP target, srp_get_txp_iu() will never
> fail. A quote from section 5.5.2 of the SRP r16a document:

What guarantees that that the send completion for the reply is
processed before a receive completion for the next request?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
