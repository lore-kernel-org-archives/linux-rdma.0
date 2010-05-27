From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] IB/util madeye.c
Date: Thu, 27 May 2010 15:25:27 -0600
Message-ID: <20100527212527.GC15969@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5D7@MNEXMB1.qlogic.org> <CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E369@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E369-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 27, 2010 at 09:31:46AM -0700, Hefty, Sean wrote:

> > Madeye is a debugging/monitoring tool for infiniband fabrics. When
> > loaded, by default it will log copies of all MAD traffic to the
> > system log. In addition, it can be configured to log only those
> > MADs which have a particular class or a particular attribute id.
 
> While I've found madeye to be very useful myself, it seems
> preferable for umad to support MAD snooping, so that a user space
> application could implement more complex filtering, monitoring, and
> reporting mechanisms.  Madeye could then be ported to user space.

I've been working on the rxe patchset and have added a
ETH_P_INFINIBAND to the net stack, ostensibly to carry packets with
LRHs through the netdevice layers for rxe..

But IHMO, the sanest way to do this is to route full MAD packets w/
LRH's etc through the net stack so they can be hooked via standard
tcpdump esque mechanisms. That stuff works, alot of time has been
spent making it work well..

AFAIK the main trouble with doing this is that the IB devices would
need to become netdevices instead of their current seperate
thingy.. I'm not sure that is a big hurdle though??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
