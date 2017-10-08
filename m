From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 27/47] IB/mlx5: Remove a set-but-not-used variable
Date: Sun, 8 Oct 2017 10:55:30 +0300
Message-ID: <20171008075530.GP25829@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-28-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZVOC9e0LfXEId8h2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006213333.6721-28-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZVOC9e0LfXEId8h2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:33:13PM -0700, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 --
>  1 file changed, 2 deletions(-)
>

Thanks,
The "inl" variable was removed in commit: 5fe9dec0d045 ("IB/mlx5: Use blue flame register allocator in mlx5_ib")

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--ZVOC9e0LfXEId8h2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnZ2fIACgkQ5GN7iDZy
WKdNIxAAzZ1cK34vH6ofOVnmtmIpKqGwjfEvWkBVZBII0CmVe6M69193jfM68Rtx
0PmST5Vz+A3kAFzSJbUAxY7pgyGUtKvhucTcMSgZLxdGFzy/wWHL8meoEhSIvdRe
Tn/lANM6td5KGU3szf2Vs80JBbZMEhnmr8yWxVPLVmp5MMW+eTqH8xOCyY/wRY+F
PxQleYiQrb4hTg4oTo/Bh4S16QaJoIfMs2xbOqMPz5ck/ENtH//qajxrLoeu/iIY
uhGtZC9LxTUIBtntXFesGvVY84yqdmfIP7Xc+gqy0R+/9Iwdr3qJbKw4bh17BV6B
PXJHWOMKP8nm3iu/OtJVslKIwIPi/hAcGc1HYXsbcBpr4o09MgWF6eCM+CVpJWMe
7lKjl6lnkmV+iM3cCZuY7yrYvzNoFaP81/EmDZIq6dPWoCfq9Qxv7okW/2pv2haq
Huhrbj5NjWbR7LdfCMWGZfWK4OjZnD04pWTnrKNeLwcaTkmQ2mfExTz5PkfaM7j5
BA3+odU1ruac39VE89p6+8wZOFZe4UB29bsj3Jhw4yLjQTTd0tCEeq+dqr+8rIwk
Wrx0qcAqOAwf2HqO3uBsboAqE2aMIz6kIYf+X7d+J50AuabFNm4UCr31f6P8Osov
gTxmDnciArh01/LEqGbbr30DbdK1V9SABhR/P8e+b2lCTHl86SQ=
=pAM0
-----END PGP SIGNATURE-----

--ZVOC9e0LfXEId8h2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
