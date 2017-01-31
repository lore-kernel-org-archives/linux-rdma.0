From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Jan 2017 17:53:40 -0700
Message-ID: <20170131005340.GA30809@obsidianresearch.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
 <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008B16A0F103D729209EA16D14A0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 12:21:17AM +0000, Parav Pandit wrote:

> > No, regular sockets can be attached to both - '*' bind makes no sense for
> > RDMA because such a socket will not rx for all ROCEE addreses, just the ones
> > on the device it is bound to.
> > 
> > For that reason the entire concept of '*' bind should not even exist.
> 
> I am talking of binding QP or socket to namespace.

Sockets are only bound to a namespace with a '*' bind - otherwise they
are bound to netdevs (and that implies a namespace)

> My understanding is a given socket can be bound to one and only one
> network namespace at a time.

Right, but that isn't what I'm talking about here...

> > That sounds broken, there should never be walking of device or anything silly
> > like that to determine the ingress netdev. The only place that is done is when
> > constructing the GID cache.
>
> GID table can have two gid entries with same GID content in there,
> but gid_attr->net can be different.

A incoming packet *cannot* match two GID table entries - that is by
definition.

Yes, two table entries can have the same GID.

However, it is invalid to search the GID table by GID alone for
rocee. The GID table can only be searched with the full network
headers. For instance (DMAC,VLAN_ID,ROCE Version,GRH.DGID,etc).

This is what the hardware should be doing when it decides if it will
accept a packet or not. Packets that do not match GID table entries
should not be received. Each UD QP should have a list of GID table
entries it will accept packets for. (this addition is necessary for
namespaces)

In IB the matching GID table entry is placed in wc.sgid_index.

I argued that rocee should do the same, but since mlx didn't implement
this in hardware they didn't want to take the performance cost when
building the WC.

So, you have to reconstruct the wc.sgid_index that the hardware used
in software - and this will always match a single GID table entry.

Since GID table entries are associated with a single netdev, this
gives you everything needed to process at ingress.

> Without considering net_ns, GID cache query is equally broken.

Again, you must never, ever, search the GID table with only a GID or
IP address. That is always wrong for rocee..

> > > > The best thing to do is introduce required netdev binding for UD QPs
> > > > in kernel and then the kernel's ib_init_ah_from_wc can work safely..
> > > >
> > > I am binding to net_ns of the calling process which can have one or
> > > more netdev.
> > 
> > But that doesn't make sense for in-kernel users, and those are the only users
> > that can call ib_init_ah_from_wc...
> 
> Its done by default even for sockets. That's how its established
> that it belongs to init_net.  Refer to sk_alloc().

IB is not sockets, we don't have the concept of a '*' bind. It just
cannot be supported by the hardware.

> I think you mean sockets are '*' bound to address.  Assuming yes, to
> it, regardless of address property they will be bound to net_ns.
> This covers the case of applications who are not using RDMA CM as
> well.

More than that, we can't support the entire idea of binding an IP. The
best we can do is SO_BINDTODEVICE - which is what RDMA CM should
actually implement. (it binds to a rdma device, not a netdevice, which
is nonsensical and wrong from an IP stack perspective)

Since that has to be fixed to support namespaces, it should be fixed
properly and emulate SO_BINDTODEVICE semantics, and not something
else.

> > But even here you need to get the ingress netdevice from the gid
> > cache and use that to deduce what namespace the packet is for.
> 
> As mentioned above, GID table can have duplicate entries so
> namespace is identified by the ingress path.  I have reviewed net
> code before, but I will refer again how it's done on regular
> Ethernet packets.

Regular ethernet derives the ingress netdev from the DMAC and VLAN tag
present in the packet. (ignoring ipvlan which is special)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
