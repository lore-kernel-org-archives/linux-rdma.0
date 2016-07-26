From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/28] IB/hfi1: Fix to fully initialize send context area
Date: Tue, 26 Jul 2016 08:26:57 +0300
Message-ID: <20160726052657.GD20674@leon.nu>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
 <20160725203759.4800.2358.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5PPnVwj6ulmYFu5t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160725203759.4800.2358.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5PPnVwj6ulmYFu5t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2016 at 01:38:01PM -0700, Dennis Dalessandro wrote:
> From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> While handling buffer control MAD, partially initialized
> dd->kernel_send_context area may cause potential dereference
> of uninitialized pointers. Fix by using kzalloc_node()
> instead of kmalloc_node().
>=20
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/pio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi=
1/pio.c
> index d402245..a99fcca 100644
> --- a/drivers/infiniband/hw/hfi1/pio.c
> +++ b/drivers/infiniband/hw/hfi1/pio.c
> @@ -1956,7 +1956,7 @@ int init_pervl_scs(struct hfi1_devdata *dd)
>  	hfi1_init_ctxt(dd->vld[15].sc);
>  	dd->vld[15].mtu =3D enum_to_mtu(OPA_MTU_2048);
> =20
> -	dd->kernel_send_context =3D kmalloc_node(dd->num_send_contexts *
> +	dd->kernel_send_context =3D kzalloc_node(dd->num_send_contexts *
>  					sizeof(struct send_context *),
>  					GFP_KERNEL, dd->node);

Dennis,
Don't you want to check kzalloc_node execution success
prior to use dd->kernel_send_context?

>  	dd->kernel_send_context[0] =3D dd->vld[15].sc;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5PPnVwj6ulmYFu5t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlvShAAoJEORje4g2clinEUwP/208gPkVwB4AJPuPlOq8PAXV
dVFwW5vFVsXJqZ8RaJaOVGR7rzibOT0evkCtQKvu/sUWgUicDP7WzJoH9pOctkNs
GfQHFwh8/905vuS12l8qZ4DGpFCHcqNIVdX+xdbaKRYJqBGekSjNEYKDqjvsB+mK
jitHxPfhjb3U5BAngAGOkRKUtI6+DNXXKAPKCRPjysna5tgfftkvptAAtjyUAC+H
6Gd+UiyTDqi0Xa6Q4207lah4FSlr6hdlyOzSnyYpwYfS/wnX8VdbSWY8ZSnDS1Lh
Q0i/yauJjKkE6yPUrOBYhq4JguUuqqgo74WROrOEViTjqs/JiW8YjPhLi8KF87Be
qIdka5AxvPkdRmX2bgPOPJqZwd4Ipr0NxAWkU4OIxkEk0AsG7OOqJM7qu+4i5SSS
bv7nmJqGW+Pl8vuFjmk2L/PuQ4DHFbrcGWa3wJtJ1ocw8B+aaM3QzHMmJ+b48KZw
wyQ5cQjpj9zWTZuZomhDuyKIEp6rFuNBB3v13MQbV3gUlhtUWpVYQu4Oizh5NWvp
iNW1eO9bnp246MKojnRO+4bl6lycU4wqFCTdkfyE0S/0CVkvVaK3l530O1fKHiDD
v9+PTnP8zmlwgGbZet0MhZWNdh62XrzENG9O2vMAFNG6rA4kaYc/YyTurGI37VUg
K9p+15SWJzDE72xSzKkQ
=lmJn
-----END PGP SIGNATURE-----

--5PPnVwj6ulmYFu5t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
