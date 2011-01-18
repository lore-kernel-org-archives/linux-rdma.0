From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IB: increase DMA max_segment_size on Mellanox hardware
Date: Mon, 17 Jan 2011 22:22:29 -0700
Message-ID: <20110118052229.GC2691@obsidianresearch.com>
References: <1295230184.2574.26.camel@obelisk.thedillows.org>
 <4D342510.80701@voltaire.com>
 <1295318783.3051.81.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1295318783.3051.81.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 17, 2011 at 09:46:23PM -0500, David Dillow wrote:

> To be sure, this is not going to be a huge efficiency gain, but it does
> reduce CPU usage and raises the largest possible IO size with the
> default srp_sg_tablesize of 12 from 768 KB to some 24 GB. Not that we'd
> likely need that large of a request or be able to allocate 12 2GB
> contiguous memory areas, of course.

AH! So this is why.. I went to some trouble to add huge page support
to some code expecting to get bigger/more consisent SRP IOs and didn't
quite get that result :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
