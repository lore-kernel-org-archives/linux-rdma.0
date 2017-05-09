From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1] RDMA/netlink: Reduce exposure of RDMA
 netlink functions
Date: Tue, 9 May 2017 09:45:47 +0300
Message-ID: <20170509064547.GA4432@yuval-lap>
References: <20170509064234.31094-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509064234.31094-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 09, 2017 at 09:42:34AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> RDMA netlink is part of ib_core, hence ibnl_chk_listeners(),
> ibnl_init() and ibnl_cleanup() don't need to be published
> in public header file.
> 
> Let's remove EXPORT_SYMBOL from ibnl_chk_listeners() and move all these
> functions to private header file.
> 
> CC: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes from v0:
>  * Move ibnl_init(), ibnl_cleanup() and ibnl_chk_listeners() functions
>    to private header.
>  * Change titile and commit message to reflect that change
> ---
>  drivers/infiniband/core/core_priv.h | 10 ++++++++++
>  drivers/infiniband/core/netlink.c   |  1 -
>  include/rdma/rdma_netlink.h         | 10 ----------
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
> index cb7d372e4bdf..d92ab4eaa8f3 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -169,6 +169,16 @@ void ib_mad_cleanup(void);
>  int ib_sa_init(void);
>  void ib_sa_cleanup(void);
> 
> +int ibnl_init(void);
> +void ibnl_cleanup(void);
> +
> +/**
> + * Check if there are any listeners to the netlink group
> + * @group: the netlink group ID
> + * Returns 0 on success or a negative for no listeners.
> + */
> +int ibnl_chk_listeners(unsigned int group);
> +
>  int ib_nl_handle_resolve_resp(struct sk_buff *skb,
>  			      struct netlink_callback *cb);
>  int ib_nl_handle_set_timeout(struct sk_buff *skb,
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index 10469b0088b5..ebd16885cfce 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -55,7 +55,6 @@ int ibnl_chk_listeners(unsigned int group)
>  		return -1;
>  	return 0;
>  }
> -EXPORT_SYMBOL(ibnl_chk_listeners);
> 
>  int ibnl_add_client(int index, int nops,
>  		    const struct ibnl_client_cbs cb_table[])
> diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> index 585266144329..348c102cb5f6 100644
> --- a/include/rdma/rdma_netlink.h
> +++ b/include/rdma/rdma_netlink.h
> @@ -10,9 +10,6 @@ struct ibnl_client_cbs {
>  	struct module *module;
>  };
> 
> -int ibnl_init(void);
> -void ibnl_cleanup(void);
> -
>  /**
>   * Add a a client to the list of IB netlink exporters.
>   * @index: Index of the added client
> @@ -77,11 +74,4 @@ int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
>  int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			unsigned int group, gfp_t flags);
> 
> -/**
> - * Check if there are any listeners to the netlink group
> - * @group: the netlink group ID
> - * Returns 0 on success or a negative for no listeners.
> - */
> -int ibnl_chk_listeners(unsigned int group);
> -
>  #endif /* _RDMA_NETLINK_H */

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> --
> 2.12.2
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
