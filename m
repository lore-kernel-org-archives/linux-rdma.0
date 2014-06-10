From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 1/1] IPoIB: Improve parent interface p_key handling.
Date: Tue, 10 Jun 2014 08:49:11 +0300
Message-ID: <53969C57.3090907@dev.mellanox.co.il>
References: <20140609215507.24166.94407.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140609215507.24166.94407.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,
one comment (more specific about a comment i wrote before)

all the rest looks good to me.

Thanks, Erez

6/10/2014 12:55 AM, Alex Estrin:
> With reference to commit c2904141696ee19551f1553944446f23cdd5d95e.
> It was noticed that parent interface keeps sending broadcast group
> join requests if p_key index 0 is invalid. That creates unnecessary
> noise on a fabric:
>
> ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff,
> status -22
>
> Proposed patch re-init resources, then brings interface
> up only if p_key idx 0 is valid either on bootup or on PKEY_CHANGE event.
> Original code could run multicast task regardless of p_key value,
> which we want to avoid.
>
> Modified event handler will utilize following strategy:
> if interface is not initialized and event is not PKEY_CHANGE related - return.
> call update_parent_pkey() -> if pkey hasn't changed - return.
> if interface is initialized
>          flush it -> call ipoib_ib_dev_stop() - de-initialized.
> Then start multicast task only if ipoib_ib_dev_open() has succeeded, reinitialized,
> i.e. p_key is valid.
>
> Changes from v1:
> p_key check for 'Invalid' value was moved to
> ipoib_pkey_dev_check_presence() that is used now in ipoib_ib_dev_open()
> for p_key validation.
> Whitespace and format adjusted.
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c |   31 +++++++++++++++++--------------
>   1 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 6a7003d..627f74f 100644
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
> +			!(priv->pkey & 0x7fff) ? "Invalid" : "not found");
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
> +		ib_find_pkey(priv->ca, priv->port, priv->pkey,
> +				&priv->pkey_index))
>   		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>   	else
>   		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> @@ -987,12 +990,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>   	up_read(&priv->vlan_rwsem);
>   
>   	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
> -		/* for non-child devices must check/update the pkey value here */
> -		if (level == IPOIB_FLUSH_HEAVY &&
> -		    !test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags))
> -			update_parent_pkey(priv);
> -		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
> -		return;
> +		if (level < IPOIB_FLUSH_HEAVY) {
> +			ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
> +			return;
> +		}
>   	}
>   
I think that If you take these lines and the IPOB_FLAG_ADMIN_UP is not 
set, you will miss that event and will not read the pkey in index 0.
The assumption is that FLAG_INITIALIZED "comes after" ADMIN_UP so, you 
can find a case where both of them are not set, the main idea is no 
mather what is the priv state the driver should handle the PKEY_CHANGE 
event.
>   	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
> @@ -1038,8 +1039,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
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
