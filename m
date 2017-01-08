From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/15] IB/rxe: Fix an skb leak
Date: Sun, 8 Jan 2017 15:37:53 +0200
Message-ID: <20170108133753.GQ15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353777.3592.42.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m46qSNjkc66Ye11q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353777.3592.42.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m46qSNjkc66Ye11q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:44:15AM +0000, Bart Van Assche wrote:
> Additionally, make it easier to detect skb leaks by issuing a warning
> if a leak occurs.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/rxe/rxe_comp.c | 15 ++++++++++++++-
> =A01 file changed, 14 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--m46qSNjkc66Ye11q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhyQLEACgkQ5GN7iDZy
WKdtRxAAzd7dHKF4LKYsBodpjTLlQ2vmlLR2pMF/P6B+8pZDYJ3MuDjUrqG7Rba6
2tEXDdhtjgsBhXdfqhGdRKXaNfOh6ZysJMlIjAHtVuIcHoGkiYe/7x0n3osceMkM
aQsoXEFWKCyyLe/Mm2sx5hSImeKdS3o552kaSCFMJjdpl7qybxVUE4UyH+Q9KdjJ
9/x+edn2xKqGaKYUfi3r7PXdh9nPFuPESS3Y8GQ0F3/uD0qXobKelf7+uyo//xHm
zHDCOfKD3Y+K1QbPxjj1XFyDo3N3N9/pcQtgdze4RzfzEWhVyb9Yf6tC57IizVXT
5qc/xFo+WJRXYXycsgxpfbv3Dj2rO9VJAaoKUioPCwSeH2nMDg0XYtOyvoo2oRuM
3OF+4aqmqPGoFi+as67aw25utCvFrfJe1sestopuSViO6v6lSHo0Vy5MptQmpyji
8ZnFJgTNw3Dbuxu6JhMDIHBXWkDSo4OIhiLH9MWpsujECP722mJFJ8sSDIqLr17T
AnzZSJz956IiMQuGpBMBBB8P02FlX5my9YlMdI+ZhzA0hooFO/G8Nc75LUlzYrVD
Frz9b2lkgIPxZk72Vj7SOpX5ThQRE5PV+KQI9OsfgpDih4kTpwDxMy6l0+F6rncb
D/gajLIX4ILSFXD8XOXW6VXQjM28xa/YGV6vpKvFDmrKY5lQ8SU=
=BOpX
-----END PGP SIGNATURE-----

--m46qSNjkc66Ye11q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
