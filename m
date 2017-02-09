From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 9 Feb 2017 21:55:18 +0000
Message-ID: <VI1PR0502MB30089F94C9F1504E142B86E0D1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
 <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
 <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
 <20170208174040.GC30720@obsidianresearch.com>
 <VI1PR0502MB3008417F3E388B617291147CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170209000157.GA14556@obsidianresearch.com>
 <VI1PR0502MB3008153CDFD7F9C7CCAB022CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CAAKD3BBunKCb6Z-FObOD0covTt3gCXDn3oic4LNbU3J5JHiQJw@mail.gmail.com>
 <20170209184720.GA809@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170209184720.GA809-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, February 9, 2017 12:47 PM
> To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Roland Dreier
> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>=20
> On Thu, Feb 09, 2017 at 11:24:17AM +0200, Matan Barak wrote:
> > On Thu, Feb 9, 2017 at 2:15 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> wrote:
> > >
> > >> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > >> Sent: Wednesday, February 8, 2017 6:02 PM
> > >> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >> Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>; Roland Dreier
> > >> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> > >> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
> > >>
> > >> On Thu, Feb 09, 2017 at 12:00:09AM +0000, Parav Pandit wrote:
> > >>
> > >> > > That still breaks link local addresses on vlan devices, so it
> > >> > > is an ugly hack, not a solution.
> > >> >
> > >> > In presence of vlan, shouldn't we be passing the ifindex of the
> > >> > vlan
> > >> netdev?
> > >>
> > >> yes, that is exactly my point...
> > >
> > > Oh ok. I get it. I am on right path to fix it than.
>=20
> Use the gid cache to figure out, not seaching netdevs..
>=20
I still believe I need to search gid cache based on the netdev.
ib_find_cached_gid_by_port() already supports it.

Help me understand how to use the gid cache for below scenario without netd=
ev.

eth0 has two vlans.
Each vlan device has one macvlan device.
eth0 (mac-A)
|----->eth0.vlan1 (mac-A)
        |---->macvlan1 (mac-B) - IP-1
        |---->macvlan2 (mac-C) - IP-2
|-----> eth0.vlan2 (mac-A)
        |---->macvlan3 (mac-D) - IP-1
        |---->macvlan4 (mac-E) - IP -3
Please note duplicate IP-1 assigned to two macvlan devices of two different=
 vlan.
These two macvlan devices are in two different namespace and therefore dupl=
icate IP is perfectly valid for them.
This means our GID cache will have two GID entries with different netdev.
Macvlan netdev doesn't have vlan property set.

Now when ib_wc arrives for it, it will not have mac address in it, but we w=
ill have VLAN.
Which means we can only reach upto eth0.vlan1.
If I seach gid cache purely based on the GID, vlan id, and netdev of eth0.v=
lan1 there won't a match in GID table.
So in order to have right search in gid cache we need the netdev of the mac=
vlan-1.
So what proposed is,

If (wc_without_vlan()) {
      leaf_netdev =3D eth0.netdev;
} else {
     /* there is vlan in wc */
    Ifaddr =3D search_ifaddr(netdev, gid);
    If (ifaddr_found) {
        /* we found matching IP for this netdev, use this netdev further  *=
/
       leaf_netdev =3D vlan_netdev;
    } else {
          for_each_lower_netdev_of_vlan(slave_ndev, list) {
                 ifaddr =3D search_ifaddr(netdev, gid);
                 if (ifaddr_found) {
                     /* matching ifaddr found, in macvlan dev, use this net=
dev further */
                     leaf_netdev =3D macvlan_netdev;
                     break;
                 }
          }
     gid_index =3D search_gid_cache(GID, leaf_netdev);
}

This should work with and without namespaces to resolve the right netdev an=
d GID for macvlan, vlan, ipvlan, regular phy dev for linklocal and other ip=
 addresses.
Most hardware will drop frame with mac-B-vlan-2 or other such combinations =
anyway.

> > > Additionally,
> > > when there is macvlan based slave device present on this vlan device,=
 I
> will pass the ifindex of that particular netdev.
> > > Now since we don't have MAC address coming in ib_wc nor in IB/RoCEv2
> > > Annex spec, code needs to refer to the
> > > (a) ifaddr of the vlan netdev
> > > and
> > > (b) ifaddr of the slave netdevs
> > > Compare the DGID of the grh with ifaddr and use that netdev's ifindex=
 for
> the first matching entry.
> > >
> > > Sounds reasonable now?
> > >
> >
> > Since we don't get the DMAC address, I think the GID cache shouldn't
> > carry entries which the hardware can't differentiate upon.
>=20
> Well, more specifically, with this limiatation, the hardware must
> *NEVER* receive a packet that does not match the primary MAC of the port.
>=20
> Which goes back to my first point: The hardware should not receive
> something that is not in the GID cache, period. It sounds like this basic=
 sanity
> is being viloated in some current rocee hardware???
>=20
> If any scenario makes the GID cache ambiguous then it cannot be allowed. =
eg
> apparently macvlan must be denied, which makes this pretty useless for
> namespaces.
>=20
> From your comments, I think the hardware function is going to have to be
> improved to make this sane. I continue to recommend returning the GID
> cache index in the WC.
>=20
> > It might be ok for some cases in the transmit side (as you choose the
> > smac based on the netdev attached to the GID entry, but if you add a
> > vxlan based interface, you won't be able to add the appropriate
> > headers). We can leave this as is or making it symmetrical.
>=20
> Again, it is madness to allow the hardware to receive a packet on a UD QP
> that is not present in the GID table, and it is unworkable to have a WC t=
hat
> doesn't unambiguously refer to a GID Table entry.
>=20
> So yes, things like vxlan should not be in the gid table if the hardware =
cannot
> cope with it.
>=20
> > So, when adding a GID, we need to consult the hardware capabilities
> > regarding the metadata it can provide in the completion. If the
> > hardware isn't capable of creating/stripping one of the headers of
> > this netdev, there's no reason to add it.
>=20
> Yes. This is also why long ago I suggested that the hardware driver shoul=
d
> provide a function to resolve the WC into a GID cach entry and that funct=
ion
> can rely on hardware unique capabilities.
>=20
> IMHO userspace should not be exposed to this and UD QPs should be locked
> by hardware to a single netdev worth of gid cache entries. Anything weake=
r
> invites exploitation when we talk about namespaces.
>=20
> > If the hardware supports creating/stripping the required headers but
> > it doesn't support reporting them in the completion or all fields are
> > supported but there are conflicting entries, you could either consult
> > the ingress route before adding these GIDs or add them both and
> > consult the
>=20
> No. Hardware must support all features: create/strip/report/per-QP filter
> before the GID cache can have an entry. No subsets can be permitted.
>=20
> This probably means existing firmware/hardware/drivers cannot support
> macvlan and maybe others, but that is much better than trying to support =
it
> in an unsafe and insecure way.
>=20
> That probbably answers Parav's earlier question about duplicates in the g=
id
> table: It is a bug today that can even happen.
>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
