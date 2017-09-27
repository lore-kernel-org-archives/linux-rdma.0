From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 03/12] IB/hfi1: Remove the debug trace message
 in pin_sdma_pages()
Date: Wed, 27 Sep 2017 18:30:33 +0300
Message-ID: <20170927153033.GH2297@mtr-leonro.local>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
 <20170926140016.15601.51658.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qVHblb/y9DPlgkHs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926140016.15601.51658.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qVHblb/y9DPlgkHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 07:00:17AM -0700, Dennis Dalessandro wrote:
> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Remove the debug trace statement in pin_sdma_pages() that
> gets executed when there is a memory allocation failure as
> the trace message doesn't help with debugging the memory
> allocation failure.
>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/user_sdma.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

BTW, by looking on something else,

1. I saw that you are not checking for kcalloc failure in drivers/infiniband/hw/hfi1/verbs.c

1138                         empty_buf = kcalloc(extra_bytes, sizeof(u8),
1139                                             GFP_KERNEL);
1140                         seg_pio_copy_mid(pbuf, empty_buf, extra_bytes);

2. The following code in drivers/infiniband/hw/hfi1/sdma.c, can and
should be replaced by kvmalloc. You are incorrectly open-coded failback.

1467                 sde->tx_ring =
1468                         kcalloc(descq_cnt, sizeof(struct sdma_txreq *),
1469                                 GFP_KERNEL);
1470                 if (!sde->tx_ring)
1471                         sde->tx_ring =
1472                                 vzalloc(
1473                                         sizeof(struct sdma_txreq *) *
1474                                         descq_cnt);

Thanks

--qVHblb/y9DPlgkHs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLxBkACgkQ5GN7iDZy
WKfohBAAogqcr/30vaDq1rgtjeXGldRQQKQHKx/YIeh+ih+Dh9gg3uvuKE3Y4nld
6mU/9ucnyXndmHvv8K2L5pS55gJ930EERXVlOrAq+nfJB9OQcKsLfy141kSXrLTi
cfHpfzoKLZA8mpdcKig9LBAVWr1e/6EIw52u/LjLiw3fWzNotoL8CF3EwTgvJ8T2
ivaNAet7KPFcWjixOrGfdEjsKkn0Y/7uvtMgqyMW9ESnkibymRInuoNB9Rr1C/x4
hS3ihWrPy9qoQj+wScbaIALd6hWRi2TpTuq6tNI28aOrU8Nl2UlpE48Gm8w8U5GQ
hcmG9HDJQGiKrvEuFkxV9bGWRoJ9cJsF8+3/KJcpx9gVQ2qb3eUjmKe75iQV3xDB
wALoJso2v2my3OfjP0TDMnM1EHQOzYJ/Cvlr8qCG+N1jYNk4g1NYI0SXiGPlPGBc
2vhWOfd8EFnyhvkSf5uE9Q+Pb05zZu8xw2Hr/8y4/xaoI6Le9R3NhAUdSenQUERH
ASrV6QC7ZLi7/P5209fX5VdSgzl02oNQta+4tK7xLQvrmhgdYUFYR65vvU06WH9f
2Qd3H0pFL4hVhoiUabKTTPRjVDJJwLCOI90HjFFU8F2390fyYT17fVc0pi83HIM0
HPvi4OrnIrgipoHXK7Pgqwl9GqdnaMUEfuV47r6cvD86p9vzQWk=
=bYRd
-----END PGP SIGNATURE-----

--qVHblb/y9DPlgkHs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
