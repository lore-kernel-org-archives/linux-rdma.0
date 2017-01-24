From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Fix rxe dev insertion to
 rxe_dev_list
Date: Tue, 24 Jan 2017 16:18:56 -0500
Message-ID: <1485292736.43764.69.camel@redhat.com>
References: <20170119132559.23999-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BPAa/1GXrB3gCJu4e7Te"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119132559.23999-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-BPAa/1GXrB3gCJu4e7Te
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-19 at 15:25 +0200, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The first argument of list_add_tail is the new item and the second
> is the head of the list. Fix the code to pass arguments in the
> right order, otherwise not all the rxe devices will be removed
> during teardown.
>=20
> Fixes: 8700e3e7c4857 ('Soft RoCE driver')
> Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, added to -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-BPAa/1GXrB3gCJu4e7Te
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8TAAAoJELgmozMOVy/dNH4P/ApapAgO35lQjVROt8z6Y1cx
xC5Cn9ZeoMk3Kzi+y5P0U7XcaiEtLqqWhUnrNRRdwRKvduFlIrA3UBYg4MNuG++F
buG5MC2yfms4whjBMwKdggdygmsiHB56mRiGIBiXlQywdq4IQfsBtwSZ7cokkCrG
IK/uL2x1B+BVJT4q4KI98CXLgG81jz3Mwbzhvqm33EkQ8+blTrVralyP2SrpwW5/
YmuvJQQ3xAdmDAspZ/yxtoCssx6JtVMeYaXuzR3dzNltXoIcGm2u92W6BtS0lLKg
t7mF+TAzZnfUNguxpHCG3ThXEvj//0sqyzUZM5y0p31x22bDnXbR789g5zK/XN0Z
VGztLOKJY5JryLsNSBElHJO17t1oUfkyksn7jgmTU5ybtA+KADbx+VrVv+1Uyf83
V2DJf+cJGLAbO0W0hlaLck5R6bXF8FUnAWXKNQtHYYrG/xPOxDQ0DpKT7FTLMa/K
+bADI3gVZMkViF8ILoYmlyrF89Iow4YFeTfauwjbC+w6jXBm0HpOlnimmw7B+ifD
guygC5kneuEGbWW4kHph9ude7Dyi9vT7Tfe8Ba20OqhwXZUWg4DCXuF04/l7kt9R
Dz2+OuSYgyLIdNUSzWArve/PeHQR9oN3Hxew8faK5Gdfw7rvVSSY0xigGhkhV6T2
dVsGJY0d6Bq9WAioRrmE
=fVhY
-----END PGP SIGNATURE-----

--=-BPAa/1GXrB3gCJu4e7Te--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
