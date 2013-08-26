From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Handling incoming RDMA CM connections when there is more than
 one IB HCA in a system
Date: Mon, 26 Aug 2013 11:48:44 -0600
Message-ID: <20130826174844.GD12296@obsidianresearch.com>
References: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 25, 2013 at 04:41:59AM -0700, Richard Sharpe wrote:
> Hi folks,
> 
> I am attempting to implement SMB Direct (aka SMB over RDMA) for Samba.
> 
> For historical, protocol and performance reasons I believe that I need
> to write a character driver that offloads RDMA stuff to the kernel.
> 
> Briefly, these reasons are:
> 
> 1. Samba forks a new smbd when each incoming SMB connection arrives
> 
> 2. SMB Over RDMA operates by first connecting to the server over TCP,
> bringing up SMB, determining that the server supports RDMA and then
> establishing an RDMA connection, bringing up SMB Direct and then
> transporting SMB PDUs over that.
> 
> 3. The current Windows client implementation pays no attention to the
> port supplied to it by the server and always connects on port 4554.

So your issue is that when the transport is upgraded SMB performs a
whole new connection setup to the common port and the server is
expected to associate the new connection to the old based on a GUID in
the first messages?

How about this for a flow?
 - The master process listens on all relavent TCP and RDMA ports for
   incoming connections
 - At each incomming connection it forks and constructs a sub process
   for that connection. I think we can do this today with RDMA, but if
   not it should be doable with less effort than making your own
   kernel driver :) Sean might know for sure..
 - The new smbd is now either a from scratch new connection (normal
   case today) or an 'upgrade' to an prior connection
 - If it is an upgrade, use some scheme to transfer the samba internal
   state from the old connection smbd to the new connection smbd

That keeps your per-process model..

> However, I figure that I will eventually need to support situations
> where there are multiple IB HCAs in a system, and I wondered if
> there are any abstractions that allow me to do an ib_cm_listen
> across multiple devices at once?

Not really, you need to listen on every device.

And you almost certainly need to use the RDMA CM interfaces (as Or
mentioned), that will be mandatory to support iWarp, and it looks like
MS is using the RDMA-CM protocol on IB as well.

> 3. When I get a callback on one listen, cancel the others.

Why? Wouldn't you listen for RDMA connections permanently, like for
the TCP listen?

>From what I read about the SMB protocol it looks completely valid to
bypass the TCP first stage and go directly to RDMA. Or go from TCP to
TCP, or RDMA to TCP, or whatever.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
