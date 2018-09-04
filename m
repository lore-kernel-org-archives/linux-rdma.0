From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix atomic_mode enum values
Date: Tue, 4 Sep 2018 15:05:40 +0300
Message-ID: <20180904120540.GC2796@mtr-leonro.mtl.com>
References: <20180903171928.19348-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rd/3IrB17klb+Ksj"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903171928.19348-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--rd/3IrB17klb+Ksj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 08:19:28PM +0300, Leon Romanovsky wrote:
> From: Moni Shoua <monis@mellanox.com>
>
> The field atomic_mode is 4 bits wide and therefore can hold values
> from 0x0 to 0xf. Remove the unnecessary 20 bit shift that made the values
> be incorrect. While that, remove unused enum values.
>
> Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  include/linux/mlx5/driver.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>

Applied to mlx5-next: aa7e80b220f3 net/mlx5: Fix atomic_mode enum values

Thanks

--rd/3IrB17klb+Ksj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbjnUUAAoJEORje4g2clinqT8P/RfV8tQM6Rk34AIJgWH5l70b
EBnWz6MOgUB+KUz+n3bJR25Cdr1e+7qyDhiBs0BzjH9kpLswLz8TJR5n1jNJOlei
sLNBbmFopcEQNtFxbrxtYJNkB37AUexPW6UEG3tFN+UfOHxwG4OxSZVosZWX1T09
Ss2ikH8SIeZI31vxNyHCgy/XlF875HwxDTyQBM1/6ETvSsUKbdfF2WT8E7NFAqE0
tzKnqEOa5sQJSZ/a5IEC+ePGCChCGIdMuPPVNl4GBsWuXqF0V5nBZeQrn7pS1mq9
RxPp592Wb3vXa1eGH6h0As/SjVwRLDI2w7oD26qodzamXfqglAGiXsK4bzZkqhK4
+9DJpaCz83q9D28ovPv16ZiiE3Zm8N9Srj4xSm31QsG8tbJsOsy83luheQSa8VgK
Q5xHbpH0gNY8fjBS2ew3NwK5wpsU3lWRt7rsAAtbEJEzXxINFjowAP8c0PSH4D7J
VQshkUPUjTVkbgS9AUWWzvwRePsZ7khztKTxV7C7MX7VYtQ1rTPyb0a+5wpZs/s4
jhMAruossQ7Z0p9J37RzX0+mk5T2d1L81Rjk2fbx2U8w5rkvJaGAtTqIfSVOD+Gm
GKiEOj7H7UbErxLLWL/DCTz9qElWt8TBNsBycRsczS1sKz6cS5+kn7Iu6KvSJcvX
+tOMvjNLxgE1oqj4QK3s
=KXXA
-----END PGP SIGNATURE-----

--rd/3IrB17klb+Ksj--
