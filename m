From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 1/1] IPoIB: Avoid multicast join attempts when having
 invalid p_key
Date: Wed, 02 Jul 2014 10:18:17 +0300
Message-ID: <53B3B239.8000007@dev.mellanox.co.il>
References: <20140625153020.18938.22186.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140625153020.18938.22186.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

Still there is an issue here, please try the following:

1. pkey table contains the pkey 8001
2. echo 0x8001 > /sys/class/net/ib0/create_child ; ifconfig ib0.8001 
1.1.1.1 up - till now all good.
3. change the sm partiotion file, take out the pkey value 8001
4. force the sm to send the new event (PKEY_CHANGE_EVENT) via pkill -HUP 
opensm
5. now return back the pkey 8001 to the partiotion file
6. again, force the sm to send the new event (PKEY_CHANGE_EVENT) via 
pkill -HUP opensm

The new interface ib0.8001 remains "down" and its carrier is 0.
please check that,

Thanks, Erez

> Currently, the parent interface keeps sending broadcast group join
> requests even if p_key index 0 is invalid, which for itself is
> possible/common in virtualized environment where a VF has been probed to
> VM but the actual p_key configuration has not yet been assigned by the
> management software. This creates unnecessary noise on the fabric and in
> the kernel logs:
>
> ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff,
> status -22
>
> The original code run the multicast task regardless of the actual
> p_key value, which can be avoided. The fix is to re-init resources  and
> bring interface up only if p_key index 0 is valid either when starting
> up or on PKEY_CHANGE event.
>
> Fixes: c290414169 ('IPoIB: Fix pkey change flow for virtualization environments')
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes from v4:
> - streamline child interface pkey event handling,
> - shutdown of pkey polling thread depends on PKEY_STOP flag state only.
> Original poib_ib_dev_down() could leave polling thread active
> if PKEY_ASSIGNED flag was set. That could create a racing condition on followed
> re-initialization of QP resources.
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c |   59 +++++++++++++++----------------
>   1 files changed, 29 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 6a7003d..ac941e1 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -52,6 +52,7 @@ MODULE_PARM_DESC(data_debug_level,
>   #endif
>   
>   static DEFINE_MUTEX(pkey_mutex);
> +static void ipoib_pkey_dev_check_presence(struct net_device *dev);
>   
>   struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
>   				 struct ib_pd *pd, struct ib_ah_attr *attr)
> @@ -669,12 +670,13 @@ int ipoib_ib_dev_open(struct net_device *dev)
>   	struct ipoib_dev_priv *priv = netdev_priv(dev);
>   	int ret;
>   
> -	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index)) {
> -		ipoib_warn(priv, "P_Key 0x%04x not found\n", priv->pkey);
> -		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> +	ipoib_pkey_dev_check_presence(dev);
> +
> +	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> +		ipoib_warn(priv, "P_Key 0x%04x is %s\n", priv->pkey,
> +			   !(priv->pkey & 0x7fff) ? "Invalid" : "not found");
>   		return -1;
>   	}
> -	set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>   
>   	ret = ipoib_init_qp(dev);
>   	if (ret) {
> @@ -712,9 +714,10 @@ dev_stop:
>   static void ipoib_pkey_dev_check_presence(struct net_device *dev)
>   {
>   	struct ipoib_dev_priv *priv = netdev_priv(dev);
> -	u16 pkey_index = 0;
>   
> -	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pkey_index))
> +	if (!(priv->pkey & 0x7fff) ||
> +	    ib_find_pkey(priv->ca, priv->port, priv->pkey,
> +			 &priv->pkey_index))
>   		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>   	else
>   		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> @@ -746,12 +749,10 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
>   	netif_carrier_off(dev);
>   
>   	/* Shutdown the P_Key thread if still active */
> -	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> -		mutex_lock(&pkey_mutex);
> -		set_bit(IPOIB_PKEY_STOP, &priv->flags);
> +	mutex_lock(&pkey_mutex);
> +	if (!test_and_set_bit(IPOIB_PKEY_STOP, &priv->flags))
>   		cancel_delayed_work_sync(&priv->pkey_poll_task);
> -		mutex_unlock(&pkey_mutex);
> -	}
> +	mutex_unlock(&pkey_mutex);
>   
>   	ipoib_mcast_stop_thread(dev, flush);
>   	ipoib_mcast_dev_flush(dev);
> @@ -972,7 +973,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>   {
>   	struct ipoib_dev_priv *cpriv;
>   	struct net_device *dev = priv->dev;
> -	u16 new_index;
> +	u16 old_index;
>   	int result;
>   
>   	down_read(&priv->vlan_rwsem);
> @@ -986,16 +987,17 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>   
>   	up_read(&priv->vlan_rwsem);
>   
> -	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
> -		/* for non-child devices must check/update the pkey value here */
> -		if (level == IPOIB_FLUSH_HEAVY &&
> -		    !test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
> -			update_parent_pkey(priv);
> +	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags) &&
> +	    level != IPOIB_FLUSH_HEAVY) {
>   		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
>   		return;
>   	}
>   
>   	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
> +		/* interface is down. update pkey and leave. */
> +		if (level == IPOIB_FLUSH_HEAVY &&
> +		    !test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
> +			update_parent_pkey(priv);
>   		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_ADMIN_UP not set.\n");
>   		return;
>   	}
> @@ -1005,20 +1007,15 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>   		 * (parent) devices should always takes what present in pkey index 0
>   		 */
>   		if (test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
> -			if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &new_index)) {
> -				clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> -				ipoib_ib_dev_down(dev, 0);
> -				ipoib_ib_dev_stop(dev, 0);
> -				if (ipoib_pkey_dev_delay_open(dev))
> -					return;
> -			}
> -			/* restart QP only if P_Key index is changed */
> -			if (test_and_set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
> -			    new_index == priv->pkey_index) {
> +			old_index = priv->pkey_index;
> +			ipoib_pkey_dev_check_presence(dev);
> +
> +			if (test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags) &&
> +			    old_index == priv->pkey_index) {
> +				/* restart QP only if P_Key index is changed */
>   				ipoib_dbg(priv, "Not flushing - P_Key index not changed.\n");
>   				return;
>   			}
> -			priv->pkey_index = new_index;
>   		} else {
>   			result = update_parent_pkey(priv);
>   			/* restart QP only if P_Key value changed */
> @@ -1038,8 +1035,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>   		ipoib_ib_dev_down(dev, 0);
>   
>   	if (level == IPOIB_FLUSH_HEAVY) {
> -		ipoib_ib_dev_stop(dev, 0);
> -		ipoib_ib_dev_open(dev);
> +		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
> +			ipoib_ib_dev_stop(dev, 0);
> +		if (ipoib_ib_dev_open(dev) != 0)
> +			return;
>   	}
>   
>   	/*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
