From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] IB/IPoIB: Fix error code in ipoib_add_port()
Date: Thu, 13 Jul 2017 13:25:58 +0300
Message-ID: <20170713102558.GM1528@mtr-leonro.local>
References: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8cfH1LqeFbt1HBOp"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170713074548.i6cgpjhmmcnvtd5c@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Erez Shitrit <erezsh@mellanox.com>, Alex Vesker <valex@mellanox.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Feras Daoud <ferasda@mellanox.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, Shamir Rabinovitch <shamir.rabinovitch@oracle.com>, Paolo Abeni <pabeni@redhat.com>, David Ahern <dsa@cumulusnetworks.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--8cfH1LqeFbt1HBOp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2017 at 10:45:48AM +0300, Dan Carpenter wrote:
> We accidentally don't see the error code on some of these error paths.
> It means we return ERR_PTR(0) which is NULL and it results in a NULL
> dereference in the caller.
>
> This bug dates to pre-git days.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 6e86eeee370e..ddd8114b6713 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -2212,6 +2212,7 @@ static struct net_device *ipoib_add_port(const char *format,

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--8cfH1LqeFbt1HBOp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnSrYACgkQ5GN7iDZy
WKfnqBAAmbzmAG6zL0ekkEM+1LLmofR23E4sCUNOcYj2h0k4KGFfUcy2b1Pc22b5
xZzQvXP2P8rvq1UnsgS636QMzCJWz3yISqnigICnbOtkKjgNONYffX39BVP4rRzO
Ja7zHcCfI0hkC8dxvtAJ34qSjgwN1x6L4+7XX7H6JlAPjKyD2sg4qj6a7eYhsA9B
g9pYF7pqiODk/GCf1JeovH0XmH078wsQvOP/rrTR2721DHDwCS7LGkrh7604Xbg5
9OAohyrcU3nw9wwHozGRKUB4RA+bGyrMve2I2KUQFYcW3LihSfG1lC6p22pdFJ5o
ruBIyK2kGSI1IfIEhphzMgcb5TsudsU1yQXzdnK2pEaCjYx0ysbqGEFgj2MAu1EQ
XWoKqlSH0i1BHPzDj0K8LwLxSRVXxpY4r+4mQ8BnnFkj0MTO7xSsex+CiaQFpksh
46MLANlai4Ge6yXXAb8vGVlXL3DiqwvV6p6ESkSGUDtKxbIoAuWGzpbddaLYZDgd
7hgDf4ENlbHIxgdywhU0koGBSyuJwh0EpVGpaHAjbaimNmSiDdVcz/nomn1cdNN5
Qy7NNu442OTBJfcc6q+8Y5eKMokLT6B+UhQDL6Jm1JgcmhY2+Pk9zHGg2Meijw71
uGJmMzFzGICcvnfzmymh5D8KPCqoKjHIC/glGbG/9MHXuWrbKlA=
=OKqz
-----END PGP SIGNATURE-----

--8cfH1LqeFbt1HBOp--
