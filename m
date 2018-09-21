From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cxgb4: remove redundant null pointer check before
 kfree_skb
Date: Fri, 21 Sep 2018 12:03:35 -0400
Message-ID: <5749e7cf632c43ffa87df5b2cdd7894581d24b66.camel@redhat.com>
References: <1537437162-42846-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Zc6UhuEnTOyWw/hV62x6"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537437162-42846-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>, swise@chelsio.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-Zc6UhuEnTOyWw/hV62x6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-09-20 at 17:52 +0800, zhong jiang wrote:
> kfree_skb has taken the null pointer into account. hence it is safe
> to remove the redundant null pointer check before kfree_skb.
>=20
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Applied to for-next, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-Zc6UhuEnTOyWw/hV62x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlulFlcACgkQuCajMw5X
L93Mxg/+I76BAUtGBcxHED4JOlZPYkanNxkxMR9U1OQeBdIMDqsoPL4FSxZrHnkf
t2XBgO9QJEnnaBtO2G8AqMasykwFyRX+ZDL55ieUjENAeCnWseGg8l5FZk/Ydq9u
olpz5TUdDhE8MzGjPlQwCQCtNBmXY4e/RjdkO1ucwrlv0eEJzksa9sB8rCz6gAGE
5ZK0/5d2AXrcH226o1jjpWxlflqv/g2qLmgiV4dIS/ZFzOYtBWFtnd6iBFaleG1d
F2aMIcd78vSifEmCpXR53HIf7fjhxt8IQKr1HO1cc7w+ZdV8h7oaw6P46hzOXT4d
hBpzSqoQFagzNwXlFuXMUbSwzsyiy9o+c26ZEwkDxATGSBbBbQrPM7NeZPnfSBze
S12weyykz3gg1gWDbM6FxpmJuo3UvWF5s7lMuHjm65v7gyVoWVCi6SfKIEUhaGaC
RQniZ6jm6nDTlrPhvRidL8isfyC26sgmZxX8rK4RVnuxkV5pBYf8I8gvTmTwPGsz
ARgk6mX79X4blchsvCauM5B+vULZmCJY9SLOluYjll/PWOrUJM5Gre5KLUw3lQrJ
4b26g+PZJ8khUU6muWeuhw477rz4tr5Ajb9U9VLOafoll/G1LzgGHtKW5LX1dhAU
3o/tODd99WCXHMtfIxrBolN4kmlBiPzyRHOH4CLSx9yy4vIYAQw=
=zPiP
-----END PGP SIGNATURE-----

--=-Zc6UhuEnTOyWw/hV62x6--
