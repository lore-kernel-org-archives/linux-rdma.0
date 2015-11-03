From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Mon, 2 Nov 2015 17:18:45 -0700
Message-ID: <20151103001845.GA24206@obsidianresearch.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com>
 <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <5637F97C.5090205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5637F97C.5090205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 07:02:04PM -0500, Doug Ledford wrote:

> Because they are *scheduled* for removal.  If I simply didn't care if
> they went away, then I wouldn't screw around with deprecating them or
> tagging them to be removed, I'd just delete them.  Breaking them before
> the scheduled removal time defeats that entire purpose.

You don't see in the compiles, but IIRC ipath is unusable after the
PAT rework.

We've also been ripping out the ULP side of things that would let
amso1100/ehca work in any meningful way with the kernel ULPs.

The reason I lobbied to get rid of them is specifically because they
don't work and maintaining them (ie the driver and the single-use ULP
codepath side) is a huge pain. Keeping them around and keeping them
compiling defeats the entire point. Just delete them, we don't need to
wait for 4.6.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
