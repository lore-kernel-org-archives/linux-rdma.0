From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Remove duplicated include from affinity.c
Date: Mon, 8 Aug 2016 13:46:58 +0300
Message-ID: <20160808104658.GT27667@leon.nu>
References: <1470649787-29933-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="finhkSr2yyrWw3ow"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470649787-29933-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--finhkSr2yyrWw3ow
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 08, 2016 at 09:49:47AM +0000, Wei Yongjun wrote:
> Remove duplicated include.
>=20
> Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/affinity.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/h=
w/hfi1/affinity.c
> index 79575ee..7a3eb30 100644
> --- a/drivers/infiniband/hw/hfi1/affinity.c
> +++ b/drivers/infiniband/hw/hfi1/affinity.c
> @@ -47,7 +47,6 @@
>  #include <linux/topology.h>
>  #include <linux/cpumask.h>
>  #include <linux/module.h>
> -#include <linux/cpumask.h>

Yeah, no doubts, thanks.
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> =20
>  #include "hfi.h"
>  #include "affinity.h"
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--finhkSr2yyrWw3ow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqGMiAAoJEORje4g2clinMaIP/R0LbYdEFRl4vUUlbfUAGIDl
CLNO2DSa3QwQVhQKJZgwf76gg+ap+VAmC2RGAgsX5ifyjyi6qyux0/A8eQ6cSUF5
SCM64UBIYzfOTYaXlFwICxmya8H6TqdeCxKiOBi6/djpcOv1QobC5VHtf+W0wvOw
M8l7BsIlSuLb/9pEYAKIcKd5oWsoss+R0rVGOb51zwm45mbCnGP+v8FOKV9tbsdd
ObG6HKXH8RF7ySdp2HvrRaA8OgSHO4c2tmhILOMqXuKFUVdNeRc69rmUsLU1pgEw
P/Wpyipj3CzlSJtrFLQu7lnkYd84A+JqKfC1q22sNMlyEiclkSa138ArKu7Zo4jd
DmD9ME53jdW25ZPrnTe8AjPJ4Qnfzq0ahernur6QOHAsP0hGpLxiTzNR7fLVXU95
cgLQfmRPnH98w4J/puiPeTypGWfV4tIU7y3wgnFYDJhGyTuaWxYnfCrYwy3ZZcdg
nLSj1e1SxwsQNfAkaxNxPJmRQziP9MGzENP6OdOgsQrp98flSUjV31KjaLn69HS0
3s/IiMkhHmzcO2cAlpwx3z2eqF4Civ4/oKktanv1T9hOH01HB76z+nmJKg9ByNOZ
XSz3UUoCkq1Fc6oGqgHDLSyrHJTQwxAlJbHIJSsveNZaZDPWLPXuy4Qrm8stn1y7
Soqu8vFmphG3aK14jQdQ
=x2o+
-----END PGP SIGNATURE-----

--finhkSr2yyrWw3ow--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
