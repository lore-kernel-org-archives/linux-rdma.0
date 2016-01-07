From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] RXE: A Soft RoCE back-end for the RVT
Date: Thu, 7 Jan 2016 09:08:10 +0200
Message-ID: <20160107070810.GA10797@leon.nu>
References: <1452106579-4081-1-git-send-email-monis@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452106579-4081-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 06, 2016 at 08:56:19PM +0200, Moni Shoua wrote:
> --- /dev/null
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -0,0 +1,580 @@
> +/*
> + * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.

Please update copyright year to 2016.

> + * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
> + *

...

> +
> +static int send(struct rvt_dev *rdev, struct rvt_av *av,
> +		struct sk_buff *skb, void *flow)
> +{
> +	struct sk_buff *nskb;
> +	int sent_bytes;
> +	int err;
> +	struct rxe_dev  *xdev = to_xdev(rdev);
> +	struct socket *sk = (struct socket *)flow;
> +
> +	nskb = skb_clone(skb, GFP_ATOMIC);
> +	if (!nskb)
> +		return -ENOMEM;
> +
> +	nskb->destructor = rxe_skb_tx_dtor;
> +	nskb->sk = sk->sk;
> +
> +	sent_bytes = nskb->len;
> +	if (av->network_type == RDMA_NETWORK_IPV4) {
> +		err = ip_local_out(dev_net(xdev->ndev), nskb->sk, nskb);
> +	} else if (av->network_type == RDMA_NETWORK_IPV6) {
> +		err = ip6_local_out(dev_net(xdev->ndev), nskb->sk, nskb);
> +	} else {
> +		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
> +		kfree_skb(nskb);
> +		return -EINVAL;
> +	}
> +
> +	if (unlikely(net_xmit_eval(err))) {
> +		pr_debug("error sending packet: %d\n", err);

You need to free nskb.

> +		return -EAGAIN;
> +	}
> +
> +	kfree_skb(skb);

Did you intend to free Nskb ?

> +
> +	return 0;
> +}
> +

...

> +static struct sk_buff *alloc_sendbuf(struct rvt_dev *rdev, struct rvt_av *av, int paylen)
> +{
> +	unsigned int hdr_len;
> +	struct sk_buff *skb;
> +	struct rxe_dev  *xdev = to_xdev(rdev);
> +
> +	if (av->network_type == RDMA_NETWORK_IPV4)
> +		hdr_len = ETH_HLEN + sizeof(struct udphdr) +
> +			sizeof(struct iphdr);
> +	else
> +		hdr_len = ETH_HLEN + sizeof(struct udphdr) +
> +			sizeof(struct ipv6hdr);
> +
> +	skb = alloc_skb(paylen + hdr_len + LL_RESERVED_SPACE(xdev->ndev),
> +			GFP_ATOMIC);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(xdev->ndev));
> +
> +	skb->dev	= xdev->ndev;

Extra spaces before =.

> +	if (av->network_type == RDMA_NETWORK_IPV4)
> +		skb->protocol = htons(ETH_P_IP);
> +	else
> +		skb->protocol = htons(ETH_P_IPV6);
> +
> +	return skb;
> +}
> +	xdev->rdev.num_ports = 1;
> +
> +	err = rvt_register_device(&xdev->rdev, &ifc_ops, ndev->mtu);
> +	if (err)
> +		return err;
> +

Extra line

> +
> +	/* for now we always assign port = 1 */
> +	port_num = 1;
> +
> +	xdev->ndev = ndev;
> +
> +

Extra line

> +	pr_info("rxe_net: added %s to %s\n",
> +		xdev->rdev.ib_dev.name, ndev->name);
> +
> +	net_info[ndev->ifindex].xdev = xdev;
> +	net_info[ndev->ifindex].port = port_num;
> +	net_info[ndev->ifindex].ndev = ndev;
> +	return 0;
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
