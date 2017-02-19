From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mthca: switch to pci_alloc_irq_vectors
Date: Sun, 19 Feb 2017 08:55:06 -0500
Message-ID: <1487512506.86943.107.camel@redhat.com>
References: <20170209151058.15632-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WUOQC5FE6EyXtaQ1bHs3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170209151058.15632-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-WUOQC5FE6EyXtaQ1bHs3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-02-09 at 16:10 +0100, Christoph Hellwig wrote:
> Trivial switch to the new API for this driver.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-WUOQC5FE6EyXtaQ1bHs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaO6AAoJELgmozMOVy/dQW8QAMOTLcOJ8t2Ewr5t1UtOn659
iVlRk2Dc1HnsJkXX4T4Mhy9QakRjs3jHRY4hw7M6SyyUlizeimK1Qi5aZZyhL8L7
D5jWNI+PnWIdmSjDoDGmwpsB5yDqHPLRUb0zEW2DiwDqSYulr7TVyO1vagMBN9+o
C7Q8nDUH9GpDQzLTYdIWokYhRF7zXvrJ/Xe9ToFLKufOUGn9a1H2bEtyXGadwZVY
q511od/NQk4j32msew/dWPr0e3UIAYp1j46WJtmPrYOf/Digeoh1hwtKOjjSjCNs
z+h1amvkheH/AJ18VhPId126/8BP9s90Qa6sjNfF74EBtfZ2AZT1EHyP3noSvPfn
z7pErsKW0uT40GZhpCuV4/uaGbd6gyuwcHUHSf7f4mFW09dMXpRcj1c8WLOTJFby
33+zvdz93GHa7/SL9FTQFUNa81uyiUSkr40fHNitBLJWJ3+f5eNAiQbsHdfuaYu6
xDKWBAAZiSl9MqXOmdrgFRjOfTS9o4RyobrawPqUCehaelGSK1HmJykfu67KA+s2
RVERp6XDJ8VF60meHWEmyjl/ZabcwZGs4iiaaqNLSSeSbc4Klfgs3mCHFoNlLNRV
xYBCsmKNtv3SoxkneLy4UQATp0zGGMHmFj+tpOktSsd9sj/nMyRLPwRVWaBmLm6u
5j206rwPTnyh94E/hqWH
=T1jt
-----END PGP SIGNATURE-----

--=-WUOQC5FE6EyXtaQ1bHs3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
