From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/core, opa_vnic, hfi1, mlx5: Properly
 free rdma_netdev
Date: Sun, 2 Jul 2017 16:23:40 +0300
Message-ID: <20170702132340.GD8041@mtr-leonro.local>
References: <20170630201236.5213.72919.stgit@scvm10.sc.intel.com>
 <20170630201445.5213.82089.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170630201445.5213.82089.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 30, 2017 at 01:14:46PM -0700, Dennis Dalessandro wrote:
> From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> IPOIB is calling free_rdma_netdev even though alloc_rdma_netdev has
> returned -EOPNOTSUPP.
> Move free_rdma_netdev from ib_device structure to rdma_netdev structure
> thus ensuring proper cleanup function is called for the rdma net device.
>
> Fix the following trace:
>
> ib0: Failed to modify QP to ERROR state
> BUG: unable to handle kernel paging request at 0000000000001d20
> IP: hfi1_vnic_free_rn+0x26/0xb0 [hfi1]
> Call Trace:
>  ipoib_remove_one+0xbe/0x160 [ib_ipoib]
>  ib_unregister_device+0xd0/0x170 [ib_core]
>  rvt_unregister_device+0x29/0x90 [rdmavt]
>  hfi1_unregister_ib_device+0x1a/0x100 [hfi1]
>  remove_one+0x4b/0x220 [hfi1]
>  pci_device_remove+0x39/0xc0
>  device_release_driver_internal+0x141/0x200
>  driver_detach+0x3f/0x80
>  bus_remove_driver+0x55/0xd0
>  driver_unregister+0x2c/0x50
>  pci_unregister_driver+0x2a/0xa0
>  hfi1_mod_cleanup+0x10/0xf65 [hfi1]
>  SyS_delete_module+0x171/0x250
>  do_syscall_64+0x67/0x150
>  entry_SYSCALL64_slow_path+0x25/0x25
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/verbs.c                |    1 -
>  drivers/infiniband/hw/hfi1/vnic.h                 |    1 -
>  drivers/infiniband/hw/hfi1/vnic_main.c            |   19 +++++++++--------
>  drivers/infiniband/hw/mlx5/main.c                 |   24 +++++++++++++--------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c         |    8 ++++---
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |    8 ++++---
>  include/rdma/ib_verbs.h                           |    6 ++++-
>  7 files changed, 37 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
> index 8a63a7e..720e71d 100644
> --- a/drivers/infiniband/hw/hfi1/verbs.c
> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> @@ -1770,7 +1770,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
>  	ibdev->alloc_hw_stats = alloc_hw_stats;
>  	ibdev->get_hw_stats = get_hw_stats;
>  	ibdev->alloc_rdma_netdev = hfi1_vnic_alloc_rn;
> -	ibdev->free_rdma_netdev = hfi1_vnic_free_rn;
>
>  	/* keep process mad in the driver */
>  	ibdev->process_mad = hfi1_process_mad;
> diff --git a/drivers/infiniband/hw/hfi1/vnic.h b/drivers/infiniband/hw/hfi1/vnic.h
> index e2c4552..4a621cd 100644
> --- a/drivers/infiniband/hw/hfi1/vnic.h
> +++ b/drivers/infiniband/hw/hfi1/vnic.h
> @@ -176,7 +176,6 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
>  				      const char *name,
>  				      unsigned char name_assign_type,
>  				      void (*setup)(struct net_device *));
> -void hfi1_vnic_free_rn(struct net_device *netdev);
>  int hfi1_vnic_send_dma(struct hfi1_devdata *dd, u8 q_idx,
>  		       struct hfi1_vnic_vport_info *vinfo,
>  		       struct sk_buff *skb, u64 pbc, u8 plen);
> diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
> index 950c1b4..5a3f80b 100644
> --- a/drivers/infiniband/hw/hfi1/vnic_main.c
> +++ b/drivers/infiniband/hw/hfi1/vnic_main.c
> @@ -836,6 +836,15 @@ static void hfi1_vnic_set_vesw_id(struct net_device *netdev, int id)
>  	.ndo_get_stats64 = hfi1_vnic_get_stats64,
>  };
>
> +static void hfi1_vnic_free_rn(struct net_device *netdev)
> +{
> +	struct hfi1_vnic_vport_info *vinfo = opa_vnic_dev_priv(netdev);
> +
> +	hfi1_vnic_deinit(vinfo);
> +	mutex_destroy(&vinfo->lock);
> +	free_netdev(netdev);
> +}
> +
>  struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
>  				      u8 port_num,
>  				      enum rdma_netdev_t type,
> @@ -867,6 +876,7 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
>  	vinfo->num_tx_q = dd->chip_sdma_engines;
>  	vinfo->num_rx_q = HFI1_NUM_VNIC_CTXT;
>  	vinfo->netdev = netdev;
> +	rn->free_rdma_netdev = hfi1_vnic_free_rn;
>  	rn->set_id = hfi1_vnic_set_vesw_id;
>
>  	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
> @@ -895,12 +905,3 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
>  	free_netdev(netdev);
>  	return ERR_PTR(rc);
>  }
> -
> -void hfi1_vnic_free_rn(struct net_device *netdev)
> -{
> -	struct hfi1_vnic_vport_info *vinfo = opa_vnic_dev_priv(netdev);
> -
> -	hfi1_vnic_deinit(vinfo);
> -	mutex_destroy(&vinfo->lock);
> -	free_netdev(netdev);
> -}
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 9ecc089..cec5932 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3542,6 +3542,11 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
>  	return num_counters;
>  }
>
> +static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
> +{
> +	return mlx5_rdma_netdev_free(netdev);
> +}
> +
>  static struct net_device*
>  mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
>  			  u8 port_num,
> @@ -3550,16 +3555,18 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
>  			  unsigned char name_assign_type,
>  			  void (*setup)(struct net_device *))
>  {
> +	struct net_device *netdev;
> +	struct rdma_netdev *rn;
> +
>  	if (type != RDMA_NETDEV_IPOIB)
>  		return ERR_PTR(-EOPNOTSUPP);
>
> -	return mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> -				      name, setup);
> -}
> +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> +					name, setup);

It can return NULL

> +	rn = netdev_priv(netdev);
> +	rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;

This will crash in such case.

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllY89wACgkQ5GN7iDZy
WKdvnA/+P/khVCNfTrPiqT4NjbqoaZk7xYhWAG8s2gqXDULjTSwdKGeYeZYseWyd
arULOFtkKyl/PzWc3aO6wzqL7/jSNxoIEOdHflmBKprPM2FvPdoKUavBGH2FeQuA
rG0PnudZmyzWdFAEgr4JqdNcA0sa4qwbuWrVL+I9g4LRv65ITdKJ3CI+hajAhvsj
ai4BEH15GJ602Jg92GrbhqQ6fwLBqRmdUiqDi0BaK2DFNKszpcBsjjyC3b+QD3U2
ibpw+N+vNvmYFecXKu4WZ13V7eBZVWNAYecIEojs2FE9JuFdKsGuPmLd2adjtDK/
yjanwLXOhkj9iAGgDmwx4BMJSnhl5b+UvJJeHVtbehASn4q5yCAfSbgwioMaTLRj
SB3QZQXqKwlJWLrp71Kg8mPTo3FsnmvOhr+SkqqLRNhV+/BeVBE3ukeFW+NFLDr6
AHNG6LnPumD+Edme32/AIEQ/HOJzpZWBI9PFXQMbY9Gx+uJI2iq1jJDqQnowrFpn
esSbXJ+9jk6u5ZpYEZw0La2Bn+BWKe5x0vTcBoMNT/cpYLFAYyjntjq0y2fgB8hD
wSdggmZlvxK9OMhHnjfuUXpTfqYPmb2hgGwU/E/mY6+HH3aqm+JmF+0RFOrwAa72
whKQNuTFqBQ49GPtvR/gHTNUaqqJCRle1r8tZ9xfMHa10Pda87Q=
=gpB5
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
