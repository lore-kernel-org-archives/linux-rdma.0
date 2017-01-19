From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB/mad: Add port_num to error message
Date: Thu, 19 Jan 2017 17:10:38 +0200
Message-ID: <20170119151038.GV32481@mtr-leonro.local>
References: <1484837311-13206-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJ3xY7yfhADm8R0x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484837311-13206-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IJ3xY7yfhADm8R0x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 19, 2017 at 04:48:31PM +0200, Yuval Shaia wrote:
> Print the invalid port number to ease troubleshooting.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Fix typo in commit header
> ---
>  drivers/infiniband/core/mad.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--IJ3xY7yfhADm8R0x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliA1u4ACgkQ5GN7iDZy
WKcuJA//UD25ft6cBtiWKKo87cJHKvxXu6G3pJRUTCgpAbDQC7RwTDA1iJZbw7L1
tp17lAA8BbNoi3DXO/fOakVzfE8UfTh6NqSQyA+vCD7Q+bbpL/xTEVMO/eDVEa6l
PSXrPyUKemlq7jxpbbTXOkdMPuRyPeCzOrLjjTPNDXPuLPfEiOJZh0Z87csMZTIR
YINZ2aKNLLbCp+vUX3+ELAFU7QHGj9w/VOheTldm4/na0vhJrc0xv9RipWsZ6CMa
+xh+ithguyopep9u4jGupGqV6T3vqP3kALWHFL46+sb2w1Rsaf1PZvG/Np7Dy0/l
z6Ilra0jUE8Quzs6tk9pxBH6f/J47Xw8aic/KUvwu0e+qeuMl0lCJQQ+npt2MI0B
CCUG+jhNVjbQiJqBZEqNciLgjP93WdIw4DDAVktk7xeEU5j68qorVp7ULPTxShmY
OcTlUiyYnbVXMec5Y+hiPWmEbHUX9XaFOmCEHHqCTFmuA32HsWq6oTKa+pOEU+BP
UnEAw/mflF2TfbgHjo1+lA0nbYJvAoqYXIgq4xOw6Y2KDpABhqmFxbXfkri/QSvb
LO3EKxgwLZhqKKtP/0XJNOmBo7/c0QX09Kv/ctOf3J8JEYjoeH7/tqwEJxe0EYtQ
YTqIf5gfO+sjlPWtCZFManl+4snztJ1kUgcTCBhjGw889U68Bzc=
=UMQZ
-----END PGP SIGNATURE-----

--IJ3xY7yfhADm8R0x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
