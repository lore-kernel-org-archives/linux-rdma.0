From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 13:50:01 -0500
Message-ID: <005201d0bf2f$0e5e3ed0$2b1abc70$@opengridcomputing.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <20150715183129.GC23588@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715183129.GC23588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Wednesday, July 15, 2015 1:31 PM
> To: Sagi Grimberg
> Cc: Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Steve Wise; Or Gerlitz; Oren Duer; Chuck Lever; Bart Van Assche; Liran Liss;
Hefty,
> Sean; Doug Ledford; Tom Talpey
> Subject: Re: Kernel fast memory registration API proposal [RFC]
> 
> On Wed, Jul 15, 2015 at 11:01:46AM +0300, Sagi Grimberg wrote:
> > On 7/14/2015 8:09 PM, Jason Gunthorpe wrote:
> > >On Tue, Jul 14, 2015 at 07:55:39PM +0300, Sagi Grimberg wrote:
> > >
> > >>But, if people think that it's better to have an API that does implicit
> > >>posting always without notification, and then silently consume error or
> > >>flush completions. I can try and look at it as well.
> > >
> > >Can we do FMR transparently if we bundle the post? If yes, I'd call
> > >that a winner..
> >
> > Doing FMR transparently is not possible as the unmap flow is scheduling.
> > Unlike NFS, iSER unmaps from a soft-IRQ context, SRP unmaps from
> > hard-IRQ context. Changing the context to thread context is not
> > acceptable. The best we can do is using FMR_POOLs transparently.
> > Other than polluting the API and its semantics I suspect people will
> > have other problems with it (leaving the MRs open).
> 
> Upon deeper thought, I think I see a fairly simple solution here.
> 
> 1) Really, we probably never need a FMR for the lkey side, we should
>    just use multiple READ/WRITE ops to get a long enough SG list.
>    Even if this is not performant on mhca/ehca.
> 
>    If we absolutely need FMR for SEND/RECV lkey (do we? Anyone know?),
>    then I have some good thoughts on how to make that work transparent..
> 
>    However, rather than do all that, I'd probably choose to just
>    bounce buffer the few rare SEND/RECVs that need a MR. I'm guessing
>    the usage is 0 or near zero??
> 
> 2) The FMR completion flow for rkey is actually the same as the FRWR flow:
>     - Catch the SEND that says the READ/WRITE is done
>     - Issue an async invalidate
>     - Catch the invalidate completion
> 
> So, my simple proposal is to have the core wrapper mthca/ehca's
> poll_cq wrapper. The flow works like this:
> 
>   - ULP calls a 'rdma_post_close_rkey' helper
>      * For FRWR this posts the INVALIDATE

Note: Some send operations automatically invalidate an rkey (and the lkey for IB?).  This is intended to avoid having to post the
invalidate WR explicitly.  Namely IB_WR_READ_WITH_INV and IB_WR_SEND_WITH_INV.

>      * For FMR this triggers a work queue that issues the invalidate
>        async
>   - ULP calls poll_cq
>      * For FRWR no change, the driver is called directly
>      * For FMR, the poll_cq wrapper looks at a 2nd queue
>        filled in by the async work queue above. If it has entries they
>        are copied out as IB_WC_LOCAL_INV before calling the driver's
>        poll_cq.
> 
> This works best under the API I was talking about before, using
> posting helpers to form the right SQEs for the hardware being used.
> 
> I'm not exactly clear on the recycling rules for either FRWR or FMR -
> are they use-once-then-destroy, or can they be reused?
> 

For FRWRs, the MR can be reused with the same key values, or the bottom 8b of the keys can be modified before re-registering using
ib_update_fast_reg_key().  This allows applications to detect when using stale keys. 

> Basically.. I think something along your idea is a good first step, it
> unifies the driver API for the posting MR schemes.
> 
> The next step would be the posting helpers I've been talking about
> that do all the complicated logic for the ULPs. Those helpers would be
> able to hide the OP segmentation and FMR rkey using the above
> schemes.
> 
> This sounds very workable? Christoph?
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
