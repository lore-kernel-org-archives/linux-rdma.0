From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: release tarball top-level dir
Date: Fri, 20 Jan 2017 15:17:54 -0500
Message-ID: <1484943474.43764.4.camel@redhat.com>
References: <01b101d2733b$f0179df0$d046d9d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uQpiH7Bsfzs+BwhqYzsh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01b101d2733b$f0179df0$d046d9d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-uQpiH7Bsfzs+BwhqYzsh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-20 at 10:40 -0600, Steve Wise wrote:
> Hey all,
>=20
> Is this the intended top level dir?
>=20
> [root@stevo3 tmp]# tar tzf rdma-core-12.tar.gz
> rdma-core-rdma-core-12/
> rdma-core-rdma-core-12/.gitignore
> rdma-core-rdma-core-12/.travis.yml
>=20

No, but I don't know how to fix it just yet. =C2=A0The problem is that I
have to put rdma-core in the version tag or else the tarball is just
called v12.tar.gz, which really is not suitable. =C2=A0But I don't know how
to configure the git archive that github does on the back end to not
put the name in front of the tag when creating the tarball. =C2=A0I should
probably queue up a ticket with github's tech support to see what can
be done.

--=C2=A0
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-uQpiH7Bsfzs+BwhqYzsh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYgnByAAoJELgmozMOVy/dW6UP+weLo8wu2GYPJ8V7G9FG2wQN
85LEPoZbOsdhui8o7XofoN4fWSA5XcvdT51GcgCJVtNLhfXDZK+zTSqh2h7cRsY9
D+xZZaIKx9IKFhMSWAcxzWVbI9Mdrxb/9MQvUWwqpqEfACPVLvZrioaSsp+za6Ft
3TmCVV3H/EzPx+4Mwt7dgSbhICDVo+jSMBD52dQSDY2HqZDkggo3i1TRMNmEyBkr
QtPYdr1k24PhhfbL65224VbiViIStHDRVYHAGdZ1N95/ixRvm5OTy7WDVqbsAJUC
M7GEFotI2XbvAINMU/2U0Hu4j7lTyqIxqRE48vUUUFw2jtK+hgM+GOSM0JHZdSWw
GT9wJK1Vx6VMtm+xl62XZ1vw1eXSxiOg4Ip0H+HfYVkLGu2vErGSdVrpZbpThASh
n378Yu/3H0rnpYYEi6NdPw4x2SqyZcFpC30+XJ7b1Xo7hU9ErdJbXLl6rJhpo8DS
hC2hqaZfo6kY+L1WlhJv+HWRsvryMN7cpuSPAQhdp1eGBTT3gAHPGwui6RHM2nVO
HbNrKa6ofNsy5lQOTw5MXXai8AluBBkTwoeeWqWUsLwHO85Ki91aiud9VQyiRReJ
feOmgzyi5Ssc4Xy0vqAqnCwbEZAM37bUdNWcR5DQZ0cEJHhhtNQvafF37+ngo7O8
5WIQezrN2SOHSHM3wy7g
=PrGn
-----END PGP SIGNATURE-----

--=-uQpiH7Bsfzs+BwhqYzsh--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
