From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Mellanox CX5 Not Showing Up In ibv_devices (on some systems)
Date: Thu, 26 Oct 2017 10:59:40 -0600
Message-ID: <20171026165940.GC5829@obsidianresearch.com>
References: <DE927C68B458BE418D582EC97927A9287FD16661@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FD16661-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 26, 2017 at 04:49:29PM +0000, Gruher, Joseph R wrote:

> Hi, I'm having trouble with ibv_devices (and related tools like
> ibv_devinfo, ib_send_bw, etc) not recognizing my Mellanox CX5 NICs
> in some systems.  The NICs work fine for TCP/IP traffic, and I think
> for RDMA traffic as well as I can do NVMeoF discovery and make
> NVMeoF connections, but they're just not listed in ibv_devices.
 
> intel@BigTwin-A:~$ sudo ibv_devices
> libibverbs: Warning: no userspace device-specific driver found for
> /sys/class/infiniband_verbs/uverbs0

Well, that is pretty big clue, you haven't installed the user space
support library.

Depending on what os you are using it is either in the libmlx5 or
ibverbs-providers packages,

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
