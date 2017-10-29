From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/rxe: don't crash, if allocation of crc algorithm
 failed
Date: Sun, 29 Oct 2017 11:00:27 +0200
Message-ID: <20171029090027.GL16127@mtr-leonro.local>
References: <20171027155923.36156-1-tbogendoerfer@suse.de>
 <CAG9sBKPvK95UpxS_4SO0WxJuCyYrjAhe=Am-Ev2Kp+mQFxyYhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jz4B0QKJ3xxfGEtb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPvK95UpxS_4SO0WxJuCyYrjAhe=Am-Ev2Kp+mQFxyYhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Jz4B0QKJ3xxfGEtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 29, 2017 at 10:20:18AM +0300, Moni Shoua wrote:
> On Fri, Oct 27, 2017 at 6:59 PM, Thomas Bogendoerfer
> <tbogendoerfer-l3A5Bk7waGM@public.gmane.org> wrote:
> > Following crash happens, if crc algorithm couldn't be allocated:
> >
> > [ 1087.989072] rdma_rxe: loaded
> > [ 1097.855397] PCLMULQDQ-NI instructions are not detected.
> > [ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
> > [ 1097.901248] BUG: unable to handle kernel
> > [ 1097.901249] NULL pointer dereference
> > [ 1097.901250]  at 0000000000000046
> > [...]
> >
> > Reason is that rxe->tfm is assigned the error return, which will then
> > be used for crypto_free_shash() in rxe_cleanup. Fix by using a
> > temporay variable and assigning it rxe->tfm after allocation succeeded.
> >
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> Fix looks good only a Fixes line is missing from the commit message. Please add.

temporay -> temporary

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Jz4B0QKJ3xxfGEtb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln1mKsACgkQ5GN7iDZy
WKf95A/8ChOxhCTw96Pn/dilnO2ltSzwQ/8OHpDqxsCoC8OMuCrFyvIJMob1VBPY
WSuYZUzMXujo4TUNaNusc19/iygkPqXS5ZKxn9PW8pz9j1hBGSbPCH4pc1NqFY5w
q4H6wfXExN1c6rRFvumgU20TotMdoT4MiukP13dHJI3bjok3cNEf0X9XPkHMsxNl
QwTVbQnNUBYgp9KaqPKBqOfqEywICB83tzvnj+LIjk0pwiDrDt1U+7esPtQ4bCqc
sriW/CwP90IndXKObodurIciwDZAWsMbQjDRP1ypt4+Oqp+v/71pMwvhS/53X9GA
3WL4gAVJ2zs932MJXzU8BfCZyhkPm8k+OhsJ7OLLlqvIQdAFiPE283DAJ/RWpe+E
POdpROa6RJDnbfwWlZ7Ydb7GxqU6BXedYJjnqZnQIFCr0TFcngiFN6I831EC8UjE
+4yao+lW03gV2B6H5FU9nmxTRHRFjbuDf55RDZGaKN05oM5v7BytMhtBVVrC6pYJ
f8ZGwKXJeysH8QMqThmYLbGQjO8qFVzj7VEfMZDdWgEV305sQxi1oR/bMSzFGgNI
ChwyBi6PLqghNqg767to1/syg7nNL+9jiw1TSCCoSKx7NEChuHUr0Cy2meZr82ot
Zb1DPZe0Su2kV7ZOOJAgyk1E9rWmYMCb9p8xGB2DXnEq9B44go0=
=2wNj
-----END PGP SIGNATURE-----

--Jz4B0QKJ3xxfGEtb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
