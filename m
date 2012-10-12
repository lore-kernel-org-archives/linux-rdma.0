From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: if/how to dictate IB device name per PCI BDF
Date: Fri, 12 Oct 2012 16:43:32 -0600
Message-ID: <20121012224332.GB25541@obsidianresearch.com>
References: <5076A755.30605@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5076A755.30605-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 11, 2012 at 01:02:45PM +0200, Or Gerlitz wrote:

> Thinking about this a bit, will it be possible to provide a udev
> rulethat can dictate to the IB core what name / suffix digit to
> assign for a device with certain BDF?

FWIW, I reflected on this once (I belive it was for the netlink
discussion).. Allowing for a device to be renamed creates a serious
problem for RDMA since there isn't a stable 'if-index' like way for
software to refer to it.

The udev rules all rely on a means to rename the device once the
kernel has created it.

For this reason, all the software I've built uses the port GID to ID
the resource for bind/etc and strongly discourages use of the RDMA
device name.

The ipoib devices should already be renamable via udev rules, though
has anyone checked that udev doesn't have a problem with the long 'MAC'?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
