From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/3] ib_core: API for deriving common display strings
Date: Wed, 3 Dec 2014 16:17:27 -0500
Message-ID: <99354139-3063-459B-917F-C73B1872D2AE@oracle.com>
References: <20141117022038.4079.66922.stgit@manet.1015granger.net> <20141117022948.4079.36917.stgit@manet.1015granger.net>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141117022948.4079.36917.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Nov 16, 2014, at 9:29 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote=
:

> Introduce an API that can be shared among RDMA consumers for
> displaying string versions of status and event codes.
>=20
> Or Gerlitz suggested moving the functions from the RDS module
> written by Zach Brown into ib_core. These provide conversion from
> status/event codes to symbolic names, suitable for copy-and-paste
> into a source code search tool.
>=20
> Another interface is provided for displaying human-readable
> connection status suitable for administrative interfaces.
>=20
> It might also be interesting someday to provide conversion from op
> codes to symbolic names.
>=20
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

I=92d like to see this merged in 3.19. Will you take this in the
IB/core tree?


> ---
> drivers/infiniband/core/Makefile |    3 -
> drivers/infiniband/core/str.c    |  167 +++++++++++++++++++++++++++++=
+++++++++
> include/rdma/ib_str.h            |   54 ++++++++++++
> 3 files changed, 223 insertions(+), 1 deletion(-)
> create mode 100644 drivers/infiniband/core/str.c
> create mode 100644 include/rdma/ib_str.h
>=20
> diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/co=
re/Makefile
> index ffd0af6..c2eb383 100644
> --- a/drivers/infiniband/core/Makefile
> +++ b/drivers/infiniband/core/Makefile
> @@ -9,7 +9,8 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=3D	ib_uverbs.o=
 ib_ucm.o \
> 					$(user_access-y)
>=20
> ib_core-y :=3D			packer.o ud_header.o verbs.o sysfs.o \
> -				device.o fmr_pool.o cache.o netlink.o
> +				device.o fmr_pool.o cache.o netlink.o \
> +				str.o
> ib_core-$(CONFIG_INFINIBAND_USER_MEM) +=3D umem.o
>=20
> ib_mad-y :=3D			mad.o smi.o agent.o mad_rmpp.o
> diff --git a/drivers/infiniband/core/str.c b/drivers/infiniband/core/=
str.c
> new file mode 100644
> index 0000000..2e316a1
> --- /dev/null
> +++ b/drivers/infiniband/core/str.c
> @@ -0,0 +1,167 @@
> +/*
> + * Copyright (c) 2006, 2014 Oracle.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the G=
NU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the followi=
ng
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the followin=
g
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the followin=
g
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#include <rdma/ib_str.h>
> +
> +static const char *
> +__str_array(const char * const *array, size_t elements, size_t index=
)
> +{
> +	if ((index < elements) && array[index])
> +		return array[index];
> +	else
> +		return "unrecognized";
> +}
> +
> +#define __IB_WC_SYMBOL(foo) \
> +		[IB_WC_##foo] =3D "IB_WC_##foo"
> +static const char * const ib_wc_status_symbols[] =3D {
> +	__IB_WC_SYMBOL(SUCCESS),
> +	__IB_WC_SYMBOL(LOC_LEN_ERR),
> +	__IB_WC_SYMBOL(LOC_QP_OP_ERR),
> +	__IB_WC_SYMBOL(LOC_EEC_OP_ERR),
> +	__IB_WC_SYMBOL(LOC_PROT_ERR),
> +	__IB_WC_SYMBOL(WR_FLUSH_ERR),
> +	__IB_WC_SYMBOL(MW_BIND_ERR),
> +	__IB_WC_SYMBOL(BAD_RESP_ERR),
> +	__IB_WC_SYMBOL(LOC_ACCESS_ERR),
> +	__IB_WC_SYMBOL(REM_INV_REQ_ERR),
> +	__IB_WC_SYMBOL(REM_ACCESS_ERR),
> +	__IB_WC_SYMBOL(REM_OP_ERR),
> +	__IB_WC_SYMBOL(RETRY_EXC_ERR),
> +	__IB_WC_SYMBOL(RNR_RETRY_EXC_ERR),
> +	__IB_WC_SYMBOL(LOC_RDD_VIOL_ERR),
> +	__IB_WC_SYMBOL(REM_INV_RD_REQ_ERR),
> +	__IB_WC_SYMBOL(REM_ABORT_ERR),
> +	__IB_WC_SYMBOL(INV_EECN_ERR),
> +	__IB_WC_SYMBOL(INV_EEC_STATE_ERR),
> +	__IB_WC_SYMBOL(FATAL_ERR),
> +	__IB_WC_SYMBOL(RESP_TIMEOUT_ERR),
> +	__IB_WC_SYMBOL(GENERAL_ERR),
> +};
> +
> +const char *
> +ib_wc_status_symbol(enum ib_wc_status status)
> +{
> +	return __str_array(ib_wc_status_symbols,
> +			   ARRAY_SIZE(ib_wc_status_symbols), status);
> +}
> +EXPORT_SYMBOL(ib_wc_status_symbol);
> +
> +
> +#define __IB_EVENT_SYMBOL(foo) \
> +		[IB_EVENT_##foo] =3D "IB_EVENT_##foo"
> +static const char * const ib_event_type_symbols[] =3D {
> +	__IB_EVENT_SYMBOL(CQ_ERR),
> +	__IB_EVENT_SYMBOL(QP_FATAL),
> +	__IB_EVENT_SYMBOL(QP_REQ_ERR),
> +	__IB_EVENT_SYMBOL(QP_ACCESS_ERR),
> +	__IB_EVENT_SYMBOL(COMM_EST),
> +	__IB_EVENT_SYMBOL(SQ_DRAINED),
> +	__IB_EVENT_SYMBOL(PATH_MIG),
> +	__IB_EVENT_SYMBOL(PATH_MIG_ERR),
> +	__IB_EVENT_SYMBOL(DEVICE_FATAL),
> +	__IB_EVENT_SYMBOL(PORT_ACTIVE),
> +	__IB_EVENT_SYMBOL(PORT_ERR),
> +	__IB_EVENT_SYMBOL(LID_CHANGE),
> +	__IB_EVENT_SYMBOL(PKEY_CHANGE),
> +	__IB_EVENT_SYMBOL(SM_CHANGE),
> +	__IB_EVENT_SYMBOL(SRQ_ERR),
> +	__IB_EVENT_SYMBOL(SRQ_LIMIT_REACHED),
> +	__IB_EVENT_SYMBOL(QP_LAST_WQE_REACHED),
> +	__IB_EVENT_SYMBOL(CLIENT_REREGISTER),
> +	__IB_EVENT_SYMBOL(GID_CHANGE),
> +};
> +
> +const char *
> +ib_event_type_symbol(enum ib_event_type type)
> +{
> +	return __str_array(ib_event_type_symbols,
> +			   ARRAY_SIZE(ib_event_type_symbols), type);
> +};
> +EXPORT_SYMBOL(ib_event_type_symbol);
> +
> +#define __RDMA_CM_EVENT_SYMBOL(foo) \
> +		[RDMA_CM_EVENT_##foo] =3D "RDMA_CM_EVENT_##foo"
> +static const char * const rdma_cm_event_symbols[] =3D {
> +	__RDMA_CM_EVENT_SYMBOL(ADDR_RESOLVED),
> +	__RDMA_CM_EVENT_SYMBOL(ADDR_ERROR),
> +	__RDMA_CM_EVENT_SYMBOL(ROUTE_RESOLVED),
> +	__RDMA_CM_EVENT_SYMBOL(ROUTE_ERROR),
> +	__RDMA_CM_EVENT_SYMBOL(CONNECT_REQUEST),
> +	__RDMA_CM_EVENT_SYMBOL(CONNECT_RESPONSE),
> +	__RDMA_CM_EVENT_SYMBOL(CONNECT_ERROR),
> +	__RDMA_CM_EVENT_SYMBOL(UNREACHABLE),
> +	__RDMA_CM_EVENT_SYMBOL(REJECTED),
> +	__RDMA_CM_EVENT_SYMBOL(ESTABLISHED),
> +	__RDMA_CM_EVENT_SYMBOL(DISCONNECTED),
> +	__RDMA_CM_EVENT_SYMBOL(DEVICE_REMOVAL),
> +	__RDMA_CM_EVENT_SYMBOL(MULTICAST_JOIN),
> +	__RDMA_CM_EVENT_SYMBOL(MULTICAST_ERROR),
> +	__RDMA_CM_EVENT_SYMBOL(ADDR_CHANGE),
> +	__RDMA_CM_EVENT_SYMBOL(TIMEWAIT_EXIT),
> +};
> +
> +const char *
> +rdma_cm_event_symbol(enum rdma_cm_event_type type)
> +{
> +	return __str_array(rdma_cm_event_symbols,
> +			   ARRAY_SIZE(rdma_cm_event_symbols), type);
> +};
> +EXPORT_SYMBOL(rdma_cm_event_symbol);
> +
> +static const char * const rdma_cm_event_strings[] =3D {
> +	[RDMA_CM_EVENT_ADDR_RESOLVED]		=3D "address resolved",
> +	[RDMA_CM_EVENT_ADDR_ERROR]		=3D "address error",
> +	[RDMA_CM_EVENT_ROUTE_RESOLVED]		=3D "route resolved",
> +	[RDMA_CM_EVENT_ROUTE_ERROR]		=3D "route error",
> +	[RDMA_CM_EVENT_CONNECT_REQUEST]		=3D "connect request",
> +	[RDMA_CM_EVENT_CONNECT_RESPONSE]	=3D "connect response",
> +	[RDMA_CM_EVENT_CONNECT_ERROR]		=3D "connect error",
> +	[RDMA_CM_EVENT_UNREACHABLE]		=3D "unreachable",
> +	[RDMA_CM_EVENT_REJECTED]		=3D "rejected",
> +	[RDMA_CM_EVENT_ESTABLISHED]		=3D "established",
> +	[RDMA_CM_EVENT_DISCONNECTED]		=3D "disconnected",
> +	[RDMA_CM_EVENT_DEVICE_REMOVAL]		=3D "device removal",
> +	[RDMA_CM_EVENT_MULTICAST_JOIN]		=3D "multicast join",
> +	[RDMA_CM_EVENT_MULTICAST_ERROR]		=3D "multicast error",
> +	[RDMA_CM_EVENT_ADDR_CHANGE]		=3D "address change",
> +	[RDMA_CM_EVENT_TIMEWAIT_EXIT]		=3D "timewait exit",
> +};
> +
> +const char *
> +rdma_cm_event_str(enum rdma_cm_event_type type)
> +{
> +	return type < ARRAY_SIZE(rdma_cm_event_strings) ?
> +		rdma_cm_event_strings[type] : "unrecognized connection error";
> +};
> +EXPORT_SYMBOL(rdma_cm_event_str);
> diff --git a/include/rdma/ib_str.h b/include/rdma/ib_str.h
> new file mode 100644
> index 0000000..c330b8a
> --- /dev/null
> +++ b/include/rdma/ib_str.h
> @@ -0,0 +1,54 @@
> +/*
> + * Copyright (c) 2006, 2014 Oracle.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the G=
NU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the followi=
ng
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the followin=
g
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the followin=
g
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#if !defined(_RDMA_IB_STR_H)
> +#define _RDMA_IB_STR_H
> +
> +#include <rdma/ib_verbs.h>
> +#include <rdma/rdma_cm.h>
> +
> +/*
> + * Display the symbolic name of a status code. Suitable
> + * for copy and paste into a source code search window.
> + */
> +const char *ib_wc_status_symbol(enum ib_wc_status status);
> +const char *ib_event_type_symbol(enum ib_event_type type);
> +const char *rdma_cm_event_symbol(enum rdma_cm_event_type type);
> +
> +/*
> + * Display a connection status message. Suitable for
> + * administrative interfaces.
> + */
> +const char *rdma_cm_event_str(enum rdma_cm_event_type type);
> +
> +#endif	/* _RDMA_IB_STR_H */
>=20
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
