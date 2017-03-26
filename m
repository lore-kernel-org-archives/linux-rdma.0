From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1] IB/IPoIB: ibX: failed to create mcg debug file
Date: Sun, 26 Mar 2017 22:36:32 +0300
Message-ID: <c1a67bcf-e5d7-38e8-09ac-a700ea4ffb4e@mellanox.com>
References: <1490555151-9638-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490555151-9638-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

On 26/03/2017 22:05, Shamir Rabinovitch wrote:
> When udev renames the netdev devices, ipoib debugfs entries does not
> get renamed. As a reason, if subsequent probe of ipoib device reuse the
> name then creating a debugfs entry for the new device would fail.
> 
> Also, moved ipoib_create_debug_files and ipoib_delete_debug_files as part
> of ipoib event handling in order to avoid any race condition between these.
> 
> Full credit for this fix to Vijay Kumar.
> 
> Signed-off-by: Vijay Kumar <vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |    2 +
>  drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   28 +++++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |   42 ++++++++++++++++++++++++++--
>  3 files changed, 69 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index da12717..f426048 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -770,11 +770,13 @@ static inline void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *w
>  void ipoib_delete_debug_files(struct net_device *dev);
>  int ipoib_register_debugfs(void);
>  void ipoib_unregister_debugfs(void);
> +void ipoib_debugfs_rename(struct net_device *dev);
>  #else
>  static inline void ipoib_create_debug_files(struct net_device *dev) { }
>  static inline void ipoib_delete_debug_files(struct net_device *dev) { }
>  static inline int ipoib_register_debugfs(void) { return 0; }
>  static inline void ipoib_unregister_debugfs(void) { }
> +static void ipoib_debugfs_rename(struct net_device *dev) { }
>  #endif
>  
>  #define ipoib_printk(level, priv, format, arg...)	\
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
> index b58d9dc..ddf9eb2 100644
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
> +		break;
> +	case NETDEV_UNREGISTER:
> +		ipoib_delete_debug_files(dev);
We call ipoib_delete_debug_files on NETDEV_UNREGISTER

[snip]

> @@ -2151,6 +2174,9 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
>  		return;
>  
>  	list_for_each_entry_safe(priv, tmp, dev_list, list) {
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +		ipoib_delete_debug_files(priv->dev);
> +#endif
We also call ipoib_delete_debug_files in ipoib_remove_one, does it mean we are calling ipoib_delete_debug_files
twice? that doesn't seem right. Am I missing something?

>  		ib_unregister_event_handler(&priv->event_handler);
>  		flush_workqueue(ipoib_workqueue);
>  
> @@ -2173,6 +2199,10 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
>  	kfree(dev_list);
>  }
>  
> +static struct notifier_block ipoib_netdev_notifier = {
> +	.notifier_call = ipoib_netdev_event,
> +};
> +
>  static int __init ipoib_init_module(void)
>  {
>  	int ret;
> @@ -2225,6 +2255,9 @@ static int __init ipoib_init_module(void)
>  	if (ret)
>  		goto err_client;
>  
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +	register_netdevice_notifier(&ipoib_netdev_notifier);
> +#endif
>  	return 0;
>  
>  err_client:
> @@ -2242,6 +2275,9 @@ static int __init ipoib_init_module(void)
>  
>  static void __exit ipoib_cleanup_module(void)
>  {
> +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> +	unregister_netdevice_notifier(&ipoib_netdev_notifier);
> +#endif
>  	ipoib_netlink_fini();
>  	ib_unregister_client(&ipoib_client);
>  	ib_sa_unregister_client(&ipoib_sa_client);
> 

Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
