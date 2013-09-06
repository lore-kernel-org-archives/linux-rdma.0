From: Fubo Chen <fubo.chen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Fri, 6 Sep 2013 08:43:52 +0000 (UTC)
Message-ID: <loom.20130906T103551-423@post.gmane.org>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013BC795@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upinder Malhi (umalhi <umalhi@...> writes:
> diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h
b/drivers/infiniband/hw/usnic/usnic_abi.h
> +#define USNIC_UVERBS_ABI_VERSION	2

An ABI ? Is this an ABI between user space and kernel space, or perhaps an
ABI between kernel driver and firmware ? Please document.

> +/* Start of netdev section */
> +static inline const char *usnic_ib_netdev_event_to_string(unsigned long
event)
> +{
> +	char *event2str[] = { "NETDEV_NONE", "NETDEV_UP", "NETDEV_DOWN",
> +		"NETDEV_REBOOT", "NETDEV_CHANGE",
> +		"NETDEV_REGISTER", "NETDEV_UNREGISTER", "NETDEV_CHANGEMTU",
> +		"NETDEV_CHANGEADDR", "NETDEV_GOING_DOWN", "NETDEV_FEAT_CHANGE",
> +		"NETDEV_BONDING_FAILOVER", "NETDEV_PRE_UP",
> +		"NETDEV_PRE_TYPE_CHANGE", "NETDEV_POST_TYPE_CHANGE",
> +		"NETDEV_POST_INT", "NETDEV_UNREGISTER_FINAL", "NETDEV_RELEASE",
> +		"NETDEV_NOTIFY_PEERS", "NETDEV_JOIN"
> +	};

const char *[] ?

> +	if (event >= sizeof(event2str) / sizeof(event2str[0]))

ARRAY_SIZE() ?

Fubo.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
