From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 01/13] IB/core: Add get FW version string to the core
Date: Wed, 15 Jun 2016 09:40:08 +0300
Message-ID: <20160615064008.GS5408@leon.nu>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
 <1465971728-24104-2-git-send-email-ira.weiny@intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBTw3iMQSKDA2CaE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465971728-24104-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yBTw3iMQSKDA2CaE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2016 at 02:21:56AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Allow for a common core function to get firmware version strings
> from the individual devices.
>=20
> In later patches this format can then then be used to pass a
> properly formated version string through the IPoIB layer.
>=20
> The problem with the current code in the IPoIB layer is that it is
> specific to certain hardware types.
>=20
> Furthermore, this gives us a common function through which the core
> can provide a common sysfs entry.  Eventually we may want to
> remove the sysfs export but this provides for user space backwards
> compatibility.
>=20
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
> Changes from V0:
> 	Add parameter names to function signature
> 	change default string assignment
>=20
>  drivers/infiniband/core/device.c | 9 +++++++++
>  include/rdma/ib_verbs.h          | 3 +++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index 5c155fa91eec..760ef603a468 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -311,6 +311,15 @@ static int read_port_immutable(struct ib_device *dev=
ice)
>  	return 0;
>  }
> =20
> +void ib_get_device_fw_str(struct ib_device *dev, char *str, size_t str_l=
en)
> +{
> +	if (dev->get_dev_fw_str)
> +		dev->get_dev_fw_str(dev, str, str_len);
> +	else
> +		str[0] =3D '\0';

Interesting point, what is better for the caller to get as a version?
You chose empty string, but it can be all Fs or all 0s.

> +}
> +EXPORT_SYMBOL(ib_get_device_fw_str);

--yBTw3iMQSKDA2CaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXYPhIAAoJEORje4g2clin4voP/jn9jwbe0Xyi/Pi46U2wH6NL
dqtGBSqqEcOvzps9yrs565yiVFPkg8g44qnz5jKm5jvjD8+xcLj0JatV2cgyp/ex
Sk0b1u4Itn5gUL9MJNAmMxbQNUFkfKB+MtBUlZ2r7XiPAwJvDaVQpd/HYC4KCSAC
yp6XRYEBwXBExls3Uryf4tMidYThTc9S+WXhTfbE5QlVZXWO4OvlIJe9Kj+17eQz
BGefDXlRVf/CRPQObHSo+VUHvf8FnWVx4QPxcIRFPdkKKOC1xRfYoY3gH8Vjxp2N
l0A0/QuZu7p1TC35cW3rkBdJ0/sgffXoMV3+cyLehFjqm9g1Gmp9/iFE+JmsCs77
K2893tOB40wpDUL5qweCaX6BVQVrVxMCP8DQjAtEZucphQyLIS27QQBJVMU5TQ6h
rhWzQhMyzFlUfVSrnX7gmbpKcrHUrKdLXCuCtU+MYjmmEF+GGPpBXmOyA/Hatt2g
JycajlUlOn67QUKgJwzMRS8+3a9f2a8lR3g8OugaC6v0WzDO4jKvpy7l1WDCDiS9
yD2PaltfsETSM+d4VGioqhw6vii13/o7EY0HFyxx/1vTwHGcG+MhNaP92x/6G9YY
Uj0ykMkaatbT0meOKk6zBsmS8O6ArCM5OsQyHvtl/fdCedPQWugNxKppPEJlBSPZ
jdjxIvwpm6OUMX3U04WO
=auU2
-----END PGP SIGNATURE-----

--yBTw3iMQSKDA2CaE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
