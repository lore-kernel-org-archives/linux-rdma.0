From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Mon, 23 Oct 2017 20:00:30 +0300
Message-ID: <20171023170030.GK2106@mtr-leonro.local>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jr7V/D3tXZ2+JpAg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023165118.GA18097-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Jr7V/D3tXZ2+JpAg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 10:51:18AM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2017 at 05:41:42PM +0300, Yishai Hadas wrote:

<...>

>
> // Retreive the counters from hardware or from cache
> uint64_t data[2];
> ibv_read_counters(counters, data, NELEMS(data), [..]);
> printf("QP counter is %u\n", data[0]);
>

<..>

> [..] will have to be something sensible to define the sampling
> point, maybe an enum, or maybe a string? Not sure.

Enum

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Jr7V/D3tXZ2+JpAg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuIC4ACgkQ5GN7iDZy
WKct2Q//UeTrP3TRi6JykcTRbpKT0uuTjdUub7HayrW9J8Zc5N01sGJQ6QR7oeDk
bAiIt9ln0KaQzpnw3calVbUbuObGwfrlFShEqROeshT/5hwPpKYi0VY/6d5Rqmzo
QzTnP/1aCUCgQXZk+dghDI5BGTU1kIffq2D8SEuw1CdlF+oJEzukKu+1za0hwEII
CYtJg8B/ouVJ5OlXTX1VWbIhzpNHQceWQbIQL6rlsHDKA2xqWOwosEGYValRDCMS
8o5DiHhIzra7bLz40GdBt6Dr98AN6j+ub2dC1NaijZNW1iVUjhMkk+kKrCNLon0l
zo7GTXf7/idv8WnKYNkcKDPVooG0U9IJySkvwNB/MqdCXcgkyMCFcEF1mvYQoyHS
p+Jw4AzvLBKqF2iNM2zlIGz+zBlxYZq3wZdjmXOypYn0JIkgn8vdnjxbVAuH0OR/
3tUnBZkEJiJvy4DD0a1uD4wJYxST3doAV2qMDUzR9V4xPJ9YjV+lzyj8sqbW2nLU
LW1kgkw53mFn/xvAEUrZE5GujcwdRQGeUIMaPgtp/hJ2xkjKvlZQmf6hQg4OgZds
T2/QYUE+6oDtIyt5ANmtGAqWA+Wf6XnMXpTUNfiJRZK49Eqr2ynHpRwB0PaYgGbA
WgBd3gorPKtdNumo0HZYqF1ZZdzciG/OGXVe6kWZTk05SpX1SKw=
=OV5q
-----END PGP SIGNATURE-----

--Jr7V/D3tXZ2+JpAg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
