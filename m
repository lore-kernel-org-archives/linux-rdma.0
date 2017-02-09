From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 9 Feb 2017 15:18:28 -0700
Message-ID: <20170209221828.GA3327@obsidianresearch.com>
References: <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
 <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
 <20170208174040.GC30720@obsidianresearch.com>
 <VI1PR0502MB3008417F3E388B617291147CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170209000157.GA14556@obsidianresearch.com>
 <VI1PR0502MB3008153CDFD7F9C7CCAB022CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAAKD3BBunKCb6Z-FObOD0covTt3gCXDn3oic4LNbU3J5JHiQJw@mail.gmail.com>
 <20170209184720.GA809@obsidianresearch.com>
 <VI1PR0502MB30089F94C9F1504E142B86E0D1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30089F94C9F1504E142B86E0D1450-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 09, 2017 at 09:55:18PM +0000, Parav Pandit wrote:

> This means our GID cache will have two GID entries with different netdev.

When you load this into the GID cache you need to have four unique
entries for the MAC vlans:

(MAC-B, VLAN1, IP-1)
(MAC-C, VLAN1, IP-2)
(MAC-D, VLAN2, IP-1)
(MAC-E, VLAN2, IP-3)

And unique entries for IPs on the VLAN interfaces

(MAC-A, VLAN1, LL-IP for eth0.vlan1)
(MAC-A, VLAN2, LL-IP for eth0.vlan2)

And unique entries for the base netdevice:

(MAC-A, UNTAGGED, LL-IP for eth0)

All of these are unique keys in the GID cache.

> Now when ib_wc arrives for it, it will not have mac address in it,
> but we will have VLAN.  Which means we can only reach upto
> eth0.vlan1.

As I said before, you fundamentally cannot support macvlan on hardware
that does not provide the dmac or equivalent in the wc. As Matan said,
those IPs should never be added to the GID table in the first place.

> If I seach gid cache purely based on the GID, vlan id, and netdev of
> eth0.vlan1 there won't a match in GID table.

You'd never search the GID table with a netdev as part of the key.

But yes, if the hardware provides only (VLAN_ID, GID) then, by
definition, that hardware only supports DMAC == MAC-A and the gid
table search is (MAC-A, VLAN_ID, GID) and will not match any MACVLAN
entries.

This correct because the hardware does not support macvlan.

>           for_each_lower_netdev_of_vlan(slave_ndev, list) {
>                  ifaddr = search_ifaddr(netdev, gid);

This search is basically what ipvlan does.

It is completely wrong to replace the macvlan semantics with ipvlan
semantics way down in the offload world. If the admin intended to use
ipvlan then they would have done that.

You must stop trying to add fake support for macvlan on hardware that
cannot support it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
