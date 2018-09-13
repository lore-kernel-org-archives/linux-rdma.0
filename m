From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH -next] RDMA: Remove duplicated include from ib_addr.h
Date: Thu, 13 Sep 2018 18:58:26 +0300
Message-ID: <20180913155826.GR5257@mtr-leonro.mtl.com>
References: <20180913134752.22780-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180913134752.22780-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 13, 2018 at 09:47:52PM +0800, YueHaibing wrote:
> Remove duplicated include.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/rdma/ib_addr.h | 1 -
>  1 file changed, 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbmokiAAoJEORje4g2clinKZIP/RF+2U27YSoTaPJtXYg+Gqnn
IbvWW/VZ4fnXmGKgm1k+SXh5rNnBeYVqrXFzHrGj1cJSWqiJ59V0+Rw+HH3mMIbX
NSBgLpX6LiZpy6m9zJosKG2YsbqBEj6khM03+/qXy2N7BagDvdgCV4dpqKcNv9v2
1AwCD51KUFIrPKzKdmrRq1dEoh2hGBLAxozZqpjO+J7P/gPkyVVqDqpgi6h7x61f
URLDV83W95KTXj2z8c9mF9OT5QQTZ8KsD6F8jtGIwjUdYgnkY7C1+5ZuqkpFHJRo
B3oHhVqJgiX4PjxlQnmUWXj3UlolgGLrvy8eXXJjR1dGCQQWmBx/DwTwYBfol8ns
IP1RStw/71mpIunzR0rXg4Yp9plD3jB7i0E2Xo+xY7T8qm1xxELQlGfeNcry3Q2L
XpuwgT6TWDGTIr4Jw5F93XEgAreVk+hdbvHsNlWN4GV9KEaClKko466+rp7/lvzM
cVXYVH8zDiTpi/2uIJvPHkGi3UQZQpm47DQOPI8jvI6bpIPEPas6Ehxw7IaCzt3n
7lcR8fAhXO05J2kVVFLUDASSYTwJtkSe8qdD6xtJYjGuv/0G9H01wj27D7Nv45m9
tRVOD2/E7n6QbMIz2Caw0PwU7V6xxkjcRTP+qgp+MQvTycuv7aun/f6uHrA69Do/
kQz0eQD9+ftGmDhRdwgs
=eKEB
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
