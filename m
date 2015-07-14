From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 14:41:45 -0600
Message-ID: <20150714204145.GC26927@obsidianresearch.com>
References: <20150709000337.GE16812@obsidianresearch.com>
 <559EF332.7060103@redhat.com>
 <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
 <20150710161108.GA19042@obsidianresearch.com>
 <CCB6E837-88FF-4DBB-976D-4CF56396A1A1@ogc.us>
 <55A24571.60902@dev.mellanox.co.il>
 <00e201d0be6a$e49bc910$add35b30$@opengridcomputing.com>
 <20150714194512.GA25887@infradead.org>
 <00f901d0be6f$70c96b00$525c4100$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00f901d0be6f$70c96b00$525c4100$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Steve Wise' <swise-/Yg/VP3ZvrM@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 02:58:23PM -0500, Steve Wise wrote:
> The local_dma_lkey can be used in any rdma sge that requires an
> lkey.

No, this is where iWarp doesn't follow the generic API - a local dma
lkey cannot be used with iWarp's RDMA_READ WR lkey. In effect RDMA
READ requires an *rkey* (confusingly stuck into the lkey slot) for
iWarp. (Right?)

*THAT* is really the core difference between IB and iWarp in this
area, not that the access flags are different.

(cap_rmda_read_lkey_is_rkey ?)

> domain.  But I claim for lkeys, the PD doesn't really protect
> anything since the remote peers can't use it anyway.

I agree.

To use a PD properly I'd have thought it should be created on a client
by client basis. The risk is tiny, but client X should not be able to
guess Y's RKey and then corrupt a data transfer. *Especially* on a
server if client X hasn't auth'd yet .... That is what the PD is for.

> There is confusion about lkeys and rkeys with regard to iWARP.  In
> the iWARP verbs, there is no distinction between an lkey and rkey:
> they are the same key, called a Steering Tag or STAG.  When you
> create a MR, the lkey == rkey == STAG for iwarp transports.
> Somewhat related, but really a different issue, is that SGEs that
> are the target of a read need REMOTE_WRITE access flags on their
> STAG for iWARP.

That is the clearest explanation for the iWarp difference I've seen so
far, thanks!

Christoph: The take away from all this is that on iWarp RDMA_READ
requires a restricted temporary MR to provide the lkey value in the
WC. It cannot use local_dma_lkey.

Everything else is the same between IB and iWarp: local_dma_lkey can
be used as the lkey for SEND, RECV, WRITE.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
