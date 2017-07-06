From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-rc v1] IB/core, opa_vnic, hfi1, mlx5: Properly free
 rdma_netdev
Date: Thu, 6 Jul 2017 07:23:47 +0300
Message-ID: <20170706042347.GP1528@mtr-leonro.local>
References: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zOcTNEe3AzgCmdo9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8e959601996dc645f4ed7004482a1667c27deb39.1499289360.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zOcTNEe3AzgCmdo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 05, 2017 at 05:17:52PM -0400, Doug Ledford wrote:
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
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> v1 - I fixed this up to resolve Leon's comment.  Leon, please make sure you
>      are happy with the change to the mlx5 code.
>
>  drivers/infiniband/hw/hfi1/verbs.c                |  1 -
>  drivers/infiniband/hw/hfi1/vnic.h                 |  1 -
>  drivers/infiniband/hw/hfi1/vnic_main.c            | 19 ++++++++--------
>  drivers/infiniband/hw/mlx5/main.c                 | 27 ++++++++++++++---------
>  drivers/infiniband/ulp/ipoib/ipoib_main.c         |  8 +++----
>  drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c |  8 +++----
>  include/rdma/ib_verbs.h                           |  6 +++--
>  7 files changed, 39 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
> index 90e7b77d68e8..2d19f9bb434d 100644
> --- a/drivers/infiniband/hw/hfi1/verbs.c
> +++ b/drivers/infiniband/hw/hfi1/verbs.c
> @@ -1779,7 +1779,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
>  	ibdev->alloc_hw_stats = alloc_hw_stats;
>  	ibdev->get_hw_stats = get_hw_stats;
>  	ibdev->alloc_rdma_netdev = hfi1_vnic_alloc_rn;
> -	ibdev->free_rdma_netdev = hfi1_vnic_free_rn;
>
>  	/* keep process mad in the driver */
>  	ibdev->process_mad = hfi1_process_mad;
> diff --git a/drivers/infiniband/hw/hfi1/vnic.h b/drivers/infiniband/hw/hfi1/vnic.h
> index e2c455299b53..4a621cde4abb 100644
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
> index b601c2929f8f..339f0cdd56d6 100644
> --- a/drivers/infiniband/hw/hfi1/vnic_main.c
> +++ b/drivers/infiniband/hw/hfi1/vnic_main.c
> @@ -833,6 +833,15 @@ static const struct net_device_ops hfi1_netdev_ops = {
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
> @@ -864,6 +873,7 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
>  	vinfo->num_tx_q = dd->chip_sdma_engines;
>  	vinfo->num_rx_q = HFI1_NUM_VNIC_CTXT;
>  	vinfo->netdev = netdev;
> +	rn->free_rdma_netdev = hfi1_vnic_free_rn;
>  	rn->set_id = hfi1_vnic_set_vesw_id;
>
>  	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
> @@ -892,12 +902,3 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
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
> index 9ecc089d4529..afa5f6e88e1d 100644
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
> @@ -3550,16 +3555,19 @@ mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
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
> -
> -static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
> -{
> -	return mlx5_rdma_netdev_free(netdev);
> +	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
> +					name, setup);
> +	if (likely(!IS_ERR_OR_NULL(netdev))) {
> +		rn = netdev_priv(netdev);
> +		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
> +	}
> +	return netdev;
>  }


Thanks Doug, it looks good enough for the fix.

In general, the "likely" is not needed here (we are not in data path)
and our preference is to avoid "if(!error) { do something }" constructions
in favor of "if(error) { return ...}" (fail as early as you can).

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--zOcTNEe3AzgCmdo9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlldu1MACgkQ5GN7iDZy
WKfKRBAAsds4xEsIBDQd7u9ZS5NWtMcN+JwWjGuW1Gdx28ptQx4zi0zx527goK68
ObesQ/MfEdWttzgbAuF+EYGMY9criTWS4PKIB971S/lhJ7TKIAS/eZPTg6f9nFx8
bohNQUHqjeGNLccX78m0MdMjztEQoWNJJQx4eK+KZbmV/x1kGtW0shJA72WyYtpH
D60soDpssPAN7UJOPu0z9DKyQ2tEgqVAQLBGFrqev01HfK/eydkCQJ54/7A71Tm8
w9Zpe685+fokGZ3f0Iw+zKoOVJ6aHlCXa6HUJxq6TWPkCWDhhgVS2oQJ3ZH5BA/Q
ga7HYWiGAvbLTVMCIEYFPzbpIu4brB78Zvv/2MVyuUd6doLdlJQY6gprgtjI52U9
su++RGQ65nio2G61wxhhxz/O34BcEJMg3ZDU9wm+zjw/dEwxUer9ySCn5q9FczOB
Cjd5P/w6Z8QAcyeo2Mnwsqu90YaTUd1ByzvRkRlyFIf8cmb5q7oq+2K/KDfJ0GJE
2ZdEET5V7kF4DntlnHIxha6vt1QS4n00cpMwIOG9qQBazfGXZPOwhLC27fST3TB1
WCtpo+YtHlsRLCC6YAOdK4AD3UaJiBQrHUngTXBH2qbEG5zCya1IwTvbTMzt9TRC
TRa7XZVNJEpH55KSQ7nSuuZQf13UPjTMMn4i6dXSST7/pz/4JIc=
=GWjw
-----END PGP SIGNATURE-----

--zOcTNEe3AzgCmdo9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
