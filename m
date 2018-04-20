From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/ucma: Allow resolving address without specifying
 source address
Date: Thu, 19 Apr 2018 22:09:12 -0400
Message-ID: <1524190152.11756.13.camel@redhat.com>
References: <20180419152811.4340-1-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HnoJ3+ea8fvRw1fBIeQU"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180419152811.4340-1-roland@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Roland Dreier <roland@purestorage.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-HnoJ3+ea8fvRw1fBIeQU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-19 at 08:28 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
>=20
> The RDMA CM will select a source device and address by consulting the rou=
ting table
> if no source address is passed into rdma_resolve_address().  Userspace wi=
ll ask for
> this by passing an all-zero source address in the RESOLVE_IP command.  Un=
fortunately
> the new check for non-zero address size rejects this with EINVAL, which b=
reaks valid
> userspace applications.
>=20
> Fix this by explicitly allowing a zero address family for the source.
>=20
> Fixes: 2975d5de6428 ("RDMA/ucma: Check AF family prior resolving address"=
)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-HnoJ3+ea8fvRw1fBIeQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrZS8gACgkQuCajMw5X
L90KlhAAtue53LTmU3Ua1Zrre1bAl/sEzAnEyM5MpYvsqFRljTY6uPdPiinlDDss
zyLQ5zA8942m1CAf3j++g/C8MODG2te++Jr8SwKLEG7TCSm8MK62L7wFqS5FzLyO
RkV6VAtKMxT47WBBdmS5yuDi+GFWKxorPV9saHo2fBpWWTbVvzYcGmQF1V385EwL
V2n+/aUKbpZL7g99OXo+A4i4M9NraCtQDVqtEa+64Hy8OLr6utjxxA7iX8HxqFk3
sgxEXutfp2dMFncu/3YC/lYamCT8QJEj/uGUr0kBlEgpCofkwSaJ7czGVeZPCV0p
a768Rzdjh2NQua67bKWz+xtuWWocmVzlvbF1gTb8pF9TegjoMbdvR98xZ3qWEFTP
76IHKjbFwP85yJ6c+J0zQzkkl4mHo2WOD7QdRDjT5QBxstelNmpXHH5CZdJK2lud
uZ9zruxcOF5C/wZmMzFY8h0hbkpoHIXJ4tYYojlLBkUXRWqBq4QHP/4LKZ24NG4V
EYbR4RhB0doS+VnoIYawrzt4rU99p9icVwEmFIONEIlBk3omTEVSlKFUuyyvWgVH
qVJ6TpVC2X1VZvUuEXZIzoSXjnkXrrWT1UAnDxN7mr2NUNA0OzApoL7vnoGFAlAu
vi/Pr/H1Fps4o3zfWoKlR4bQn0Hl3ujDOkjbTVv0wjrTpIJut0k=
=VwW2
-----END PGP SIGNATURE-----

--=-HnoJ3+ea8fvRw1fBIeQU--
