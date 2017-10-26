From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Mellanox CX5 Not Showing Up In ibv_devices (on some systems)
Date: Thu, 26 Oct 2017 12:49:04 -0600
Message-ID: <20171026184904.GA6905@obsidianresearch.com>
References: <DE927C68B458BE418D582EC97927A9287FD16661@ORSMSX113.amr.corp.intel.com>
 <20171026165940.GC5829@obsidianresearch.com>
 <DE927C68B458BE418D582EC97927A9287FD167C8@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FD167C8-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 26, 2017 at 05:32:28PM +0000, Gruher, Joseph R wrote:

> I hear what you're saying, but as far as I can tell the relevant
> packages are installed, and the same packages on both systems?  See
> below.  Am I missing one I should have?

Ah, in that case it is because your libmlx5 is too old to support the
new card you have:

18:00.0 Ethernet controller: Mellanox Technologies MT28800 Family [ConnectX-5]
vs
81:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]

You can upgrade it by building rdma-core from source.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
