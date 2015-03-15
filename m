From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 01/16] xprtrdma: Display IPv6 addresses and port numbers
 correctly
Date: Sun, 15 Mar 2015 04:50:34 +0200
Message-ID: <5504F37A.20803@dev.mellanox.co.il>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212641.22783.93522.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212641.22783.93522.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/13/2015 11:26 PM, Chuck Lever wrote:
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/transport.c |   47 ++++++++++++++++++++++++++++++++-------
>   net/sunrpc/xprtrdma/verbs.c     |   21 +++++++----------
>   2 files changed, 47 insertions(+), 21 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
> index 2e192ba..26a62e7 100644
> --- a/net/sunrpc/xprtrdma/transport.c
> +++ b/net/sunrpc/xprtrdma/transport.c
> @@ -157,12 +157,47 @@ static struct ctl_table sunrpc_table[] = {
>   static struct rpc_xprt_ops xprt_rdma_procs;	/* forward reference */
>
>   static void
> +xprt_rdma_format_addresses4(struct rpc_xprt *xprt, struct sockaddr *sap)
> +{
> +	struct sockaddr_in *sin = (struct sockaddr_in *)sap;
> +	char buf[20];
> +
> +	snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
> +	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = kstrdup(buf, GFP_KERNEL);
> +
> +	xprt->address_strings[RPC_DISPLAY_NETID] = "rdma";
> +}
> +
> +static void
> +xprt_rdma_format_addresses6(struct rpc_xprt *xprt, struct sockaddr *sap)
> +{
> +	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)sap;
> +	char buf[40];
> +
> +	snprintf(buf, sizeof(buf), "%pi6", &sin6->sin6_addr);

Don't you prefer %pIS can handle both IPv4/v6 instead of two different
routines? or maybe even %pISp can be better?

> +	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = kstrdup(buf, GFP_KERNEL);
> +
> +	xprt->address_strings[RPC_DISPLAY_NETID] = "rdma6";

Was RPC_DISPLAY_NETID "rdma6" before this patch?

> +}
> +
> +static void
>   xprt_rdma_format_addresses(struct rpc_xprt *xprt)
>   {
>   	struct sockaddr *sap = (struct sockaddr *)
>   					&rpcx_to_rdmad(xprt).addr;
> -	struct sockaddr_in *sin = (struct sockaddr_in *)sap;
> -	char buf[64];
> +	char buf[128];
> +
> +	switch (sap->sa_family) {
> +	case AF_INET:
> +		xprt_rdma_format_addresses4(xprt, sap);
> +		break;
> +	case AF_INET6:
> +		xprt_rdma_format_addresses6(xprt, sap);
> +		break;
> +	default:
> +		pr_err("rpcrdma: Unrecognized address family\n");
> +		return;
> +	}
>
>   	(void)rpc_ntop(sap, buf, sizeof(buf));
>   	xprt->address_strings[RPC_DISPLAY_ADDR] = kstrdup(buf, GFP_KERNEL);
> @@ -170,16 +205,10 @@ xprt_rdma_format_addresses(struct rpc_xprt *xprt)
>   	snprintf(buf, sizeof(buf), "%u", rpc_get_port(sap));
>   	xprt->address_strings[RPC_DISPLAY_PORT] = kstrdup(buf, GFP_KERNEL);
>
> -	xprt->address_strings[RPC_DISPLAY_PROTO] = "rdma";
> -
> -	snprintf(buf, sizeof(buf), "%08x", ntohl(sin->sin_addr.s_addr));
> -	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = kstrdup(buf, GFP_KERNEL);
> -
>   	snprintf(buf, sizeof(buf), "%4hx", rpc_get_port(sap));
>   	xprt->address_strings[RPC_DISPLAY_HEX_PORT] = kstrdup(buf, GFP_KERNEL);
>
> -	/* netid */
> -	xprt->address_strings[RPC_DISPLAY_NETID] = "rdma";
> +	xprt->address_strings[RPC_DISPLAY_PROTO] = "rdma";
>   }
>
>   static void
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 124676c..1aa55b7 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -50,6 +50,7 @@
>   #include <linux/interrupt.h>
>   #include <linux/slab.h>
>   #include <linux/prefetch.h>
> +#include <linux/sunrpc/addr.h>
>   #include <asm/bitops.h>
>
>   #include "xprt_rdma.h"
> @@ -424,7 +425,7 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
>   	struct rpcrdma_ia *ia = &xprt->rx_ia;
>   	struct rpcrdma_ep *ep = &xprt->rx_ep;
>   #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> -	struct sockaddr_in *addr = (struct sockaddr_in *) &ep->rep_remote_addr;
> +	struct sockaddr *sap = (struct sockaddr *)&ep->rep_remote_addr;
>   #endif
>   	struct ib_qp_attr *attr = &ia->ri_qp_attr;
>   	struct ib_qp_init_attr *iattr = &ia->ri_qp_init_attr;
> @@ -480,9 +481,8 @@ connected:
>   		wake_up_all(&ep->rep_connect_wait);
>   		/*FALLTHROUGH*/
>   	default:
> -		dprintk("RPC:       %s: %pI4:%u (ep 0x%p): %s\n",
> -			__func__, &addr->sin_addr.s_addr,
> -			ntohs(addr->sin_port), ep,
> +		dprintk("RPC:       %s: %pIS:%u (ep 0x%p): %s\n",
> +			__func__, sap, rpc_get_port(sap), ep,
>   			CONNECTION_MSG(event->event));
>   		break;
>   	}
> @@ -491,19 +491,16 @@ connected:
>   	if (connstate == 1) {
>   		int ird = attr->max_dest_rd_atomic;
>   		int tird = ep->rep_remote_cma.responder_resources;
> -		printk(KERN_INFO "rpcrdma: connection to %pI4:%u "
> -			"on %s, memreg %d slots %d ird %d%s\n",
> -			&addr->sin_addr.s_addr,
> -			ntohs(addr->sin_port),
> +
> +		pr_info("rpcrdma: connection to %pIS:%u on %s, memreg %d slots %d ird %d%s\n",
> +			sap, rpc_get_port(sap),
>   			ia->ri_id->device->name,
>   			ia->ri_memreg_strategy,
>   			xprt->rx_buf.rb_max_requests,
>   			ird, ird < 4 && ird < tird / 2 ? " (low!)" : "");
>   	} else if (connstate < 0) {
> -		printk(KERN_INFO "rpcrdma: connection to %pI4:%u closed (%d)\n",
> -			&addr->sin_addr.s_addr,
> -			ntohs(addr->sin_port),
> -			connstate);
> +		pr_info("rpcrdma: connection to %pIS:%u closed (%d)\n",
> +			sap, rpc_get_port(sap), connstate);
>   	}
>   #endif
>
>

Other than the minors above, Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
