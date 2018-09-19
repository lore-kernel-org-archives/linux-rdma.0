From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH -next] RDMA/core: Properly return the error code of
 rdma_set_src_addr_rcu
Date: Wed, 19 Sep 2018 13:47:09 +0000
Message-ID: <VI1PR0501MB22718B17DA968E8B8C2A0EC3D11C0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20180919122838.28184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919122838.28184-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, "dledford@redhat.com" <dledford@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: YueHaibing <yuehaibing@huawei.com>
> Sent: Wednesday, September 19, 2018 7:29 AM
> To: dledford@redhat.com; jgg@ziepe.ca; leon@kernel.org; Parav Pandit
> <parav@mellanox.com>; Daniel Jurgens <danielj@mellanox.com>
> Cc: linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; YueHaibing
> <yuehaibing@huawei.com>
> Subject: [PATCH -next] RDMA/core: Properly return the error code of
> rdma_set_src_addr_rcu
>=20
> rdma_set_src_addr_rcu should check copy_src_l2_addr fails, rather than
> always return 0. Also copy_src_l2_addr should return 'ret' as its return =
value
> while rdma_translate_ip fails.
>=20
> Fixes: c31d4b2ddf07 ("RDMA/core: Protect against changing dst->dev during
> destination resolve")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/core/addr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/add=
r.c
> index 7a0356c..8a31b11 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -468,7 +468,7 @@ static int addr_resolve_neigh(const struct dst_entry
> *dst,
>  	return ret;
>  }
>=20
> -static void copy_src_l2_addr(struct rdma_dev_addr *dev_addr,
> +static int copy_src_l2_addr(struct rdma_dev_addr *dev_addr,
>  			     const struct sockaddr *dst_in,
>  			     const struct dst_entry *dst,
>  			     const struct net_device *ndev)
> @@ -492,6 +492,8 @@ static void copy_src_l2_addr(struct rdma_dev_addr
> *dev_addr,
>  						RDMA_NETWORK_IPV6;
>  	else
>  		dev_addr->network =3D RDMA_NETWORK_IB;
> +
> +	return ret;
>  }
>=20
>  static int rdma_set_src_addr_rcu(struct rdma_dev_addr *dev_addr, @@ -
> 499,6 +501,7 @@ static int rdma_set_src_addr_rcu(struct rdma_dev_addr
> *dev_addr,
>  				 const struct sockaddr *dst_in,
>  				 const struct dst_entry *dst)
>  {
> +	int ret;
>  	struct net_device *ndev =3D READ_ONCE(dst->dev);
>=20
>  	*ndev_flags =3D ndev->flags;
> @@ -515,8 +518,8 @@ static int rdma_set_src_addr_rcu(struct
> rdma_dev_addr *dev_addr,
>  			return -ENODEV;
>  	}
>=20
> -	copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> -	return 0;
> +	ret =3D copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> +	return ret;
>  }
>=20
>  static int set_addr_netns_by_gid_rcu(struct rdma_dev_addr *addr)
> --
> 2.7.0
>=20
Reviewed-by: Parav Pandit <parav@mellanox.com>
