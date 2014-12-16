From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build failure after merge of the infiniband tree
Date: Tue, 16 Dec 2014 12:47:50 +1100
Message-ID: <20141216124750.153e3fdd@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UQQO4pX7abOKhts/BrsgpgH"; protocol="application/pgp-signature"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--Sig_/UQQO4pX7abOKhts/BrsgpgH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
drivers/infiniband/hw/mlx5/main.c:248:34: error: 'MLX5_DEV_CAP_FLAG_ON_DMND=
_PG' undeclared (first use in this function)
  if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
                                  ^
drivers/net/ethernet/mellanox/mlx5/core/fw.c: In function 'mlx5_query_odp_c=
aps':
drivers/net/ethernet/mellanox/mlx5/core/fw.c:79:30: error: 'MLX5_DEV_CAP_FL=
AG_ON_DMND_PG' undeclared (first use in this function)
  if (!(dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
                              ^
drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function 'mlx5_start_eqs':
drivers/net/ethernet/mellanox/mlx5/core/eq.c:459:28: error: 'MLX5_DEV_CAP_F=
LAG_ON_DMND_PG' undeclared (first use in this function)
  if (dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
                            ^

Really?  Code added half way though the merge window not even build
tested?

I have used the infiniband tree from next-20141215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/UQQO4pX7abOKhts/BrsgpgH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj49KAAoJEMDTa8Ir7ZwV16IP/15ZzM3O90EgQsDh2NCZ9HyK
SuPkUwMoLbI+/a4TjbvxddCBtxb6WXLnxyin8uUT+92ZtH5wq/bjqL2OOeNutL1s
x0uVOfWBu0L6FLvZlE/sdTNW5w1yQbDX6jRrSrupjGVffCYbYU+vC4p9ylceMpoF
TeQczsZFZp8FDiKXa4nSOV4Fp2zLvZtk4G74kPyFVf6AVl/l4+Uc+UmhzjbQKk6s
h4+RfqVo76xU5qRnWEogJiJnLV1zlgI3HN+WOZUKTDa3O4grIJMvax2odYGNPUF9
HrQsRqyLsGcFXjH+thTEArcEpYJ5Bhq7plvK8Gv7d1FfIzxgoNqCHKVnTaWdXr2s
yENlVsWca4pJyN9ioCvzjDRz3M4v2OtfErEc2/cC30akOGKHO8HbDWkKrGvfw9Gd
McWGPFS11oCfYoKH5KIRBvexVJvnyLlFuxYwRCLUCN0QmJHqlJoFTy4gbnxtxukw
qV7ncDpdTaR5eJRtU0Rz9BL3ZTFO7HDTgyE26GwNrFWThMWivstLtMV9n1Ip/D/2
yWmq12ke48aQ27IiE68sPgHzS0yI91q7KebKd/5agxYrJaAv2QmrHMJ2AvwZRjkf
ezvN3bnRUzeLIydVa2gRdk109ozVoGbl5ziXiYvjAnmbgYVfSIyv43neeuGNskhc
Vv07z9NgxQeLshEZh9tf
=HGnS
-----END PGP SIGNATURE-----

--Sig_/UQQO4pX7abOKhts/BrsgpgH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
