From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Fri, 13 May 2016 15:34:20 -0400
Message-ID: <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4V4CWKiToonb7H5vMo66ntXhB4g3iCIJe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462563928-29164-6-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4V4CWKiToonb7H5vMo66ntXhB4g3iCIJe
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/06/2016 03:45 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> IB address resolution is declared as a module (ib_addr.ko) which loads
> itself before IB core module (ib_core.ko).
>=20
> It causes to the scenario where IB netlink which is initialized by IB
> core can't be used by ib_addr.ko.
>=20
> In order to solve it, we are converting ib_addr.ko to be part of
> IB core module.

> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core=
/device.c
> index 1097984..8894ad0 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -977,16 +977,24 @@ static int __init ib_core_init(void)
>  		goto err_comp;
>  	}
> =20
> +	ret =3D addr_init();
> +	if (ret) {
> +		pr_warn("Could't init IB address resolution\n");
> +		goto err_sysfs;
> +	}
> +
>  	ret =3D ibnl_init();
>  	if (ret) {
>  		pr_warn("Couldn't init IB netlink interface\n");
> -		goto err_sysfs;
> +		goto err_addr;
>  	}

It's unclear to me how this change helps things.  Theoretically, if you
load ib_addr before ib_core (and therefore before any ibnl_init() is
run) and that prevents ib_addr from using the ibnl infrastructure, then
you would think that building ib_addr into ib_core and then running the
addr_init() before the ibnl_init() would have exactly the same problem.
I don't see what issue is resolved by this patch.  But, just as
importantly, after reading addr.c to see how it uses the ibnl
infrastructure, I don't even see what the original problem can be.
Please elaborate more on what actual problem we are solving with this
because I am loathe to change the module structure without good cause
(in particular, I know at least the Red Hat init scripts and systemd
units know about module names, so this requires changes to user space
scripts and that's a big no-no if it can be avoided).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4V4CWKiToonb7H5vMo66ntXhB4g3iCIJe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNiw8AAoJELgmozMOVy/d+1IP/0afspvCnHmPJYDL4ljxxL7X
zjdwYQEsoYNYfdOeSTe6oTu5gkhIy/5yrmsHkVLXwFA5gnMLjorUiorvHsTus7jv
4q9VQAp6EHJY5UbqqqMfZd36rCA4XnO2HC6D+YiiKS4AArFSk/HB6Ef4iL4scFwQ
6NTJkSv0Cso0r2LllAsCMJT4KviakdH/1JR9WfiFcYxjdsF7HeCTwjQqKPg/949Q
/6riJR7XJM0YW7+YQ8poJJ1dcmuaVkevBN/cBoi0IzSpxnyofAQwfu7RvA9ukzh2
KfpObyy9CLrKvXcEZqJt4VpbXyYKn92nGSUha1zjsf4x/vCdF4mLOUK56Ja5YLlK
vciSTixA8aEcL/GK6qyegHyl1vtYjcuXasByiKuJdYc82vmlG+pKwTIV3Aq6oCrJ
Yr1gL6HyNVkc0bKJO2lIkttVi839sa2GRb/QSt8C3OrZuCWN3GuZEVjNDWf2LTps
ysEsnYHT+WoTKRPWeIjXr/XgHC5zY/9M+J9NSs3VehWzwWVPJNjIejLS79nMBcar
Ggo8Oa3Tu5bvkPYF7w1nJf3g4Y6KEfE1XBoeWQSw50pr6rk2NsGcIEOsG8dG6src
LGlq2cQaT9TFko3+C1xeSV1n7DFO6nGR4FZTP936JGeMowMM8FlQZugRQawan0Nd
fe0mg+76n0w4kMsQdFr9
=oOMi
-----END PGP SIGNATURE-----

--4V4CWKiToonb7H5vMo66ntXhB4g3iCIJe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
