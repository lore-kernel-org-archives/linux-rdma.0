From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 25/47] IB/mlx4: Suppress gcc 7 fall-through complaints
Date: Sun, 8 Oct 2017 10:50:01 +0300
Message-ID: <20171008075001.GO25829@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-26-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7pXD3OQNRL3RjWCz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006213333.6721-26-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7pXD3OQNRL3RjWCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 02:33:11PM -0700, Bart Van Assche wrote:
> Avoid that gcc 7 reports the following warning when building with W=1:
>
> warning: this statement may fall through [-Wimplicit-fallthrough=]
>
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cq.c  | 2 ++
>  drivers/infiniband/hw/mlx4/mcg.c | 1 +
>  2 files changed, 3 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--7pXD3OQNRL3RjWCz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnZ2KkACgkQ5GN7iDZy
WKdKXRAAvoBaJFjQuYOnU75uSr2Gwe/5vzowRjiQgShXZ06R/QXn1nTsDGG5x1C2
x2oOes8yYxwd9V4aesGTOSgH29xYwpyHOGdRlsqzXcnSoyvgLHJ16QYBOlUh8Yc5
4biBuvL+dwjKhk8z+bALXE26VtWnJavu19TnqrGpoYwANmdyTHAJYBKIWd+YWI6B
s+OZBzgqSybN9OnJwgK75uMO74FiElB9+6rcrH/HfZUgNIo6R7DCZcvi03tGudgD
Q/RhDtGHsU4ZBONjPlg2gyYOU+F8Y7knzgQ61eN2RHpQKm5gmEsBFqmSSz+Pnb9Z
az85a8E3c2woMHJtHFcxIstcPr/B9jENT39aRt/FWlEWB3VPIY1K/g2K+wbttPa4
SfKr7pBB5hEkjT2XzoiIV1hEAuSnF5xndBINdD+pwGopc4gLOZeNezaQYludLZQI
SfS3DLmMAF/iRTw5Oup9JQts/iZxy3J6ykitEvPPt4CGdVESCOGFiYiIRrYIKpr+
bqqTB8LtcB6AKh6rthOXEf+sjXM8n7LTWWSZYV3pGrzjf4WRoyBB7n2ho5YrvWXG
CIcah/6j1y1Kwu9PpZ9/jhIU/UK+37gb1H9D/TfayI5IQvK7FcsUln8GxzlNRqUp
IuTlBlDNmhLOQ/bNCuzf8pASQTUuT5SNuX3lFWFnRmF7CZOtpS8=
=jWI+
-----END PGP SIGNATURE-----

--7pXD3OQNRL3RjWCz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
