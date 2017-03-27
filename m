From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Mon, 27 Mar 2017 22:55:00 +0300
Message-ID: <20170327195500.GH20443@mtr-leonro.local>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490599139-12665-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 27, 2017 at 03:18:59AM -0400, Shamir Rabinovitch wrote:
> When udev renames the netdev devices, ipoib debugfs entries does not
> get renamed. As a result, if subsequent probe of ipoib device reuse the
> name then creating a debugfs entry for the new device would fail.
>
> Also, moved ipoib_create_debug_files and ipoib_delete_debug_files as part
> of ipoib event handling in order to avoid any race condition between these.
>
> Signed-off-by: Vijay Kumar <vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> ---
> v2->v3:
> - Move rev change out of commit message
> - Fix typo
> v1->v2:
> - Review comment from Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>   Verified again and NETDEV_UNREGISTER is called correctly. Debug
>   files are removed as expected. Thanks.
> - Fix compile warning when CONFIG_INFINIBAND_IPOIB_DEBUG is not set
> ---
>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    1 +
>  drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   28 +++++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |   41 ++++++++++++++++++++++++++--
>  3 files changed, 67 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index da12717..95a457f 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -770,6 +770,7 @@ static inline void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *w
>  void ipoib_delete_debug_files(struct net_device *dev);
>  int ipoib_register_debugfs(void);
>  void ipoib_unregister_debugfs(void);
> +void ipoib_debugfs_rename(struct net_device *dev);
>  #else
>  static inline void ipoib_create_debug_files(struct net_device *dev) { }
>  static inline void ipoib_delete_debug_files(struct net_device *dev) { }
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
> index 6bd5740..d849b1d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
> @@ -259,6 +259,34 @@ static int ipoib_path_open(struct inode *inode, struct file *file)
>  	.release = seq_release
>  };
>
> +void ipoib_debugfs_rename(struct net_device *dev)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +	char name[IFNAMSIZ + sizeof "_path"];
> +
> +	if (!ipoib_root)
> +		return;
> +
> +	if (priv->mcg_dentry) {
> +		snprintf(name, sizeof(name), "%s_mcg", dev->name);
> +		priv->mcg_dentry = debugfs_rename(ipoib_root, priv->mcg_dentry,
> +						  ipoib_root, name);
> +		if (!priv->mcg_dentry)
> +			ipoib_warn(priv, "failed to rename debug file %s to %s\n",
> +				   priv->mcg_dentry->d_iname, name);
> +	}
> +
> +	if (priv->path_dentry) {
> +		snprintf(name, sizeof(name), "%s_path", dev->name);
> +		priv->path_dentry = debugfs_rename(ipoib_root,
> +						   priv->path_dentry,
> +						   ipoib_root, name);
> +		if (!priv->path_dentry)
> +			ipoib_warn(priv, "failed to rename debug file %s to %s\n",
> +				   priv->mcg_dentry->d_iname, name);
> +	}
> +}
> +
>  void ipoib_create_debug_files(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index b58d9dc..c84b8ee 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -108,6 +108,32 @@ struct ipoib_path_iter {
>  	.get_net_dev_by_params = ipoib_get_net_dev_by_params,
>  };
>
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +static int ipoib_netdev_event(struct notifier_block *this,
> +			      unsigned long event, void *ptr)
> +{
> +	struct netdev_notifier_info *ni = ptr;
> +	struct net_device *dev = ni->dev;
> +
> +	if (dev->netdev_ops->ndo_open != ipoib_open)
> +		return NOTIFY_DONE;
> +
> +	switch (event) {
> +	case NETDEV_REGISTER:
> +		ipoib_create_debug_files(dev);
> +		break;
> +	case NETDEV_CHANGENAME:
> +		ipoib_debugfs_rename(dev);

Why do we need explicit ipoib_debugfs_rename function?
Will it work by simply calling ipoib_delete_debug_files
and immediately after that ipoib_create_debug_files?


> +		break;
> +	case NETDEV_UNREGISTER:
> +		ipoib_delete_debug_files(dev);
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +#endif
> +
>  int ipoib_open(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> @@ -2072,8 +2098,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
>  		goto register_failed;
>  	}
>
> -	ipoib_create_debug_files(priv->dev);
> -
>  	if (ipoib_cm_add_mode_attr(priv->dev))
>  		goto sysfs_failed;
>  	if (ipoib_add_pkey_attr(priv->dev))
> @@ -2088,7 +2112,6 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
>  	return priv->dev;
>
>  sysfs_failed:
> -	ipoib_delete_debug_files(priv->dev);
>  	unregister_netdev(priv->dev);
>
>  register_failed:
> @@ -2173,6 +2196,12 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
>  	kfree(dev_list);
>  }
>
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +static struct notifier_block ipoib_netdev_notifier = {
> +	.notifier_call = ipoib_netdev_event,
> +};
> +#endif
> +
>  static int __init ipoib_init_module(void)
>  {
>  	int ret;
> @@ -2225,6 +2254,9 @@ static int __init ipoib_init_module(void)
>  	if (ret)
>  		goto err_client;
>
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +	register_netdevice_notifier(&ipoib_netdev_notifier);
> +#endif
>  	return 0;
>
>  err_client:
> @@ -2242,6 +2274,9 @@ static int __init ipoib_init_module(void)
>
>  static void __exit ipoib_cleanup_module(void)
>  {
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +	unregister_netdevice_notifier(&ipoib_netdev_notifier);
> +#endif
>  	ipoib_netlink_fini();
>  	ib_unregister_client(&ipoib_client);
>  	ib_sa_unregister_client(&ipoib_sa_client);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljZbhQACgkQ5GN7iDZy
WKfyJA/+MFw62A39a/MNLDbtRP/kWI1dbHbDFwSkGwFIBlHgmfwNVfbvH2K4zA5L
GTSGPM1RSWD/SwVLpnDq4yXRZZ+OOFXOSiAbJjXsnkYwPG3KoYSuCdCvB2mYRmZp
imCTrdA7zf9kvqjWp+H6cjQnTEWiwKatm1RdPa6pSwOUio93jf94IUwNrPFmj8HS
4IVZwn0adA0z0ko09njKoW7/QsX48IgJ48XpC1yzZ1bB9YdA/nxaU/OjcUrmnC/s
P2ScCw0teNc2DVypJrfJ+6Zuv7sHBXd9aVQCbaDmS6Ib1NU5qpm+I2cg3hNYzzQV
lkqm6wxSxZkH812x9vANVKA4g91/IAGSfw93nFRdts/HkYpwPQs78B5w9hlL0ykU
8kNGP4xX6wkd7xTdE1Gu8DXakbt46eaTnhkK8LtK72Ny2ytyuKsDMiq20UlJ8TeI
rynV/YZQmWyefcyy7yPMTkVZe+uTff9x4zGmKwH0gNR7w/9Lof5uGrw4C0YJoGZM
AAg6yR6r2mYEOsieS0qlH6XwnPi1BZCxN4nUSUpyCHERHN0u1ybddWKTJPygtO0R
1FPSGG8z7K/1NJyUcG4/aZroXzoJgFlH0LgfuDWW/SUfsiB2HBkKC3eMCvp27olm
cCMSDJ5pfdS2CnwawEfVO2UT7YYqCKSOmcQqRVhH7VGUCCEDFew=
=Oem7
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
