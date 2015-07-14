From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 15:51:29 -0500
Message-ID: <010c01d0be76$dbb4c520$931e4f60$@opengridcomputing.com>
References: <20150709000337.GE16812@obsidianresearch.com> <559EF332.7060103@redhat.com> <20150709225306.GA30741@obsidianresearch.com> <559FC710.1050307@talpey.com> <20150710161108.GA19042@obsidianresearch.com> <CCB6E837-88FF-4DBB-976D-4CF56396A1A1@ogc.us> <55A24571.60902@dev.mellanox.co.il> <00e201d0be6a$e49bc910$add35b30$@opengridcomputing.com> <20150714194512.GA25887@infradead.org> <00f901d0be6f$70c96b00$525c4100$@opengridcomputing.com> <20150714204145.GC26927@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714204145.GC26927-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Steve Wise' <swise-/Yg/VP3ZvrM@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Tuesday, July 14, 2015 3:42 PM
> To: Steve Wise
> Cc: 'Christoph Hellwig'; 'Sagi Grimberg'; 'Steve Wise'; 'Tom Talpey'; 'Doug Ledford'; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org;
> roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org; 'Oren Duer'
> Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
> 
> On Tue, Jul 14, 2015 at 02:58:23PM -0500, Steve Wise wrote:
> > The local_dma_lkey can be used in any rdma sge that requires an
> > lkey.
> 
> No, this is where iWarp doesn't follow the generic API - a local dma
> lkey cannot be used with iWarp's RDMA_READ WR lkey. In effect RDMA
> READ requires an *rkey* (confusingly stuck into the lkey slot) for
> iWarp. (Right?)
>

Right, a local_dma_lkey is not an rkey, and iwarp requires the rkey for the read destination MR.  Further that rkey needs
REMOTE_WRITE.

 
> *THAT* is really the core difference between IB and iWarp in this
> area, not that the access flags are different.
>

It both.  Because an rkey without REMOTE_WRITE would not work.
 
> (cap_rmda_read_lkey_is_rkey ?)
> 

IMO its more like rdma_cap_read_dest_needs_remote_write().  And maybe make it camel step too. ;)

> > domain.  But I claim for lkeys, the PD doesn't really protect
> > anything since the remote peers can't use it anyway.
> 
> I agree.
> 
> To use a PD properly I'd have thought it should be created on a client
> by client basis. The risk is tiny, but client X should not be able to
> guess Y's RKey and then corrupt a data transfer. *Especially* on a
> server if client X hasn't auth'd yet .... That is what the PD is for.
> 
> > There is confusion about lkeys and rkeys with regard to iWARP.  In
> > the iWARP verbs, there is no distinction between an lkey and rkey:
> > they are the same key, called a Steering Tag or STAG.  When you
> > create a MR, the lkey == rkey == STAG for iwarp transports.
> > Somewhat related, but really a different issue, is that SGEs that
> > are the target of a read need REMOTE_WRITE access flags on their
> > STAG for iWARP.
> 
> That is the clearest explanation for the iWarp difference I've seen so
> far, thanks!
> 
> Christoph: The take away from all this is that on iWarp RDMA_READ
> requires a restricted temporary MR to provide the lkey value in the
> WC. It cannot use local_dma_lkey.
>
> Everything else is the same between IB and iWarp: local_dma_lkey can
> be used as the lkey for SEND, RECV, WRITE.
>

The source of a WRITE can use local_dma_lkey, not the destination.   But this is true for IB and IW...



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
