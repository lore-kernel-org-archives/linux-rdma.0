From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB: Fix incorrect structure packing for booleans
Date: Thu, 12 Jan 2017 12:10:33 -0500
Message-ID: <1484241033.123135.10.camel@redhat.com>
References: <20161223010752.GA20676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JmjJd9vMD9nHI2PGsOAT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161223010752.GA20676-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-JmjJd9vMD9nHI2PGsOAT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-12-22 at 18:07 -0700, Jason Gunthorpe wrote:
> The RDMA core uses ib_pack() to convert from unpacked CPU structs
> to on-the-wire bitpacked structs.
>=20
> This process requires that 1 bit fields are declared as u8 in the
> unpacked struct, otherwise the packing process does not read the
> value properly and the packed result is wired to 0. Several
> places wrongly used int.
>=20
> Crucially this means the kernel has never, set reversible
> correctly in the path record request. It has always asked for
> irreversible paths even if the ULP requests otherwise.
>=20
> When the kernel is used with a SM that supports this feature, it
> completely breaks communication management if reversible paths are
> not properly requested.
>=20
> The only reason this ever worked is because opensm ignores the
> reversible bit.
>=20
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-JmjJd9vMD9nHI2PGsOAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7iJAAoJELgmozMOVy/dg/MQALVSRzjg4DfRN1ia8OpfXoj6
gnpiv7sN5NshM62mk0vAAjQ2VRtL8UjXYXsDsvqPJtejgzWH4Q13T7AsjPSnYk98
IofaE0zEEFIYNiFBGcnIr1vxKWAMwJlnVdE6Ql+N5E82fiWzdcz8QRs1mtqb0T+S
SWDEkujYDyQv1n59807LGtfkb3QO81Rky+P1O73g8LXcvlyJBQNF1R4aiEUwvvdc
NZquEwz/Fe++BxqLziC1nm2ulflfNYSB9ZZ6Giev78B1WPIzZo/DTnRgFh1FqQzu
bp6ny5bQjnspJdXczdTJ4g543F9jhbWTyJfykvzohfV8Zso3kjgOoDuumtSZ+0Np
7taVOaN4cugxSiqT6imG354kyI22gzXBfu3cNQQ6bQO7qnP1jyEZw4IK3Rn/bsxM
sR8XfTnffa+xnbDAqnFnLGv/98XwtkYF22oqy3vKrUBg+m5+ImCADNfpKom6vBiQ
oUYuwwa5JO1R0wWitoPWGFSYVMIhu2Q/aMq5uD8TnXq0w7Hv/V3JkzAsZfdQbboV
8WuISdusONT0q4l59jkqgm+0ZXnOEwbuzxRvF45rPVo3MN2+4FPmLk8qW++SJyrd
QvMETtArV5KyyZJ9gGDF77sx3r66P4lVXOmfdaMcge8G4sKBOqNqPq7079W7FuDA
Q3ZjdIDdNIvyLZfyAzan
=80et
-----END PGP SIGNATURE-----

--=-JmjJd9vMD9nHI2PGsOAT--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
