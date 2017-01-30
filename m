From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Jan 2017 14:14:20 -0700
Message-ID: <20170130211420.GB27111@obsidianresearch.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 08:15:51PM +0000, Parav Pandit wrote:

> > Both roceev1 and v2 need to use the netdev that was used to create the UD
> > QP to anchor these lookups, that netdev should be a child of some kind from
> > the get_netdev (eg a vlan, or macvlan, etc)
> > 
> As you know UD QP is not created with netdev (AH binds to netdev).
> So AH and RC QPs are going to be anchored now around GID.

Well, that is fundamentally incompatible with how the netdev stack
works.

We certainly can't have namespaces with such an insecure
design. UD QPs must not receive packets inapproprate for the netdev
they are associated with, or the collection of netdevs in their
namespace (for * binds)

In my prior message I was assuming that rocee disallowed '*' binds
since that isn't really how RDMA CM works.. (what does that even mean
if you have two rocee devices??)

But this clearly hasn't been thought through on the rocee side, so we
have a nonsense mess :\

> > This is necessary to make namespaces and other subtle things work properly.
> 
> Yes. I am currently testing my patches for this support in our setup.
> I will post the patches soon.
> However fix that Roland pointed out is needed regardless.
> I actually hit ifindex case even with IPv4 last week but was unable to reproduce it.

Well, using idev isn't going to work with child netdevs, etc

The best approach for now is to first consult the GID table to learn
the ingress netdev for the packet that caused the 'wc'.

Then do an ingress route lookup to make sure the packet should have
been accepted (bit late, but OK)

Then do the egreess route lookup to figure out the parameters for the
new AH.

But this is only 'safe' if the caller of ib_init_ah_from_wc is
assuming the UD QP was bound to * - and only if there are no
namespaces.

The best thing to do is introduce required netdev binding for UD QPs
in kernel and then the kernel's ib_init_ah_from_wc can work safely..

> > I think this brokenness fell out of the above confusion, it should be removed,
> > rdma_addr_find_dmac_by_grh should not be callable without a proper
> > netdev.
> > 
> IP route apis are working mostly based on the iface_id as input.
> So I am thinking to continue with ifindex input argument instead of changing to netdev pointer.

ifindex do not quickly re-use so this is fine.

> Currently rdma_addr_find_l2_eth_by_grh() has ifindex as optional
> argument, which is removed in my sandbox now.

Right, should not be optional, but I'm wondering if this routine
should even exist in this form. The two call sites seem reasonably different.

> > The != case can happen if the gid table resolve differently than the route
> > table, but it is conceptually wrong to lookup in the gid table before doing a
> > route lookup, and I think these apis are poorly designed to enforce that
> > requirement.
> > 
> Gid lookup is still done after the route lookup using get_sgid_index_from_eth().
> ib_get_gids_from_rdma_hdr() just gets the GID formatted properly.
> I think this part is ok?

Sort of, but you can't do the route lookup until you get the netdev,
and you can't get a netdev without a gid table lookup. :\

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
