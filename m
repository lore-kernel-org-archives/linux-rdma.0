From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: Remove redudant label
Date: Tue, 14 Feb 2017 10:57:06 +0200
Message-ID: <20170214085706.GI6989@mtr-leonro.local>
References: <1487061792-6279-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487061792-6279-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 14, 2017 at 03:43:12AM -0500, Zhu Yanjun wrote:
> There are 2 labels to mark the same statements. Replace the 2 labels
> with one versatile labe.
>
> Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliixmIACgkQ5GN7iDZy
WKeMvBAApcQA9978tNyVc2Fw4WWTVBd6WS4WBsdnmiWCo216DHNtjRA7QyVXDm8j
U8WWf9F2qv8rOT/HrodzNVqnE2fPJVjgWqLUOBk/NhbNQxS0ZWWAjt2S7D4zZZZd
LxXY4carDJI2/SCv6igBY6RaBLjYyajOiiQWefSM3cumpV6lsZtc9H77EaH+GL31
8GlNU3KnekfdXrEB51SXuOz9RUIGY0lHmfDiI9lvjZkyaeMJH3axxjoI54meh7/C
Tjk/dR69hii+1d8mqqleCOZmyDJgQE2KKxk40kpn+VHIkPxsbXqygBtfHAgGmmWG
PMyBG4B6I+uD+VfI/MVMYD/SEJQ8xH8amTmcQOftl1Rb94k/1m1LDZ0/JJOTsalX
s59Prstum00jP9Byu2rl92x2gwSng8QT5ZIWzoH+4h+AS746pJ0esHzWNYL+REGM
hu4dzSbaEDm7Rofx/ECkq3NY+8owtl80XPyeCZKDbaP3CPFitdGORh0WP2F8tvtX
2ovLJbRXXMbp+h7N6fuvKFKU72nIrQE2h27miNoJedz0rsaAH9yZOaGOolsQAyBX
wECIFJmRIbxrQ4kykfpsS+JyDrCRALaGwgUJn5kalT3WrB7NkM+oi0ikD3D9eja/
XD8SIhpADu1LpYuFQwgSPTTU7a4LBGyx9eNDPNek2dNodhJBjdk=
=VWMQ
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
