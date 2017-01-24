From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Prevent from completer to operate
 on non valid QP
Date: Tue, 24 Jan 2017 16:19:17 -0500
Message-ID: <1485292757.43764.70.camel@redhat.com>
References: <20170119132559.23999-1-leon@kernel.org>
         <20170119132559.23999-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lVbagT/0QT9Z4uuA+41z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119132559.23999-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-lVbagT/0QT9Z4uuA+41z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-19 at 15:25 +0200, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> On UD QP completer tasklet is scheduled for each packet sent.
>=20
> If it is followed by a destroy_qp(), the kernel panic will
> happen as the completer tries to operate on a destroyed QP.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, added to -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-lVbagT/0QT9Z4uuA+41z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8TVAAoJELgmozMOVy/dM8oP/0sIgXwkPjWeclUCiw+pdEb+
8dKcJCGDHqxOLGzADErE60HCwoIyVRBnObVd+s3TJWqunlv8dnghippMFVRyte8v
vEmDmTd+V7QlYXBJ+BbJH5G6BL9hNNu3S7JZM0RDpkaqBpHZa+58KwX8PJEaRZOY
xptOAD2TJIqPIWIRBtmGaCBmbmWLjDtsNkuWw+i6KBoN38nB0FLPqCu5nPhQXhS1
IFYxSB8/7OS3gWAYTVcodAIKl/qZCyNX7tY4jzCn2Le7gP7rj1L36P97njMAgStH
9BLIFWf2DLvsEyJ1PGGHbl2EdUH02gD/e8bXwweG+UMC/7suYaAh8vhwq4aQPOoa
ytfZJ12Sf/FiX83r5KGgpm4V0RQyWyIP4ZpbCyE2PXx2zDbslpJVNcMrNqZhMdd/
IUWPHwJOkn5S95zaXQ1IeO+xSeHLl/x9nEcycS5uhjFjeelY1s4UuRco/viTjXXa
8qRYEReGjd/N1elRRT1lvCTtw2c932Hx4Rzk6Bo0r6IQwSmq1FmsxV5eRiuxVJfh
rGfNkIlEhsLbrmqtq/WSyaexn6a1M0J05yAFlPEXElcePGrF5/yBd+TFcQa+Ps7E
RY/rE2Y8OL13X/AxfiKuXVW+97kmZjTfvaz+x9o3BwWyh2tKS3tSs8fQhuBjdgw4
VDCPRvUsD4P3bYIUXkbo
=NF1j
-----END PGP SIGNATURE-----

--=-lVbagT/0QT9Z4uuA+41z--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
