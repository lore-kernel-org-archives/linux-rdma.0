From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: CSUM support in connected mode
Date: Sun, 5 Oct 2014 05:09:34 +0300
Message-ID: <20141005020933.GA18513@yuval-lab>
References: <1412423147-8402-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412423147-8402-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,
Sorry but this patch will not go smoothly to latest kernel.
I'm currently adjusting it to fit to v3.17-rc4 and will send new one soon.

Yuval

On Sat, Oct 04, 2014 at 04:45:47AM -0700, Yuval Shaia wrote:
> This enhancement suggest the usage of IB CRC instead of CSUM in IPoIB CM.
> IPoIB Connected Mode driver uses RC (Reliable Connection) which guarantees the
> corruption free delivery of the packet.
> InfiniBand uses 32b CRC which provides stronger data integrity protection
> compare to 16b IP Checksum.
> So, there is no added value that IP Checksum provides in the IB world.
> The proposal is to tell that network stack that IPoIB-CM supports IP Checksum
> offload.
> This enables Linux to save the time of checksum calculation of IPoIB CM packets.
> Network sends the IP packet without adding the IP Checksum to the header.
> On the receive side, IPoIB driver again tells the network stack that IP
> Checksum is good for the incoming packets and network stack avoids the IP
> Checksum calculations.
> During connection establishment the driver determine if the other end supports
> IB CRC as checksum.
> This is done so driver will be able to calculate checksum before transmiting
> the packet in case the other end does not support this feature.
> A support for fragmented skb is added to transmit path.
> 
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib.h      |   25 ++++++
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  117 ++++++++++++++++++++++++----
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    3 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |   19 ++++-
>  4 files changed, 143 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> index 0ed9aed..6fedf83 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -100,6 +100,7 @@ enum {
>  	IPOIB_FLAG_AUTO_MODER     = 13, /*indicates moderation is running*/
>  	/*indicates if event handler was registered*/
>  	IPOIB_FLAG_EVENTS_REGISTERED    = 14,
> +	IPOIB_FLAG_CSUM		  = 15,
>  
>  	IPOIB_MAX_BACKOFF_SECONDS = 16,
>  
> @@ -192,9 +193,28 @@ struct ipoib_pmtu_update {
>  
>  struct ib_cm_id;
>  
> +#define IPOIB_CM_PROTO_SIG		0x2211
> +#define IPOIB_CM_PROTO_VER		(1UL << 12)
> +
> +static inline int ipoib_cm_check_proto_sig(u16 proto_sig)
> +{
> +	return proto_sig & IPOIB_CM_PROTO_SIG;
> +};
> +
> +static inline int ipoib_cm_check_proto_ver(u16 caps)
> +{
> +	return caps & IPOIB_CM_PROTO_VER;
> +};
> +
> +enum ipoib_cm_data_caps {
> +	IPOIB_CM_CAPS_IBCRC_AS_CSUM	= 1UL << 0,
> +};
> +
>  struct ipoib_cm_data {
>  	__be32 qpn; /* High byte MUST be ignored on receive */
>  	__be32 mtu;
> +	__be16 sig; /* must be IPOIB_CM_PROTO_SIG */
> +	__be16 caps; /* 4 bits proto ver and 12 bits capabilities */
>  };
>  
>  /*
> @@ -241,6 +261,7 @@ struct ipoib_cm_rx {
>  	int			recv_count;
>  	u32			qpn;
>  	int index; /* For ring counters */
> +	u16			caps;
>  };
>  
>  struct ipoib_cm_tx {
> @@ -255,6 +276,7 @@ struct ipoib_cm_tx {
>  	unsigned	     tx_tail;
>  	unsigned long	     flags;
>  	u32		     mtu;
> +	u16		     caps;
>  };
>  
>  struct ipoib_cm_rx_buf {
> @@ -558,6 +580,8 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid);
>  extern struct workqueue_struct *ipoib_workqueue;
>  extern struct workqueue_struct *ipoib_auto_moder_workqueue;
>  
> +extern int cm_ibcrc_as_csum;
> +
>  /* functions */
>  
>  int ipoib_poll(struct napi_struct *napi, int budget);
> @@ -613,6 +637,7 @@ int ipoib_mcast_stop_thread(struct net_device *dev, int flush);
>  
>  void ipoib_mcast_dev_down(struct net_device *dev);
>  void ipoib_mcast_dev_flush(struct net_device *dev);
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req);
>  
>  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
>  struct ipoib_mcast_iter *ipoib_mcast_iter_init(struct net_device *dev);
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index db0303e..553569a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -436,9 +436,16 @@ static int ipoib_cm_send_rep(struct net_device *dev, struct ib_cm_id *cm_id,
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	struct ipoib_cm_data data = {};
>  	struct ib_cm_rep_param rep = {};
> +	u16 caps = 0;
> +
> +	caps |= IPOIB_CM_PROTO_VER;
> +	if (cm_ibcrc_as_csum)
> +		caps |= IPOIB_CM_CAPS_IBCRC_AS_CSUM;
>  
>  	data.qpn = cpu_to_be32(priv->qp->qp_num);
>  	data.mtu = cpu_to_be32(IPOIB_CM_BUF_SIZE);
> +	data.sig = cpu_to_be16(IPOIB_CM_PROTO_SIG);
> +	data.caps = cpu_to_be16(caps);
>  
>  	rep.private_data = &data;
>  	rep.private_data_len = sizeof data;
> @@ -458,6 +465,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>  	struct ipoib_cm_data *data = event->private_data;
>  	unsigned psn;
>  	int ret;
> +	struct ipoib_cm_data *cm_data;
>  
>  	ipoib_dbg(priv, "REQ arrived\n");
>  	p = kzalloc(sizeof *p, GFP_KERNEL);
> @@ -480,6 +488,13 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>  		goto err_qp;
>  	}
>  
> +	cm_data = (struct ipoib_cm_data *)event->private_data;
> +	ipoib_dbg(priv, "Otherend sig=0x%x\n", be16_to_cpu(cm_data->sig));
> +	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
> +	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
> +		p->caps = be16_to_cpu(cm_data->caps);
> +	ipoib_dbg(priv, "Otherend caps=0x%x\n", p->caps);
> +
>  	psn = random32() & 0xffffff;
>  	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
>  	if (ret)
> @@ -696,6 +711,9 @@ copied:
>          if (skb->dev->priv_flags & IFF_EIPOIB_VIF)
>  		set_skb_oob_cb_data(skb, wc, NULL);
>  
> +	if (cm_ibcrc_as_csum)
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +
>  	netif_receive_skb(skb);
>  
>  repost:
> @@ -732,14 +750,43 @@ static inline int post_send(struct ipoib_dev_priv *priv,
>  	return ib_post_send(tx->qp, &send_ring->tx_wr, &bad_wr);
>  }
>  
> +static inline int post_send_sg(struct ipoib_dev_priv *priv,
> +			       struct ipoib_cm_tx *tx,
> +			       unsigned int wr_id,
> +			       struct sk_buff *skb,
> +			       u64 mapping[MAX_SKB_FRAGS + 1],
> +			       struct ipoib_send_ring *send_ring)
> +{
> +	struct ib_send_wr *bad_wr;
> +	int i, off;
> +	skb_frag_t *frags = skb_shinfo(skb)->frags;
> +	int nr_frags = skb_shinfo(skb)->nr_frags;
> +	if (skb_headlen(skb)) {
> +		send_ring->tx_sge[0].addr = mapping[0];
> +		send_ring->tx_sge[0].length = skb_headlen(skb);
> +		off = 1;
> +	} else
> +		off = 0;
> +
> +	for (i = 0; i < nr_frags; ++i) {
> +		send_ring->tx_sge[i + off].addr = mapping[i + off];
> +		send_ring->tx_sge[i + off].length = frags[i].size;
> +	}
> +	send_ring->tx_wr.num_sge = nr_frags + off;
> +	send_ring->tx_wr.wr_id = wr_id | IPOIB_OP_CM;
> +
> +	return ib_post_send(tx->qp, &send_ring->tx_wr, &bad_wr);
> +}
> +
>  void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_tx *tx)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	struct ipoib_cm_tx_buf *tx_req;
> -	u64 addr;
> +	u64 addr = 0;
>  	int rc;
>  	struct ipoib_send_ring *send_ring;
>  	u16 queue_index;
> +	struct ipoib_tx_buf sg_tx_req;
>  
>  	queue_index = skb_get_queue_mapping(skb);
>  	send_ring = priv->send_ring + queue_index;
> @@ -768,26 +815,45 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
>  	tx_req = &tx->tx_ring[tx->tx_head & (ipoib_sendq_size - 1)];
>  	tx_req->skb = skb;
>  
> -	if (skb->len < ipoib_inline_thold && !skb_shinfo(skb)->nr_frags) {
> -		addr = (u64) skb->data;
> -		send_ring->tx_wr.send_flags |= IB_SEND_INLINE;
> -		tx_req->is_inline = 1;
> -	} else {
> -		addr = ib_dma_map_single(priv->ca, skb->data,
> -			skb->len, DMA_TO_DEVICE);
> -		if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> -			++send_ring->stats.tx_errors;
> +	/* Calculate checksum if we support ibcrc_as_csum but peer does not */
> +	if ((skb->ip_summed != CHECKSUM_NONE) && cm_ibcrc_as_csum &&
> +	    !(tx->caps & IPOIB_CM_CAPS_IBCRC_AS_CSUM))
> +		skb_checksum_help(skb);
> +
> +	if (skb_shinfo(skb)->nr_frags) {
> +		sg_tx_req.skb = skb;
> +		if (unlikely(ipoib_dma_map_tx(priv->ca, &sg_tx_req))) {
> +			++dev->stats.tx_errors;
>  			dev_kfree_skb_any(skb);
>  			return;
>  		}
> -
> -		tx_req->mapping = addr;
>  		tx_req->is_inline = 0;
> -		send_ring->tx_wr.send_flags &= ~IB_SEND_INLINE;
> -	}
> +		rc = post_send_sg(priv, tx, tx->tx_head &
> +				  (ipoib_sendq_size - 1),
> +				  skb, sg_tx_req.mapping, send_ring);
> +	} else {
> +		if (skb->len < ipoib_inline_thold &&
> +		    !skb_shinfo(skb)->nr_frags) {
> +			addr = (u64) skb->data;
> +			send_ring->tx_wr.send_flags |= IB_SEND_INLINE;
> +			tx_req->is_inline = 1;
> +		} else {
> +			addr = ib_dma_map_single(priv->ca, skb->data,
> +				skb->len, DMA_TO_DEVICE);
> +			if (unlikely(ib_dma_mapping_error(priv->ca, addr))) {
> +				++send_ring->stats.tx_errors;
> +				dev_kfree_skb_any(skb);
> +				return;
> +			}
>  
> -	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> -		       addr, skb->len, send_ring);
> +			tx_req->mapping = addr;
> +			tx_req->is_inline = 0;
> +			send_ring->tx_wr.send_flags &= ~IB_SEND_INLINE;
> +		}
> +
> +		rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
> +			       addr, skb->len, send_ring);
> +	}
>  	if (unlikely(rc)) {
>  		ipoib_warn(priv, "%s: post_send failed, error %d queue_index: %d skb->len: %d\n",
>  			   __func__, rc, queue_index, skb->len);
> @@ -1012,6 +1078,7 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>  	struct ib_qp_attr qp_attr;
>  	int qp_attr_mask, ret;
>  	struct sk_buff *skb;
> +	struct ipoib_cm_data *cm_data;
>  
>  	p->mtu = be32_to_cpu(data->mtu);
>  
> @@ -1021,6 +1088,13 @@ static int ipoib_cm_rep_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>  		return -EINVAL;
>  	}
>  
> +	cm_data = (struct ipoib_cm_data *)event->private_data;
> +	ipoib_dbg(priv, "Otherend sig=0x%x\n", be16_to_cpu(cm_data->sig));
> +	if (ipoib_cm_check_proto_sig(be16_to_cpu(cm_data->sig)) &&
> +	    ipoib_cm_check_proto_ver(be16_to_cpu(cm_data->caps)))
> +		p->caps = be16_to_cpu(cm_data->caps);
> +	ipoib_dbg(priv, "Otherend caps=0x%x\n", p->caps);
> +
>  	qp_attr.qp_state = IB_QPS_RTR;
>  	ret = ib_cm_init_qp_attr(cm_id, &qp_attr, &qp_attr_mask);
>  	if (ret) {
> @@ -1105,6 +1179,9 @@ static struct ib_qp *ipoib_cm_create_tx_qp(struct net_device *dev, struct ipoib_
>  
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
> +	if (dev->features & NETIF_F_SG)
> +		attr.cap.max_send_sge = MAX_SKB_FRAGS + 1;
> +
>  	return ib_create_qp(priv->pd, &attr);
>  }
>  
> @@ -1116,9 +1193,16 @@ static int ipoib_cm_send_req(struct net_device *dev,
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  	struct ipoib_cm_data data = {};
>  	struct ib_cm_req_param req = {};
> +	u16 caps = 0;
> +
> +	caps |= IPOIB_CM_PROTO_VER;
> +	if (cm_ibcrc_as_csum)
> +		caps |= IPOIB_CM_CAPS_IBCRC_AS_CSUM;
>  
>  	data.qpn = cpu_to_be32(priv->qp->qp_num);
>  	data.mtu = cpu_to_be32(IPOIB_CM_BUF_SIZE);
> +	data.sig = cpu_to_be16(IPOIB_CM_PROTO_SIG);
> +	data.caps = cpu_to_be16(caps);
>  
>  	req.primary_path		= pathrec;
>  	req.alternate_path		= NULL;
> @@ -1594,7 +1678,6 @@ static void ipoib_cm_stale_task(struct work_struct *work)
>  	spin_unlock_irq(&priv->lock);
>  }
>  
> -
>  static ssize_t show_mode(struct device *d, struct device_attribute *attr,
>  			 char *buf)
>  {
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 9e7d824..28f36dd 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -349,8 +349,7 @@ repost:
>  			   "for buf %d\n", wr_id);
>  }
>  
> -static int ipoib_dma_map_tx(struct ib_device *ca,
> -			    struct ipoib_tx_buf *tx_req)
> +int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
>  {
>  	struct sk_buff *skb = tx_req->skb;
>  	u64 *mapping = tx_req->mapping;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index dcf18df..b17c7ab 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -69,6 +69,12 @@ module_param_named(debug_level, ipoib_debug_level, int, 0644);
>  MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default: 0) (0-1)");
>  #endif
>  
> +int cm_ibcrc_as_csum;
> +
> +module_param_named(cm_ibcrc_as_csum, cm_ibcrc_as_csum, int, 0444);
> +MODULE_PARM_DESC(cm_ibcrc_as_csum, "Indicates whether to utilize IB-CRC as "
> +		 "CSUM in connected mode,(default: 0)");
> +
>  struct ipoib_path_iter {
>  	struct net_device *dev;
>  	struct ipoib_path  path;
> @@ -195,7 +201,12 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
>  
>  	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
> -		features &= ~(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
> +		if (cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
> +						  &priv->flags)))
> +			dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
> +		else
> +			features &= ~(NETIF_F_SG | NETIF_F_IP_CSUM |
> +				      NETIF_F_TSO);
>  
>  	return features;
>  }
> @@ -249,7 +260,11 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
>  
>  		send_ring = priv->send_ring;
>  		for (i = 0; i < priv->num_tx_queues; i++) {
> -			send_ring->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
> +			if (cm_ibcrc_as_csum && (test_bit(IPOIB_FLAG_CSUM,
> +							  &priv->flags)))
> +				send_ring->tx_wr.send_flags |= IB_SEND_IP_CSUM;
> +			else
> +				send_ring->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
>  			send_ring++;
>  		}
>  
> -- 
> 1.7.1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
