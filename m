From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 10:14:06 -0400
Message-ID: <1432736046.28905.215.camel@redhat.com>
References: <1432226406.28905.22.camel@redhat.com>
	 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	 <1432242708.28905.73.camel@redhat.com>
	 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	 <20150525211433.GA9186@obsidianresearch.com>
	 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	 <20150525223235.GA9858@obsidianresearch.com>
	 <1432659226.28905.151.camel@redhat.com>
	 <20150526181336.GD11800@obsidianresearch.com>
	 <1432672378.28905.178.camel@redhat.com>
	 <20150526211114.GB4502@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-zp+xiDzHUpmq+Xb1z8GM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526211114.GB4502-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-zp+xiDzHUpmq+Xb1z8GM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-26 at 15:11 -0600, Jason Gunthorpe wrote:
> On Tue, May 26, 2015 at 04:32:58PM -0400, Doug Ledford wrote:
>=20
> > Not so much ethernet world as netdevice world.  The iproute2 program is
> > used to configure any and all netdevices, ethernet or otherwise.  Right
> > now, we can abuse it to do the same here, but it uses the netdevice ndo=
_
> > ops, not rtnetlink to accomplish what it does, so we are limited in how
> > we do thing if we want to maintain tool usage.
>=20
> Hmm? iproute2 does it over rtnetlink?

Yes, it does.  Sorry for being imprecise.  It uses the specific netlink
packet that maps back to the predefined ndo_ entry point and so you
can't use that netlink on anything other than a netdevice with a defined
ndo_ entry point.  We can't use it, for example, to extend the new RDMA
netlink operations that Kaike posted without also making modifications
to iproute2 to know about the new netlink.

> > > The LLADDR for IPoIB *is* 20 bytes.
> > >=20
> > > Truncating it down is *broken userspace*:
> > >  - DHCP: Not sending the full 20 bytes in the client request means th=
e
> > >    server cannot unicast the reply. This causes all sorts of problems
> > >    and is discouraged in the RFCs these days.
> >=20
> > Reference?  The RFCs I've read (4390 -> 4361 -> 3315) list a number of
> > options (three at the moment), but the LLADDR options all call for usin=
g
>=20
> I'm talking about this part from RFC 4390:
>=20
>    As described above, the link-layer address is unavailable to the DHCP
>    server because the link-layer address is larger than the "chaddr"
>    field length.  As a result, the server cannot unicast its reply to
>    the client.  Therefore, a DHCP client MUST request that the server
>    send a broadcast reply by setting the BROADCAST flag when IPoIB
>    Address Resolution Protocol (ARP) is not possible, i.e., in
>    situations where the client does not know its IP address.
>=20
> AFAIK, nobody ever solved this, and it actually does cause real world
> problems for cloud stuff as there is limited randomness in the
> TID. This is the network side of DHCP.
>=20
> > a LLADDR from a device that is a permanent part of the machine (not
> > common with add in cards), so the option most commonly used in IB is
> > option 2, DUID Assigned by Vendor, aka GUID.  According to that,
> > truncating to 8 bytes is precisely what you are supposed to do.  And, a=
t
> > least in all current Red Hat products, that's exactly how dhcp client
> > creates the client-id.
>=20
> Using the GUID as the client-id is sort of OK from a policy
> perspective (ie what IP should I use), but it doesn't help the network
> side, and it breaks down completely when you create child interfaces.

Actually, no, it doesn't.  My standard test network inside Red Hat uses
child interfaces and dhcp exclusively and it all works as expected.
This is because each child interface has its own unique pkey and all of
the devices include the pkey in the broadcast address, so one child does
not see another child's broadcast reply, not the parent's.

It does, however, mean that you only want a single link on a given pkey
for a given device, which is why adding a second ipoib link without a
unique pkey seems so broken to me.

> Basically, the dhcp server not having the LLADDR at all is a pretty
> big hack.. No other network I know of runs DHCP like that.

That's how they decided to solve the issue in the RFCs, so that's what
we have.

> > >  - ifcfg/udev/networkmanager: So what happens when I do
> > >     ip link add link ib0 name ib0.1 type ipoib
> > >    And get two IPoIB interfaces with the same GUID? I doubt any sane
> > >    user would want to apply the same config to those two interfaces.
> >=20
> > No, they probably don't want to apply the same rules to both interfaces=
.
> > I'm not entirely sure I agree with the argument though.  I fully
> > expected this to fail without a pkey argument on the ip command
> > line.
>=20
> Does that matter to the above tools? Are they using PKey,GUID as their
> key?

They are pkey aware, yes.  There is the parent device, and all
non-default pkey devices are listed as a pkey device and given a pkey
number and they share the same GUID.  They are considered children of
the parent, just like with vlan setups.

> > The net stack doesn't allow users to do the same thing with Ethernet
> > devices, so I'm not sure we shouldn't be disallowing this as opposed to
> > creating duplicate devices that are identical in all ways except name.
>=20
> The netstack doesn't allow it for ethernet because it would create a
> 2nd identical LLADDR, and LLADDRs must be unique.

And as far as the configuration scripts (at least on Red Hat) as well as
NetworkManager is concerned, the unique requirements are GUID/P_Key.
But, the P_Key doesn't show up in the LLADDR, only in the broadcast
address, so only the GUID is checked in the LLADDR.  All IPoIB devices
are either parent devices (meaning no PKEY field specified in the config
file) in which case they are the first started and match the GUID, or
they are PKEY devices and are started only after their parent device is
brought up (and here I think they actually match on parent name, not on
GUID, but I would have to double check that).

> Because the QPN is part of the LLADDR IB can create two interfaces on
> the same physical port that are completely separated by hardware. Read
> Haggi's email, he explains how they plan to use this to create
> interfaces that can be delegated to namespaces. It is not a bad idea
> really..=20

Yes, it is actually.  The whole reason we went to GUID matching long ago
was because of this exact issue.  Actually, allow me to be perfectly
clear about this point: the qpn changing on IPoIB interfaces *drove* us
to drop the qpn from device matching.  In addition, links that were slow
to come up (such as 40GBit links that needed more time to synchronize at
40GBit/s than it took to try and start the IPoIB interface) drove us to
drop the subnet prefix from the match because you could start to
configure your IPoIB interfaces before OpenSM had a chance to tell you
what your subnet prefix actually was.  So we were forced to stick with
only the 8byte GUID.  You can not put a transient item into your device
identifier, *ever*.  The problem here is that even a slight change in
ordering of module loading can change the qpn that each IPoIB device
gets.  Or, even easier to demonstrate, was the fact that if you rmmod
ib_ipoib; modprobe ib_ipoib, then all of your devices will fail to start
because all of your qpns no longer match up!

The *only* way this will ever be a workable item is if we A) reserve a
number of queue pairs from the driver specifically for IPoIB use and B)
specify which queue pairs go to which IPoIB devices at IPoIB module load
time.  Short of that, using qpn in the device identifier is a complete
non-starter.  And that still doesn't address the subnet prefix either.
If you want that included, then we need the ability to tell ib_ipoib
what each link's subnet prefix will be once it talks to the SM so we
don't have the wrong device identifier because we booted up faster than
the link synchronized.

>=20
> So prepare for a world where each namespace has a child IPoIB
> interface with a unique QPN, but the same Pkey and GUID as the
> host. The breakage from assuming GUID =3D=3D unique will become a problem=
.

See above.  Without further changes, this is a total non-starter.  And
this will require coordination with initscripts and NetworkManager (at
least, I don't know if other distros use their own custom tools here).

> > > Unbreaking it is a UAPI change, not impossible, but do we really care
> > > enough about 8 or 20 to push for that?
> >=20
> > In truth, at least right now, it's all moot.  Since we can't set the
> > subnet prefix, the qpn, or the flags, anything above 8 bytes is
> > immutable regardless of how many bytes we pass in.  So even if we say w=
e
> > aren't going to change the UAPI and for everything to 20, the real worl=
d
> > result is that 8 works exactly the same and has no functional
> > difference.
>=20
> Not quite, in the 20 byte format the 8 bytes of the GUID are in the
> last 8/20 bytes, so the app would have to place 12 zeros and then the
> GUID to follow the 20 byte format (or 4 zeros, the prefix, then the GUID)
>=20
> This is why the question of 'what is ILFA_VF_MAC' is so important,
> every option presented (MAC,GUID,LLADDR) are incompatible with each
> other.

For Ethernet devices, it's the MAC.  The equivalent of MAC on IB is the
GUID.  I would leave it at that.  IPoIB devices are constructs on top of
the GUID/link, and you can have 10 IPoIB interfaces between the parent
and children, but we don't need to specify all of those LLADDRs, we just
need to give a unique GUID and allow the guest OS to create their own
IPoIB devices on top of that.

> > > What does get return? If we accept 8 or 20, then get must return 20.
> >=20
> > The get has to return 20 regardless.  It's the only accepted means of
> > getting all 20 bytes of the LLADDR.
>=20
> You are conflating IFLA_ADDRESS and IFLA_VF_MAC.
>=20
> IFLA_VF_MAC could be 8 byte and IFLA_ADDRESS could be 20, I think that
> makes no sense, but it wouldn't break existing stuff.

Sorry, you're right.  I was thinking about getting the address of the
parent IPoIB device we are talking to, not getting the VF_MAC.  For
VF_MAC, I would say it should be the 8 byte GUID.  In a world where we
are configuring a base device via a parent base device, then as you
suggest it would make no sense that the two would be different sizes.
But in a world where we are using a construct on top of the base device
in order to access config space for the base device, and we are
configuring SRIOV instances of the base device for use in a guest (and
not our construct we are accessing things through), then our access
device and configure device need not have the same address size.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-zp+xiDzHUpmq+Xb1z8GM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZdEuAAoJELgmozMOVy/dR1oP/3YF3hzcKW6hyHLKIStmBPD4
Wa7m0rYM/x8yM3oUJkqaCWGAaVBB5IyJlJ7CtOxQFJWrSkk0uL8PzQco+rHEyvy4
mXrypwnmYTVd5mJ7fWKKocs0HkMtHVX/kCVnENWZyG89rOPepFTbQB6J02kNOIIl
cnDu5XeomHhSXpD4tZxmwxsVS5i+EhrcEAjPaZIFZ/zV7fQJVBEiel+2W75f9ILw
rPr4adDtmT82ZX3eSuWIJ68XteI7wymhqS1oN29OPh+injqAglX4cEMEFyPDKS7T
sGp+O/WXM2Y3GkR0ysgzbY/X+fAAEHb4dpOBJlEnrkz95Phdzd3Qi7wBbnuaYHr1
eYWT/BiDgO/Pq/TzDZJpaik9hpF7l8mcXTpv+mtzNJbmGboLTRGBnNf6eUC2dMec
I4mw2U/77gDX1eTmjsT/KaUVAWoUaQMiPBUVJAmxexnuPkkdGt3Bi/7cuhs23veJ
SAjWwztNZhXhhHE2f2ZPtDu6iSLUF78YN9ZA0CGNdQ5Xt9FR3b6pBVfKTDf0CEZZ
5miaZxmnasz3OBXMjm566ASJIZtYaRbKraFEVxJ5VPK/mxvawpx/Y9G5xcmxbRNb
EXrroUMhK92DcUeRgwv1WFPygEcTYiNwWrbN3mYAQ+ndasXu2CsnKinpGAO0sTg4
adhj8IgdGaFQ5EB09plx
=3FUW
-----END PGP SIGNATURE-----

--=-zp+xiDzHUpmq+Xb1z8GM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
