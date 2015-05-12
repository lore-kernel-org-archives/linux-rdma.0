From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Tue, 12 May 2015 09:56:16 -0400
Message-ID: <E27932C3-BDF3-4FED-ABD6-416454EFA5C0@oracle.com>
References: <1431432329-859-1-git-send-email-sagig@mellanox.com> <1431432329-859-2-git-send-email-sagig@mellanox.com> <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhOnrZJrUfwtMs7Tod7YeGy_Be6yF543+xds_05hO-F-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 12, 2015, at 8:59 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, May 12, 2015 at 3:05 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> w=
rote:
>> Some of us keep revisiting the code to decode enumerations that
>> appear in out logs. Let's borrow the nice logging helpers that
>> exists in xprtrdma and rds for CMA events, IB events and WC statuses=
=2E
>=20
> [...]
>=20
>> +static const char * const cma_events[] =3D {
>> +       [RDMA_CM_EVENT_ADDR_RESOLVED]   =3D "ADDR_RESOLVED",
>> +       [RDMA_CM_EVENT_ADDR_ERROR]      =3D "ADDR_ERROR",
>> +       [RDMA_CM_EVENT_ROUTE_RESOLVED]  =3D "ROUTE_RESOLVED",
>> +       [RDMA_CM_EVENT_ROUTE_ERROR]     =3D "ROUTE_ERROR",
>> +       [RDMA_CM_EVENT_CONNECT_REQUEST] =3D "CONNECT_REQUEST",
>> +       [RDMA_CM_EVENT_CONNECT_RESPONSE]=3D "CONNECT_RESPONSE",
>> +       [RDMA_CM_EVENT_CONNECT_ERROR]   =3D "CONNECT_ERROR",
>> +       [RDMA_CM_EVENT_UNREACHABLE]     =3D "UNREACHABLE",
>> +       [RDMA_CM_EVENT_REJECTED]        =3D "REJECTED",
>> +       [RDMA_CM_EVENT_ESTABLISHED]     =3D "ESTABLISHED",
>> +       [RDMA_CM_EVENT_DISCONNECTED]    =3D "DISCONNECTED",
>> +       [RDMA_CM_EVENT_DEVICE_REMOVAL]  =3D "DEVICE_REMOVAL",
>> +       [RDMA_CM_EVENT_MULTICAST_JOIN]  =3D "MULTICAST_JOIN",
>> +       [RDMA_CM_EVENT_MULTICAST_ERROR] =3D "MULTICAST_ERROR",
>> +       [RDMA_CM_EVENT_ADDR_CHANGE]     =3D "ADDR_CHANGE",
>> +       [RDMA_CM_EVENT_TIMEWAIT_EXIT]   =3D "TIMEWAIT_EXIT",
>> +};
>=20
> Sagi,
>=20
> My vote goes to using easy-to-digest human-readable non-capital
> letters strings here and
> elsewhere (IB events, etc),  as done today by the NFS code and
> generally by errno based
> helpers such as strerror, e.g
>=20
> "address resolved"
> "address error"
> "route resolved"
>=20
> Will be happy to hear what others think

I generally prefer spelled-out strings over symbol names.

=46or the strings in xprtrdma, I looked up the symbols in the IBTA spec=
,
and used part of the description of each error. It=92s obvious in most
cases, but there are one or two that are a little odd (eg. MW_BIND_ERR
is =93memory management operation error=94).

> Or.
>=20
>> +
>> +const char *rdma_event_msg(enum rdma_cm_event_type event)
>> +{
>> +       size_t index =3D event;
>> +
>> +       return (index < ARRAY_SIZE(cma_events) && cma_events[index])=
 ?
>> +                       cma_events[index] : "UNRECOGNIZED_EVENT";
>> +}
>> +EXPORT_SYMBOL(rdma_event_msg);
>> +
>> static void cma_add_one(struct ib_device *device);
>> static void cma_remove_one(struct ib_device *device);
>>=20
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/co=
re/verbs.c
>> index f93eb8d..e366a52 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -48,6 +48,71 @@
>>=20
>> #include "core_priv.h"
>>=20
>> +static const char * const ib_events[] =3D {
>> +       [IB_EVENT_CQ_ERR]               =3D "CQ_ERR",
>> +       [IB_EVENT_QP_FATAL]             =3D "QP_FATAL",
>> +       [IB_EVENT_QP_REQ_ERR]           =3D "QP_REQ_ERR",
>> +       [IB_EVENT_QP_ACCESS_ERR]        =3D "QP_ACCESS_ERR",
>> +       [IB_EVENT_COMM_EST]             =3D "COMM_EST",
>> +       [IB_EVENT_SQ_DRAINED]           =3D "SQ_DRAINED",
>> +       [IB_EVENT_PATH_MIG]             =3D "PATH_MIG",
>> +       [IB_EVENT_PATH_MIG_ERR]         =3D "PATH_MIG_ERR",
>> +       [IB_EVENT_DEVICE_FATAL]         =3D "DEVICE_FATAL",
>> +       [IB_EVENT_PORT_ACTIVE]          =3D "PORT_ACTIVE",
>> +       [IB_EVENT_PORT_ERR]             =3D "PORT_ERR",
>> +       [IB_EVENT_LID_CHANGE]           =3D "LID_CHANGE",
>> +       [IB_EVENT_PKEY_CHANGE]          =3D "PKEY_CHANGE",
>> +       [IB_EVENT_SM_CHANGE]            =3D "SM_CHANGE",
>> +       [IB_EVENT_SRQ_ERR]              =3D "SRQ_ERR",
>> +       [IB_EVENT_SRQ_LIMIT_REACHED]    =3D "SRQ_LIMIT_REACHED",
>> +       [IB_EVENT_QP_LAST_WQE_REACHED]  =3D "QP_LAST_WQE_REACHED",
>> +       [IB_EVENT_CLIENT_REREGISTER]    =3D "CLIENT_REREGISTER",
>> +       [IB_EVENT_GID_CHANGE]           =3D "GID_CHANGE",
>> +};
>> +
>> +const char *ib_event_msg(enum ib_event_type event)
>> +{
>> +       size_t index =3D event;
>> +
>> +       return (index < ARRAY_SIZE(ib_events) && ib_events[index]) ?
>> +                       ib_events[index] : "UNRECOGNIZED_EVENT";
>> +}
>> +EXPORT_SYMBOL(ib_event_msg);
>> +
>> +static const char * const wc_statuses[] =3D {
>> +       [IB_WC_SUCCESS]                 =3D "SUCCESS",
>> +       [IB_WC_LOC_LEN_ERR]             =3D "LOC_LEN_ERR",
>> +       [IB_WC_LOC_QP_OP_ERR]           =3D "LOC_QP_OP_ERR",
>> +       [IB_WC_LOC_EEC_OP_ERR]          =3D "LOC_EEC_OP_ERR",
>> +       [IB_WC_LOC_PROT_ERR]            =3D "LOC_PROT_ERR",
>> +       [IB_WC_WR_FLUSH_ERR]            =3D "WR_FLUSH_ERR",
>> +       [IB_WC_MW_BIND_ERR]             =3D "MW_BIND_ERR",
>> +       [IB_WC_BAD_RESP_ERR]            =3D "BAD_RESP_ERR",
>> +       [IB_WC_LOC_ACCESS_ERR]          =3D "LOC_ACCESS_ERR",
>> +       [IB_WC_REM_INV_REQ_ERR]         =3D "REM_INV_REQ_ERR",
>> +       [IB_WC_REM_ACCESS_ERR]          =3D "REM_ACCESS_ERR",
>> +       [IB_WC_REM_OP_ERR]              =3D "REM_OP_ERR",
>> +       [IB_WC_RETRY_EXC_ERR]           =3D "RETRY_EXC_ERR",
>> +       [IB_WC_RNR_RETRY_EXC_ERR]       =3D "RNR_RETRY_EXC_ERR",
>> +       [IB_WC_LOC_RDD_VIOL_ERR]        =3D "LOC_RDD_VIOL_ERR",
>> +       [IB_WC_REM_INV_RD_REQ_ERR]      =3D "REM_INV_RD_REQ_ERR",
>> +       [IB_WC_REM_ABORT_ERR]           =3D "REM_ABORT_ERR",
>> +       [IB_WC_INV_EECN_ERR]            =3D "INV_EECN_ERR",
>> +       [IB_WC_INV_EEC_STATE_ERR]       =3D "INV_EEC_STATE_ERR",
>> +       [IB_WC_FATAL_ERR]               =3D "FATAL_ERR",
>> +       [IB_WC_RESP_TIMEOUT_ERR]        =3D "RESP_TIMEOUT_ERR",
>> +       [IB_WC_GENERAL_ERR]             =3D "GENERAL_ERR",
>> +};
>> +
>> +const char *ib_wc_status_msg(enum ib_wc_status status)
>> +{
>> +       size_t index =3D status;
>> +
>> +       return (index < ARRAY_SIZE(wc_statuses) && wc_statuses[index=
]) ?
>> +                       wc_statuses[index] : "UNRECOGNIZED_STATUS";
>> +}
>> +EXPORT_SYMBOL(ib_wc_status_msg);
>> +
>> __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
>> {
>>        switch (rate) {
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 65994a1..672fc8f 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -412,6 +412,8 @@ enum ib_event_type {
>>        IB_EVENT_GID_CHANGE,
>> };
>>=20
>> +__attribute_const__ const char *ib_event_msg(enum ib_event_type eve=
nt);
>> +
>> struct ib_event {
>>        struct ib_device        *device;
>>        union {
>> @@ -663,6 +665,8 @@ enum ib_wc_status {
>>        IB_WC_GENERAL_ERR
>> };
>>=20
>> +__attribute_const__ const char *ib_wc_status_msg(enum ib_wc_status =
status);
>> +
>> enum ib_wc_opcode {
>>        IB_WC_SEND,
>>        IB_WC_RDMA_WRITE,
>> diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
>> index 1ed2088..c92522c 100644
>> --- a/include/rdma/rdma_cm.h
>> +++ b/include/rdma/rdma_cm.h
>> @@ -62,6 +62,8 @@ enum rdma_cm_event_type {
>>        RDMA_CM_EVENT_TIMEWAIT_EXIT
>> };
>>=20
>> +__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event_t=
ype event);
>> +
>> enum rdma_port_space {
>>        RDMA_PS_SDP   =3D 0x0001,
>>        RDMA_PS_IPOIB =3D 0x0002,
>> --
>> 1.7.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
