From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1] RDMA/srpt: Fix RCU debug build error
Date: Thu, 25 Jan 2018 10:22:45 -0500
Message-ID: <1516893765.27592.112.camel@redhat.com>
References: <20180124065605.19310-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-n7rxhHy0hkT5LRTspGkY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124065605.19310-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-n7rxhHy0hkT5LRTspGkY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-24 at 08:56 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Combination of CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy and
> CONFIG_INFINIBAND_SRPT=3Dm produces the following build error.
>=20
> ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined=
!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> make: *** [Makefile:1216: modules] Error 2
>=20
> The reason to it that init_rcu_head() is not exported and not supposed
> to be used in modules. It is needed for dynamic initialization of
> statically allocated rcu_head structures.
>=20
> Fixes: 795bc112cd5a ("IB/srpt: Make it safe to use RCU for srpt_device.rc=
h_list")
> Fixes: a11253142e6d ("IB/srpt: Rework multi-channel support")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-n7rxhHy0hkT5LRTspGkY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpp9kUACgkQuCajMw5X
L93O8w/+M199dNsnxUu++MG1shlFraBtbWoMGqUbTj5jITVeHGU/oSDpCGCICFpi
PGnsxxClesTC3Y0AkoXJaOqr6NJXq8zTnf/4Oqj/YbXvQsDObR0Rxp5DXRmwzJA3
I+HQHgwgcNEATa/KdzQmJGsq0x1GbUHy8j6WJuErARFT8yfytq6Mn2ZPjTcR0X15
X7Brz1u7XI65Ro9mqDoyDLB4T0kHKdbSGBA759/Nq/WUEnYyue/W8Hbqohd9h0zu
DYY7mrVcb/sgy0GH5qsqRVp6moNusfpTi7AMB+5lxB78Q7uFMlTPRA8hh3z49SkW
MimmZcpaln/WzbRYv8FzjLhHwraF0+k9kLflQB7Ha3/utmpsQLSgF4cwIIcM+onM
AdNe5hKOmq9UAkJobZtl3DyM2exC5qct2NrJ22LJSqEJjChDhLIMBdhhDdbDwO2l
2zg9qfdS6KEzh92OcNIsTCRmuZ7JmC6APImuPT1DoUd7YLM3ZWYcVtC0PujSs7z6
VOwNa13xWJXMsKF9LB8ZO5sT45rZpyRAVRLvKEdFEdre636My+jh8ncPWWeDB0yN
V7xaJdupkfz5sj5hqjC3dY5YlvIv9fskuyyEl0TumFEv+rm8w7XorCC/gdgAWMX8
8wt50UV5srJ5+5BBzwtaeoko1nzx9DL89YtEDck6P9GY8c0oHyg=
=1syT
-----END PGP SIGNATURE-----

--=-n7rxhHy0hkT5LRTspGkY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
