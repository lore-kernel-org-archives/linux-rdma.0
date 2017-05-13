From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] RDMA/iw_cxgb4: Avoid touch after free error in ARP
 failure handlers
Date: Sat, 13 May 2017 14:36:20 +0300
Message-ID: <20170513113620.GL3616@mtr-leonro.local>
References: <20170511114354.25046-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EEx6GiKZGZ1wKUra"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170511114354.25046-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--EEx6GiKZGZ1wKUra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 11, 2017 at 05:13:54PM +0530, Raju Rangoju wrote:
> The patch 761e19a504af: "RDMA/iw_cxgb4: Handle return value of
> c4iw_ofld_send() in abort_arp_failure()" from May 6, 2016, leads to the
> following static checker warning:
> 	drivers/infiniband/hw/cxgb4/cm.c:575 abort_arp_failure()
> 	warn: passing freed memory 'skb'
>
> Also fixes skb leak when l2t resolution fails
>
> Fixes: 761e19a504afa55 (RDMA/iw_cxgb4: Handle return value of
> c4iw_ofld_send() in abort_arp_failure())
>
> Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--EEx6GiKZGZ1wKUra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkW77QACgkQ5GN7iDZy
WKf8GA/7BRjmY950l1LiS9kb7VwRO7xEy/2hH2IhIyLvUR72ih1K41xZn8xj4VFB
0IjdsORvG/GqT+vl4vTlEekYHA4EGU9fgeLJ0NMV8Q50wN1TLCxFkFNXQBSLOo7J
JAcujZIuzrFIX8p0bQaM+1VQdewZ9ByRWM8/q8/gx6WrDGLqSWj6Ep1LOvtJpI1N
KJdwSqSlnvyQ87K6zNyocODFKBKQFV9IIAcR7WVWRFPi6LXY2kj8qba/tYzNt0pB
cRXlbIzujjDCVInDTcqkuKM1jTdMDc/QE5x63TxkePYlFpMuW4ClulMzIRCORaTp
XSnQJHuuaIiseyR+N71Xt4GOuJnz0uBBaARtRuewkjJO0voyIEHK+swrsxtOARqs
SVQCkIuahgpBuEVNB/Q4qtMXPWXFteSuDTgDpJgDgauc7sqx6htz4GV+6WSqkoge
wGRT3kRJhJlc6Yey2hqZDIJxo8EX4z0jZOvDYuzyCcgfBs7ckj3Px67X5NDb3tR9
V3x/0Mn+wsa5VwT5o7hU7ePprh0RtmUbBcFLVcKuIM1oLtrGjGlDn+9zz7xEcHok
oVz/o5DRqCw9JQKMXRdD/KEc82V373FC2NUC8NInmQHIqv9/fojAmk2vkmLT00Kg
g7GSHfWRc+6Xh796no6Wz7RKBbMWwkPXKsOtlUzOGYV6x9teq8A=
=7UoG
-----END PGP SIGNATURE-----

--EEx6GiKZGZ1wKUra--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
