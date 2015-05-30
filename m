From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] RDMA/ocrdma: Fix memory leak in _ocrdma_alloc_pd()
Date: Sat, 30 May 2015 11:26:26 -0400
Message-ID: <1432999586.114391.158.camel@redhat.com>
References: <1432966231-12125-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-bIAxUf8kXb5KacaZpOHw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432966231-12125-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-bIAxUf8kXb5KacaZpOHw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 23:10 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> If ocrdma_get_pd_num() fails, then we need to free the pd struct we alloc=
ated.
>=20
> This was detected by Coverity (CID 1271245).
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Thanks, series applied.

> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infini=
band/hw/ocrdma/ocrdma_verbs.c
> index 9dcb66077d6c..fcb86749efc9 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -375,7 +375,12 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocr=
dma_dev *dev,
> =20
>  	if (dev->pd_mgr->pd_prealloc_valid) {
>  		status =3D ocrdma_get_pd_num(dev, pd);
> -		return (status =3D=3D 0) ? pd : ERR_PTR(status);
> +		if (status =3D=3D 0) {
> +			return pd;
> +		} else {
> +			kfree(pd);
> +			return ERR_PTR(status);
> +		}
>  	}
> =20
>  retry:


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-bIAxUf8kXb5KacaZpOHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVadaiAAoJELgmozMOVy/dYnsQAK0SVc7rol3ZEkIWpUBu5lpy
SDnbvWQeE7jirRhVjGeAwbmvBnsLTvHNYpBpQLZ1Yvn2qxs0DkLw2TyjdtXdD6/S
wolx9jK1JMu07BXI0vLwqyPSRYQnlGSfKQzLYOpU40oyhaDOuxVAznZCflvMKGHv
XjymP7ME+oFOTmyLnwKx9HlCBGBpp3HzqRBHHYd1x27g0x7xVJf1SMzq/qm6kWnh
gkzlbsGQ/gViJPyHSJ34HcL4Ff65A9cqNg7Q76XmE7WAq6tVYgsQMXV1PN6iu3f2
8cR5ydkAGRFiaU1GEZD9UxS5rofhM1idrHaeNK3WQzFCvwIh8hHRZhr33W1jEFSQ
fVDvHSeF7NnaTdz3kploAYzdtYqlgH1dPR/oqOYfyjuAglLMsAF4rHnfcHxnwRlp
qBSOhY42w3NhVOrvuMWwWLxh4crupKDptL0iB7zxTpAqBuTX3zPXKS9KuBg7U466
JXSJ7JRtnMHkYcIFyl7d9g5bnKdFyijqlWMh0WvWWJVtpJlyuRfCB2N2NPweE6E2
NIQoaDpLEWq3JKo98Zbgv/3D0DK/CEc6f/nOXlcz9etLIsMqt50TAN9XnRhnUJs+
vCX6JUCGJ4BKE/u8DGLGR2LfrUI/UcqoDVPNMDm6O6zJO/6M2oplE7vagDb+13Yd
dsdXxTllXK4kfa4+KBws
=vdIJ
-----END PGP SIGNATURE-----

--=-bIAxUf8kXb5KacaZpOHw--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
