From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Sat, 23 Oct 2010 08:33:18 -0400
Message-ID: <1287837198.2729.13.camel@obelisk.thedillows.org>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
	 <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
	 <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
	 <1287407410.10438.46.camel@lap75545.ornl.gov>
	 <AANLkTi=M9swgmnMUBdd71yCde3xXh81GweUL-F1-ROho@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=M9swgmnMUBdd71yCde3xXh81GweUL-F1-ROho-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-10-23 at 12:47 +0200, Bart Van Assche wrote:
> On Mon, Oct 18, 2010 at 3:10 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> >
> > [ ... ]
> > While looking at this, I noticed that we didn't do any syncs in
> > srp_send_tsk_mgmt(), so I've pushed this patch for now. We can remove
> > the *_sync_for_cpu() calls later if it turns out we really don't need
> > them.
> > [ ... ]
> > +       ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
> > +                                  DMA_TO_DEVICE);
> 
> Hello Dave,
> 
> Sorry for the late comment, but I just noticed that the above code
> performs a partial buffer synchronization. If I remember correctly,
> the DMA API doesn't allow this and the "size" argument must match the
> size argument passed to the corresponding ib_dma_map_single() call,
> that is, target->max_ti_iu_len ?

One only needs to sync the part of the buffer that is going to be
touched/was tocuhed; it doesn't have to match the map call like the
unmap call does.

This is pretty common in the network stack -- as is the
sync_for_cpu/sync_for_device question -- it is common in the drivers to
only sync the length of the packet in the buffer. It's a bit of a cargo
cultish argument I suppose, but we've not received a response about it
on LKML, so I continued to check the existing uses for guidance. I
really wish I could pin down my recollection of the discussion, though.
I'd like to understand the reasoning, as your comment about not needing
the sync_for_cpu makes a lot of sense intuitively.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
