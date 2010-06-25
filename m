From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Fri, 25 Jun 2010 18:46:54 +0200
Message-ID: <OFE69DF7DF.E7AB1B1F-ONC125774D.0035CCED-C125774D.005C2F46@ch.ibm.com>
References: <ada6319ttnj.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada6319ttnj.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner@vger.kernel.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>  > > On the other hand trying to hook offloaded iWARP into the normal
stack
>  > > does seem to lead to a mess.  I see DaveM's point: TCP port space is
>  > > just the beginning -- filtering, queueing, etc also have config that
>  > > ultimately an offload device would want to hook too.
>
>  > TCP port space is just the beginning but then these features
>  > didn't show up all at once in the kernel either.  Instead of
>  > evolving iWARP implementation, we can't even take a baby step
>  > and fix a flaw that exists in the current kernel.  Why are we
>  > "replicating" everything offered by the host stack instead of
>  > hooking in?  It does not sound like good engineering to me.
>
> Well as I said I don't particularly see a clean solution.  But the point
> I was making was that the net stack is already very complex with many
> places where interface configs are controlled -- having to add hooks to
> pass that config on to offload devices is going to add even more
> complexity and also add constraints to the format of that config
> information.  Which is not good.
>
To my understanding, our discussion touches two topics. One is
to solve the TCP port space issue, the other is more general, its about
proper integration of offloaded TCP within Linux. So, the second
topic is a generalization of the first.

Regarding the first topic, what I was about to propose is that the
iWARP kernel driver (software iWARP or RNIC) itself should take care of
port space allocations. Port space maintenance functionality should
be minimized at iWARP CM level. It looks straightforward to me if
during the rdma_connect() call the driver picks a free port using
a socket/bind sequence for its local interface. The same would be possible
for
the passive connection setup, which always involves an rdma_bind_addr()
- we would have to pass the rdma_bind_addr() call down to the driver
and EADDRINUSE would be a reasonable return value.
Here things are getting a little more complicated, if it comes to
INADDR_ANY and port 0 bindings. In private email, Bob Sharp already
suggested it -  the iWARP CM would have to pick a port and
try it on all interfaces....maybe by starting with port 0 binding
on one interface and trying to extend with the returned port on
all remaining interfaces. That introduces an unbind() call if things
fail, too. In any case, the rdma_bind_addr() call would create additional
state
at driver level.

For softiwarp, during bind() or connect(), a TCP socket would be created
and bound, for an RNIC driver (currently) the same would happen. While with
softiwarp this socket would be used for communication later, the RNIC
driver
would simply have to keep it around until the connection endpoint gets
destroyed
or the port gets unbound.

Introducing a new kernel interface to bind a port w/o having to allocate
a socket i would put on the wishlist for netdev.



The more general issue - the proper integration of offloaded TCP with all
the available tools for filtering, queueing ... of the kernel TCP stack, is
the harder nut to crack and we should start discussing it.

I propose to avoid any special treatment of RNIC devices at link or
IP level, but, at least for now, make it visible per
connection (only!) if a TCP connection is offloaded. A simple socket flag
(visible via netstat etc.) could serve that purpose. Architecturally,
network interfaces introduced by RNIC hardware should be able to serve
normal
L2 connectivity (used by any in-kernel connection endpoint) and
offloaded iWARP connections at the same time, while sharing TCP port
space with the kernel. The major argument for iWarp is link unification,
and it should be extensible to flexible RDMA enablement at application
level. And, single homed hosts with an RNIC should have plain
TCP connectivity...
For now and maybe forever, an offloaded connection would not fulfill the
conditions to serve all the good additional features of an in-kernel
connection. It would be up to the user to explicitly decide if he
likes to have offloaded connections anyway.
Some of the features might get supported by additional private
communication
between driver and offloaded connection - but i would restrict that to
supporting functionality which does not impose any further
changes to the kernel network stack (statistics etc. if possible).
All other features would be known to be unavailable.
Of course, a softiwarp connection would be visible as a normal
in-kernel TCP connection.

Maybe, that solution is to simple-minded and I miss some serious
roadblocks. Please let me know. In any case, let's start discussing these
things to come up with a reasonable solution to be further
disussed with the responsible people.



Many thanks,
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
