From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Make function mlx5e_change_rep_mtu()
 static
Date: Tue, 5 Jun 2018 07:20:23 +0300
Message-ID: <20180605042023.GB2958@mtr-leonro.mtl.com>
References: <1528166565-54828-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528166565-54828-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Adi Nissim <adin@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2018 at 02:42:45AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:903:5: warning:
>  symbol 'mlx5e_change_rep_mtu' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbFg+HAAoJEORje4g2clinPa0P/RaCB9/9hjcuSUwI/rSgNgEf
RRW5y4iT/aPOzcNNq0ZSczWZveAXjRKDFXWd+EIytNwtRs+mowb5U+1n0DQsADcA
ze+C5vvvDq6UguYZdsQ4XcPxlaLqkYYPFEYNjhZ4Y/5tKDBJ2U3WUe6ltxyXvsGX
HQxZXkzZ6IOKzHOOACyNDgLH9jR2rWnLxyL8/JCgxWqwf/9S6RTGIGHcfyr+5UyK
NCX9hjn1swt546bL8JP63DBpKqe/zmcQxPi4PYTMXlTYV7U4N1SAyZW5dfeaDGIs
KymUl+5HHgL64E5TDxSZ60flPgU+igtpnVAeFHQsYgJy0FB3N5CpxtOrY2/T+duu
sIW5GKgrfgvlNkUCtW8xv2Bfydqv0SZvvD9Xt5OdRgH1Bt1Mp1djRvdqQGfB6EN6
uqWUHWtvKb4QqYxEsjMWgWC2vDuEeVqFibvRFkJbiNFEy3ZdmqAvdmz/gK7v2jXP
0FSTQiUVNsRWQ3Un8ipN08WG7sqysk59BWj/i4DPyAvZAf/3l0v3+UAD9wXW+2ta
k0bbYfEaH3KX/GXe+fw0m5t/8ioASpH5nKFasXrTUNpnB/ptT2EAQVSVLlZBWX8C
PPNzZPedwFtO0NSrfBBWBViZMF3F7ALFf04cBUGMLCc6/Fbhrg9Y8xWx+5Fdngqj
xtEROYKJDRlegJByIteE
=bQVN
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
