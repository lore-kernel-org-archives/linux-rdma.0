From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Wed, 20 Jul 2011 17:34:51 -0600
Message-ID: <20110720233451.GL18090@obsidianresearch.com>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110720161655.1ed38052.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2011 at 04:16:55PM -0700, Ira Weiny wrote:
> 
> The old algorithm would attempt to extend a DR path through the CA and fail.
> The new algorithm retracts the path properly.
> 
> This does not work when combined routing is used with the CA as a starting
> point.  :-(

The ibtool version of this switches the starting LID with the
connected switch in this case.. Having that general functionality
means you can easially write a traceroute routine with this common
code.

Note, doing tricks like this with the DR path screws up the
localPortNum value, so if you ever read Port/NodeInfo using a path
that has been manipulated like this it needs a fixup step.

Also, there is a bug, you can't DLID route to the local HCA and then
use that as a source of a DR path, even though intuitively that should
work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
