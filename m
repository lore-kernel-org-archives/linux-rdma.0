From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: can't build ibumad on 32-bit arm
Date: Tue, 10 Jan 2017 12:36:04 -0500
Message-ID: <1484069764.2149.18.camel@redhat.com>
References: <20170109213944.31970-1-jarod@redhat.com>
         <20170109223108.GA10850@obsidianresearch.com>
         <a1b3f6cc-2de0-8a19-18dd-182f2cb7d3e1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-onPhYRNlDpoJwQIb8SAy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a1b3f6cc-2de0-8a19-18dd-182f2cb7d3e1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-onPhYRNlDpoJwQIb8SAy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-10 at 11:30 -0500, Hal Rosenstock wrote:
> On 1/9/2017 5:31 PM, Jason Gunthorpe wrote:
> >=20
> > On Mon, Jan 09, 2017 at 04:39:44PM -0500, Jarod Wilson wrote:
> > >=20
> > > Building for 32-bit arm, things fall down, due to lack of arch-
> > > specific
> > > memory barriers.
> >=20
> > Since we now have rxe that should work on ARM I think we need to
> > fix
> > this upstream..
> >=20
> > Do you have time to test some patches on ARM?
>=20
> Looks to me that issue was introduced by:
>=20
> commit 1df0888f6a736e1612ce8b054d6c17651ebd003f
> Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Date:=C2=A0=C2=A0=C2=A0Fri Sep 2 12:57:57 2016 -0600
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Remove most checks of __BYTE_ORDER
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0For a long time now endian.h has defined sane fix=
ed with
> conversion
> =C2=A0=C2=A0=C2=A0=C2=A0macros, so lets just use them instead of rolling =
our own.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Also, htonll is defined in this source tree under
> infiniband/arch.h,
> =C2=A0=C2=A0=C2=A0=C2=A0so all users of that macro can just use the heade=
r.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Someday we should also get rid of all the endless=
 wrappers..
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidi=
anresearch.com>
>=20
> where byte order macros are from libibverbs arch.h which also
> includes
> the memory barrier stuff.
>=20
> So can't arch.h be separated out into 2 headers and have the various
> parts of rdma-core include one or both of these headers as needed ?

No, that won't help. =C2=A0At most it would shift where the compile breaks.
=C2=A0When Steve Wise did the patch to add the arm64 memory barriers, we
discussed on list the fact that not having a proper memory barrier
define for an arch should be a fatal error, so we also made it such
that without an arch specific memory barrier define, we fail the build.
=C2=A0If you split the headers, then somewhere you are going to come to a
file that needs the memory barriers defined in the headers, and when
you include the header, the compile error returns. =C2=A0The proper fix is
just to get 32bit arm defines in place.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-onPhYRNlDpoJwQIb8SAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYdRuEAAoJELgmozMOVy/d2NUP/iQBAa8xN1JDXZt/lJdHgmNc
blA468KCNwVyWV7zfG2L/XyZjnMTgVCL9ctY09qfLPyRMki6mCFPrxkg5CFRcFCP
q8jAga4/XByYetb3jBkARC1yd0cr03qxKpkRz/+Exi/iNrxGSpoJs5vwvf9oPxsp
98sAAJB4bveHHu8imz75gVU2jTYnfmyiFEM0alyCp+H4AvV93S7QeofWnxUrwbFd
mFw30vE6PKRBUv/ybVsxNl0a3Cy9XK1Dw+8n0pEXYRjwqsKhdeza+6e8Y2pVuNrT
gtJePY9XRcO6OEjFRBE5U3SrJmv6GR+f5E/X09roqu5qGen8LAZ4XxLlT79+gcCW
xC7wtRWSOmC1XcsUgNArD43qp2CebRfjhWyyQ1Erxmpym+p9sAGKDuR+CUacztuK
WaQfIWqj0dIeSgeK0NbK87XhRse9lcnIupWM5ddB+6oaaliWB9PVYz0IC1u8ACR8
kfUWNaVGkRszu/LuHjDaNAMhFSsvYwvAeSq4uIvL11+Yfw3V/CVdymBf75WZzAPF
OCfsd1ewbCBcSD+hQbe8bHqIw1BKUWqe9e/WC+3l6mWbXcxCWOGAIfKa0mrYJl+o
TDavnNpmgNZRniHyey9rgwmCJrEWzIZYYgoTod2OioRweXJXwJaoAcjz7vg6myCG
Uz/gSBbKO47sdqo0Qq6/
=OSir
-----END PGP SIGNATURE-----

--=-onPhYRNlDpoJwQIb8SAy--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
