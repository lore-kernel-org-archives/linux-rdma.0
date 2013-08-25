From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Handling incoming RDMA CM connections when there is more than
 one IB HCA in a system
Date: Sun, 25 Aug 2013 15:26:03 +0300
Message-ID: <5219F7DB.60601@mellanox.com>
References: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzPJ=cZ1WkjYJ_o_4uLE50mn-TX93Answz7nw2rn619-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
>
> I plan on writing a small driver that uses the in-kernel RDMA support
> to implement SMB Direct and provide shared memory mechanisms for
> avoiding copying data to and from the kernel for RDMA READs and RDMA
> WRITEs.
>
> After reading the srpt driver, much of what I need to do seems clear.
>
> However, I figure that I will eventually need to support situations
> where there are multiple IB HCAs in a system, and I wondered if there
> are any abstractions that allow me to do an ib_cm_listen across
> multiple devices at once?
>
> It seems that I have to do an ib_create_cm_id against a device before
> I can do a listen, but that suggests that I have to:
>
> 1. Create a CM ID for each device in the system. This seems easy
> because of the callbacks that result from ib_register_client
>
> 2. Listen on each CM ID
>
> 3. When I get a callback on one listen, cancel the others.
>
> Is there an easier way?

Hi Richard,

I would recommend using the kernel rdma-cm API (see
include/rdma/rdma_cm.h), this way you can have your control plane to use
IP addressing and the equivalent of TCP ports, where you provide
sockaddr strucutures containing IP and PORT on the bind stage.

Basically, your app flow would look like

listen_id = rdma_create_id(your handler, your context, RDMA_PS_TCP,
IB_QPT_RC)
rdma_bind_addr(listen_id, use $IP:$PORT or IP_ADDR_ANY:$PORT)
rdma_listen(listen_id)

for each new connection request
<-- get RDMA_CM_EVENT_CONNECT_REQUEST (with conn_id)
rdma_create_qp(conn_id, your qp attr)
rdma_accept(conn_id)
<-- get RDMA_CM_EVENT_ESTABLISHED

and on tear down

rdma_disconnect(conn_id)
<-- get RDMA_CM_EVENT_DISCONNECTED

You can see the upstream LIO iser driver for how it works
drivers/infiniband/ulp/isert

If you listen with IP_ADDR_ANY you listen over all HCAs in the system
for which there's a running IPoIB device
(for IB) or running Ethernet device (for RoCE)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
