From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Expose ioctl command to retrieve SGID of a
 given socket
Date: Thu, 31 Dec 2015 17:34:03 +0200
Message-ID: <56854AEB.50802@mellanox.com>
References: <1451572875-24961-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451572875-24961-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/12/2015 16:41, Yuval Shaia wrote:
> To support security applications, that need to filter out connections based
> on SGID, an ioctl command to retrieve SGID of a given socket is added.

Could you elaborate on the security applications? How do you see this ioctl 
being used?

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c b/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c
> new file mode 100644
> index 0000000..124d545
> --- /dev/null
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ioctl.c

> +static int ipoib_get_sguid(struct net_device *dev, int fd, u64 *sgid,
> +			   u64 *subnet_prefix)
A GID is composed of a GUID and a subnet prefix.

> +{
> +	struct socket *sock;
> +	struct inet_sock *inetsock;
> +	struct neighbour *neigh;
> +	int rc = 0;
> +	union ib_gid *gid;
> +	struct list_head *dev_list = 0;
> +	struct ipoib_dev_priv *priv = netdev_priv(dev);
> +	u16 pkey_index = priv->pkey_index;
> +	struct ipoib_dev_priv *child_priv;
> +
> +	sock = sockfd_lookup(fd, &rc);
> +	if (IS_ERR_OR_NULL(sock))
> +		return -EINVAL;
> +
> +	inetsock = inet_sk(sock->sk);
> +
> +	neigh = neigh_lookup(&arp_tbl, &inetsock->inet_daddr, dev);

Also, isn't inet_daddr the destination address? But the function claims 
to return the SGID. I guess these can be ambiguous but still it seems 
confusing.

> +	if (!IS_ERR_OR_NULL(neigh))
> +		goto found;
> +
> +	/* If not found try in all other ipoib devices */
> +	dev_list = ipoib_get_dev_list(priv->ca);
> +	if (!dev_list)
> +		return -EINVAL;
> +
> +	list_for_each_entry(priv, dev_list, list) {
This list can contain devices that belong to a different namespace. It
doesn't make sense to do a neighbor lookup on these. Also, you can simply use 
neigh_lookup_nodev if you don't care about the device.

> +		if (priv->pkey_index == pkey_index) {
> +			neigh = neigh_lookup(&arp_tbl, &inetsock->inet_daddr,
> +					     priv->dev);
> +			if (!IS_ERR_OR_NULL(neigh))
> +				goto found;
> +		}
> +		list_for_each_entry(child_priv, &priv->child_intfs, list) {
> +			if (child_priv->pkey_index == pkey_index) {
> +				neigh = neigh_lookup(&arp_tbl,
> +						     &inetsock->inet_daddr,
> +						     child_priv->dev);
> +				if (!IS_ERR_OR_NULL(neigh))
> +					goto found;
> +			}
> +		}
> +	}
> +
> +	return -ENODEV;
> +
> +found:
> +	if (!(neigh->nud_state & NUD_VALID))
> +		return -EINVAL;
> +
> +	gid = (union ib_gid *)(neigh->ha + 4);
If you just take the GID from the hardware address why not do that from userspace?
Why do you need a new ioctl to do that for you?

> +	*sgid = be64_to_cpu(gid->global.interface_id);
> +	*subnet_prefix = be64_to_cpu(gid->global.subnet_prefix);
> +
> +	neigh_release(neigh);
> +
> +	return 0;
> +}

Regards,
Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
