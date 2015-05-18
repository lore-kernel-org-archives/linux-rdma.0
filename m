From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v7 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Mon, 18 May 2015 16:25:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDC8A8@ORSMSX109.amr.corp.intel.com>
References: <1431945633-18401-1-git-send-email-sagig@mellanox.com>
 <1431945633-18401-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431945633-18401-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/core/verbs.c
> b/drivers/infiniband/core/verbs.c
> index f93eb8d..961c47a 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -48,6 +48,71 @@
> 
>  #include "core_priv.h"
> 
> +static const char * const ib_events[] = {
> +	[IB_EVENT_CQ_ERR]		= "CQ error",
> +	[IB_EVENT_QP_FATAL]		= "QP fatal error",
> +	[IB_EVENT_QP_REQ_ERR]		= "QP request error",
> +	[IB_EVENT_QP_ACCESS_ERR]	= "QP access error",
> +	[IB_EVENT_COMM_EST]		= "communication established",
> +	[IB_EVENT_SQ_DRAINED]		= "send queue drained",
> +	[IB_EVENT_PATH_MIG]		= "path migration successful",
> +	[IB_EVENT_PATH_MIG_ERR]		= "path migration error",
> +	[IB_EVENT_DEVICE_FATAL]		= "device fatal error",
> +	[IB_EVENT_PORT_ACTIVE]		= "port active",
> +	[IB_EVENT_PORT_ERR]		= "port error",
> +	[IB_EVENT_LID_CHANGE]		= "LID change",
> +	[IB_EVENT_PKEY_CHANGE]		= "P_key change",
> +	[IB_EVENT_SM_CHANGE]		= "SM change",
> +	[IB_EVENT_SRQ_ERR]		= "SRQ error",
> +	[IB_EVENT_SRQ_LIMIT_REACHED]	= "SRQ limit reached",
> +	[IB_EVENT_QP_LAST_WQE_REACHED]	= "last WQE reached",
> +	[IB_EVENT_CLIENT_REREGISTER]	= "client reregister",
> +	[IB_EVENT_GID_CHANGE]		= "GID changed",
> +};
> +
> +const char *ib_event_msg(enum ib_event_type event)
> +{
> +	size_t index = event;
> +
> +	return (index < ARRAY_SIZE(ib_events) && ib_events[index]) ?
> +			ib_events[index] : "unrecognized event";
> +}
> +EXPORT_SYMBOL(ib_event_msg);
> +
> +static const char * const wc_statuses[] = {
> +	[IB_WC_SUCCESS]			= "success",
> +	[IB_WC_LOC_LEN_ERR]		= "local length error",
> +	[IB_WC_LOC_QP_OP_ERR]		= "local QP operation error",
> +	[IB_WC_LOC_EEC_OP_ERR]		= "local EE context operation error",
> +	[IB_WC_LOC_PROT_ERR]		= "local protection error",
> +	[IB_WC_WR_FLUSH_ERR]		= "WR flushed",
> +	[IB_WC_MW_BIND_ERR]		= "memory management operation error",
> +	[IB_WC_BAD_RESP_ERR]		= "bad response error",
> +	[IB_WC_LOC_ACCESS_ERR]		= "local access error",
> +	[IB_WC_REM_INV_REQ_ERR]		= "invalid request error",
> +	[IB_WC_REM_ACCESS_ERR]		= "remote access error",
> +	[IB_WC_REM_OP_ERR]		= "remote operation error",
> +	[IB_WC_RETRY_EXC_ERR]		= "transport retry counter exceeded",
> +	[IB_WC_RNR_RETRY_EXC_ERR]	= "RNR retry counter exceeded",
> +	[IB_WC_LOC_RDD_VIOL_ERR]	= "local RDD violation error",
> +	[IB_WC_REM_INV_RD_REQ_ERR]	= "remove invalid RD request",

Remove -> remote

> +	[IB_WC_REM_ABORT_ERR]		= "operation aborted",
> +	[IB_WC_INV_EECN_ERR]		= "invalid EE context number",
> +	[IB_WC_INV_EEC_STATE_ERR]	= "invalid EE context state",
> +	[IB_WC_FATAL_ERR]		= "fatal error",
> +	[IB_WC_RESP_TIMEOUT_ERR]	= "response timeout error",
> +	[IB_WC_GENERAL_ERR]		= "general error",

Otherwise:

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
