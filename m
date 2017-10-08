From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/13] SoftiWarp application interface
Date: Sun, 8 Oct 2017 16:17:46 +0300
Message-ID: <20171008131746.GY25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-6-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Gle0L8H5l8ToQqD4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-6-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Gle0L8H5l8ToQqD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:45AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_ae.c    |  113 ++
>  drivers/infiniband/sw/siw/siw_verbs.c | 1929 +++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
>  include/uapi/rdma/siw_user.h          |  220 ++++
>  4 files changed, 2381 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
>  create mode 100644 include/uapi/rdma/siw_user.h
>

<..>

> +#endif
> diff --git a/include/uapi/rdma/siw_user.h b/include/uapi/rdma/siw_user.h
> new file mode 100644
> index 000000000000..9bf1448d54e7
> --- /dev/null
> +++ b/include/uapi/rdma/siw_user.h
> @@ -0,0 +1,220 @@
> +/*
> + * Software iWARP device driver for Linux
> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *
> + * Copyright (c) 2008-2017, IBM Corporation
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
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
> +#ifndef _SIW_USER_H
> +#define _SIW_USER_H
> +
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
> +
> +/*Common string that is matched to accept the device by the user library*/
> +#define SIW_NODE_DESC_COMMON	"Software iWARP stack"
> +
> +#define SIW_IBDEV_PREFIX "siw_"

NACK to whole this file, no "#ifdef __KERNEL__" magic and wrong data types.

> +
> +#define VERSION_ID_SOFTIWARP	2
> +
> +#define SIW_MAX_SGE		6
> +#define SIW_MAX_UOBJ_KEY	0xffffff
> +#define SIW_INVAL_UOBJ_KEY	(SIW_MAX_UOBJ_KEY + 1)
> +
> +struct siw_uresp_create_cq {
> +	uint32_t	cq_id;
> +	uint32_t	num_cqe;
> +	uint32_t	cq_key;
> +};
> +
> +struct siw_uresp_create_qp {
> +	uint32_t	qp_id;
> +	uint32_t	num_sqe;
> +	uint32_t	num_rqe;
> +	uint32_t	sq_key;
> +	uint32_t	rq_key;
> +};
> +
> +struct siw_ureq_reg_mr {
> +	uint8_t	stag_key;
> +	uint8_t	reserved[3];
> +};
> +
> +struct siw_uresp_reg_mr {
> +	uint32_t	stag;
> +};
> +
> +struct siw_uresp_create_srq {
> +	uint32_t	num_rqe;
> +	uint32_t	srq_key;
> +};
> +
> +struct siw_uresp_alloc_ctx {
> +	uint32_t	dev_id;
> +};
> +
> +enum siw_opcode {
> +	SIW_OP_WRITE		= 0,
> +	SIW_OP_READ		= 1,
> +	SIW_OP_READ_LOCAL_INV	= 2,
> +	SIW_OP_SEND		= 3,
> +	SIW_OP_SEND_WITH_IMM	= 4,
> +	SIW_OP_SEND_REMOTE_INV	= 5,
> +
> +	/* Unsupported */
> +	SIW_OP_FETCH_AND_ADD	= 6,
> +	SIW_OP_COMP_AND_SWAP	= 7,
> +
> +	SIW_OP_RECEIVE		= 8,
> +	/* provider internal SQE */
> +	SIW_OP_READ_RESPONSE	= 9,
> +	/*
> +	 * below opcodes valid for
> +	 * in-kernel clients only
> +	 */
> +	SIW_OP_INVAL_STAG	= 10,
> +	SIW_OP_REG_MR		= 11,
> +	SIW_NUM_OPCODES		= 12
> +};
> +
> +/* Keep it same as ibv_sge to allow for memcpy */
> +struct siw_sge {
> +	uint64_t	laddr;
> +	uint32_t	length;
> +	uint32_t	lkey;
> +};
> +
> +/*
> + * Inline data are kept within the work request itself occupying
> + * the space of sge[1] .. sge[n]. Therefore, inline data cannot be
> + * supported if SIW_MAX_SGE is below 2 elements.
> + */
> +#define SIW_MAX_INLINE	(sizeof(struct siw_sge) * (SIW_MAX_SGE - 1))
> +
> +#if SIW_MAX_SGE < 2
> +#error "SIW_MAX_SGE must be at least 2"
> +#endif
> +
> +enum siw_wqe_flags {
> +	SIW_WQE_VALID           = 1,
> +	SIW_WQE_INLINE          = (1 << 1),
> +	SIW_WQE_SIGNALLED       = (1 << 2),
> +	SIW_WQE_SOLICITED       = (1 << 3),
> +	SIW_WQE_READ_FENCE	= (1 << 4),
> +	SIW_WQE_COMPLETED       = (1 << 5)
> +};
> +
> +/* Send Queue Element */
> +struct siw_sqe {
> +	uint64_t	id;
> +	uint16_t	flags;
> +	uint8_t		num_sge;
> +	/* Contains enum siw_opcode values */
> +	uint8_t		opcode;
> +	uint32_t	rkey;
> +	union {
> +		uint64_t	raddr;
> +		uint64_t	ofa_mr;
> +	};
> +	union {
> +		struct siw_sge	sge[SIW_MAX_SGE];
> +		uint32_t	access;
> +	};
> +};
> +
> +/* Receive Queue Element */
> +struct siw_rqe {
> +	uint64_t	id;
> +	uint16_t	flags;
> +	uint8_t		num_sge;
> +	/*
> +	 * only used by kernel driver,
> +	 * ignored if set by user
> +	 */
> +	uint8_t		opcode;
> +	uint32_t	imm_data;
> +	struct siw_sge	sge[SIW_MAX_SGE];
> +};
> +
> +enum siw_notify_flags {
> +	SIW_NOTIFY_NOT			= (0),
> +	SIW_NOTIFY_SOLICITED		= (1 << 0),
> +	SIW_NOTIFY_NEXT_COMPLETION	= (1 << 1),
> +	SIW_NOTIFY_MISSED_EVENTS	= (1 << 2),
> +	SIW_NOTIFY_ALL = SIW_NOTIFY_SOLICITED |
> +			SIW_NOTIFY_NEXT_COMPLETION |
> +			SIW_NOTIFY_MISSED_EVENTS
> +};
> +
> +enum siw_wc_status {
> +	SIW_WC_SUCCESS		= 0,
> +	SIW_WC_LOC_LEN_ERR	= 1,
> +	SIW_WC_LOC_PROT_ERR	= 2,
> +	SIW_WC_LOC_QP_OP_ERR	= 3,
> +	SIW_WC_WR_FLUSH_ERR	= 4,
> +	SIW_WC_BAD_RESP_ERR	= 5,
> +	SIW_WC_LOC_ACCESS_ERR	= 6,
> +	SIW_WC_REM_ACCESS_ERR	= 7,
> +	SIW_WC_REM_INV_REQ_ERR	= 8,
> +	SIW_WC_GENERAL_ERR	= 9,
> +	SIW_NUM_WC_STATUS	= 10
> +};
> +
> +struct siw_cqe {
> +	uint64_t	id;
> +	uint8_t		flags;
> +	uint8_t		opcode;
> +	uint16_t	status;
> +	uint32_t	bytes;
> +	uint64_t	imm_data;
> +	/* QP number or QP pointer */
> +	union {
> +		void	*qp;
> +		uint64_t qp_id;
> +	};
> +};
> +
> +/*
> + * Shared structure between user and kernel
> + * to control CQ arming.
> + */
> +struct siw_cq_ctrl {
> +	enum siw_notify_flags	notify;
> +};
> +
> +#endif
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Gle0L8H5l8ToQqD4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaJXkACgkQ5GN7iDZy
WKcsWw//dvIC8Eu30zEG5+/oBUOobzBcFfhj61N8t1bxfu/FKQOY/5izHr0Pvdhh
X91ois6yvzKE++f+FXZG1m99ip//7mOACvdU2qhKXKz9ZwJ8pH9hjlAaLRdGJnDk
CqCNPy++ov4stG2Secp4KGPPB3oi5MuVHJ7E//bWIcId83a6FVxbzxV6UgFOORaT
mj/IByd6YqACbxqcDjBdtLs9RS1jxMnGd8HSEXPdp6pHc6SmYgFir+80Hp/mgmmI
c0HfwuzMjvnaRIdPbH4Fg0sUjMpdqtFES3j9WqDnFZ0Ws2lg1jeML0DMw48hjObP
CowEuK/0bBXZplKFk9CgsiKg6xApNoCFgh3N6FQw0V1CgU7VBg6LguxxQX+QRlQF
x0E6alKxUWJs0G1KKU7YsnJ6d7azw2SyXANe1nRBd2kGyhxGTuljgvlvs7AzOCOD
qCqC1mGneDPKgm3u5qRB9kUOa68baX1eC73SqEYCWk+8pDPk49R1drAtZD3hUs9u
TBkIenQR+qywd7yIbtJ7J0vCz1zwVEVo8mPey/Vslm3I9gFIEj4RoEROe5FF4dTK
kETHu76WllP/QlwG6fU33OY5Mb3nQMseyjQiMRuUHWvsBMAYk+qPolhwMFqOOFea
VLodOzbTaCE3rZz2NgXupOBHOH1ljvrxsvrxasCJL1/qRhxSY4c=
=66B8
-----END PGP SIGNATURE-----

--Gle0L8H5l8ToQqD4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
