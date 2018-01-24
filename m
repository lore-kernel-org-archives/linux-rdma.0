From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] RDMA: Use standard way to check return value
Date: Wed, 24 Jan 2018 15:18:09 +0200
Message-ID: <20180124131809.GJ1393@mtr-leonro.local>
References: <20180124124301.10884-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TXtjXAp+Y+VkYOQB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180124124301.10884-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TXtjXAp+Y+VkYOQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 24, 2018 at 02:43:01PM +0200, Yuval Shaia wrote:
> To be compatible with other modules/drivers, change return code checks
> from "if (rc != 0)" to "if (rc)".
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Add some other fixes (srp,iser and srpt)
> v1 -> v2:
> 	* Accept Leon's comment and change commit's title.
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 8 ++++----
>  drivers/infiniband/ulp/iser/iser_initiator.c   | 2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c            | 2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c          | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--TXtjXAp+Y+VkYOQB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpoh5AACgkQ5GN7iDZy
WKcMdRAAszEk7wUGUmiZRAeCExcaSZl3EKgaC+BZnTxpVwNWaGl4EJHqCXCPCVAQ
+ayJ5gCnPtUXTYQ6HmSiCFnIjU7ImYpMwkejouWJWyv1E7v0m04GSFLCJ2TZZ0xh
/lPRUKdnmgU3Q2SuNK4XTMUXEIIL7gmTf/yZN9rnBzQ2Hyg93ozhRr3Z97Sc/Cxv
k0ZpfrPwFDHDysE0gul6rnbIYLo2YcjUyHvp/8UdZlqSzsdllEpQWXh2d4eWxaV/
stjcweKthBgQRihOnBwjgG82j/6E58CCGvIlIZujBNTV6jmBPYanFo6QBtpHZL8V
97Kqxk3glmXP60wRCGWGTvjiMWablmn91OV0Lk4XeRHZsbp87hAHlSvT0ujyTmj0
Z3fgkNIrRHQW1/OnavW1gmzpLBKTA0l3p+Xjzkr8vloXTR54vNR91fX4O9lc8iyD
ggVSItsYoJB7hgn2sqY67XEf1M3pntY19n+U6O+mUSlWG/GSKXGrHkvpKN6ODcMx
U7RYY2QrzolgrAymNTBDVxWH9tLi7r2vNKiCcjxNtDUPMw11njFQ7FDlI0qltYZx
pfOVUTbj8Yqq+d1I7p9h6BZqiGf11rWECi5DdyJgR2pN7foRaWBnWfN0HEtlU4HD
gQ1IivVRmbTnoJUe1ykeF1zXP2PHCqTJ813d8Zz4B9+xgBEaM14=
=pmYh
-----END PGP SIGNATURE-----

--TXtjXAp+Y+VkYOQB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
