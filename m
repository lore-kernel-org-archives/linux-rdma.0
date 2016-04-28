From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Thu, 28 Apr 2016 14:29:20 +0300
Message-ID: <20160428112920.GA21343@leon.nu>
References: <1461830300-2851-1-git-send-email-omer.dagan@tandemg.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461830300-2851-1-git-send-email-omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 28, 2016 at 10:58:20AM +0300, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org wrote:
> From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>

Please fix subject line from rdma\hfi1 to be RDMA/hfi1, add description
to subject and to the commit message itself which explains why unsigned
variable needs to be declared as unsigned int variable and much more
important - COMPILE patches before sending them.

> -			unsigned free = 0U;
> +			unsigned iny free = 0U;
                                 ^^^

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIfQQAAoJEORje4g2clinsykQAJ4ME97qSdCn0rrB+oT4EwHA
A73ID6tYW4w717DLIO/YKPlAFfoClAzcYMh7CIBpCMue42xYn8Eh28SBQPEtAVNU
IiALB9NBUYJkTvt/oJyzOlH/uuv/vdje2ettPE+PznPlz/+Kg2CzDVa9HeLba1Eo
oRq/BeXJPVw6ne/KDYGEHSGpoV2lltEGN9o4Jyz756J+A50ZELEwf/9RUNUfI3KQ
Kw3IyRBDkb5EeObCsGTUx128/3Bcs6uxKECDt/s3dQSf6J6aIx/ia2XJlThI7cJA
jv1KjfvkhHNgioo/LfOPcGm5EpvGPuVGNF8xhgP6b4YCLxhKfsXNz2ZIf0/8BVSv
6ktTPUcJOSjq/FS/ZJjYV3FXM3TFJJBBLxo3w2E3pRwmIi5cBY96tLP0AOWhYQmC
GxNyxE5KohYirc+wHAEdxLXWK1PVQBJ8hTrv86srgIEb9j0PdEkso/uoUERF7IRZ
9hxo6TTXQrta6kAsl7pMsUsXqVEvbJqTU7WErO/9KScaK+1DIl8dAmXnN7DLg1cp
g9tV5fgt5pSLrBoWhcWwjYUQPMxwVqrqHpuGA07MF990yvWnvBo7yN6SMC0PEXXd
1h7+sfU3dFbaZZO9ILrsK+2sl8JsbkftOSbN6t6VTHTtce6Vv4+9aZukY2vNwNv5
wjtcRrTdzQk2auGcPdDI
=81wj
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
