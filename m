From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: Remove the unnecessary error check
Date: Thu, 19 Jan 2017 10:35:07 +0200
Message-ID: <20170119083507.GO32481@mtr-leonro.local>
References: <1484799366-3463-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5nbaS3kz4OSBzmjj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484799366-3463-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5nbaS3kz4OSBzmjj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 11:16:06PM -0500, Zhu Yanjun wrote:
> The function ipoib_mcast_start_thread/ipoib_ib_dev_up always return zero.
> As such, in the function ipoib_open, err_stop will never be reached.
> So remove this err_stop and change the return type of the function
> ipoib_mcast_start_thread/ipoib_ib_dev_up to void.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h           | 4 ++--
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 6 +++---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 6 +-----
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 4 +---
>  4 files changed, 7 insertions(+), 13 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--5nbaS3kz4OSBzmjj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAejsACgkQ5GN7iDZy
WKeCLRAAvneEGOUu8js6+8/SJcc1QXvmLG/QMmojAlFP1qzmXBXJ6C5/8O4KVEjt
MxybburcOG/OfYxi/HTMc8ymriCPtws3EjI+v5ZgtPXHBpczxNtivpJuL1R547D1
6W+fIKEdbgSSYYfrjl5k09GiznKl+397s0ptZO4Wtva71r1c3ac+V4HO672yXiFj
P1fDcugteoNjP/kUzmRr04QEIMreQCEa+hiPBQzjR3qaNF7s/mb2Etk+gjRrzTb2
GcGbs2w1F3YDPxJIFatYmAxxBaIKfjHeDcymsdeOceQ8FF6fgRTTXrhfklh0+Uk1
DiLAp4cPi44gXCzYJPFkTiYfIo7RQyzSQYeaf0dzqETPbpec87v1hJT474np7Tto
rV7EoCBseaIr1zkIelYuropY6apQCtuU4nLJo9nWBX8N4oS1LsI8p0Qza6Pn+f5t
BAtfyFwZyWZCx1d1oH+FAyeA8g2IpKiIcBhrU5vhGXuVKBiv9NgAW8sSo71cY+Er
AkINqMjANOxHUBHU00uBY8wI3oq64quK9H09EDgep9ZHxRgp2ea3Hmd1gUL9MvZZ
x38D/vXQ2Zk2Tvo/uHcc7VJwU9gcagRAci/ac01LnVdKrzR6x1uP/5XNDq1hUwxQ
+lbWxpUEoOh3xtRAMx346dD/F4sHYPyoI6hT32SYQdcyHtTErbE=
=Zeo7
-----END PGP SIGNATURE-----

--5nbaS3kz4OSBzmjj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
