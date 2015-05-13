From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Wed, 13 May 2015 14:18:42 +0200
Message-ID: <1431519522.25060.69.camel@opteya.com>
References: <1431509705-16337-1-git-send-email-sagig@mellanox.com>
	 <1431509705-16337-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431509705-16337-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mercredi 13 mai 2015 =C3=A0 12:35 +0300, Sagi Grimberg a =C3=A9crit =
:
> Some of us keep revisiting the code to decode enumerations that
> appear in out logs. Let's borrow the nice logging helpers that
> exists in xprtrdma and rds for CMA events, IB events and WC statuses.
>=20
> Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

As a new patch, please remove the Reviewed-by:

> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c   |   28 +++++++++++++++++
>  drivers/infiniband/core/verbs.c |   65 +++++++++++++++++++++++++++++=
++++++++++
>  include/rdma/ib_verbs.h         |    4 ++
>  include/rdma/rdma_cm.h          |    2 +
>  4 files changed, 99 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index d570030..36bbe78 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -65,6 +65,34 @@ MODULE_LICENSE("Dual BSD/GPL");
>  #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
>  #define CMA_IBOE_PACKET_LIFETIME 18
> =20
> +static const char * const cma_events[] =3D {
> +	[RDMA_CM_EVENT_ADDR_RESOLVED]	 =3D "address resolved",
> +	[RDMA_CM_EVENT_ADDR_ERROR]	 =3D "address error",
> +	[RDMA_CM_EVENT_ROUTE_RESOLVED]	 =3D "route resolved ",
> +	[RDMA_CM_EVENT_ROUTE_ERROR]	 =3D "route error",
> +	[RDMA_CM_EVENT_CONNECT_REQUEST]	 =3D "connect request",
> +	[RDMA_CM_EVENT_CONNECT_RESPONSE] =3D "connect response",
> +	[RDMA_CM_EVENT_CONNECT_ERROR]	 =3D "connect error",
> +	[RDMA_CM_EVENT_UNREACHABLE]	 =3D "unreachable",
> +	[RDMA_CM_EVENT_REJECTED]	 =3D "rejected",
> +	[RDMA_CM_EVENT_ESTABLISHED]	 =3D "established",
> +	[RDMA_CM_EVENT_DISCONNECTED]	 =3D "disconnected",
> +	[RDMA_CM_EVENT_DEVICE_REMOVAL]	 =3D "device removal",
> +	[RDMA_CM_EVENT_MULTICAST_JOIN]	 =3D "multicast join",
> +	[RDMA_CM_EVENT_MULTICAST_ERROR]	 =3D "multicast error",
> +	[RDMA_CM_EVENT_ADDR_CHANGE]	 =3D "address change",
> +	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 =3D "timewait exit",
> +};
> +
> +const char *rdma_event_msg(enum rdma_cm_event_type event)
> +{
> +	size_t index =3D event;
> +
> +	return (index < ARRAY_SIZE(cma_events) && cma_events[index]) ?
> +			cma_events[index] : "UNRECOGNIZED_EVENT";

The default error message should also be modified to follow the updated
message scheme. For example:

"<unrecognized event>"
"<unrecognized status>"

> +}
> +EXPORT_SYMBOL(rdma_event_msg);
> +
>  static void cma_add_one(struct ib_device *device);
>  static void cma_remove_one(struct ib_device *device);
> =20
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/cor=
e/verbs.c
> index f93eb8d..d8f70d6 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -48,6 +48,71 @@
> =20
>  #include "core_priv.h"
> =20
> +static const char * const ib_events[] =3D {
> +	[IB_EVENT_CQ_ERR]		=3D "CQ error",
> +	[IB_EVENT_QP_FATAL]		=3D "QP fatal error",
> +	[IB_EVENT_QP_REQ_ERR]		=3D "QP request error",
> +	[IB_EVENT_QP_ACCESS_ERR]	=3D "QP access error",
> +	[IB_EVENT_COMM_EST]		=3D "communication established",
> +	[IB_EVENT_SQ_DRAINED]		=3D "send queue drained",
> +	[IB_EVENT_PATH_MIG]		=3D "path migration successful",
> +	[IB_EVENT_PATH_MIG_ERR]		=3D "path migration error",
> +	[IB_EVENT_DEVICE_FATAL]		=3D "device fatal error",
> +	[IB_EVENT_PORT_ACTIVE]		=3D "port active",
> +	[IB_EVENT_PORT_ERR]		=3D "port error",
> +	[IB_EVENT_LID_CHANGE]		=3D "LID change",
> +	[IB_EVENT_PKEY_CHANGE]		=3D "P_key change",
> +	[IB_EVENT_SM_CHANGE]		=3D "SM change",
> +	[IB_EVENT_SRQ_ERR]		=3D "SRQ error",
> +	[IB_EVENT_SRQ_LIMIT_REACHED]	=3D "SRQ limit reached",
> +	[IB_EVENT_QP_LAST_WQE_REACHED]	=3D "last WQE reached",
> +	[IB_EVENT_CLIENT_REREGISTER]	=3D "client reregister",
> +	[IB_EVENT_GID_CHANGE]		=3D "GID changed",
> +};
> +
> +const char *ib_event_msg(enum ib_event_type event)
> +{
> +	size_t index =3D event;
> +
> +	return (index < ARRAY_SIZE(ib_events) && ib_events[index]) ?
> +			ib_events[index] : "UNRECOGNIZED_EVENT";
> +}
> +EXPORT_SYMBOL(ib_event_msg);
> +
> +static const char * const wc_statuses[] =3D {
> +	[IB_WC_SUCCESS]			=3D "success",
> +	[IB_WC_LOC_LEN_ERR]		=3D "local length error",
> +	[IB_WC_LOC_QP_OP_ERR]		=3D "local QP operation error",
> +	[IB_WC_LOC_EEC_OP_ERR]		=3D "local EE context operation error",
> +	[IB_WC_LOC_PROT_ERR]		=3D "local protection error",
> +	[IB_WC_WR_FLUSH_ERR]		=3D "WR flushed",
> +	[IB_WC_MW_BIND_ERR]		=3D "memory management operation error",
> +	[IB_WC_BAD_RESP_ERR]		=3D "bad response error",
> +	[IB_WC_LOC_ACCESS_ERR]		=3D "local access error",
> +	[IB_WC_REM_INV_REQ_ERR]		=3D "envalid request error",

"invalid"

> +	[IB_WC_REM_ACCESS_ERR]		=3D "remote access error",
> +	[IB_WC_REM_OP_ERR]		=3D "remote operation error",
> +	[IB_WC_RETRY_EXC_ERR]		=3D "transport retry counter exceeded",
> +	[IB_WC_RNR_RETRY_EXC_ERR]	=3D "RNR retry counter exceeded",
> +	[IB_WC_LOC_RDD_VIOL_ERR]	=3D "local RDD violation error",
> +	[IB_WC_REM_INV_RD_REQ_ERR]	=3D "remove invalid RD request",
> +	[IB_WC_REM_ABORT_ERR]		=3D "operation aborted",
> +	[IB_WC_INV_EECN_ERR]		=3D "invalid EE context number",
> +	[IB_WC_INV_EEC_STATE_ERR]	=3D "invalid EE context state",
> +	[IB_WC_FATAL_ERR]		=3D "fatal error",
> +	[IB_WC_RESP_TIMEOUT_ERR]	=3D "response timeout error",
> +	[IB_WC_GENERAL_ERR]		=3D "general error",
> +};
> +
> +const char *ib_wc_status_msg(enum ib_wc_status status)
> +{
> +	size_t index =3D status;
> +
> +	return (index < ARRAY_SIZE(wc_statuses) && wc_statuses[index]) ?
> +			wc_statuses[index] : "UNRECOGNIZED_STATUS";
> +}
> +EXPORT_SYMBOL(ib_wc_status_msg);
> +
>  __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
>  {
>  	switch (rate) {
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 65994a1..672fc8f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -412,6 +412,8 @@ enum ib_event_type {
>  	IB_EVENT_GID_CHANGE,
>  };
> =20
> +__attribute_const__ const char *ib_event_msg(enum ib_event_type even=
t);
> +
>  struct ib_event {
>  	struct ib_device	*device;
>  	union {
> @@ -663,6 +665,8 @@ enum ib_wc_status {
>  	IB_WC_GENERAL_ERR
>  };
> =20
> +__attribute_const__ const char *ib_wc_status_msg(enum ib_wc_status s=
tatus);
> +
>  enum ib_wc_opcode {
>  	IB_WC_SEND,
>  	IB_WC_RDMA_WRITE,
> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
> index 1ed2088..c92522c 100644
> --- a/include/rdma/rdma_cm.h
> +++ b/include/rdma/rdma_cm.h
> @@ -62,6 +62,8 @@ enum rdma_cm_event_type {
>  	RDMA_CM_EVENT_TIMEWAIT_EXIT
>  };
> =20
> +__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event_ty=
pe event);
> +
>  enum rdma_port_space {
>  	RDMA_PS_SDP   =3D 0x0001,
>  	RDMA_PS_IPOIB =3D 0x0002,

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
