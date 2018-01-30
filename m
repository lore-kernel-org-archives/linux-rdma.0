From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 06/13] SoftiWarp connection management
Date: Tue, 30 Jan 2018 15:27:38 -0600
Message-ID: <047b01d39a11$27609940$7621cbc0$@opengridcomputing.com>
References: <20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-7-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180114223603.19961-7-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_cm.c | 2184
> ++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_cm.h |  156 +++
>  2 files changed, 2340 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.h

<snip>

> diff --git a/drivers/infiniband/sw/siw/siw_cm.h
> b/drivers/infiniband/sw/siw/siw_cm.h
> new file mode 100644
> index 000000000000..36a8d15d793a
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/siw_cm.h
> @@ -0,0 +1,156 @@
> +/*
> + * Software iWARP device driver
> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *          Greg Joyce <greg-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> + *
> + * Copyright (c) 2008-2017, IBM Corporation
> + * Copyright (c) 2017, Open Grid Computing, Inc.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses. You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *   Redistribution and use in source and binary forms, with or
> + *   without modification, are permitted provided that the following
> + *   conditions are met:
> + *
> + *   - Redistributions of source code must retain the above copyright
notice,
> + *     this list of conditions and the following disclaimer.
> + *
> + *   - Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in
the
> + *     documentation and/or other materials provided with the
distribution.
> + *
> + *   - Neither the name of IBM nor the names of its contributors may be
> + *     used to endorse or promote products derived from this software
without
> + *     specific prior written permission.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
> IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _SIW_CM_H
> +#define _SIW_CM_H
> +
> +#include <net/sock.h>
> +#include <linux/tcp.h>
> +
> +#include <rdma/iw_cm.h>
> +
> +
> +enum siw_cep_state {
> +	SIW_EPSTATE_IDLE = 1,
> +	SIW_EPSTATE_LISTENING,
> +	SIW_EPSTATE_CONNECTING,
> +	SIW_EPSTATE_AWAIT_MPAREQ,
> +	SIW_EPSTATE_RECVD_MPAREQ,
> +	SIW_EPSTATE_AWAIT_MPAREP,
> +	SIW_EPSTATE_RDMA_MODE,
> +	SIW_EPSTATE_CLOSED
> +};
> +
> +struct siw_mpa_info {
> +	struct mpa_rr		hdr;	/* peer mpa hdr in host byte order
*/
> +	struct mpa_v2_data	v2_ctrl;
> +	struct mpa_v2_data	v2_ctrl_req;
> +	char			*pdata;
> +	int			bytes_rcvd;
> +};
> +
> +struct siw_llp_info {
> +	struct socket		*sock;
> +	struct sockaddr_in	laddr;	/* redundant with socket info above
*/
> +	struct sockaddr_in	raddr;	/* dito, consider removal */
> +	struct siw_sk_upcalls	sk_def_upcalls;
> +};
> +
> +struct siw_device;
> +
> +struct siw_cep {
> +	struct iw_cm_id		*cm_id;
> +	struct siw_device	*sdev;
> +
> +	struct list_head	devq;
> +	/*
> +	 * The provider_data element of a listener IWCM ID
> +	 * refers to a list of one or more listener CEPs
> +	 */
> +	struct list_head	listenq;
> +	struct siw_cep		*listen_cep;
> +	struct siw_qp		*qp;
> +	spinlock_t		lock;
> +	wait_queue_head_t	waitq;
> +	struct kref		ref;
> +	enum siw_cep_state	state;
> +	short			in_use;
> +	struct siw_cm_work	*mpa_timer;
> +	struct list_head	work_freelist;
> +	struct siw_llp_info	llp;
> +	struct siw_mpa_info	mpa;
> +	int			ord;
> +	int			ird;
> +	bool			enhanced_rdma_conn_est;
> +	int			sk_error; /* not (yet) used XXX */
> +
> +	/* Saved upcalls of socket llp.sock */
> +	void	(*sk_state_change)(struct sock *sk);
> +	void	(*sk_data_ready)(struct sock *sk);
> +	void	(*sk_write_space)(struct sock *sk);
> +	void	(*sk_error_report)(struct sock *sk);
> +};
> +
> +/*
> + * Connection initiator waits 10 seconds to receive an
> + * MPA reply after sending out MPA request. Reponder waits for
> + * 5 seconds for MPA request to arrive if new TCP connection
> + * was set up.
> + */
> +#define MPAREQ_TIMEOUT	(HZ*10)
> +#define MPAREP_TIMEOUT	(HZ*5)
> +

These timeout times seem pretty low for a WAN link or even a brief network
down event during MPA negotiation connection.   Any particular reason for 10
and 5?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
