From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 12:35:34 -0400
Message-ID: <13da78012c55e8f224c2226f3c0cfc53bd0522be.camel@redhat.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
         <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
         <20180513132447.GF10381@mtr-leonro.mtl.com>
         <c57b8f18-858c-62df-50c6-453933a67913@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rzUWdAUB/rUfleiIHbQt"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <c57b8f18-858c-62df-50c6-453933a67913@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-rzUWdAUB/rUfleiIHbQt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-05-14 at 09:51 -0500, Steve Wise wrote:
>=20
> On 5/13/2018 8:24 AM, Leon Romanovsky wrote:
> > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> > > This enhancement allows printing rdma device-specific state, if provi=
ded
> > > by the kernel.  This is done in a generic manner, so rdma tool doesn'=
t
> >=20
> > Double space between "." and "This".
> >=20
> > > need to know about the details of every type of rdma device.
> > >=20
> > > Driver attributes for a rdma resource are in the form of <key,
> > > [print_type], value> tuples, where the key is a string and the value =
can
> > > be any supported driver attribute.  The print_type attribute, if pres=
ent,
> >=20
> > ditto
>=20
> I'll fix these.

Fix it if you want, but don't do it because Leon told you to.  A double
space after period is perfectly acceptable.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-rzUWdAUB/rUfleiIHbQt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7DFYACgkQuCajMw5X
L91E7Q//ctElUzqze1/hVIUWbOZ7wZkQ1WvbYR4twIHH1HX6J6fSa6IlkV/tMZVH
dZdW21USCGeXoK/dWRwJ5JRffEsA4hcig9oG7wQ4Q3yq7B36ueCa+D03EbZgNRre
mj3dFIJ41tLntIJbhazkgjwIlwEfXPSOJLsydt8vdw6HgjWJCB+9YrLCoZ/m6ejL
kCm2iu0+eoxEaTRoQigA7UPORWV2N3tuFzXFWO+7dUjaCYhShSuil824u0a+93ZS
gJpItAex29OJqP9JxZnEq5H1f/hR5eUVsvc7AHsfvjtYFW4qr+mNSObDQ4JEphLD
1QG5OFi8d4tSiszkIhM6yiNE/7JTai9I6GN4faKfqRwIfZVOvzn8AZ85bmbjyt/0
aa7kiB7Zv3q7apIO3aNXKhheeSZAtik2WPdR1JHEonhlqC47VztwazE/PDrLB2Mf
CTUSNDuUirlse3oJzAo4p59d36a2EbH/xOKMecK1RUNsHfFZfTUvrCL8iWzpuY3x
tdJWHfuEG1PKDzmwpAUEy6/J2hW9s45nytsx02MTkP9SOi+BiA/eJvmRPtJYcMZ7
PCyYQRMuxfFhGojHhwtieCkv++CPa5D6ADr9ijrW+7sKKU6lilWaSzbGcKTBs+6w
asutLdgrUMglxTo5w9vB8Q9pol3STGphuml02SjC8NgO8nFlvz4=
=Xq4E
-----END PGP SIGNATURE-----

--=-rzUWdAUB/rUfleiIHbQt--
