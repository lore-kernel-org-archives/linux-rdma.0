From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next, 1/1] IB/IPoIB: Add destination address when re-queue
 packet
Date: Sun, 12 Feb 2017 13:31:38 +0200
Message-ID: <20170212113134.GA31998@yuval-lap.uk.oracle.com>
References: <20170201171005.15587-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170201171005.15587-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "# v4 . 8+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 01, 2017 at 07:10:05PM +0200, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> When sending packet to destination that was not resolved yet
> via path query, the driver keeps the skb and tries to re-send it
> again when the path is resolved.
> 
> But when re-sending via dev_queue_xmit the kernel doesn't call
> to dev_hard_header, so IPoIB needs to keep 20 bytes in the skb
> and to put the destination address inside them.
> 
> In that way the dev_start_xmit will have the correct destination,
> and the driver won't take the destination from the skb->data, while
> nothing exists there, which causes to packet be be dropped.
> 
> The test flow is:
> 1. Run the SM on remote node,
> 2. Restart the driver.
> 4. Ping some destination,
> 3. Observe that first ICMP request will be dropped.
> 
> Fixes: fc791b633515 ("IB/ipoib: move back IB LL address into the hard header")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.8+
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 3ce0765a05ab..205fa1c7ec4d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -716,6 +716,14 @@ int ipoib_check_sm_sendonly_fullmember_support(struct ipoib_dev_priv *priv)
>  	return ret;
>  }
>  
> +static void push_pseudo_header(struct sk_buff *skb, const char *daddr)
> +{
> +	struct ipoib_pseudo_header *phdr;
> +
> +	phdr = (struct ipoib_pseudo_header *)skb_push(skb, sizeof(*phdr));
> +	memcpy(phdr->hwaddr, daddr, INFINIBAND_ALEN);
> +}
> +
>  void ipoib_flush_paths(struct net_device *dev)
>  {
>  	struct ipoib_dev_priv *priv = netdev_priv(dev);
> @@ -940,8 +948,7 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
>  			}
>  			if (skb_queue_len(&neigh->queue) <
>  			    IPOIB_MAX_PATH_REC_QUEUE) {
> -				/* put pseudoheader back on for next time */
> -				skb_push(skb, IPOIB_PSEUDO_LEN);
> +				push_pseudo_header(skb, neigh->daddr);
>  				__skb_queue_tail(&neigh->queue, skb);
>  			} else {
>  				ipoib_warn(priv, "queue length limit %d. Packet drop.\n",
> @@ -959,10 +966,12 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
>  
>  		if (!path->query && path_rec_start(dev, path))
>  			goto err_path;
> -		if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
> +		if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> +			push_pseudo_header(skb, neigh->daddr);
>  			__skb_queue_tail(&neigh->queue, skb);
> -		else
> +		} else {
>  			goto err_drop;
> +		}
>  	}
>  
>  	spin_unlock_irqrestore(&priv->lock, flags);
> @@ -998,8 +1007,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
>  		}
>  		if (path) {
>  			if (skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> -				/* put pseudoheader back on for next time */
> -				skb_push(skb, IPOIB_PSEUDO_LEN);
> +				push_pseudo_header(skb, phdr->hwaddr);
>  				__skb_queue_tail(&path->queue, skb);
>  			} else {
>  				++dev->stats.tx_dropped;
> @@ -1031,8 +1039,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
>  		return;
>  	} else if ((path->query || !path_rec_start(dev, path)) &&
>  		   skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> -		/* put pseudoheader back on for next time */
> -		skb_push(skb, IPOIB_PSEUDO_LEN);
> +		push_pseudo_header(skb, phdr->hwaddr);
>  		__skb_queue_tail(&path->queue, skb);
>  	} else {
>  		++dev->stats.tx_dropped;
> @@ -1113,8 +1120,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	}
>  
>  	if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
> -		/* put pseudoheader back on for next time */
> -		skb_push(skb, sizeof(*phdr));
> +		push_pseudo_header(skb, phdr->hwaddr);
>  		spin_lock_irqsave(&priv->lock, flags);
>  		__skb_queue_tail(&neigh->queue, skb);
>  		spin_unlock_irqrestore(&priv->lock, flags);
> @@ -1146,7 +1152,6 @@ static int ipoib_hard_header(struct sk_buff *skb,
>  			     unsigned short type,
>  			     const void *daddr, const void *saddr, unsigned len)
>  {
> -	struct ipoib_pseudo_header *phdr;
>  	struct ipoib_header *header;
>  
>  	header = (struct ipoib_header *) skb_push(skb, sizeof *header);
> @@ -1159,8 +1164,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
>  	 * destination address into skb hard header so we can figure out where
>  	 * to send the packet later.
>  	 */
> -	phdr = (struct ipoib_pseudo_header *) skb_push(skb, sizeof(*phdr));
> -	memcpy(phdr->hwaddr, daddr, INFINIBAND_ALEN);
> +	push_pseudo_header(skb, daddr);
>  
>  	return IPOIB_HARD_LEN;
>  }

Tested-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
