From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH -next] IB/mlx5: remove duplicated include from mlx5_ib.h
Date: Mon, 10 Dec 2018 09:47:05 +0200
Message-ID: <20181210074705.GD3933@mtr-leonro.mtl.com>
References: <20181210072759.26128-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181210072759.26128-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 10, 2018 at 03:27:59PM +0800, YueHaibing wrote:
> Remove duplicated include.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
>  1 file changed, 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcDhn5AAoJEORje4g2clin4ecP/25J+S3sNfiveM55tBd5IRvX
viCV0tOmHz0vdgUAA6oYvJjUxz23ugeM3rUfE9oneUausF4QMjn2OaiJpL1li2rl
yNgHIHTjCaId2+4Zjo9AQpeJg8iyTLdrKK3bER/1s63gadcWRctRgzImc5caKHbq
69chEHpV/ke2jTiVi3gwj4/DY2G/YHhuizmgldfioVwHqablwPps0V8qZezat4GP
acslU0fHHMaYdLAgf3aKMJcn+cgdHoc9jFcYlrax2ejaCpGz1Vjoeqck7jCDoQ1c
JDMthgcID2i1PEkrLsQLKE9PkwE1q1iP5zIwAkte2mMWF6x18Nec7ZEYoLfZApdG
FzWBha4JRx7XaRIBPPbwSaCs7ILT/njzGtnkPdbR+LL7WJaIR5uIKq1FakssXW/E
2tZ1YVphjOGm22CaDG08TggGy8NK4EKvBzabon12/g7+vI2+hzcMA569VfccVrYd
CsuGr/0ikprgyphGLXIHyaBQxEn/Rz1DuQyEZ9r3Vt77/FKR00ifKGq8pei55XSo
fW340gb9No8SBefiK0zF7bFif8Aj4dIJsxFiadMMTR2Zmcfir5LO8DBNHBqg4keb
IWJL4IvUGgqjRL0rsmxF/P5g1Qb/OGb408or3zEFoL2m/LeEoOmmqF7RBDlKczw/
nJeLY6IRj/xb4FqJmUib
=So03
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
