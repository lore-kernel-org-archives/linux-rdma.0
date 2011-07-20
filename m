From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Wed, 20 Jul 2011 16:53:36 -0700
Message-ID: <20110720165336.894b1298.weiny2@llnl.gov>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
	<20110720233451.GL18090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110720233451.GL18090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jul 2011 16:34:51 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Wed, Jul 20, 2011 at 04:16:55PM -0700, Ira Weiny wrote:
> > 
> > The old algorithm would attempt to extend a DR path through the CA and fail.
> > The new algorithm retracts the path properly.
> > 
> > This does not work when combined routing is used with the CA as a starting
> > point.  :-(
> 
> The ibtool version of this switches the starting LID with the
> connected switch in this case..

Given a LID (resolved from a PR query of a GUID) for a CA port, how do you know the connected switch?  Via sa query?

> Having that general functionality
> means you can easially write a traceroute routine with this common
> code.

Yes that would be nice.  But again requires more sa queries.

> 
> Note, doing tricks like this with the DR path screws up the
> localPortNum value, so if you ever read Port/NodeInfo using a path
> that has been manipulated like this it needs a fixup step.

Not sure I follow you.  To be clear this patch alters the path like this:

Given DR path 0,1,3,4, where 0,1,3,4 ends at a CA

"retract" the path to 0,1,3 and query that node as well as 0,1,3,4.  Resolve the port linkage and return that "fabric" to the user.

Given a combined route DLID+path the CA is resolved and returned.  There is, as you say below, no way to resolve (via SMP queries) the connected node without scanning the entire fabric and resolving the connection.

> 
> Also, there is a bug, you can't DLID route to the local HCA and then
> use that as a source of a DR path, even though intuitively that should
> work.

A bug in the code?

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
