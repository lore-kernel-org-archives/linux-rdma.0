From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IPoIB: Improve parent interface p_key handling.
Date: Sun, 08 Jun 2014 16:07:13 +0300
Message-ID: <53946001.303@dev.mellanox.co.il>
References: <20140605184010.19629.7048.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140605184010.19629.7048.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,
it is a good idea, i have 2 comments.

Thanks, Erez
> Resending as there was a typo in Subject line.
>
> ----------------------
>
> With reference to commit c2904141696ee19551f1553944446f23cdd5d95e.
> It was noticed that parent interface keeps sending broadcast group
> join requests if p_key index 0 is invalid. That creates unnecessary
> noise on a fabric:
>
> ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff,
>   status -22
>
> Proposed patch re-init resources, then brings interface
> up only if p_key idx 0 is valid either on bootup or on PKEY_CHANGE event.
> Otherwise it keeps interface quiet.
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c |   25 ++++++++++++++++---------
>   1 files changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 6a7003d..3201fe5 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -669,6 +669,12 @@ int ipoib_ib_dev_open(struct net_device *dev)
>   	struct ipoib_dev_priv *priv = netdev_priv(dev);
>   	int ret;
>   
> +	if (!(priv->pkey & 0x7fff)) {
> +		ipoib_warn(priv, "Invalid P_Key\n");
> +		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> +		return -1;
> +	}
> +
>   	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index)) {
>   		ipoib_warn(priv, "P_Key 0x%04x not found\n", priv->pkey);
>   		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
Instead of that check here, you can call again to 
ipoib_pkey_dev_check_presence, one place for checking that.
(like it is in ipoib_ib_dev_up)

> @@ -714,7 +720,8 @@ static void ipoib_pkey_dev_check_presence(struct net_device *dev)
>   	struct ipoib_dev_priv *priv = netdev_priv(dev);
>   	u16 pkey_index = 0;
>   
> -	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pkey_index))
> +	if (!(priv->pkey & 0x7fff) ||
> +		ib_find_pkey(priv->ca, priv->port, priv->pkey, &pkey_index))
Here should be the only place for checking, perhaps you will want to 
change the prototype of the function, to return int instead.
>   		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>   	else
>   		set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> @@ -987,12 +994,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
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
> +			ipoib_dbg(priv,	"Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
> +			return;
> +		}
>   	}
>   
i think that you cannot skip the call for update_parent_pkey, otherwise 
if the pkey value in index 0 was changed before the bit 
IPOIB_FLAG_INITIALIZED was set, the pkey will not be updated.
so, IMHO you can leave the code at that point, as it was before.
>   	if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
> @@ -1038,8 +1043,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
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
