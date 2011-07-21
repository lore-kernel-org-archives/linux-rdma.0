From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Wed, 20 Jul 2011 21:17:13 -0600
Message-ID: <20110721031713.GA19500@obsidianresearch.com>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
 <20110720233451.GL18090@obsidianresearch.com>
 <20110720165336.894b1298.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110720165336.894b1298.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2011 at 04:53:36PM -0700, Ira Weiny wrote:

> > The ibtool version of this switches the starting LID with the
> > connected switch in this case..
> 
> Given a LID (resolved from a PR query of a GUID) for a CA port, how
> do you know the connected switch?  Via sa query?

Yes, there is also a general question when and if various tools should
use SMPs vs use the SA...

> > Note, doing tricks like this with the DR path screws up the
> > localPortNum value, so if you ever read Port/NodeInfo using a path
> > that has been manipulated like this it needs a fixup step.
> 
> Not sure I follow you.  To be clear this patch alters the path like this:
> 
> Given DR path 0,1,3,4, where 0,1,3,4 ends at a CA
> 
> "retract" the path to 0,1,3 and query that node as well as 0,1,3,4.
> Resolve the port linkage and return that "fabric" to the user.

If you issue a NodeRecord SMP to DR path 0,1,3,4 you will get
localPortNum of 1. If you then algorithmically want to construct a
DR path of 0,1,3,4,1 to reach the device connected to the CA port your
algorithm will adjust it to 0,1,3, but a NodeRecord SMP will not
return a localPortNum of 3, which would be expected from the
construction of the original path.

It depends on how your other algorithms are using this feature, but,
eg for a tracing application that wants to print each hop along the
path, messing up the localPortNum during the adjustment is bad news.

> Given a combined route DLID+path the CA is resolved and returned.
> There is, as you say below, no way to resolve (via SMP queries) the
> connected node without scanning the entire fabric and resolving the
> connection.

You trace through the LFT from the local end port to the target CA
DLID and that gives you a path to the switch.
 
> > Also, there is a bug, you can't DLID route to the local HCA and then
> > use that as a source of a DR path, even though intuitively that should
> > work.
> 
> A bug in the code?

In Linux or the HCA I think.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
