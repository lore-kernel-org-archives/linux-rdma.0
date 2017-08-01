From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Potential uninitialized variable in
 bringup_rss_rwqs()
Date: Tue, 1 Aug 2017 14:19:37 +0300
Message-ID: <20170801111937.GK13672@mtr-leonro.local>
References: <20170801105755.vy4tqnmvtdtrbbo5@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1IYcr18XUmgwOrO2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801105755.vy4tqnmvtdtrbbo5@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1IYcr18XUmgwOrO2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 01:57:55PM +0300, Dan Carpenter wrote:
> My static checker complains "err" can be used uninitialized.  I don't
> know the subsystem well, but to an outside observer it seems like a
> potential bug.
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Thanks, Dan,
I made the same patch, but didn't submit it yet.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-next&id=2c714f9f58e2b6a27b941d7395f4f49a4d0e414b

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--1IYcr18XUmgwOrO2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAY8kACgkQ5GN7iDZy
WKcdHg/7BRknHAHYuNoYGwLy/7y/V7mSQvVGldMcMJhk29HmvFoWc1GQhXmE+uqS
a6ZycqumAYCN3gbfqRyEN8rwL6iJR+cY6xfPsrCSaU2D7trBTVdFhoHkHQFoscD6
TZg10Ag8OiovcF06VVD+A43lqaBf8nQAL8dBX44s+7Es9yLfbpKwkbZ1nKl5gICf
zy1EiRzSyX/JME5qAFi2m5Y//AX62SnOo2v1wbY8NLxm1IJuJF5t2YRXjatV+2u7
6y0fVFGoNSj4si0INKcInVepqgHLMFBxca4x7eBdjJomA3n3k3SFVpjtvQj5LJal
ck5ohktX3LpAyx+I8JjvxM/xOZrXTiUh/u9uSVXGniTjESrRveLxZfkx5ME3XQcD
KTRmQmb/gGoCciSek0vpSBZuwY+yr2G0vRUGl2DNcfCZCcL71FCZc0qG1TDZNt9X
UPNWFaOBoxSDKeCVzBjRB8WErcskr2vbtViTDahFHiNUU8q0ESainzKngS73WcCH
froFoIHV5xb0Cxaz5ha1m2rNRTJMSavHdj8ES04/qO1raOtasRmxlegGHx5/Nvxz
Jl5/jRhMsn6ivSpYm/C6sn9XdfFuZVaiZFHbbYNVpOkqfEZjX9BVeXp3BhppIubn
hxSJfuTUdN6jUtA+vhdwnguoNYdlugBQIN/r3bngM4x9wtscR2Y=
=x4ut
-----END PGP SIGNATURE-----

--1IYcr18XUmgwOrO2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
