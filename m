From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v8 2/4] IB/core: Add rdma netlink helper functions
Date: Tue, 4 Aug 2015 18:52:23 -0600
Message-ID: <20150805005223.GA28789@obsidianresearch.com>
References: <1436463268-32365-1-git-send-email-kaike.wan@intel.com>
 <1436463268-32365-3-git-send-email-kaike.wan@intel.com>
 <20150804031534.GA28707@obsidianresearch.com>
 <20150805004830.GA23589@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150805004830.GA23589-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 08:48:31PM -0400, ira.weiny wrote:
> We are using Netlink multicast.  I believe that netlink_bind only allows root
> to bind to multicast.

That is a good start...

> That said I have not tested the ability to change the timeout settings if one
> were to bind without multicast and send a message.

I rather expect that needs fixing..

And I bet sequence numbers are sufficiently predictable that the path
reply should be restricted to root as well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
