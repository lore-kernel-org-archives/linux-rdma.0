From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/11] libbnxtre: Add support for CQ and QP
 management
Date: Mon, 30 Jan 2017 09:16:45 +0200
Message-ID: <20170130071645.GJ6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-4-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k040vn1t/h12DMPO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-4-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--k040vn1t/h12DMPO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:34PM -0500, Devesh Sharma wrote:
> This patch adds support for completion queue creation and
> destruction following are the changes:
>
>  - Added User/Kernel ABI to communicate CQ specific parameters.
>  - Added a function in a new file to allocate Page-Aligned address
>    space.
>  - Added a function to free page-aligned address space.
>  - Added function to create and destroy completion queue.
>  - Add ABI to for QP creation and WQE/RQE format.
>  - Add functions to allocate SQ, RQ and Search PSN address
>    space.
>  - Add functions to store/clean qp-handles in the form of
>    a linear table. There is table maintained in every instance
>    of ucontext.
>  - CQ and QP contexts now hold a pointer to the DPI mapped
>    during PD allocation.
>  - Removed hard-coding of page size during mapping DB page.
>  - Renamed a variable in PD code.
>  - Add support for create-qp.
>  - Add support for destroy-qp.
>  - Add support for modify-qp.
>  - Add support for query-qp.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxtre/CMakeLists.txt |   1 +
>  providers/bnxtre/abi.h          | 127 +++++++++++++++++++++
>  providers/bnxtre/main.c         |   5 +
>  providers/bnxtre/main.h         |  61 +++++++++--
>  providers/bnxtre/memory.c       |  73 +++++++++++++
>  providers/bnxtre/memory.h       |  76 +++++++++++++
>  providers/bnxtre/verbs.c        | 236 +++++++++++++++++++++++++++++++++++++++-
>  7 files changed, 561 insertions(+), 18 deletions(-)
>  create mode 100644 providers/bnxtre/memory.c
>  create mode 100644 providers/bnxtre/memory.h
>
> diff --git a/providers/bnxtre/CMakeLists.txt b/providers/bnxtre/CMakeLists.txt
> index 4c61355..93bdf1a 100644
> --- a/providers/bnxtre/CMakeLists.txt
> +++ b/providers/bnxtre/CMakeLists.txt
> @@ -1,4 +1,5 @@
>  rdma_provider(bnxtre
> +	memory.c
>  	main.c
>  	verbs.c
>  )
> diff --git a/providers/bnxtre/abi.h b/providers/bnxtre/abi.h
> index 0568d67..81d7585 100644
> --- a/providers/bnxtre/abi.h
> +++ b/providers/bnxtre/abi.h
> @@ -47,6 +47,10 @@ struct bnxt_re_cntx_resp {
>  	struct ibv_get_context_resp resp;
>  	__u32 dev_id;
>  	__u32 max_qp; /* To allocate qp-table */
> +	__u32 pg_size;
> +	__u32 cqe_size;
> +	__u32 max_cqd;
> +	__u32 rsvd;
>  };
>
>  struct bnxt_re_pd_resp {
> @@ -60,4 +64,127 @@ struct bnxt_re_mr_resp {
>  	struct ibv_reg_mr_resp resp;
>  };
>
> +struct bnxt_re_cq_req {
> +	struct ibv_create_cq cmd;
> +	__u64 cq_va;
> +	__u64 cq_handle;
> +};
> +
> +struct bnxt_re_cq_resp {
> +	struct ibv_create_cq_resp resp;
> +	__u32 cqid;
> +	__u32 tail;
> +	__u32 phase;
> +	__u32 rsvd;
> +};
> +
> +struct bnxt_re_qp_req {
> +	struct ibv_create_qp cmd;
> +	__u64 qpsva;
> +	__u64 qprva;
> +	__u64 qp_handle;
> +};
> +
> +struct bnxt_re_qp_resp {
> +	struct ibv_create_qp_resp resp;
> +	__u32 qpid;
> +	__u32 rsvd;
> +};
> +
> +struct bnxt_re_bsqe {
> +	__u32 rsv_ws_fl_wt;
> +	__u32 key_immd;
> +};
> +
> +struct bnxt_re_psns {
> +	__u32 opc_spsn;
> +	__u32 flg_npsn;
> +};
> +
> +struct bnxt_re_sge {
> +	__u32 pa_lo;
> +	__u32 pa_hi;
> +	__u32 lkey;
> +	__u32 length;
> +};
> +
> +/*  Cu+ max inline data */
> +#define BNXT_RE_MAX_INLINE_SIZE		0x60
> +
> +struct bnxt_re_send {
> +	__u32 length;
> +	__u32 qkey;
> +	__u32 dst_qp;
> +	__u32 avid;
> +	__u64 rsvd;
> +};
> +
> +struct bnxt_re_raw {
> +	__u32 length;
> +	__u32 rsvd1;
> +	__u32 cfa_meta;
> +	__u32 rsvd2;
> +	__u64 rsvd3;
> +};
> +
> +struct bnxt_re_rdma {
> +	__u32 length;
> +	__u32 rsvd1;
> +	__u32 rva_lo;
> +	__u32 rva_hi;
> +	__u32 rkey;
> +	__u32 rsvd2;
> +};
> +
> +struct bnxt_re_atomic {
> +	__u32 rva_lo;
> +	__u32 rva_hi;
> +	__u32 swp_dt_lo;
> +	__u32 swp_dt_hi;
> +	__u32 cmp_dt_lo;
> +	__u32 cmp_dt_hi;
> +};
> +
> +struct bnxt_re_inval {
> +	__u64 rsvd[3];
> +};
> +
> +struct bnxt_re_bind {
> +	__u32 plkey;
> +	__u32 lkey;
> +	__u32 va_lo;
> +	__u32 va_hi;
> +	__u32 len_lo;
> +	__u32 len_hi; /* only 40 bits are valid */
> +};
> +
> +struct bnxt_re_brqe {
> +	__u32 rsv_ws_fl_wt;
> +	__u32 rsvd;
> +};
> +
> +struct bnxt_re_rqe {
> +	__u64 rsvd[3];
> +};
> +
> +struct bnxt_re_srqe {
> +	__u32 srq_tag; /* 20 bits are valid */
> +	__u32 rsvd1;
> +	__u64 rsvd[2];
> +};
> +
> +static inline uint32_t bnxt_re_get_sqe_sz(void)
> +{
> +	return sizeof(struct bnxt_re_bsqe) +
> +	       sizeof(struct bnxt_re_send) +
> +	       BNXT_RE_MAX_INLINE_SIZE;
> +}
> +
> +static inline uint32_t bnxt_re_get_rqe_sz(void)
> +{
> +	return sizeof(struct bnxt_re_brqe) +
> +	       sizeof(struct bnxt_re_rqe) +
> +	       BNXT_RE_MAX_INLINE_SIZE;
> +}

I afraid that you misuse this abi.h file. Our intention is to keep it as
close as possible to kernel version, so no functions please.

> +
>  #endif
> diff --git a/providers/bnxtre/main.c b/providers/bnxtre/main.c
> index 0c26c8b..3cb3827 100644
> --- a/providers/bnxtre/main.c
> +++ b/providers/bnxtre/main.c
> @@ -115,8 +115,10 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
>  {
>  	struct ibv_get_context cmd;
>  	struct bnxt_re_cntx_resp resp;
> +	struct bnxt_re_dev *dev;
>  	struct bnxt_re_context *cntx;
>
> +	dev = to_bnxt_re_dev(&vdev->device);
>  	cntx = to_bnxt_re_context(ibvctx);
>
>  	memset(&resp, 0, sizeof(resp));
> @@ -127,6 +129,9 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
>
>  	cntx->dev_id = resp.dev_id;
>  	cntx->max_qp = resp.max_qp;
> +	dev->pg_size = resp.pg_size;
> +	dev->cqe_size = resp.cqe_size;
> +	dev->max_cq_depth = resp.max_cqd;
>  	ibvctx->ops = bnxt_re_cntx_ops;
>
>  	return 0;
> diff --git a/providers/bnxtre/main.h b/providers/bnxtre/main.h
> index 700dcb8..954ac47 100644
> --- a/providers/bnxtre/main.h
> +++ b/providers/bnxtre/main.h
> @@ -47,6 +47,16 @@
>  #include <infiniband/driver.h>
>  #include <infiniband/arch.h>
>
> +#include "memory.h"
> +
> +#define DEV	"bnxtre : "
> +
> +struct bnxt_re_dpi {
> +	__u32 dpindx;
> +	__u64 *dbpage;
> +	pthread_spinlock_t db_lock;
> +};
> +
>  struct bnxt_re_pd {
>  	struct ibv_pd ibvpd;
>  	uint32_t pdid;
> @@ -54,31 +64,48 @@ struct bnxt_re_pd {
>
>  struct bnxt_re_cq {
>  	struct ibv_cq ibvcq;
> -};
> -
> -struct bnxt_re_qp {
> -	struct ibv_qp ibvqp;
> +	uint32_t cqid;
> +	struct bnxt_re_queue cqq;
> +	struct bnxt_re_dpi *udpi;
> +	uint32_t cqe_size;
> +	uint8_t  phase;
>  };
>
>  struct bnxt_re_srq {
>  	struct ibv_srq ibvsrq;
>  };
>
> -struct bnxt_re_mr {
> -	struct ibv_mr ibvmr;
> +struct bnxt_re_qp {
> +	struct ibv_qp ibvqp;
> +	struct bnxt_re_queue *sqq;
> +	struct bnxt_re_psns *psns; /* start ptr. */
> +	struct bnxt_re_queue *rqq;
> +	struct bnxt_re_srq *srq;
> +	struct bnxt_re_cq *scq;
> +	struct bnxt_re_cq *rcq;
> +	struct bnxt_re_dpi *udpi;
> +	uint64_t *swrid;
> +	uint64_t *rwrid;
> +	uint32_t qpid;
> +	uint32_t tbl_indx;
> +	uint16_t mtu;
> +	uint16_t qpst;
> +	uint8_t qptyp;
> +	/* wrid? */
> +	/* irdord? */
>  };
>
> -#define DEV	"bnxtre : "
> -
> -struct bnxt_re_dpi {
> -	__u32 dpindx;
> -	__u64 *dbpage;
> -	pthread_spinlock_t db_lock;
> +struct bnxt_re_mr {
> +	struct ibv_mr ibvmr;
>  };
>
>  struct bnxt_re_dev {
>  	struct verbs_device vdev;
>  	uint8_t abi_version;
> +	uint32_t pg_size;
> +
> +	uint32_t cqe_size;
> +	uint32_t max_cq_depth;
>  };
>
>  struct bnxt_re_context {
> @@ -105,4 +132,14 @@ static inline struct bnxt_re_pd *to_bnxt_re_pd(struct ibv_pd *ibvpd)
>  	return container_of(ibvpd, struct bnxt_re_pd, ibvpd);
>  }
>
> +static inline struct bnxt_re_cq *to_bnxt_re_cq(struct ibv_cq *ibvcq)
> +{
> +	return container_of(ibvcq, struct bnxt_re_cq, ibvcq);
> +}
> +
> +static inline struct bnxt_re_qp *to_bnxt_re_qp(struct ibv_qp *ibvqp)
> +{
> +	return container_of(ibvqp, struct bnxt_re_qp, ibvqp);
> +}
> +
>  #endif
> diff --git a/providers/bnxtre/memory.c b/providers/bnxtre/memory.c
> new file mode 100644
> index 0000000..c96641e
> --- /dev/null
> +++ b/providers/bnxtre/memory.c
> @@ -0,0 +1,73 @@
> +/*
> + * Broadcom NetXtreme-E User Space RoCE driver
> + *
> + * Copyright (c) 2015-2016, Broadcom. All rights reserved.  The term
> + * Broadcom refers to Broadcom Limited and/or its subsidiaries.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> + * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> + * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * Description: Implements method to allocate page-aligned memory
> + *              buffers.
> + */
> +
> +#include <sys/mman.h>
> +
> +#include "main.h"
> +
> +int bnxt_re_alloc_aligned(struct bnxt_re_queue *que, uint32_t pg_size)
> +{
> +	int ret, bytes;
> +
> +	bytes = (que->depth * que->stride);
> +	que->bytes = get_aligned(bytes, pg_size);

There is the same function align(..) which many providers implemented it.
Please move it to common code to all providers and use it from there.

> +	que->va = mmap(NULL, que->bytes, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (que->va == MAP_FAILED) {
> +		que->bytes = 0;
> +		return errno;
> +	}
> +
> +	ret = ibv_dontfork_range(que->va, que->bytes);
> +	if (ret) {
> +		munmap(que->va, que->bytes);
> +		que->bytes = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +void bnxt_re_free_aligned(struct bnxt_re_queue *que)
> +{
> +	if (que->bytes) {
> +		ibv_dofork_range(que->va, que->bytes);
> +		munmap(que->va, que->bytes);
> +		que->bytes = 0;
> +	}
> +}
> diff --git a/providers/bnxtre/memory.h b/providers/bnxtre/memory.h
> new file mode 100644
> index 0000000..6c4ebaa
> --- /dev/null
> +++ b/providers/bnxtre/memory.h
> @@ -0,0 +1,76 @@
> +/*
> + * Broadcom NetXtreme-E User Space RoCE driver
> + *
> + * Copyright (c) 2015-2016, Broadcom. All rights reserved.  The term
> + * Broadcom refers to Broadcom Limited and/or its subsidiaries.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> + * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> + * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * Description: Implements data-struture to allocate page-aligned
> + *              memory buffer.
> + */
> +
> +#ifndef __BNXT_RE_MEMORY_H__
> +#define __BNXT_RE_MEMORY_H__
> +
> +#include <pthread.h>
> +
> +struct bnxt_re_queue {
> +	void *va;
> +	uint32_t bytes; /* for munmap */
> +	uint32_t depth; /* no. of entries */
> +	uint32_t head;
> +	uint32_t tail;
> +	uint32_t stride;
> +	pthread_spinlock_t qlock;
> +};
> +
> +static inline unsigned long get_aligned(uint32_t size, uint32_t al_size)
> +{
> +	return (unsigned long)(size + al_size - 1) & ~(al_size - 1);
> +}
> +
> +static inline unsigned long roundup_pow_of_two(unsigned long val)
> +{
> +	unsigned long roundup = 1;
> +
> +	if (val == 1)
> +		return (roundup << 1);
> +
> +	while (roundup < val)
> +		roundup <<= 1;
> +
> +	return roundup;
> +}

Please move to common code.

> +
> +int bnxt_re_alloc_aligned(struct bnxt_re_queue *que, uint32_t pg_size);
> +void bnxt_re_free_aligned(struct bnxt_re_queue *que);
> +
> +#endif
> diff --git a/providers/bnxtre/verbs.c b/providers/bnxtre/verbs.c
> index 9813db8..3cad358 100644
> --- a/providers/bnxtre/verbs.c
> +++ b/providers/bnxtre/verbs.c
> @@ -84,6 +84,7 @@ struct ibv_pd *bnxt_re_alloc_pd(struct ibv_context *ibvctx)
>  	struct ibv_alloc_pd cmd;
>  	struct bnxt_re_pd_resp resp;
>  	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvctx);
> +	struct bnxt_re_dev *dev = to_bnxt_re_dev(ibvctx->device);
>  	struct bnxt_re_pd *pd;
>
>  	pd = calloc(1, sizeof(*pd));
> @@ -99,7 +100,7 @@ struct ibv_pd *bnxt_re_alloc_pd(struct ibv_context *ibvctx)
>
>  	/* Map DB page now. */
>  	cntx->udpi.dpindx = resp.dpi;
> -	cntx->udpi.dbpage = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED,
> +	cntx->udpi.dbpage = mmap(NULL, dev->pg_size, PROT_WRITE, MAP_SHARED,
>  				 ibvctx->cmd_fd, resp.dbr);
>  	if (cntx->udpi.dbpage == MAP_FAILED) {
>  		(void)ibv_cmd_dealloc_pd(&pd->ibvpd);
> @@ -117,6 +118,7 @@ int bnxt_re_free_pd(struct ibv_pd *ibvpd)
>  {
>  	struct bnxt_re_pd *pd = to_bnxt_re_pd(ibvpd);
>  	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
> +	struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
>  	int status;
>
>  	status = ibv_cmd_dealloc_pd(ibvpd);
> @@ -125,7 +127,8 @@ int bnxt_re_free_pd(struct ibv_pd *ibvpd)
>
>  	pthread_spin_destroy(&cntx->udpi.db_lock);
>  	if (cntx->udpi.dbpage && (cntx->udpi.dbpage != MAP_FAILED))
> -		munmap(cntx->udpi.dbpage, 4096);
> +		munmap(cntx->udpi.dbpage, dev->pg_size);
> +
>  	free(pd);
>
>  	return 0;
> @@ -167,6 +170,48 @@ int bnxt_re_dereg_mr(struct ibv_mr *ibvmr)
>  struct ibv_cq *bnxt_re_create_cq(struct ibv_context *ibvctx, int ncqe,
>  				 struct ibv_comp_channel *channel, int vec)
>  {
> +	struct bnxt_re_cq *cq;
> +	struct bnxt_re_cq_req cmd;
> +	struct bnxt_re_cq_resp resp;
> +
> +	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvctx);
> +	struct bnxt_re_dev *dev = to_bnxt_re_dev(ibvctx->device);
> +
> +	if (ncqe > dev->max_cq_depth)
> +		return NULL;
> +
> +	cq = calloc(1, sizeof(*cq));
> +	if (!cq)
> +		return NULL;
> +
> +	cq->cqq.depth = roundup_pow_of_two(ncqe + 1);
> +	if (cq->cqq.depth > dev->max_cq_depth + 1)
> +		cq->cqq.depth = dev->max_cq_depth + 1;
> +	cq->cqq.stride = dev->cqe_size;
> +	if (bnxt_re_alloc_aligned(&cq->cqq, dev->pg_size))
> +		goto fail;
> +
> +	pthread_spin_init(&cq->cqq.qlock, PTHREAD_PROCESS_PRIVATE);
> +
> +	cmd.cq_va = (uint64_t)cq->cqq.va;
> +	cmd.cq_handle = (uint64_t)cq;
> +
> +	memset(&resp, 0, sizeof(resp));
> +	if (ibv_cmd_create_cq(ibvctx, ncqe, channel, vec,
> +			      &cq->ibvcq, &cmd.cmd, sizeof(cmd),
> +			      &resp.resp, sizeof(resp)))
> +		goto cmdfail;
> +
> +	cq->cqid = resp.cqid;
> +	cq->phase = resp.phase;
> +	cq->cqq.tail = resp.tail;
> +	cq->udpi = &cntx->udpi;
> +
> +	return &cq->ibvcq;
> +cmdfail:
> +	bnxt_re_free_aligned(&cq->cqq);
> +fail:
> +	free(cq);
>  	return NULL;
>  }
>
> @@ -177,7 +222,17 @@ int bnxt_re_resize_cq(struct ibv_cq *ibvcq, int ncqe)
>
>  int bnxt_re_destroy_cq(struct ibv_cq *ibvcq)
>  {
> -	return -ENOSYS;
> +	int status;
> +	struct bnxt_re_cq *cq = to_bnxt_re_cq(ibvcq);
> +
> +	status = ibv_cmd_destroy_cq(ibvcq);
> +	if (status)
> +		return status;
> +
> +	bnxt_re_free_aligned(&cq->cqq);
> +	free(cq);
> +
> +	return 0;
>  }
>
>  int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc)
> @@ -195,27 +250,196 @@ int bnxt_re_arm_cq(struct ibv_cq *ibvcq, int flags)
>  	return -ENOSYS;
>  }
>
> +static int bnxt_re_check_qp_limits(struct ibv_qp_init_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static void bnxt_re_free_queue_ptr(struct bnxt_re_qp *qp)
> +{
> +	if (qp->rqq)
> +		free(qp->rqq);
> +	if (qp->sqq)
> +		free(qp->sqq);
> +}
> +
> +static int bnxt_re_alloc_queue_ptr(struct bnxt_re_qp *qp,
> +				   struct ibv_qp_init_attr *attr)
> +{
> +	qp->sqq = calloc(1, sizeof(struct bnxt_re_queue));
> +	if (!qp->sqq)
> +		return -ENOMEM;
> +	if (attr->srq)
> +		qp->srq = NULL;/*TODO: to_bnxt_re_srq(attr->srq);*/
> +	else {
> +		qp->rqq = calloc(1, sizeof(struct bnxt_re_queue));
> +		if (!qp->rqq) {
> +			free(qp->sqq);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void bnxt_re_free_queues(struct bnxt_re_qp *qp)
> +{
> +	if (qp->rwrid)
> +		free(qp->rwrid);
> +	pthread_spin_destroy(&qp->rqq->qlock);
> +	bnxt_re_free_aligned(qp->rqq);
> +
> +	if (qp->swrid)
> +		free(qp->swrid);
> +	pthread_spin_destroy(&qp->sqq->qlock);
> +	bnxt_re_free_aligned(qp->sqq);
> +}
> +
> +static int bnxt_re_alloc_queues(struct bnxt_re_qp *qp,
> +				struct ibv_qp_init_attr *attr,
> +				uint32_t pg_size) {
> +	struct bnxt_re_queue *que;
> +	uint32_t psn_depth;
> +	int ret;
> +
> +	if (attr->cap.max_send_wr) {
> +		que = qp->sqq;
> +		que->stride = bnxt_re_get_sqe_sz();
> +		que->depth = roundup_pow_of_two(attr->cap.max_send_wr);
> +		/* psn_depth extra entries of size que->stride */
> +		psn_depth = (que->depth * sizeof(struct bnxt_re_psns)) /
> +			     que->stride;
> +		que->depth += psn_depth;
> +		ret = bnxt_re_alloc_aligned(qp->sqq, pg_size);
> +		if (ret)
> +			return ret;
> +		/* exclude psns depth*/
> +		que->depth -= psn_depth;
> +		/* start of spsn space sizeof(struct bnxt_re_psns) each. */
> +		qp->psns = (que->va + que->stride * que->depth);
> +		pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
> +		qp->swrid = calloc(que->depth, sizeof(uint64_t));
> +		if (!qp->swrid) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +	}
> +
> +	if (attr->cap.max_recv_wr && qp->rqq) {
> +		que = qp->rqq;
> +		que->stride = bnxt_re_get_rqe_sz();
> +		que->depth = roundup_pow_of_two(attr->cap.max_recv_wr);
> +		ret = bnxt_re_alloc_aligned(qp->rqq, pg_size);
> +		if (ret)
> +			goto fail;
> +		pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
> +		qp->rwrid = calloc(que->depth, sizeof(uint64_t));
> +		if (!qp->rwrid) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +	}
> +
> +	return 0;
> +
> +fail:
> +	bnxt_re_free_queues(qp);
> +	return ret;
> +}
> +
>  struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
>  				 struct ibv_qp_init_attr *attr)
>  {
> +	struct bnxt_re_qp *qp;
> +	struct bnxt_re_qp_req req;
> +	struct bnxt_re_qp_resp resp;
> +
> +	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
> +	struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
> +
> +	if (bnxt_re_check_qp_limits(attr))
> +		return NULL;
> +
> +	qp = calloc(1, sizeof(*qp));
> +	if (!qp)
> +		return NULL;
> +	/* alloc queue pointers */
> +	if (bnxt_re_alloc_queue_ptr(qp, attr))
> +		goto fail;
> +	/* alloc queues */
> +	if (bnxt_re_alloc_queues(qp, attr, dev->pg_size))
> +		goto failq;
> +	/* Fill ibv_cmd */
> +	req.qpsva = (uint64_t)qp->sqq->va;
> +	req.qprva = qp->rqq ? (uint64_t)qp->rqq->va : 0;
> +	req.qp_handle = (uint64_t)qp;
> +
> +	if (ibv_cmd_create_qp(ibvpd, &qp->ibvqp, attr, &req.cmd, sizeof(req),
> +			      &resp.resp, sizeof(resp))) {
> +		goto failcmd;
> +	}
> +
> +	qp->qpid = resp.qpid;
> +	qp->qptyp = attr->qp_type;
> +	qp->qpst = IBV_QPS_RESET;
> +	qp->scq = to_bnxt_re_cq(attr->send_cq);
> +	qp->rcq = to_bnxt_re_cq(attr->recv_cq);
> +	qp->udpi = &cntx->udpi;
> +
> +	return &qp->ibvqp;
> +failcmd:
> +	bnxt_re_free_queues(qp);
> +failq:
> +	bnxt_re_free_queue_ptr(qp);
> +fail:
> +	free(qp);
> +
>  	return NULL;
>  }
>
>  int bnxt_re_modify_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
>  		      int attr_mask)
>  {
> -	return -ENOSYS;
> +	struct ibv_modify_qp cmd = {};
> +	struct bnxt_re_qp *qp = to_bnxt_re_qp(ibvqp);
> +	int rc;
> +
> +	rc = ibv_cmd_modify_qp(ibvqp, attr, attr_mask, &cmd, sizeof(cmd));
> +	if (!rc)
> +		qp->qpst = ibvqp->state;
> +
> +	return rc;
>  }
>
>  int bnxt_re_query_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
>  		     int attr_mask, struct ibv_qp_init_attr *init_attr)
>  {
> -	return -ENOSYS;
> +	struct ibv_query_qp cmd;
> +	struct bnxt_re_qp *qp = to_bnxt_re_qp(ibvqp);
> +	int rc;
> +
> +	rc = ibv_cmd_query_qp(ibvqp, attr, attr_mask, init_attr,
> +			      &cmd, sizeof(cmd));
> +	if (!rc)
> +		qp->qpst = ibvqp->state;
> +
> +	return rc;
>  }
>
>  int bnxt_re_destroy_qp(struct ibv_qp *ibvqp)
>  {
> -	return -ENOSYS;
> +	struct bnxt_re_qp *qp = to_bnxt_re_qp(ibvqp);
> +	int status;
> +
> +	status = ibv_cmd_destroy_qp(ibvqp);
> +	if (status)
> +		return status;
> +
> +	bnxt_re_free_queues(qp);
> +	bnxt_re_free_queue_ptr(qp);
> +	free(qp);
> +
> +	return 0;
>  }
>
>  int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--k040vn1t/h12DMPO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliO6F0ACgkQ5GN7iDZy
WKfkWg/+NaqDRSrTUJzBtdwZPxd+ekJG+/yBEj0iUQgYFhmoNKnHpTN7lhUxUEC8
zlCdfyavwEJ5vOXx0bdaPzgZ7yn2lO/BlWUgOWgzOO0ypxFzdooxbgIpffW20q5B
RPx9B8NHsxA7/ZA6F4oBtLXE7OcG9HfOk/o71kmZ651Gm6ATtq8zagR07fSWEShr
vlnq3eInYaMpGt74BaqfdcFsGf/i54blYeWPQSrGbWfaQfvlA77jMf2blsAy+3Ie
0xG4tnqrohn599NO4kptm8i0U/XhNqQFRGzRo9w6jihfcoUN9aEcracDICfHnAF6
Sdo4l4A3g+D3DkQugkr3NczWFcbKw65p2L5gTDG7g/2A4XZMFrBleiBG5sRf3EzC
Q7/Wv4udbK4tUK0Dswe142Shr/eA1Nmd6PzP0pFvphUbZRZ/bUgiwwzAkxqD2Yb8
E9udIa7pAvcencpGyAOXmLI8/BbEo+t2vGV+lododOAN6SWtJ9E1X/I+KTj8Uywe
Cc8E31kA1sB4WkTn4wGT+rYugzP8kCVyE4QzW1ziSgdWibxhb++Te1SHElyUNixD
lTe/8+6Z3LZDubwuhU7U+elaVt0R9C6uedwdfyBRm1MM5cAFyl6oknc9jWS0xm7k
qvSGjVOC3DAEDf3N0Krcvlwrhf/34H0zqkT89D3BTrBonyBzhkg=
=sSwN
-----END PGP SIGNATURE-----

--k040vn1t/h12DMPO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
