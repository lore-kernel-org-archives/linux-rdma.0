From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 13:07:42 -0600
Message-ID: <20150519190742.GO18675@obsidianresearch.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431975616-23529-4-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 18, 2015 at 03:00:16PM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch routes a SA pathrecord query to netlink first and processes the
> response appropriately. If a failure is returned, the request will be sent
> through IB. The decision whether to route the request to netlink first is
> determined by the presence of a listener for the MAD netlink multicast
> group. If the user-space MAD netlink multicast group listener is not
> present, the request will be sent through IB, just like what is currently
> being done.

I have mixed feelings about using the SA message format for this.

In-kernel we don't use that format, and many of the newer APIs were
designed around passing the GMP,Forward,Return path tuple, not just a
naked GMP.

I've argued for this in the past.

I'd rather see the netlink data ask for what the kernel needs (eg UD
path to X, RC path to X) and return the new format we've already
established for AF_IB

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
