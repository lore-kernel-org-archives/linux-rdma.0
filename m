From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: ocrdma: Replace BUG() with BUG_ON()
Date: Thu, 12 Jan 2017 12:11:47 -0500
Message-ID: <1484241107.123135.13.camel@redhat.com>
References: <1482593149-6243-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2ndAm9Pss+iO17WdeivJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482593149-6243-1-git-send-email-mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org
Cc: devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-2ndAm9Pss+iO17WdeivJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2016-12-24 at 20:55 +0530, Shyam Saini wrote:
> Replace BUG() with BUG_ON() using coccinelle
>=20
> Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-2ndAm9Pss+iO17WdeivJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7jTAAoJELgmozMOVy/dRMUP/2+7QVanOB254HNHfdmYt/26
1VKMMq+TE+wu79tT/im/38PAaIVUkqGuA8tNqo9KQs/o+R+uxPuwPk5mEkmtpSnP
3GM+gOe5EwZ2zkvqMJ+FCukd0AZN+tbPmftL6xuICVBLwfjlxlhrY2tPoJE6GpHP
eb8I5jmRTBeTiFIUrXLvkL0O8u1E0pasIXaNljywsBT7XAC99KtKLFi7PlKL+jnq
rv97uOybwOdLtsGA8C8NDCz+PiQCxBgyU+FHTpfR3XZ0RcJAheAAn4nG4O1YhFqK
epBQICpAW+c6TJ+hG+WR/ENvqd5Qsq4jBXVfOQ02xj9I4j7iepmwBDLCrXMvE0FA
PlYtJnSpuMm6Wi8Q0LqSIfrBSAnUFwvDMZlY5Bk6KxJyR8ldWxl6AmnnFUlDuIqu
cnk5Ouw4jIKFfWQjqzwOIGB9vHoH3jy8ABTf3i1pWgtwCbHW+VGi4ap2awZbxZ+1
YPw2Qu9Kcpg0+MDQ0rPbx9Dx58u1Ur4EQPG1GowAo92madYoQmVfrfnQ7hgnoRxx
pNVuKwIm1ePTJIvoJF50d2oPJ+x7Vx/3UZcmgfvo/+QBiUCki/4O7bxqbPKxEfLo
Q8stwmXSB1kwLVSiRYOssi3heQ0Mciz7gAhEeIPn/tu0kV74T03epsrehmKgZE7t
tpnDxqi3j2TjKLIe/Ywy
=TSrH
-----END PGP SIGNATURE-----

--=-2ndAm9Pss+iO17WdeivJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
