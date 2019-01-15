From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/mlx5: Replace kzalloc with kcalloc
Date: Tue, 15 Jan 2019 12:39:07 +0200
Message-ID: <20190115103907.GI15600@mtr-leonro.mtl.com>
References: <20190115060048.GA9911@embeddedor>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115060048.GA9911@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2019 at 12:00:48AM -0600, Gustavo A. R. Silva wrote:
> Replace kzalloc() function with its 2-factor argument form, kcalloc().
>
> This patch replaces cases of:
>
> 	kzalloc(a * b, gfp)
>
> with:
> 	kcalloc(a, b, gfp)
>
> This code was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcPbhLAAoJEORje4g2cliniacQAKa27GuwRv6bwOSYLFEEo2FW
9F/qhfIjupxHk3BWle8XXPFrYiRNlYoL0nO35tFHL6ViXu7o3+seq1/SQk42xBOE
1A2zU5R5fqfpqyLxCPuuEr4ax4Y/lARi55sv9AUVfbNnQvgWgKa99JPq5C4VqM1r
x7unh4Xusi21huqIwOYIeFYKh974r8BneVRkbQjKF/sM9RNPEH5kFTI6Maj37Lcm
NfjN/Rm4aKnbtPeIPBF2CIdS+U9J3x2PGKrrZkjOa3aWXaMMMjqlyjscDd9KTxPB
Plpyf19pLpFa3qRHqCjPs4w5aRj/SMh9Q8O7pD99L4fECh6ujPmL6OihOfvdVjld
pPyZuABuc3GCr4w+BoDjAeXl2xvifoBOYQx3nAVH/JOe7q3xBNDUIRcH9K6lDdNU
cybYso3NBlZb78GoT+55flpjpFFNC3r6ybH6bMrNdaNlCNYK0Mok/4y1nacn4CKn
aU8eoEziIwj778teTkK0nHohsy6pVcMyqv/9SK32Oe3Xu2rAwdg8EWG7gd2U3c0m
5Pkq4iEw1Gut4E2r17tE++RrET1+it2i6c2JHlG9Oz3NlymFkQigKUaLrSdiaUFC
/rk+GNvDx/h49d2XgZAMrZA2x4k6fY0SViBFvFhTAZlSrNUwIFzgPFM7GKjzQir3
O+PSSEVJd/0YuUp0qbX1
=z5kD
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
