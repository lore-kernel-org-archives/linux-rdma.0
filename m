From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Jan 2017 15:14:37 -0700
Message-ID: <20170130221437.GA28117@obsidianresearch.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 09:52:17PM +0000, Parav Pandit wrote:

> > > > Both roceev1 and v2 need to use the netdev that was used to create
> > > > the UD QP to anchor these lookups, that netdev should be a child of
> > > > some kind from the get_netdev (eg a vlan, or macvlan, etc)
> > > >
> > > As you know UD QP is not created with netdev (AH binds to netdev).
> > > So AH and RC QPs are going to be anchored now around GID.
> > 
> > Well, that is fundamentally incompatible with how the netdev stack works.

> What I meant is, UD QP is not attached to netdev but yes with my
> patches any QP is attached to namespace, just like regular socket.
> So I have qp_net inside ib_qp structure.  Let me finish internal
> peer reviews before I post the patches.

No, regular sockets can be attached to both - '*' bind makes no sense
for RDMA because such a socket will not rx for all ROCEE addreses,
just the ones on the device it is bound to.

For that reason the entire concept of '*' bind should not even exist.

> > We certainly can't have namespaces with such an insecure design. UD QPs
> > must not receive packets inapproprate for the netdev they are associated
> > with, or the collection of netdevs in their namespace (for * binds)
>
> Haggai and I had exact same discussion few days back when I referred
> the IB spec. 1.3.1 section C9-46.  So I agree for netdev (mac,
> vlan).

ipvlan is a thing too..

> But IP could be of other namespace in incoming packet and that
> should be ok because we don't have UDP socket style bind() on UD
> QPs.

That isn't OK from a security standpoint.

You can't secure UD QPs by using the QPN, the NIC has to restrict
incoming packets to only match certain GID table entries, and those
entries must be the netdev the UD QP is bound to or all netdevices in
the UD QPs's namespace (for '*' bind)

Otherwise the NIC does not support rocee namespaces.

> > Well, using idev isn't going to work with child netdevs, etc
 
> I have further added checks for vlan_dev in presence of wc vlan id
> present and walking upto upper device.

That sounds broken, there should never be walking of device or
anything silly like that to determine the ingress netdev. The only
place that is done is when constructing the GID cache.

> > The best thing to do is introduce required netdev binding for UD
> > QPs in kernel and then the kernel's ib_init_ah_from_wc can work
> > safely..
> > 
> I am binding to net_ns of the calling process which can have one or
> more netdev.

But that doesn't make sense for in-kernel users, and those are the
only users that can call ib_init_ah_from_wc...

> This is the right thing to do similar to regular sockets.

Only if the sockets are '*' bound,..

> Exception if QP1 which will receive packets for all namespaces and
> will ingress and egress lookups based on the git_addr->net.

But even here you need to get the ingress netdevice from the gid cache
and use that to deduce what namespace the packet is for.

> > ifindex do not quickly re-use so this is fine.
 
> Its not quickly reused but when netdevice moves to different
> namespace, if that ifindex is already exist there, it assigns new
> one.  But I agree it's pretty corner case and its likely an
> administrative limitation until we establish good use case.

Oh? But in that case an (ifindex,ns) is still a stable reference.

> > Sort of, but you can't do the route lookup until you get the netdev, and you
> > can't get a netdev without a gid table lookup. :\
> > 
> wc->vlan establishes netdev and its ifindex.

Nope, that isn't enough to support all the behaviors.

> If upper device exist, netdev is established through that in
> addition to vlan.  netdev establishes namespace.  Namespace
> establishes gid table search scope and therefore right sgid index.
> Same namespace will be used for destination route table lookup as
> you described in steps above.

No way, that is backwards.

The ingress netdev comes from searching the GID table, period. The GID
table matches the vlan and dgid.

>From there you have the netnamespace to do routing lookups, etc.

> I am glad that we are having this discussion right now.

Can you try and submit a patch to fix Roland's problem please?

Searching the gid table is the way to go for now...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
