From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] IB/mlx5: Fix duplicate const warning
Date: Tue, 02 Aug 2016 13:02:25 -0400
Message-ID: <1470157345.18081.11.camel@redhat.com>
References: <1468323167-1843-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-PWyvmk0EL/ISyqW/ual6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468323167-1843-1-git-send-email-weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: weiyj_lk-9Onoh4P/yGk@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-PWyvmk0EL/ISyqW/ual6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-12 at 11:32 +0000, weiyj_lk-9Onoh4P/yGk@public.gmane.org wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>=20
> Fixes the following sparse warning:
>=20
> drivers/infiniband/hw/mlx5/main.c:2574:25: warning: duplicate const=C2=A0
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-PWyvmk0EL/ISyqW/ual6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoNIhAAoJELgmozMOVy/dqIsQAJ/8HW7nwJjdY3eLkuFE+bTg
FzgqJta+UJ0XlQA0pXdtO3kRbjyoGCseILUCjbbzZ40i1NAPMHa4ZJgDKwDYg5v0
r7vcpdszEH32gABu8htNlbF5tP72y0OWLVwaLl93ERrBFE8YPYfMPxKCH3rI50Pg
Px7N+SHqgCoNigIaLgeDaUbH6nV6WvIJwfynQ1Bvm0srHRGyp/+wPNc/OH06ABmu
QXDJaT7G4HU/LrwKTC1zyik8y+Dcs1xnDAG79WX0lXIaCebf4u7ZB/kXea0l+NmK
tZf7McUBjB+buDA2SH6bSKiPQ1xOGmS5q5Mbil4R4vsV2xgiLQMCZgSRJLxmTpp/
pAYR2ABvBYchOi4oWYSJaFv8dBo9y0Z2hBLTn3rQgBk4y8jwl4lwWp8G6QZLAUox
VdH2JH7wNZVa6meBifnnY1I0tg2+mpot7DPxdwUBT3L14SbJLp6D403wgeUUNvLu
4ZHCpSIDjq1tftKqkKD1oZRaSjtwyShLozQNM5bhslT/7K7fOcZ1gBdkdI9VsSFd
FG4zPH3bzlhTlfOtVmxBFNi2WArhdyHyf6qQnuE/N43DvTnHREeCihNRAGAsjwBQ
zYAm8ie/fG4qbC98bSJGuQvQAVIsMFEXQPj+L1r4F1usI6uJ6snmq6sM8YstHQr9
qScloZ9tYJLq2dSuflPx
=Zmqx
-----END PGP SIGNATURE-----

--=-PWyvmk0EL/ISyqW/ual6--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
