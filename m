From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:42:44 -0600
Message-ID: <20150720224244.GB12278@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com>
 <20150720210544.GA9655@obsidianresearch.com>
 <015101d0c331$69e31d10$3da95730$@opengridcomputing.com>
 <55AD7065.8040809@talpey.com>
 <015701d0c33d$36b53110$a41f9330$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <015701d0c33d$36b53110$a41f9330$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 05:41:27PM -0500, Steve Wise wrote:
> > B) why bother to check? Are machines with <4GB interesting, and worth
> > supporting a special optimization?
> 
> No, but cxgb3 is still interesting to user applications, and perhaps NFSRDMA using FRMRs.

Doesn't look like the NFS client will work. It requires an all
physical memory lkey for SEND and RECV buffers..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
