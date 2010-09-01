From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ibnetdiscover issue with multiported CA (or router) with
 multiple ports on same subnet
Date: Wed, 1 Sep 2010 16:43:44 +0300
Message-ID: <20100901134344.GC12172@me>
References: <AANLkTi=54yw-YcpXNvWmsCFybZhTZX6Hp6=KW6Gz9KLH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=54yw-YcpXNvWmsCFybZhTZX6Hp6=KW6Gz9KLH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 13:27 Wed 25 Aug     , Hal Rosenstock wrote:
> 
> I'm seeing an issue with ibnetdiscover from a CA port where it appears
> to extend a path at a "remote" CA port (it's actually another port on
> the same CA) to query NodeInfo of the next hop beyond it. I get the
> following error message:
> 
> src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr
> 0x11:0) bad status 110; Connection timed out
> 
> where smpquery -D nodeinfo of 0,1,20 is a CA which can also be seen
> from the topology.
> 
> It appears to stem from the following code snippet from
> libibnetdisc/src/ibnetdisc.c:recv_port_info
> 
>         if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
>             == IB_PORT_PHYS_STATE_LINKUP
>             && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
>                 (node == fabric->from_node && port_num == local_port))) {
>                 ib_portid_t path = smp->path;
>                 if (extend_dpath(engine, &path, port_num) > 0)
>                         query_node_info(engine, &path, node);
>         }

This makes sense for me.

> 
> that was introduced by:
> commit fcb8d5e7588e38508a8e354c37009d73c0a3889f
> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date:   Sat Apr 10 02:43:24 2010 +0300
> 
>     libibnetdisc: no backward NodeInfo queries
> 
>     Then switch is reached via port N we don't need to query back via this
>     port - source node is discovered already. Finally this saves some amount
>     of unnecessary MADs.
> 
>     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> and subsequently modified by:
> commit 49d149c63a44d99259f516a15af53d8cf3f0e7c9
> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date:   Tue Apr 13 19:54:45 2010 +0300
> 
>     libibnetdisc: don't try to cross discovery over CA
> 
>     When discovery is running from CA node it shouldn't try to cross over
>     all ports, but only via local one (send over non-local ports will fail
>     since CA doesn't route MADs).
> 
>     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> due to the (node == fabric->from_node && port_num == local_port)
> clause being TRUE.

But I don't see how those patches are actually related to the story. An
original (before patches) condition was:

	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
	    == IB_PORT_PHYS_STATE_LINKUP
	    && (node->type == IB_NODE_SWITCH || node == fabric->from_node))

, which has the described bug as I can understand this.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
