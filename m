From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Wed, 27 May 2015 13:53:11 -0400
Message-ID: <1432749191.28905.243.camel@redhat.com>
References: <1432242708.28905.73.camel@redhat.com>
	 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	 <20150525211433.GA9186@obsidianresearch.com>
	 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	 <20150525223235.GA9858@obsidianresearch.com>
	 <1432659226.28905.151.camel@redhat.com>
	 <20150526181336.GD11800@obsidianresearch.com>
	 <1432672378.28905.178.camel@redhat.com>
	 <20150526211114.GB4502@obsidianresearch.com>
	 <1432736046.28905.215.camel@redhat.com>
	 <20150527171143.GB9909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CJQ0JBGwnlymRui4MlZO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527171143.GB9909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-CJQ0JBGwnlymRui4MlZO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-05-27 at 11:11 -0600, Jason Gunthorpe wrote:
> On Wed, May 27, 2015 at 10:14:06AM -0400, Doug Ledford wrote:
> > > Because the QPN is part of the LLADDR IB can create two interfaces on
> > > the same physical port that are completely separated by hardware. Rea=
d
> > > Haggi's email, he explains how they plan to use this to create
> > > interfaces that can be delegated to namespaces. It is not a bad idea
> > > really..=20
> >=20
> > Yes, it is actually.  The whole reason we went to GUID matching long ag=
o
> > was because of this exact issue.
>=20
> I reflected on this some more last night, and yes, I am leaning toward
> 'bad idea' direction too.
>=20
> Too much stuff breaks if you create multiple children with the same
> pkey/guid:
>  - RDMA CM cannot disambiguate CM packets between them
>  - DHCP cannot tell them apart
>  - Net scripts/network manager won't work
>  - IPv6 becomes totally broken
>=20
> That means the namespace stuff will have to create children using GUID
> aliases..

Glad we agree on that ;-)

> > The *only* way this will ever be a workable item is if we A) reserve a
> > number of queue pairs from the driver specifically for IPoIB use and B)
> > specify which queue pairs go to which IPoIB devices at IPoIB module
> > load
>=20
> This basic idea is exactly why I think we should stick with the 20
> byte LLADDR for ILFA_VF_MAC. It gives a route for the PF to tell the
> VF what QPN to use for IPoIB (if we ever see HW support to implement that=
)
>=20
> If we use 8 bytes then that route is closed off forever.

And that's exactly as it should be.  If we allow setting all 20 bytes
via the VF_MAC calls, then we violate the "guests should behave like
they are on bare metal as much as possible" rule.  As a host, we get a
GUID and if we want to control the QPNs for IPoIB (and indeed if we want
to control how many IPoIB interfaces and on what P_Keys) then we must
create config files in /etc/sysconfig/network-scripts (on Red Hat,
similar requirements on other distros) that would instruct the OS to
create exactly what we want.  But, the key point is that we are only
given a GUID, and we must create everything else from our config files.
Guests should be the same way.  They only get the GUID to start, then
the guest disk image with its self contained configuration will take
over and control the rest.

> > > Not quite, in the 20 byte format the 8 bytes of the GUID are in the
> > > last 8/20 bytes, so the app would have to place 12 zeros and then the
> > > GUID to follow the 20 byte format (or 4 zeros, the prefix, then the G=
UID)
> > >=20
> > > This is why the question of 'what is ILFA_VF_MAC' is so important,
> > > every option presented (MAC,GUID,LLADDR) are incompatible with each
> > > other.
> >=20
> > For Ethernet devices, it's the MAC.  The equivalent of MAC on IB is the
> > GUID.  I would leave it at that.
>=20
> Yes, both arguments can be made:
>   - Our netlink end point is targetting an IPoIB interface, and
>     the equivelent to an Ethernet MAC in IPoIB language is the LLADDR.
>   - Our netlink interface is targetting the hardware under the IPoIB
>     interface and that MAC equivilent is the GUID
>=20
> > IPoIB devices are constructs on top of
> > the GUID/link, and you can have 10 IPoIB interfaces between the parent
> > and children, but we don't need to specify all of those LLADDRs, we jus=
t
> > need to give a unique GUID and allow the guest OS to create their own
> > IPoIB devices on top of that.
>=20
> As I've said, I would like to see netdev review that idea before we
> merge any patches..
>=20
> There are pragmatic downsides to the 8 byte choice: Userspace
> completely looses the ability to size the address without a table
> based on link type. That is terrible in the context of netlink's
> design.

Well, let's just be clear: netlink/iproute2 screwed the pooch on their
implementation of this stuff.  Any solution that doesn't include fixing
this up in some way is not really a good solution.

>  For instance iproute2 would need IB specific code to format
> the 'ip link show' (review print_vfinfo in iproute2) and to length
> check 'ip link set vf mac'
>=20
> If we do use 8, then it would be ideal (and my strong preference) to
> also fix the IFLA_VF_MAC message to have a working length. I think
> that could be done compatibly with a bit of work. At least that way
> iproute2 can be kept clean when it learns to do IB, and we could have
> the option again of using 20 someday if we need.
>=20
> So to be clear, to go with the 8 byte option I suggest:
>  - Engage netdev/iproute and confirm they are philosophically OK
>    with IFLA_VF_MAC !=3D IFLA_ADDRESS
>  - Make a kernel patch to properly size the IFLA_VF_MAC message
>  - Make a iproute patch to use the IFLA_VF_MAC size in print_vfinfo
>    instead of hardcoded ETH_ALEN (using len =3D=3D 32 mean len 6 for comp=
at)
>  - Drop in the IB patch

Sounds like a reasonable plan.

Or, this is your patch set, are you going to pick up these action items?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-CJQ0JBGwnlymRui4MlZO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZgSHAAoJELgmozMOVy/dJsMP/0KAvVRm8toZWhnv3pz8D1L1
nHDaBTLWRFeRdEIO+InV6Bz6th3xF1rxC+jfCD8cxks1PNjtbFSuFi3F+Wr1s3M/
t0uhBDqgezxT+fGKPPEzzfCgxRY2y9aGdD+nN2YGy4fc1sUtBaWpTwpIVE9aJpsV
VdwFIce41VlkQOqUJoVvsBWmXZqYDQSPCnOtxhgiuhAKB9ab3f2T5VR/PWjJ6SVh
ZVzUwCZFyC96jdacAwnaRYx1AUCGOIp9A2+gu017YUKV6QFexqhVBQqlPs0N1Y1j
VsW5QxlcgwQH9ErnENwIatI8TNkf0YQ+Nfb0JPY1FCTFWTT229tgoarJO+H1PiRa
rhO27HhHrgUb2/9GLCDzWWrER5GsVvJqDi1L82++3CgpUUOIQuTFvOy6+Z3lXydA
R2BZWg/6EFAatJxKegy0Zjw3VWh0inh4XQ7k8Xyi/ZIkbPAHZz57CODZz+8cGiBb
Xf+GPEIk9UkY1FSxeNFzBWxERbzurfaDKmyDYfYENsjclopkSoco8GWahnevtY6R
Xjf/9vZO9jYJFxrn7MioPGS2zXgSivdzoKsCac2Nx2D94PILhYgcRDViKHz1nvxG
bja8xQVpamaYz5gVSbTFzNFRiyrlNrvjYLJ/r91Hq6NiXPCUb4qRHujVLyI2dmp8
Ozj2FvjGhK8nzpE96Nl4
=U/Ta
-----END PGP SIGNATURE-----

--=-CJQ0JBGwnlymRui4MlZO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
