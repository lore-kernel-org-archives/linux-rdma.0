From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 2 Dec 2009 10:33:14 -0700
Message-ID: <20091202173314.GP1966@obsidianresearch.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com> <20091201174604.GO1966@obsidianresearch.com> <2ED289D4E09FBD4D92D911E869B97FDD01D647E2@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01D647E2-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 02, 2009 at 12:38:31PM +0200, Liran Liss wrote:
> 
> > So? There are substantial semantic differences for *all* non-rdmacm
> > applications. Even common ones like OpenMPI. You propose to ignore them?
> 
> On the contrary! Any application that *does* care what the link layer is
> can look up a new field in port_attr (rather than a new node transport
> type).
> Applications that don't, both old and new, can continue as normal - no
> changes to the code are required.

Existing apps rely on transport_type == IBV_TRANSPORT_IB to indicate IB
management is present. There are many examples of this.

The art of API compatability is to not break existing old apps, so you
don't get to change the meaning of transport_type == IBV_TRANSPORT_IB
to mean 'it is only IB verbs like'. That breaks the API.

Adding a new field to port_attr preserves functionality but not
compatability. I hope you understand the difference.

> So, all relevant apps will work great with either IB or RDMAoE, in a
> transparent manner.

No, they won't. They will see transport_type == IBV_TRANSPORT_IB and
attempt to do PR queries to the SM. That won't work on RDMAoE.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
