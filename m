From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Performance Improvents for Secured Mode NVMe over
 Fabrics and other RDMA ULPs
Date: Sun, 29 Oct 2017 19:43:21 +0200
Message-ID: <20171029174321.GM16127@mtr-leonro.local>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
 <e1ba4993-5c77-4754-967c-4da8ec34bf77@grimberg.me>
 <8cb59a0a-c902-0c0e-27a8-fdf9b98982ac@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i6ZTfQE1Row3TVml"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8cb59a0a-c902-0c0e-27a8-fdf9b98982ac-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--i6ZTfQE1Row3TVml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 29, 2017 at 07:09:41PM +0200, Max Gurtovoy wrote:
> > What about mlx4 btw?
>
> We still haven't try to improve the mlx4, but it's on our plate.

Max and Idan thanks for doing it.

The improvements look good, but I wonder what type of testing did you do?
Did you run full verification suite on it?

Thanks

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i6ZTfQE1Row3TVml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2EzgACgkQ5GN7iDZy
WKclmQ//Uwgu09JArCvL2hyrhTuCx++H98oVFBj0evVkdzKaqfP+6dPBB0CgqxGN
t8G2Pl3bYpO5t/KDqqSEYpVp0gHghdu/KFBgYWhEQ1q2c6FNlxy78z1Sr//Ya8T3
80CtUSYn7UjGC0jsX7Iq7KuepoV0fNwW2oVpdGRzJW/xwXSJUQF1Qr4nr3OhldKs
wwSo5LFijVaUm2OPOihph5zU/MZs2h9TG8zH70A0Fpjwce1Nmq8xuVNTRnpLTj31
4p3IDWEsq7xroS1Nl1M2iYQ2DgMnthqty+1fWRFAo4ICr0wHCfWqJPU/JfAQwI/V
Rovvh8borf4X9xxie4J5bx8dJWzXSB8EEXRGxD+5Yi959VpORd+XC7bo14H8YlBQ
NS+KINK0mG3yJ/d3HvD6ebQ2JWA2lHxjTGrjOMkvLlJYAQwgXKgfTiKsATfbcpp1
kES26+C3MON9GW4tQfMz0e7SIFjxbS8AMFBBlH2edfdEGY7lTSut9ejXzG3jt0Ph
rzPSANOHGxsOKu/4XI4VMglzBhivlakE4eOoMh9LcRop1TU6t1aD3mRNYXFPYuqZ
6LzHrgfwRhlVl2SLtlriA8QnaJuHxrFhZ7QlAh3iaNpqwg2ZNvbnR5rwg4eYlSM2
iRN8DEldqTcT0l0K/O6JE7CLKXbS8thXfGBXCZM1GFadDEgFu0s=
=92DH
-----END PGP SIGNATURE-----

--i6ZTfQE1Row3TVml--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
