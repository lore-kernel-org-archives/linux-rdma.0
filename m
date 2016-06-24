From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Interrupted IO causing async errors
Date: Fri, 24 Jun 2016 13:26:37 -0600
Message-ID: <20160624192637.GE14506@obsidianresearch.com>
References: <00e101d1cd65$e19bf360$a4d3da20$@opengridcomputing.com>
 <BDD2D64C-7A05-42EB-83C2-F95825C7579D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BDD2D64C-7A05-42EB-83C2-F95825C7579D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 08:15:29PM -0400, Chuck Lever wrote:
> When an application is signaled, outstanding RPCs are terminated.
> When an RPC completes, whether because a reply was received,
> or because the local application has died, any memory that was
> registered on behalf of that RPC is invalidated before it can be
> used for something else. The data in that memory remains at rest
> until invalidation and DMA unmapping is complete.

> It appears that your server is attempting to read an argument or
> write a result for an RPC that is no longer pending. I think both
> sides should report a transport error, and the connection should
> terminate. No other problems, though: other operation should
> continue normally after the client re-establishes a fresh connection.

Yuk! A transport tare down and restart on user space CTRL-C/etc ?
Isn't that a little too common and a little too expensive to be a
permanent solution?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
