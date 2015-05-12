From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Tue, 12 May 2015 15:59:05 +0300
Message-ID: <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A@mail.gmail.com>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com>
	<1431432329-859-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431432329-859-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 3:05 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Some of us keep revisiting the code to decode enumerations that
> appear in out logs. Let's borrow the nice logging helpers that
> exists in xprtrdma and rds for CMA events, IB events and WC statuses.

[...]

> +static const char * const cma_events[] = {
> +       [RDMA_CM_EVENT_ADDR_RESOLVED]   = "ADDR_RESOLVED",
> +       [RDMA_CM_EVENT_ADDR_ERROR]      = "ADDR_ERROR",
> +       [RDMA_CM_EVENT_ROUTE_RESOLVED]  = "ROUTE_RESOLVED",
> +       [RDMA_CM_EVENT_ROUTE_ERROR]     = "ROUTE_ERROR",
> +       [RDMA_CM_EVENT_CONNECT_REQUEST] = "CONNECT_REQUEST",
> +       [RDMA_CM_EVENT_CONNECT_RESPONSE]= "CONNECT_RESPONSE",
> +       [RDMA_CM_EVENT_CONNECT_ERROR]   = "CONNECT_ERROR",
> +       [RDMA_CM_EVENT_UNREACHABLE]     = "UNREACHABLE",
> +       [RDMA_CM_EVENT_REJECTED]        = "REJECTED",
> +       [RDMA_CM_EVENT_ESTABLISHED]     = "ESTABLISHED",
> +       [RDMA_CM_EVENT_DISCONNECTED]    = "DISCONNECTED",
> +       [RDMA_CM_EVENT_DEVICE_REMOVAL]  = "DEVICE_REMOVAL",
> +       [RDMA_CM_EVENT_MULTICAST_JOIN]  = "MULTICAST_JOIN",
> +       [RDMA_CM_EVENT_MULTICAST_ERROR] = "MULTICAST_ERROR",
> +       [RDMA_CM_EVENT_ADDR_CHANGE]     = "ADDR_CHANGE",
> +       [RDMA_CM_EVENT_TIMEWAIT_EXIT]   = "TIMEWAIT_EXIT",
> +};

Sagi,

My vote goes to using easy-to-digest human-readable non-capital
letters strings here and
elsewhere (IB events, etc),  as done today by the NFS code and
generally by errno based
helpers such as strerror, e.g

"address resolved"
"address error"
"route resolved"

Will be happy to hear what others think

Or.

> +
> +const char *rdma_event_msg(enum rdma_cm_event_type event)
> +{
> +       size_t index = event;
> +
> +       return (index < ARRAY_SIZE(cma_events) && cma_events[index]) ?
> +                       cma_events[index] : "UNRECOGNIZED_EVENT";
> +}
> +EXPORT_SYMBOL(rdma_event_msg);
> +
>  static void cma_add_one(struct ib_device *device);
>  static void cma_remove_one(struct ib_device *device);
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index f93eb8d..e366a52 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -48,6 +48,71 @@
>
>  #include "core_priv.h"
>
> +static const char * const ib_events[] = {
> +       [IB_EVENT_CQ_ERR]               = "CQ_ERR",
> +       [IB_EVENT_QP_FATAL]             = "QP_FATAL",
> +       [IB_EVENT_QP_REQ_ERR]           = "QP_REQ_ERR",
> +       [IB_EVENT_QP_ACCESS_ERR]        = "QP_ACCESS_ERR",
> +       [IB_EVENT_COMM_EST]             = "COMM_EST",
> +       [IB_EVENT_SQ_DRAINED]           = "SQ_DRAINED",
> +       [IB_EVENT_PATH_MIG]             = "PATH_MIG",
> +       [IB_EVENT_PATH_MIG_ERR]         = "PATH_MIG_ERR",
> +       [IB_EVENT_DEVICE_FATAL]         = "DEVICE_FATAL",
> +       [IB_EVENT_PORT_ACTIVE]          = "PORT_ACTIVE",
> +       [IB_EVENT_PORT_ERR]             = "PORT_ERR",
> +       [IB_EVENT_LID_CHANGE]           = "LID_CHANGE",
> +       [IB_EVENT_PKEY_CHANGE]          = "PKEY_CHANGE",
> +       [IB_EVENT_SM_CHANGE]            = "SM_CHANGE",
> +       [IB_EVENT_SRQ_ERR]              = "SRQ_ERR",
> +       [IB_EVENT_SRQ_LIMIT_REACHED]    = "SRQ_LIMIT_REACHED",
> +       [IB_EVENT_QP_LAST_WQE_REACHED]  = "QP_LAST_WQE_REACHED",
> +       [IB_EVENT_CLIENT_REREGISTER]    = "CLIENT_REREGISTER",
> +       [IB_EVENT_GID_CHANGE]           = "GID_CHANGE",
> +};
> +
> +const char *ib_event_msg(enum ib_event_type event)
> +{
> +       size_t index = event;
> +
> +       return (index < ARRAY_SIZE(ib_events) && ib_events[index]) ?
> +                       ib_events[index] : "UNRECOGNIZED_EVENT";
> +}
> +EXPORT_SYMBOL(ib_event_msg);
> +
> +static const char * const wc_statuses[] = {
> +       [IB_WC_SUCCESS]                 = "SUCCESS",
> +       [IB_WC_LOC_LEN_ERR]             = "LOC_LEN_ERR",
> +       [IB_WC_LOC_QP_OP_ERR]           = "LOC_QP_OP_ERR",
> +       [IB_WC_LOC_EEC_OP_ERR]          = "LOC_EEC_OP_ERR",
> +       [IB_WC_LOC_PROT_ERR]            = "LOC_PROT_ERR",
> +       [IB_WC_WR_FLUSH_ERR]            = "WR_FLUSH_ERR",
> +       [IB_WC_MW_BIND_ERR]             = "MW_BIND_ERR",
> +       [IB_WC_BAD_RESP_ERR]            = "BAD_RESP_ERR",
> +       [IB_WC_LOC_ACCESS_ERR]          = "LOC_ACCESS_ERR",
> +       [IB_WC_REM_INV_REQ_ERR]         = "REM_INV_REQ_ERR",
> +       [IB_WC_REM_ACCESS_ERR]          = "REM_ACCESS_ERR",
> +       [IB_WC_REM_OP_ERR]              = "REM_OP_ERR",
> +       [IB_WC_RETRY_EXC_ERR]           = "RETRY_EXC_ERR",
> +       [IB_WC_RNR_RETRY_EXC_ERR]       = "RNR_RETRY_EXC_ERR",
> +       [IB_WC_LOC_RDD_VIOL_ERR]        = "LOC_RDD_VIOL_ERR",
> +       [IB_WC_REM_INV_RD_REQ_ERR]      = "REM_INV_RD_REQ_ERR",
> +       [IB_WC_REM_ABORT_ERR]           = "REM_ABORT_ERR",
> +       [IB_WC_INV_EECN_ERR]            = "INV_EECN_ERR",
> +       [IB_WC_INV_EEC_STATE_ERR]       = "INV_EEC_STATE_ERR",
> +       [IB_WC_FATAL_ERR]               = "FATAL_ERR",
> +       [IB_WC_RESP_TIMEOUT_ERR]        = "RESP_TIMEOUT_ERR",
> +       [IB_WC_GENERAL_ERR]             = "GENERAL_ERR",
> +};
> +
> +const char *ib_wc_status_msg(enum ib_wc_status status)
> +{
> +       size_t index = status;
> +
> +       return (index < ARRAY_SIZE(wc_statuses) && wc_statuses[index]) ?
> +                       wc_statuses[index] : "UNRECOGNIZED_STATUS";
> +}
> +EXPORT_SYMBOL(ib_wc_status_msg);
> +
>  __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
>  {
>         switch (rate) {
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..672fc8f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -412,6 +412,8 @@ enum ib_event_type {
>         IB_EVENT_GID_CHANGE,
>  };
>
> +__attribute_const__ const char *ib_event_msg(enum ib_event_type event);
> +
>  struct ib_event {
>         struct ib_device        *device;
>         union {
> @@ -663,6 +665,8 @@ enum ib_wc_status {
>         IB_WC_GENERAL_ERR
>  };
>
> +__attribute_const__ const char *ib_wc_status_msg(enum ib_wc_status status);
> +
>  enum ib_wc_opcode {
>         IB_WC_SEND,
>         IB_WC_RDMA_WRITE,
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 1ed2088..c92522c 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -62,6 +62,8 @@ enum rdma_cm_event_type {
>         RDMA_CM_EVENT_TIMEWAIT_EXIT
>  };
>
> +__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event_type event);
> +
>  enum rdma_port_space {
>         RDMA_PS_SDP   = 0x0001,
>         RDMA_PS_IPOIB = 0x0002,
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
