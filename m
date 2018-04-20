From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/core: Make ib_mad_client_id atomic
Date: Thu, 19 Apr 2018 23:55:55 -0400
Message-ID: <1524196555.11756.30.camel@redhat.com>
References: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PLg0GUGohGjeHX9p8SOq"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180418142450.15581-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@oracle.com>, Don Hiatt <don.hiatt@intel.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Ira Weiny <ira.weiny@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-PLg0GUGohGjeHX9p8SOq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-04-18 at 16:24 +0200, H=C3=A5kon Bugge wrote:
> Two kernel threads may get the same value for agent.hi_tid, if the
> agents are registered for different ports. As of now, this works, as
> the agent list is per port.
>=20
> It is however confusing and not future robust. Hence, making it
> atomic.
>=20

People sometimes underestimate the performance penalty of atomic ops.=20
Every atomic op is the equivalent of a spin_lock/spin_unlock pair.  This
is why two atomics are worse than taking a spin_lock, doing what you
have to do, and releasing the spin_lock.  Is this really what you want
for a "confusing, let's make it robust" issue?

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-PLg0GUGohGjeHX9p8SOq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrZZMsACgkQuCajMw5X
L93joA/8DJwFhaQ/BqkgGb7IU86MZGrNpT+yjnPKt9BIV6mi998Rvrf9dDR4mqy6
junN9n2TFg3I5+YdDDDGuIisUHGaR1cWf6w6b+lZXHqFpTNYPxzJZf64M1BvW7GS
9kQPD50wq9tb5Cvh4qGQsN7ENmMagXaExy+VMgf3sIWKrvJIpHYVlpLUo4Sd9EFp
xRXE2JMgOfSFtKOhsGOJP2fQ4ioZuXzmaJbbO9d6vS2IyFfv6dqJSI8uDdqeJXkx
hvzsmS4L+SuEs/n6t5ce+gjG8b+xhp3QEOumL4siTQrzK6QIVlN49KOMN54VdI6q
3qZjBMlgVS31YHKMzK+6wYRfK+Ri9ry97vDUzsSyATmlOB+kz6HyHcbjOcUMrQzy
5cCEfO1W0jLQ6mZ3QuBn0Q3B/FTWXCbOaF6tBo0QAHpaWBN/N1PcI9sOyJHwhySt
PzWtq3mnFbZ1MlIpCrjxoYbo/BxrzEyaDImr5X7XRGJoNWbBdyTlI47yUuq/65mx
uOgjS8IIpJ+BHmYzItOahvCPFEeKw6dBME0KoUTPWslBeXY8bgyCrS57UiABoWYk
nCWp7z8XjsuIetIvPLU3Ep9wC86tZN+BDeev/AICwE/IdpAufKxeBZDSv4Ek/oeF
FBrQe0SoueIKORlI+x3Jo8rpcQP+AUl0Y0MiiQDpAQLvU6gjYRI=
=ilTE
-----END PGP SIGNATURE-----

--=-PLg0GUGohGjeHX9p8SOq--
