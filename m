From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/13] SoftiWarp Queue Pair methods
Date: Sun, 8 Oct 2017 16:11:44 +0300
Message-ID: <20171008131144.GX25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-9-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6pjpgtPchv3bUQQn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-9-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--6pjpgtPchv3bUQQn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:48AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_qp.c | 1173 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 1173 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_qp.c
>
> diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
> new file mode 100644
> index 000000000000..dc33d8fd93f8
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/siw_qp.c
> @@ -0,0 +1,1173 @@
> +/*
> + * Software iWARP device driver for Linux
> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *
> + * Copyright (c) 2008-2017, IBM Corporation
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
> + *   - Redistributions of source code must retain the above copyright notice,
> + *     this list of conditions and the following disclaimer.
> + *
> + *   - Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in the
> + *     documentation and/or other materials provided with the distribution.
> + *
> + *   - Neither the name of IBM nor the names of its contributors may be
> + *     used to endorse or promote products derived from this software without
> + *     specific prior written permission.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/net.h>
> +#include <linux/file.h>
> +#include <linux/scatterlist.h>
> +#include <linux/highmem.h>
> +#include <linux/vmalloc.h>
> +#include <asm/barrier.h>
> +#include <net/sock.h>
> +#include <net/tcp_states.h>
> +#include <net/tcp.h>
> +
> +#include <rdma/iw_cm.h>
> +#include <rdma/ib_verbs.h>
> +#include <rdma/ib_smi.h>
> +#include <rdma/ib_user_verbs.h>
> +
> +#include "siw.h"
> +#include "siw_obj.h"
> +#include "siw_cm.h"
> +
> +
> +#if DPRINT_MASK > 0
> +static char siw_qp_state_to_string[SIW_QP_STATE_COUNT][sizeof "TERMINATE"] = {
> +	[SIW_QP_STATE_IDLE]		= "IDLE",
> +	[SIW_QP_STATE_RTR]		= "RTR",
> +	[SIW_QP_STATE_RTS]		= "RTS",
> +	[SIW_QP_STATE_CLOSING]		= "CLOSING",
> +	[SIW_QP_STATE_TERMINATE]	= "TERMINATE",
> +	[SIW_QP_STATE_ERROR]		= "ERROR"
> +};
> +#endif
> +
> +extern struct crypto_shash *siw_crypto_shash;
> +
> +/*
> + * iWARP (RDMAP, DDP and MPA) parameters as well as Softiwarp settings on a
> + * per-RDMAP message basis. Please keep order of initializer. All MPA len
> + * is initialized to minimum packet size.
> + */
> +struct iwarp_msg_info iwarp_pktinfo[RDMAP_TERMINATE + 1] = { {
> +	/* RDMAP_RDMA_WRITE */
> +	.hdr_len = sizeof(struct iwarp_rdma_write),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_write) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_TAGGED | DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_RDMA_WRITE),
> +	.proc_data = siw_proc_write
> +},
> +{	/* RDMAP_RDMA_READ_REQ */
> +	.hdr_len = sizeof(struct iwarp_rdma_rreq),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_rreq) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_RDMA_READ_REQ),
> +	.proc_data = siw_proc_rreq
> +},
> +{	/* RDMAP_RDMA_READ_RESP */
> +	.hdr_len = sizeof(struct iwarp_rdma_rresp),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_rresp) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_TAGGED | DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_RDMA_READ_RESP),
> +	.proc_data = siw_proc_rresp
> +},
> +{	/* RDMAP_SEND */
> +	.hdr_len = sizeof(struct iwarp_send),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_send) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_SEND),
> +	.proc_data = siw_proc_send
> +},
> +{	/* RDMAP_SEND_INVAL */
> +	.hdr_len = sizeof(struct iwarp_send_inv),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_send_inv) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_SEND_INVAL),
> +	.proc_data = siw_proc_send
> +},
> +{	/* RDMAP_SEND_SE */
> +	.hdr_len = sizeof(struct iwarp_send),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_send) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_SEND_SE),
> +	.proc_data = siw_proc_send
> +},
> +{	/* RDMAP_SEND_SE_INVAL */
> +	.hdr_len = sizeof(struct iwarp_send_inv),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_send_inv) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_SEND_SE_INVAL),
> +	.proc_data = siw_proc_send
> +},
> +{	/* RDMAP_TERMINATE */
> +	.hdr_len = sizeof(struct iwarp_terminate),
> +	.ctrl.mpa_len = htons(sizeof(struct iwarp_terminate) - 2),
> +	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
> +		| cpu_to_be16(DDP_VERSION << 8)
> +		| cpu_to_be16(RDMAP_VERSION << 6)
> +		| cpu_to_be16(RDMAP_TERMINATE),
> +	.proc_data = siw_proc_terminate
> +} };
> +
> +void siw_qp_llp_data_ready(struct sock *sk)
> +{
> +	struct siw_qp		*qp;
> +
> +	read_lock(&sk->sk_callback_lock);
> +
> +	if (unlikely(!sk->sk_user_data || !sk_to_qp(sk))) {
> +		dprint(DBG_ON, " No QP: %p\n", sk->sk_user_data);
> +		goto done;
> +	}
> +	qp = sk_to_qp(sk);
> +
> +	if (likely(!qp->rx_ctx.rx_suspend &&
> +		   down_read_trylock(&qp->state_lock))) {
> +		read_descriptor_t rd_desc = {.arg.data = qp, .count = 1};
> +
> +		dprint(DBG_SK|DBG_RX, "(QP%d): state (before read_sock)=%d\n",
> +			QP_ID(qp), qp->attrs.state);
> +
> +		if (likely(qp->attrs.state == SIW_QP_STATE_RTS))
> +			/*
> +			 * Implements data receive operation during
> +			 * socket callback. TCP gracefully catches
> +			 * the case where there is nothing to receive
> +			 * (not calling siw_tcp_rx_data() then).
> +			 */
> +			tcp_read_sock(sk, &rd_desc, siw_tcp_rx_data);
> +
> +		dprint(DBG_SK|DBG_RX, "(QP%d): state (after read_sock)=%d\n",
> +			QP_ID(qp), qp->attrs.state);

The word "likely" and debug prints are opposite things and rare to be at
the same function.

> +
> +		up_read(&qp->state_lock);
> +	} else {
> +		dprint(DBG_SK|DBG_RX, "(QP%d): Unable to RX: rx_suspend: %d\n",
> +			QP_ID(qp), qp->rx_ctx.rx_suspend);
> +	}
> +done:
> +	read_unlock(&sk->sk_callback_lock);
> +}
> +
> +
> +void siw_qp_llp_close(struct siw_qp *qp)
> +{
> +	dprint(DBG_CM, "(QP%d): Enter: SIW QP state = %s, cep=0x%p\n",
> +		QP_ID(qp), siw_qp_state_to_string[qp->attrs.state],
> +		qp->cep);
> +
> +	down_write(&qp->state_lock);
> +
> +	dprint(DBG_CM, "(QP%d): state locked\n", QP_ID(qp));
> +
> +	qp->rx_ctx.rx_suspend = 1;
> +	qp->tx_ctx.tx_suspend = 1;
> +	qp->attrs.llp_stream_handle = NULL;
> +
> +	switch (qp->attrs.state) {
> +
> +	case SIW_QP_STATE_RTS:
> +	case SIW_QP_STATE_RTR:
> +	case SIW_QP_STATE_IDLE:
> +	case SIW_QP_STATE_TERMINATE:
> +

No extra space

> +		qp->attrs.state = SIW_QP_STATE_ERROR;
> +
> +		break;
> +	/*
> +	 * SIW_QP_STATE_CLOSING:
> +	 *
> +	 * This is a forced close. shall the QP be moved to
> +	 * ERROR or IDLE ?
> +	 */
> +	case SIW_QP_STATE_CLOSING:
> +		if (tx_wqe(qp)->wr_status == SIW_WR_IDLE)
> +			qp->attrs.state = SIW_QP_STATE_ERROR;
> +		else
> +			qp->attrs.state = SIW_QP_STATE_IDLE;
> +
> +		break;
> +
> +	default:
> +		dprint(DBG_CM, " No state transition needed: %d\n",
> +			qp->attrs.state);
> +		break;
> +	}
> +	siw_sq_flush(qp);
> +	siw_rq_flush(qp);
> +
> +	/*
> +	 * dereference closing CEP
> +	 */
> +	if (qp->cep) {
> +		siw_cep_put(qp->cep);
> +		qp->cep = NULL;
> +	}
> +
> +	up_write(&qp->state_lock);
> +	dprint(DBG_CM, "(QP%d): Exit: SIW QP state = %s, cep=0x%p\n",
> +		QP_ID(qp), siw_qp_state_to_string[qp->attrs.state],
> +		qp->cep);
> +}
> +
> +
> +/*
> + * socket callback routine informing about newly available send space.
> + * Function schedules SQ work for processing SQ items.
> + */
> +void siw_qp_llp_write_space(struct sock *sk)
> +{
> +	struct siw_cep	*cep = sk_to_cep(sk);
> +
> +	cep->sk_write_space(sk);
> +
> +	if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
> +		siw_sq_start(cep->qp);
> +}
> +
> +static int siw_qp_readq_init(struct siw_qp *qp, int irq_size, int orq_size)
> +{
> +	dprint(DBG_CM|DBG_WR, "(QP%d): %d %d\n", QP_ID(qp), irq_size, orq_size);
> +
> +	if (!irq_size)
> +		irq_size = 1;
> +	if (!orq_size)
> +		orq_size = 1;
> +
> +	qp->attrs.irq_size = irq_size;
> +	qp->attrs.orq_size = orq_size;
> +
> +	qp->irq = vmalloc(irq_size * sizeof(struct siw_sqe));
> +	if (!qp->irq) {
> +		dprint(DBG_ON, "(QP%d): Failed\n", QP_ID(qp));
> +		qp->attrs.irq_size = 0;
> +		return -ENOMEM;
> +	}
> +	qp->orq = vmalloc(orq_size * sizeof(struct siw_sqe));
> +	if (!qp->orq) {
> +		dprint(DBG_ON, "(QP%d): Failed\n", QP_ID(qp));
> +		qp->attrs.orq_size = 0;
> +		qp->attrs.irq_size = 0;
> +		vfree(qp->irq);
> +		return -ENOMEM;
> +	}
> +	memset(qp->irq, 0, irq_size * sizeof(struct siw_sqe));
> +	memset(qp->orq, 0, orq_size * sizeof(struct siw_sqe));

Use vzalloc.

> +
> +	return 0;

--6pjpgtPchv3bUQQn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaJBAACgkQ5GN7iDZy
WKfYUw/+LOkeDzUxEQ3+Uwd5fbSCo6mlL+5rhMD6rBGw6saoKyxuv65FJgM9Mv+9
4zBYgA2FPfxPPoTR/jcrtVqlAm9CbmOIiy2JHDFuL8QrQzKG62elFAhzXI+9r9WW
XanKYstuRJQ5sjyq5fSjs4vuxOLbBWHaLT87dT//cDS2teKMX6Vx0aB6KVsYFjE2
eAmaDf0H8lzN60YarkO2vdnhZHgRE0/oIx0ahA+rQDqZ61kYE+VPCngspDkOFK7n
DHbAU7SjN9BQmnh1pEIJ0rzyYIq9CadXdjaBSDnp76AGPKTbOmmYp0D7y5iaBwC4
vM+oDW67CsrPc0JC4KqiKU66mxYN0Yy/WZDaVBZACu8ZgDMzzkXayM6koALY9BHA
Y2LZ8gEFxY/fIBkiH0EtOczAH1wNbs0cA+e+PvominTJMyKjx0Cf/PPwsC6eU1Uu
11fuUAoLNKTH6u/oLaztyesrL1sJ3qN4PSP7L7EZ54gHuZjO7ZQ+3Pikoo81PY54
HtUcU5lQy70EyjSFD2rNUiYDvjzLqpRZfJdQ8ybpRoX9fbfgZdRbgrZGrTugj23f
y7nfEeqlEIScjzkqXYaisIS/Ot9orOBAES9Uj9CU+8aq4bl8jC+mnvl9BIRt5TIB
N1/3VuVL6MQe8MHsv1IUpQowJW2vAb5pMsSH3IV6ktGGg3Joktg=
=kbGM
-----END PGP SIGNATURE-----

--6pjpgtPchv3bUQQn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
