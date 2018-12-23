From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 02/20] net/mlx5e: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 11:40:26 +0200
Message-ID: <20181223094026.GO3940@mtr-leonro.mtl.com>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-3-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hHiQ9nAwW5IGN2dL"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545555435-24576-3-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Saeed Mahameed <saeedm@mellanox.com>, kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--hHiQ9nAwW5IGN2dL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 23, 2018 at 09:56:57AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares is never used.
>
> These became useless in 244cd96adb5f ("net_sched: remove list_head
> from tc_action")
>
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
>
> Fixes: 244cd96adb5f ("net_sched: remove list_head from tc_action")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--hHiQ9nAwW5IGN2dL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcH1gKAAoJEORje4g2clinezYQALJ4CE1YSPVZl0v/mro+VPkd
ibEjMf6lCI9/I2ldfbwlvzZfEVE5KKILn0YCwn614zvcnR+Qvvb1Pt3tbsxWGsIj
IZ/oZMhuIUWME7TEiAmxK+UvqARbgqseVykG0/1f7CajispL5WVp8BdVCvAiUcgE
JtAkJtyjByHAvCWpWutQqWqJ4cq7PLlGKzOPFhdh/nfMpe53iKCRyhB3xrTEbCF0
ETU1GKujnbcQY6F30SNTjPn7I5EOCTZlfqop92o0391ypVXewnKmGACgm6fIgrnm
FADP2CckVunXd6jAodc5VUJj9cRBIRdV+k7O3YS0YOjOMk48K5JqM6VDbEmctdKQ
d5YV4alekhnN4dlSdktJod5J4npL6DX9OcNTZk8FnDmyX4X0nP+uODY5G9Aie3Iq
jb96mi4pZrQry/fky0DppS1SX6W5yrjiH/qhcagHFHKxmUc2sAE9L27wFUBVw0B6
wcJc6eWJxCkuoHc+xD1mZz/Eo3I60aVoJPX5WSSnchkgFNpT6ZnaMWl754JlBfbP
iok/mUYp2nYDqj+lJxi2a689T3ossODrS6x4rxmruvU4Y+5DVSZ0q3QcGD779kxi
XFdqu+O65uDcU4lx1HD5wWYjfCAvwnHLvTDFuXdkbDZ94lO7o1k/9OmFiIFNDe91
Yd4Rh70MvMJ1TQElNTJ+
=v4sq
-----END PGP SIGNATURE-----

--hHiQ9nAwW5IGN2dL--
