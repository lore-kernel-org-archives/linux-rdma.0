From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hns: include linux/of.h to fix build failure
Date: Wed, 5 Apr 2017 17:23:28 -0400
Message-ID: <07983650-b4b9-eb61-1111-e14f88ea4452@redhat.com>
References: <20170404133637.18643-1-tobias.regnery@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5baKP7QQckOi2fArUdDsnTXPnOE2i4vgd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404133637.18643-1-tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5baKP7QQckOi2fArUdDsnTXPnOE2i4vgd
Content-Type: multipart/mixed; boundary="o4Q4GrK0aufrcHshIVCk8imDlCU5IJqN5";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
 xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <07983650-b4b9-eb61-1111-e14f88ea4452-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hns: include linux/of.h to fix build failure
References: <20170404133637.18643-1-tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20170404133637.18643-1-tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--o4Q4GrK0aufrcHshIVCk8imDlCU5IJqN5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/4/2017 9:36 AM, Tobias Regnery wrote:
> I see the following build error in an arm64 randconfig build:
>=20
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c: In function 'hns_roce_v1_re=
set':
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1384:15: error: implicit dec=
laration of function 'of_parse_phandle' [-Werror=3Dimplicit-function-decl=
aration]
>=20
> Fix this by including linux/of.h directly.
>=20
> Signed-off-by: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> This is against next-20170404
>=20
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infin=
iband/hw/hns/hns_roce_hw_v1.c
> index ec68f56e8ee5..0f7e85c7b70b 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -33,6 +33,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/acpi.h>
>  #include <linux/etherdevice.h>
> +#include <linux/of.h>
>  #include <rdma/ib_umem.h>
>  #include "hns_roce_common.h"
>  #include "hns_roce_device.h"
>=20

Hi Tobias, I already picked up this same change from another person.
Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--o4Q4GrK0aufrcHshIVCk8imDlCU5IJqN5--

--5baKP7QQckOi2fArUdDsnTXPnOE2i4vgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJY5WBQAAoJELgmozMOVy/dR8EP/RqWKkd3UZ7helBXyqWR1b4j
fK4NXhQRzUwm0tgEuSCQbxwkowL2XMxX0sqARyuWYKeL0mxy2ga/C1KWxbvVeYBE
0OOKhMwZfgW4Pa9sU7otDeQK0eK2FNxWgt8x6j6qY3U02rvo9nL38DB2rQeRrfRs
T5GslaOztgrL0PVLbXhYm6sWKV9Afmww6EuDXbwh0e21oviKSe4FtOiEVJYDuSrw
AUHc0BoKyOKR+kP9UwM5c2cXIaR/PVFZobwUr83doPBXsxmED274E9AwgVLjp/pM
uXIfNDVZ39JBPoaDAmb3rt7ff10WL1fZ0cfI/ZtQa9aHdWWzwqj9K+Ikovau46W1
H2kEYVCyQAMISVDrEY3WSIMdfrPgHwSJbgjVdsbEE7daooxMN+PhoQzQPJzsyNoa
jIM7OH9xNw9Je40IhmEWQ5Zpx0UILCLo+lJkd4hvDuLNRMUvYN1p4wOH+3jT5LYI
1kQj7CG35n17i+ZSLkjN0bfK8YZzzqe4KbRUYgzUpm6/Y0Pscwa8zGTMBWxnt5ly
ttjmVnNWTxAV9MeEg3DO36fTD/SLX+RssK6WcxhL5VIs2siHRf4pox2Hc6G9D9Gt
DxnFzJj9YUCd9NHB5InrT4nlZ9RwwdDH9AdDe1zcuK1VqQjExZWtSe5x6uG9gCF7
VyFUm1hq6q/qC3dmhPMY
=7oKm
-----END PGP SIGNATURE-----

--5baKP7QQckOi2fArUdDsnTXPnOE2i4vgd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
