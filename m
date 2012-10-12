From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: if/how to dictate IB device name per PCI BDF
Date: Fri, 12 Oct 2012 16:04:18 -0700
Message-ID: <20121012160418.385ace32ddde5379381d5889@llnl.gov>
References: <5076A755.30605@mellanox.com>
	<20121012224332.GB25541@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121012224332.GB25541-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 12 Oct 2012 16:43:32 -0600
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Oct 11, 2012 at 01:02:45PM +0200, Or Gerlitz wrote:
> 
> > Thinking about this a bit, will it be possible to provide a udev
> > rulethat can dictate to the IB core what name / suffix digit to
> > assign for a device with certain BDF?
> 
> FWIW, I reflected on this once (I belive it was for the netlink
> discussion).. Allowing for a device to be renamed creates a serious
> problem for RDMA since there isn't a stable 'if-index' like way for
> software to refer to it.
> 
> The udev rules all rely on a means to rename the device once the
> kernel has created it.
> 
> For this reason, all the software I've built uses the port GID to ID
> the resource for bind/etc and strongly discourages use of the RDMA
> device name.

IMHO, from a user perspective using GID's or GUIDs is just too hard.  While the port GID is unique across reboots in practice with 1000's of nodes in a cluster names are much more useful and, at least here at LLNL, nobody refers to HCA's by GUID.  They refer to them by hostname/card name.  This is especially true when HCA's get swapped out for maintenance.

Furthermore, how would you propose MPI selects a card when the job is launched on different nodes, chosen by a scheduler, from run to run?

Unfortunately, I don't know the details of the "serious problem" you describe above but it seems that a udev solution to renaming things would be worth trying to solve from a users perspective.

Ira

> 
> The ipoib devices should already be renamable via udev rules, though
> has anyone checked that udev doesn't have a problem with the long 'MAC'?
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
