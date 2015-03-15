From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 03/16] xprtrdma: Add vector of ops for each memory
 registration strategy
Date: Sun, 15 Mar 2015 05:04:40 +0200
Message-ID: <5504F6C8.9030902@dev.mellanox.co.il>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net> <20150313212659.22783.28341.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212659.22783.28341.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/13/2015 11:26 PM, Chuck Lever wrote:
> Instead of employing switch() statements, let's use the typical
> Linux kernel idiom for handling behavioral variation: virtual
> functions.
>
> Define a vector of operations for each supported memory registration
> mode, and add a source file for each mode.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/Makefile       |    3 ++-
>   net/sunrpc/xprtrdma/fmr_ops.c      |   22 ++++++++++++++++++++++
>   net/sunrpc/xprtrdma/frwr_ops.c     |   22 ++++++++++++++++++++++
>   net/sunrpc/xprtrdma/physical_ops.c |   24 ++++++++++++++++++++++++
>   net/sunrpc/xprtrdma/verbs.c        |   11 +++++++----
>   net/sunrpc/xprtrdma/xprt_rdma.h    |   12 ++++++++++++
>   6 files changed, 89 insertions(+), 5 deletions(-)
>   create mode 100644 net/sunrpc/xprtrdma/fmr_ops.c
>   create mode 100644 net/sunrpc/xprtrdma/frwr_ops.c
>   create mode 100644 net/sunrpc/xprtrdma/physical_ops.c
>
> diff --git a/net/sunrpc/xprtrdma/Makefile b/net/sunrpc/xprtrdma/Makefile
> index da5136f..579f72b 100644
> --- a/net/sunrpc/xprtrdma/Makefile
> +++ b/net/sunrpc/xprtrdma/Makefile
> @@ -1,6 +1,7 @@
>   obj-$(CONFIG_SUNRPC_XPRT_RDMA_CLIENT) += xprtrdma.o
>
> -xprtrdma-y := transport.o rpc_rdma.o verbs.o
> +xprtrdma-y := transport.o rpc_rdma.o verbs.o \
> +	fmr_ops.o frwr_ops.o physical_ops.o
>
>   obj-$(CONFIG_SUNRPC_XPRT_RDMA_SERVER) += svcrdma.o
>
> diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
> new file mode 100644
> index 0000000..ffb7d93
> --- /dev/null
> +++ b/net/sunrpc/xprtrdma/fmr_ops.c
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (c) 2015 Oracle.  All rights reserved.
> + * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
> + */
> +
> +/* Lightweight memory registration using Fast Memory Regions (FMR).
> + * Referred to sometimes as MTHCAFMR mode.
> + *
> + * FMR uses synchronous memory registration and deregistration.
> + * FMR registration is known to be fast, but FMR deregistration
> + * can take tens of usecs to complete.
> + */
> +
> +#include "xprt_rdma.h"
> +
> +#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> +# define RPCDBG_FACILITY	RPCDBG_TRANS
> +#endif
> +
> +const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
> +	.ro_displayname			= "fmr",
> +};
> diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> new file mode 100644
> index 0000000..79173f9
> --- /dev/null
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (c) 2015 Oracle.  All rights reserved.
> + * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
> + */
> +
> +/* Lightweight memory registration using Fast Registration Work
> + * Requests (FRWR). Also referred to sometimes as FRMR mode.
> + *
> + * FRWR features ordered asynchronous registration and deregistration
> + * of arbitrarily sized memory regions. This is the fastest and safest
> + * but most complex memory registration mode.
> + */
> +
> +#include "xprt_rdma.h"
> +
> +#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> +# define RPCDBG_FACILITY	RPCDBG_TRANS
> +#endif
> +
> +const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops = {
> +	.ro_displayname			= "frwr",
> +};
> diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
> new file mode 100644
> index 0000000..b0922ac
> --- /dev/null
> +++ b/net/sunrpc/xprtrdma/physical_ops.c
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2015 Oracle.  All rights reserved.
> + * Copyright (c) 2003-2007 Network Appliance, Inc. All rights reserved.
> + */
> +
> +/* No-op chunk preparation. All client memory is pre-registered.
> + * Sometimes referred to as ALLPHYSICAL mode.
> + *
> + * Physical registration is simple because all client memory is
> + * pre-registered and never deregistered. This mode is good for
> + * adapter bring up, but is considered not safe: the server is
> + * trusted not to abuse its access to client memory not involved
> + * in RDMA I/O.
> + */
> +
> +#include "xprt_rdma.h"
> +
> +#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> +# define RPCDBG_FACILITY	RPCDBG_TRANS
> +#endif
> +
> +const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops = {
> +	.ro_displayname			= "physical",
> +};
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 1aa55b7..e4d9d9c 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -492,10 +492,10 @@ connected:
>   		int ird = attr->max_dest_rd_atomic;
>   		int tird = ep->rep_remote_cma.responder_resources;
>
> -		pr_info("rpcrdma: connection to %pIS:%u on %s, memreg %d slots %d ird %d%s\n",
> +		pr_info("rpcrdma: connection to %pIS:%u on %s, memreg '%s', %d credits, %d responders%s\n",
>   			sap, rpc_get_port(sap),
>   			ia->ri_id->device->name,
> -			ia->ri_memreg_strategy,
> +			ia->ri_ops->ro_displayname,
>   			xprt->rx_buf.rb_max_requests,
>   			ird, ird < 4 && ird < tird / 2 ? " (low!)" : "");
>   	} else if (connstate < 0) {
> @@ -649,13 +649,16 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>   	 */
>   	switch (memreg) {
>   	case RPCRDMA_FRMR:
> +		ia->ri_ops = &rpcrdma_frwr_memreg_ops;
>   		break;
>   	case RPCRDMA_ALLPHYSICAL:
> +		ia->ri_ops = &rpcrdma_physical_memreg_ops;
>   		mem_priv = IB_ACCESS_LOCAL_WRITE |
>   				IB_ACCESS_REMOTE_WRITE |
>   				IB_ACCESS_REMOTE_READ;
>   		goto register_setup;
>   	case RPCRDMA_MTHCAFMR:
> +		ia->ri_ops = &rpcrdma_fmr_memreg_ops;
>   		if (ia->ri_have_dma_lkey)
>   			break;
>   		mem_priv = IB_ACCESS_LOCAL_WRITE;
> @@ -675,8 +678,8 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>   		rc = -ENOMEM;
>   		goto out3;
>   	}
> -	dprintk("RPC:       %s: memory registration strategy is %d\n",
> -		__func__, memreg);
> +	dprintk("RPC:       %s: memory registration strategy is '%s'\n",
> +		__func__, ia->ri_ops->ro_displayname);
>
>   	/* Else will do memory reg/dereg for each chunk */
>   	ia->ri_memreg_strategy = memreg;
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index c8afd83..ef3cf4a 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -60,6 +60,7 @@
>    * Interface Adapter -- one per transport instance
>    */
>   struct rpcrdma_ia {
> +	const struct rpcrdma_memreg_ops	*ri_ops;
>   	rwlock_t		ri_qplock;
>   	struct rdma_cm_id 	*ri_id;
>   	struct ib_pd		*ri_pd;
> @@ -331,6 +332,17 @@ struct rpcrdma_stats {
>   };
>
>   /*
> + * Per-registration mode operations
> + */
> +struct rpcrdma_memreg_ops {
> +	const char	*ro_displayname;
> +};
> +
> +extern const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops;
> +extern const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops;
> +extern const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops;
> +
> +/*
>    * RPCRDMA transport -- encapsulates the structures above for
>    * integration with RPC.
>    *
>

Don't know if I'd use three different files, but other than that I like
the change.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
