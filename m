From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Thu, 07 Jan 2010 11:26:32 -0500
Message-ID: <1262881592.29991.17.camel@obelisk.thedillows.org>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <1262568846.13289.4.camel@obelisk.thedillows.org>
	 <e2e108261001032313v472d4b9dm75c3d0b1a9268adc@mail.gmail.com>
	 <adavdfesyi4.fsf@roland-alpha.cisco.com>
	 <e2e108261001062359l66384219r650294b4d6e9f3f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001062359l66384219r650294b4d6e9f3f1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-01-07 at 08:59 +0100, Bart Van Assche wrote:
> On Wed, Jan 6, 2010 at 10:40 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> >
> >  > Is that regular kernel coding practice, to run away with the work
> >  > someone else did and to claim authorship ? As far as I know this is
> >  > considered as impolite.
> >
> > I don't see "with proper credit for Bart" as claiming authorship.  And
> > yes, I think proposing a better way of doing things is definitely
> > regular kernel coding practice.  It's more than polite -- it's going way
> > beyond helpful review comments and actually helping revise the patches.
> 
> You are welcome to have a look at the descriptions of the three
> patches posted by David Dillow. I was not credited in any way in these
> descriptions. Not for analyzing the problem, not for the design of a
> solution and not for the work I did in implementing a solution. That
> is why I wrote that David Dillow was claiming authorship of the work I
> did.

And here I thought I covered it by stating in the cover letter that they
were not signed off, needed credit for you, and shouldn't go upstream
until you ACK'd them, presumably with that fixed. I thought people would
put two and two together, but I suppose not. I'll try to be more
explicit next time.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
