From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 1/5] RDMA/netlink: Remove netlink clients infrastructure
Date: Mon, 12 Jun 2017 11:49:25 -0500
Message-ID: <073401d2e39b$d935bf60$8ba13e20$@opengridcomputing.com>
References: <20170611083931.13686-1-leon@kernel.org> <20170611083931.13686-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611083931.13686-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Leon:

> diff --git a/drivers/infiniband/core/netlink.c
b/drivers/infiniband/core/netlink.c
> index fcc9702efd38..7f498ecc0f0b 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -38,16 +38,13 @@
>  #include <net/sock.h>
>  #include <rdma/rdma_netlink.h>
> 
> -struct ibnl_client {
> -	struct list_head		list;
> -	int				index;
> -	int				nops;
> -	const struct ibnl_client_cbs   *cb_table;
> -};
> +#include "core_priv.h"
> 
> -static DEFINE_MUTEX(ibnl_mutex);
> +static DEFINE_MUTEX(rdma_nl_mutex);
>  static struct sock *nls;
> -static LIST_HEAD(client_list);
> +static struct {
> +	const struct ibnl_client_cbs   *cb_table;
> +} rdma_nl_types[RDMA_NL_NUM_CLIENTS];
> 
>  int ibnl_chk_listeners(unsigned int group)
>  {
> @@ -57,58 +54,74 @@ int ibnl_chk_listeners(unsigned int group)
>  }
>  EXPORT_SYMBOL(ibnl_chk_listeners);
> 
> -int ibnl_add_client(int index, int nops,
> -		    const struct ibnl_client_cbs cb_table[])
> +static bool is_nl_msg_valid(unsigned int type, unsigned int op)
>  {
> -	struct ibnl_client *cur;
> -	struct ibnl_client *nl_client;
> +	unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
> +				  RDMA_NL_RDMA_CM_NUM_OPS,
> +				  RDMA_NL_IWPM_NUM_OPS,
> +				  0,
> +				  RDMA_NL_LS_NUM_OPS,
> +				  0 };

Why build max_num_ops on every call to is_nl_msg_valid()?  Shouldn't it be
global and static and const?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
