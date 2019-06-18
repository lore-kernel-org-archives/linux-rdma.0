From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
Date: Tue, 18 Jun 2019 13:29:59 -0400
Message-ID: <bd0b0a87b8bc459e172ad9396931bb69697da6c9.camel@redhat.com>
References: <20190617085341.51592-1-dkirjanov@suse.com>
         <20190617085341.51592-4-dkirjanov@suse.com>
         <20190618.100801.2026737630386139646.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rJaeBMmpzYKDyoRq6m/v"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618.100801.2026737630386139646.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, kda@linux-powerpc.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org


--=-rJaeBMmpzYKDyoRq6m/v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-06-18 at 10:08 -0700, David Miller wrote:
> From: Denis Kirjanov <kda@linux-powerpc.org>
> Date: Mon, 17 Jun 2019 10:53:41 +0200
>=20
> > in IPoIB case we can't see a VF broadcast address for but
> > can see for PF
>=20
> I just want to understand why this need to see the VF broadcast
> address is IPoIB specific?

A VF might or might not have the same security domain (P_Key) as the
parent, and the P_Key is encoded in the broadcast address.  In the
event that two vfs or a vf and a pf can't see each other over the IPoIB
network, it is necessary to be able to see the broadcast address in use
by each to make sure they are the same and not that they shouldn't be
able to see each other because they are on different P_Keys and
therefore different broadcast multicast groups.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-rJaeBMmpzYKDyoRq6m/v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0JH5cACgkQuCajMw5X
L90pLw/+M53RLjvu53BjG5dkzA3bSMIxTX4o+IE6pbdaMEg+lm+Z19RNiCznZgo0
O2BbfZDYf9nAu7IBpuGKJYWbvhoTFtkd+tymK2sPseHc7Fz9AtyLHK2o/ZTr/WOk
lJR4ys7Jc5L8cLD85aH7TZb1rflqH/A0A6Zub171yWnayyIj/Ka1VkoIDYs6rHn5
KTdo9yHaBI7ui0L7yYyruPvw+zTAIiW4r1mN/Q2+5/quvhHVxFAtf4VGSzUVkNKb
77cbrTpqidE/RhyjUMBXw2M0OCwdfOVFfzes2OIQ8J1McumPsOw6Ff4NHtfhbZus
+jZq+6L5LG8Ow7l4gDEgFCJeLTke459M55IM+hvhGcnGG/Q5F+Av29WYkPM/nseU
WaLH9IET1ntTe48yxhv5EzmfirALdTX3Pw4mItlo5mrgL1Vot6oz8lqjB3T2+Gnx
Zu/IFzb9ZbgfI4bW35lU8N08+wrrRnbYjIQuGNYpqnQE2r8XysCGH1GNX5ZwLRxm
FWF6qCRnjet9oUdR8W5WcFuWPfYQlJfeRX74IOO3SYROktRXkhvUVdKENuNlMHms
9jaicq3Ls1tUjHP4F3XnYIzflz5gwuqmrqew5YpLKrfAIunZ7679NmMTUiEPcnrE
pJWc56ajkildxiPqu/KP0VtBKlcwUdEitvmJC5g/WU83Yii45PM=
=RlJE
-----END PGP SIGNATURE-----

--=-rJaeBMmpzYKDyoRq6m/v--
