From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V6 9/9] isert: Support iWARP transports using FRMRs
Date: Fri, 24 Jul 2015 13:24:11 -0600
Message-ID: <20150724192411.GC26225@obsidianresearch.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161904.25617.85015.stgit@build2.ogc.int>
 <20150724165721.GC25480@obsidianresearch.com>
 <00ce01d0c641$493ea300$dbbbe900$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00ce01d0c641$493ea300$dbbbe900$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 24, 2015 at 01:48:09PM -0500, Steve Wise wrote:
> > The use of FRWR for RDMA READ should be iWarp specific, IB shouldn't
> > pay that overhead. I am expecting to see a cap_rdma_read_rkey or
> > something in here ?
> 
> Ok.  But cap_rdma_read_rkey() doesn't really describe the
> requirement.  The requirement is rkey + REMOTE_WRITE.  So it is more
> like rdma_cap_read_requires_remote_write() which is ugly and too
> long (but descriptive)...

I don't care much what name you pick, just jam something like this in
the description

 If set then RDMA_READ must be performed by mapping the local
 buffers through a rkey MR with ACCESS_REMOTE_WRITE enabled.
 The rkey of this MR should be passed in as the sg_lists's lkey for
 IB_WR_RDMA_READ_WITH_INV.

 FRWR should be used to register the buffer in the send queue,
 and the read should be issued using IB_WR_RDMA_READ_WITH_INV (xx
 can we just implicitly rely on this? Are there any iWarp cards that
 support FRWR but not WITH_INV?)

 Finally, only a single SGE can be used with RDMA_READ, all scattering
 must be accomplished with the MR.

This quite dramatically changes what is an allowed scatter for the
transfer, IB can support arbitary unaligned S/G lists, while this is
now forced into gapless page aligned elements.

Your patch takes care of this? And only impacts IB?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
