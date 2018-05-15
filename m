From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 16:05:23 -0400
Message-ID: <bd0edf7b17f7a1d2f6e8c591e05172b82e9c38b3.camel@redhat.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
         <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
         <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
         <eb6edd23b76a176b876002cc19c546a0669cf66f.camel@redhat.com>
         <c9d9c8dd-682e-ab38-a3af-6159adbebba7@gmail.com>
         <d4a8a280c94dd8db969bc52abe057af1fde89a4b.camel@redhat.com>
         <fd64ce39-a284-b09f-85b0-8cd7ba0d1207@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UlP0HU4RAZyIQCPr89EG"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <fd64ce39-a284-b09f-85b0-8cd7ba0d1207@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-UlP0HU4RAZyIQCPr89EG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 14:01 -0600, David Ahern wrote:
> On 5/15/18 2:00 PM, Doug Ledford wrote:
> > I just sent an incremental fix to the list under separate cover.  You
> > can squash that fix into Steve's patch and it should resolve the issue.=
=20
> > Or Steve can respin the set.  Either way.
>=20
> Once the patch has been committed to the upstream repo, spin a new set
> with the correct header update.

Well, I wrote it, so it's in my repo now ;-).  I just sent it to the
list because that's what you do when you are writing fixup patches even
if you've already committed them.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-UlP0HU4RAZyIQCPr89EG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7PYMACgkQuCajMw5X
L92yoxAAlcDRworhoflB0fDG2NJciZcro26hccflEplV6IxNx/lOnY0861Rz3nMV
zr/7KOkUdUoH7zZhMtF2gVkmkgSDtblOn5wBA2feKzeg0BM2216/0Fej3eq+phht
GgxBjdMaMGb7gasDK8JwimL+KbRPCNI5l4r0Cc0HzNNoyIqWhV49UNsYNdQG6Va6
jTNUnSqKaq+gTKO/aSWuH9DbdylG8FTg3k0tuJD7v5L0EvEb/Jj6FEOyoo9ic00o
npZanVWgBYHD25A7mGrMf9J9hFBMbin/U+th97gwk1QgxgXjejSnXGjNZ6ca05Dk
e3TIxhSmVev2qXqkAHBgGAK1emwvTKmYewBpXCg15rEABHWOmTBVQK/qQpvp2T9q
31MpPFNKdZB1+4nqBH6g2X0ry2J7Qcoc4dEs68ec24qe8QKLLb9doIHMspznif6c
rNUyxUrchw3SzxNQ0SQQuc1tcS3MoPM7NmAASR7YrCESqBZsJ/OxOtpfYHiXaB38
v+XTVtBL07DpP0M1gJnD8ui4dUovOePszWpX8CAX845nQGXLsamymzh/j25BRBP9
yZ8h4KcwQvDDmtLGz5ZdlBSg2dCgODgUMePEXJ9KoXSxl+mVv64dZM5ot4S8eaVE
TnHvuxYtJR4w1o7/fXmnr/aZO8O7NaMoyUWMtP1eXGONXZN1GII=
=9M59
-----END PGP SIGNATURE-----

--=-UlP0HU4RAZyIQCPr89EG--
