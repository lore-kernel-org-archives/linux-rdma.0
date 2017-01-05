From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/15] IB/rxe: Suppress sparse warnings
Date: Thu, 5 Jan 2017 14:59:55 +0200
Message-ID: <20170105125955.GB15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353409.3592.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353409.3592.15.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2017 at 10:39:05AM +0000, Bart Van Assche wrote:
> Avoid that sparse complains about using 0 as a pointer. Avoid that
> sparse complains about missing function declarations. Avoid that
> sparse complains about
> endianness.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---

Something wrong with commit message.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhuQ0sACgkQ5GN7iDZy
WKdBwBAAhsSX08UOnTAKKc5XnJTNUD8EJL9bCDz2S4icFe6N+jPZd0Qq90A+HgR8
XA4xJaN5UOXNs2ffR3AptLSe7PYCRTviFi2WLOEy53cLLvvg9QLO2xK6laPb2mwC
5CcqmrbM8u1MVteWsRVLqqxl/DBP+FjLR3JhHvOxK0aC8/lJ6upgh+GX6VLqyEMc
rYpK0OZRGcSBp4QtEcuEEwITKdSTBbfmXam9lBiua4dOIQ/L6Krt803LtnQTvmsL
naes74jwQntdrhws4f5iGneewp34LmX0SlzwOCp1BBwbQz1fU6wk2v4th416QUoK
Aira3sGvQtVUjJakLfeGvJp/DffHQN+IXKMCw5nkTfDeUO5UUG+QSWb0sPV8rgPy
TN3LyXEqmrjE8+/dleBdxm+HI9jw3twOao/Sot5TgFPu5Jfu1Pp7daBzXhdUvGTK
jypZiIy46nS0IjT4xpPnoKa1qLJXKulsvNLhGkZus+2Kmj/FASXFhKw8YlvWh3dn
z87mOIUBJhK/migXenaxZ3tW2nZJfYF/liPNcYQ9JG0rPoITOk9/BnBvJrmvhpxd
Rx8TZ+P+8sibJ/55oRX5FdT101x1Fo7QHSR27W79DL9AcO7jBr+8GCB7hAMSfTDf
oLiWvH+MtlF3pqV/Z6cU3bcutB2yTwf2oR4WQRtT1DvvDJdsVBQ=
=CPuF
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
