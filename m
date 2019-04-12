From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH][next] RDMA/mlx5: check for error return in flow_rule
 rather than err
Date: Fri, 12 Apr 2019 18:52:34 +0300
Message-ID: <20190412155234.GE3201@mtr-leonro.mtl.com>
References: <20190412104017.25507-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CqVFb5A8LpjztvkH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190412104017.25507-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--CqVFb5A8LpjztvkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2019 at 11:40:17AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently when the call to create_flow_rule_vport_sq fails, the error
> check is being performed on err rather than on the return pointer
> flow_rule.  The return flow_rule maybe NULL (which is not considered
> an error) or an error code, so check for the error on flow_rule.
>
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: d5ed8ac34cef ("RDMA/mlx5: Move default representors SQ steering to rule to modify QP")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--CqVFb5A8LpjztvkH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcsLRCAAoJEORje4g2clinJTgP/2fgwFUh66hOcloEsSa6Yv0x
SjrXPwLwu+ppyOsmqyYHv3bgHmqkAH2h04hCRjeWHOfEU5hK4tmqnLuSM3cQ2Uxg
sXGaRSaQ6aqlQldjWtEM0Qtu9PdxeA1HVyLRyACtUdp9ze/pIKRU4DNVswoCazkA
RdhtjyEwq3pmZz7GkBYNjEtQFLxSnshEaghQvVdfcSdKBDZ7atlNeoKYgmz5LepZ
Xs5UIjKC+9oqD1Fv5yajbWBbAbJ9GCjSVkt5XW7P+G7fwlafUZ97jUF0kgEVC4Ib
LmKBniv3bmTLOnT5n2np+U7HJBUzpJmn0eDELVjZefBZAoTtcceK+xCT+J2Kf2QY
VhTXrUBrkgrZn8p8V+25655Hd4fHLujyvaC07Yn8evbBD3k5A6iysnkctbi3cPUS
Rhwa/vYJA6v+CDpUrBo2fg2KRrvIi6ghRUsiV6ItwQFF2WZQp6rBUsq8Hyxv6fSE
zr3Kh8GZ9lifEAJU57fE/I7m3yN3u0lPc6nVrtL5oR3KCdK6ZvYBG7njuBUDDg9m
7LtHN6syTZu/XUVJQkOKahYBicapEJusvReP74HtEYtVk53q1wToRnlyBbcLB2Za
5anuw9n7kKIzEJZNlxe77lJ+ZIE5SauT97n+m2qRBsOydnmlVp5GIE1+KmumQ7ZC
ny0e5BqclAnp/pnO3lUX
=j6pB
-----END PGP SIGNATURE-----

--CqVFb5A8LpjztvkH--
