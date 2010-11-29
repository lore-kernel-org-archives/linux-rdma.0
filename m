From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 1/5] IB Netlink Infrastructure
Date: Mon, 29 Nov 2010 11:21:59 -0700
Message-ID: <20101129182159.GB16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-2-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291047399-430-2-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 29, 2010 at 06:16:35PM +0200, Nir Muchtar wrote:
> The basic IB netlink infrastructure.
> It allows for registration of IB module for which data is to be exported.
> It supplies skb/message construction callbacks.

You need to setup the module aliases for autoloading ie like:

MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_INFINIBAND);

> +enum {
> +	IBNL_RDMA_CM = 1
> +};
> +
> +enum {
> +	IBNL_RDMA_CM_STATS = 0,
> +	IBNL_RDMA_CM_DEVICE_NAME,
> +	IBNL_RDMA_CM_ID_STATS,
> +};

These belong in patch #5 - the one that adds them..

I don't want to see this as a RDMA_CM specific thing.

> +int ibnl_add_cb(int module,
> +		int (*get_data)(int op, struct sk_buff **skb, int pid));

The cb needs to have enough arguments to be able to call
netlink_dump_start.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
