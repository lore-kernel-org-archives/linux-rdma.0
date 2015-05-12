From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] IB/qib: fix test of unsigned variable
Date: Tue, 12 May 2015 12:45:14 -0400
Message-ID: <1431449114.43876.57.camel@redhat.com>
References: <20150512163233.26836.98544.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-DNWXxmTX1VkiqQAr8wz8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512163233.26836.98544.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-DNWXxmTX1VkiqQAr8wz8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-12 at 12:32 -0400, Mike Marciniszyn wrote:
> Commit d4988623cc60 ("IB/qib: use arch_phys_wc_add()")
> adjusted mtrr inititialization to use the new interface.
>=20
> Unfortunately, the new interface returns a signed
> value and the patch tested the unsigned wc_cookie.
>=20
> Fix the issue by changing the type of wc_cookie to int.  For
> the success case the ret is changed to zero to avoid
> a warning from the caller.  For failure wc_cookie
> is used as the ret.
>=20
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib.h           |    2 +-
>  drivers/infiniband/hw/qib/qib_wc_x86_64.c |    8 ++++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/=
qib.h
> index ba5173e2..7df16f7 100644
> --- a/drivers/infiniband/hw/qib/qib.h
> +++ b/drivers/infiniband/hw/qib/qib.h
> @@ -903,7 +903,7 @@ struct qib_devdata {
>  	/* PCI Device ID (here for NodeInfo) */
>  	u16 deviceid;
>  	/* for write combining settings */
> -	unsigned long wc_cookie;
> +	int wc_cookie;
>  	unsigned long wc_base;
>  	unsigned long wc_len;
> =20
> diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniba=
nd/hw/qib/qib_wc_x86_64.c
> index 6d61ef9..2f2e15a 100644
> --- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> +++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
> @@ -117,8 +117,12 @@ int qib_enable_wc(struct qib_devdata *dd)
> =20
>  	if (!ret) {
>  		dd->wc_cookie =3D arch_phys_wc_add(pioaddr, piolen);
> -		if (dd->wc_cookie < 0)
> -			ret =3D -EINVAL;
> +		if (dd->wc_cookie >=3D 0)
> +			/* insure no warning on success */
> +			ret =3D 0;

This stanza has no meaning.  ret was already 0 or we wouldn't be in this
section, setting it again serves no purpose.  Just keep the original
code, but replace -EINVAL with dd->wc_cookie.

> +		else
> +			/* use error from routine */
> +			ret =3D dd->wc_cookie;
>  	}
> =20
>  	return ret;
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-DNWXxmTX1VkiqQAr8wz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUi4aAAoJELgmozMOVy/dQPYP/2zQcT8mX1h2AgF2pdE+ilVT
zj54NXOPQugFQQobQEa9r7dew9YtCtYFw4FP5Cx3YuFp5SZJmdM2uVgCRbX2WegO
hQZrAOGaF5MTgOjpaVc1HiW8/lbqoBro2p8wg1OrHAKLBg7DKdFpe84ID9ewKFSt
/poOzUwj1P9/ig3mlW3WO7oQMvhR8TXX8U9a3NSCda1xunF4x1XA2pq5FqUK4VOn
P6agMVuV9otLrcaaaIz1A6IboAK6ARczq0mW0p5HGg74Dqs8xsd1yynZKk3vHf2C
Nl9F5ZAkK+fdjnQZFs+UELwOoq3LJllpy7RaZOCrxsTTRp25kSz77O1bxPz0uePm
QNtDtg5kF1o+iGkoj/2Yh1nv7KpCluviP5NofK5ESquDGUqLb9xKV7c6q+mkuy1B
EAMwjw3Y6JlWfcPl3G0CeLnS4RhTBBx+/UbJV47VX+VrBI8CZ1df6mzoyZCT+j3r
D0tvK2+WuFyVk+IQeg0q/Rf5QYhZnTEjExN3XoA5DflFtkIbF1/krw+wmLovuO4f
XxENbH+qWvb0RLBvbhkSPvnZBFCGLPRvXdYNYhc2H+2ljAqP2jB+QFVj1oZ0Ye8Z
bpH6qpiLUgZu6dZL055tqa/HqW2rQ8CFZ47Phfho6NeMI8CSKGOBqT/7tbxyp9s8
7RgGlNKMXm/32dd/2HeK
=oFnm
-----END PGP SIGNATURE-----

--=-DNWXxmTX1VkiqQAr8wz8--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
