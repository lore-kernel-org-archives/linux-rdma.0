From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/core: Remove pointer casting from void to
 net_device
Date: Wed, 1 Feb 2017 19:05:26 +0200
Message-ID: <20170201170526.GY6005@mtr-leonro.local>
References: <20170201115126.7313-1-leon@kernel.org>
 <20170201131845.GA9782@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HPm2I89eDTDbofr6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170201131845.GA9782@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HPm2I89eDTDbofr6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 01, 2017 at 03:18:46PM +0200, Yuval Shaia wrote:
> On Wed, Feb 01, 2017 at 01:51:26PM +0200, Leon Romanovsky wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch avoids unnecessary type casting from void to net_device.
>
> How about going one step further and get rid of this temporary event_ndev
> variable?

Sure, I'll send updated patch.
Thanks

--HPm2I89eDTDbofr6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliSFVYACgkQ5GN7iDZy
WKfwhg/+JMfsbXu7b3EXi5A9cy5lrAroS+qTJVcwgl/oNOh3kbAWMcABE2a658w/
sC9VN7yn2lpWLBdlKa5sN5eU4jYd74TP3L2mtzUKXGWjhnZWzdSaqU8lmIvYpZ9d
Qw1ijZDd7alYZTZtpZdNLn/sTkvbcXCEommBi7HYTQR0bXaJsASiw3QMWQo93FpE
4W94ASKvW1XnNcw/ZINrCTW+b8HAxfOGJCRIH8pak/6tftxZx27ouolaiZ7QeGa9
sL0LH4oXEuLO8Pp+cgjW8qZT/MRDvF/JFimCAme4b9rB6ZUapkviDr1/W8g6p+RT
POPfPqwcjZ4AD1LJu0CZIBhAWmNt4Ano8VkoZDnIxEcRqrRgv1HBkePD/TPuBepk
KmRlOXgQTf/1lFaLZeXSgPbeprqi1rz2zh+z3umlXem4Mp44yOWOMiTw5KSo3+tH
vP/jfEsfH4r/ty6GAGeYJgMPQbcbO7kYxdH/Qfj66NLjRdYy6hVcdPDe7k+CK3jd
s9VJPdwuUg0oyiuOpn8xc2q833dDs364Yn4jqdKWLHTdZNDo2f1bKauqBOPcQGhG
iWH0trrf7GUIIxDs2OoaSpGxL5SrQaag0Wgnc7UA6UG4mVdPOjBNlH1szSD6Vj+L
92IajaE87rA+Vqw8OWAyPt5MBhRFwx8Py+edSLn7so3H2HBGLv0=
=WzNJ
-----END PGP SIGNATURE-----

--HPm2I89eDTDbofr6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
