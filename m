From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 31/37] librdmacm: provide abstracted verb calls
Date: Wed, 07 Apr 2010 14:39:03 -0500
Message-ID: <4BBCDF57.20303@opengridcomputing.com>
References: <27A4CFF94530491F88C8E528428FF93E@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27A4CFF94530491F88C8E528428FF93E-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> Provide abstractions to the verb calls to simplify the user
> interface for more casual verbs consumers.  Users still have
> access to the full range of verbs functionality by calling
> verbs directly.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
>  Makefile.am               |    5 -
>  include/rdma/rdma_verbs.h |  287 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 290 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 8d86045..8aef24a 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -31,7 +31,8 @@ librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband
>  
>  librdmacminclude_HEADERS = include/rdma/rdma_cma_abi.h \
>  			   include/rdma/rdma_cma.h \
> -			   include/infiniband/ib.h
> +			   include/infiniband/ib.h \
> +			   include/rdma/rdma_verbs.h
>  
>  man_MANS = \
>  	man/rdma_accept.3 \
> @@ -69,7 +70,7 @@ man_MANS = \
>  	man/rdma_cm.7
>  
>  EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
> -	     include/infiniband/ib.h \
> +	     include/infiniband/ib.h include/rdma/rdma_verbs.h \
>  	     src/cma.h src/librdmacm.map librdmacm.spec.in $(man_MANS)
>  
>  dist-hook: librdmacm.spec
> diff --git a/include/rdma/rdma_verbs.h b/include/rdma/rdma_verbs.h
> new file mode 100644
> index 0000000..05964c1
> --- /dev/null
> +++ b/include/rdma/rdma_verbs.h
> @@ -0,0 +1,287 @@
> +/*
> + * Copyright (c) 2010 Intel Corporation.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
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
> +#if !defined(RDMA_VERBS_H)
> +#define RDMA_VERBS_H
> +
> +#include <assert.h>
> +#include <infiniband/verbs.h>
> +#include <rdma/rdma_cma.h>
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +/*
> + * Memory registration helpers.
> + */
> +static inline struct ibv_mr *
> +rdma_reg_msgs(struct rdma_cm_id *id, void *addr, size_t length)
> +{
> +	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE);
> +}
> +
> +static inline struct ibv_mr *
> +rdma_reg_read(struct rdma_cm_id *id, void *addr, size_t length)
> +{
> +	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE|
> +						    IBV_ACCESS_REMOTE_READ);
> +}
> +
> +static inline struct ibv_mr *
> +rdma_reg_write(struct rdma_cm_id *id, void *addr, size_t length)
> +{
> +	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
> +						    IBV_ACCESS_REMOTE_WRITE);
> +}
> +
> +static inline int
> +rdma_dereg_mr(struct ibv_mr *mr)
> +{
> +	return ibv_dereg_mr(mr);
> +}
> +
> +
> +/*
> + * Vectored send, receive, and RDMA operations.
> + * Support multiple scatter-gather entries.
> + */
> +static inline int
> +rdma_post_recvv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
> +		int nsge)
> +{
> +	struct ibv_recv_wr wr, *bad;
> +
> +	wr.wr_id = (uintptr_t) context;
> +	wr.next = NULL;
> +	wr.sg_list = sgl;
> +	wr.num_sge = nsge;
> +
> +	return ibv_post_recv(id->qp, &wr, &bad);
> +}
> +
> +static inline int
> +rdma_post_sendv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
> +		int nsge, int flags)
> +{
> +	struct ibv_send_wr wr, *bad;
> +
> +	wr.wr_id = (uintptr_t) context;
> +	wr.next = NULL;
> +	wr.sg_list = sgl;
> +	wr.num_sge = nsge;
> +	wr.opcode = IBV_WR_SEND;
> +	wr.send_flags = flags;
> +
> +	return ibv_post_send(id->qp, &wr, &bad);
> +}
> +
> +static inline int
> +rdma_post_readv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
> +		int nsge, int flags, uint64_t remote_addr, uint32_t rkey)
> +{
> +	struct ibv_send_wr wr, *bad;
> +
> +	wr.wr_id = (uintptr_t) context;
> +	wr.next = NULL;
> +	wr.sg_list = sgl;
> +	wr.num_sge = nsge;
> +	wr.opcode = IBV_WR_RDMA_READ;
> +	wr.send_flags = flags;
> +	wr.wr.rdma.remote_addr = remote_addr;
> +	wr.wr.rdma.rkey = rkey;
> +
> +	return ibv_post_send(id->qp, &wr, &bad);
> +}
> +
> +static inline int
> +rdma_post_writev(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
> +		 int nsge, int flags, uint64_t remote_addr, uint32_t rkey)
> +{
> +	struct ibv_send_wr wr, *bad;
> +
> +	wr.wr_id = (uintptr_t) context;
> +	wr.next = NULL;
> +	wr.sg_list = sgl;
> +	wr.num_sge = nsge;
> +	wr.opcode = IBV_WR_RDMA_WRITE;
> +	wr.send_flags = flags;
> +	wr.wr.rdma.remote_addr = remote_addr;
> +	wr.wr.rdma.rkey = rkey;
> +
> +	return ibv_post_send(id->qp, &wr, &bad);
> +}
> +
> +/*
> + * Simple send, receive, and RDMA calls.
> + */
> +static inline int
> +rdma_post_recv(struct rdma_cm_id *id, void *context, void *addr,
> +	       size_t length, struct ibv_mr *mr)
> +{
> +	struct ibv_sge sge;
> +
> +	assert((addr >= mr->addr) && ((addr + length) <= (mr->addr + mr->length)));
> +	sge.addr = (uint64_t) addr;
> +	sge.length = (uint32_t) length;
> +	sge.lkey = mr->lkey;
> +
> +	return rdma_post_recvv(id, context, &sge, 1);
> +}
> +
> +static inline int
> +rdma_post_send(struct rdma_cm_id *id, void *context, void *addr,
> +	       size_t length, struct ibv_mr *mr, int flags)
> +{
> +	struct ibv_sge sge;
> +
> +	sge.addr = (uint64_t) addr;
> +	sge.length = (uint32_t) length;
> +	sge.lkey = mr ? mr->lkey : 0;
> +
> +	return rdma_post_sendv(id, context, &sge, 1, flags);
> +}
> +
> +static inline int
> +rdma_post_read(struct rdma_cm_id *id, void *context, void *addr,
> +	       size_t length, struct ibv_mr *mr, int flags,
> +	       uint64_t remote_addr, uint32_t rkey)
> +{
> +	struct ibv_sge sge;
> +
> +	sge.addr = (uint64_t) addr;
> +	sge.length = (uint32_t) length;
> +	sge.lkey = mr->lkey;
> +
> +	return rdma_post_readv(id, context, &sge, 1, flags, remote_addr, rkey);
> +}
> +
> +static inline int
> +rdma_post_write(struct rdma_cm_id *id, void *context, void *addr,
> +		size_t length, struct ibv_mr *mr, int flags,
> +		uint64_t remote_addr, uint32_t rkey)
> +{
> +	struct ibv_sge sge;
> +
> +	sge.addr = (uint64_t) addr;
> +	sge.length = (uint32_t) length;
> +	sge.lkey = mr ? mr->lkey : 0;
> +
> +	return rdma_post_writev(id, context, &sge, 1, flags, remote_addr, rkey);
> +}
> +
> +static inline int
> +rdma_post_ud_send(struct rdma_cm_id *id, void *context, void *addr,
> +		  size_t length, struct ibv_mr *mr, int flags,
> +		  struct ibv_ah *ah, uint32_t remote_qpn)
> +{
> +	struct ibv_send_wr wr, *bad;
> +	struct ibv_sge sge;
> +
> +	sge.addr = (uint64_t) addr;
> +	sge.length = (uint32_t) length;
> +	sge.lkey = mr ? mr->lkey : 0;
> +
> +	wr.wr_id = (uintptr_t) context;
> +	wr.next = NULL;
> +	wr.sg_list = &sge;
> +	wr.num_sge = 1;
> +	wr.opcode = IBV_WR_SEND;
> +	wr.send_flags = flags;
> +	wr.wr.ud.ah = ah;
> +	wr.wr.ud.remote_qpn = remote_qpn;
> +	wr.wr.ud.remote_qkey = RDMA_UDP_QKEY;
> +
> +	return ibv_post_send(id->qp, &wr, &bad);
> +}
> +
> +static inline int
> +rdma_get_send_comp(struct rdma_cm_id *id, struct ibv_wc *wc)
> +{
> +	struct ibv_cq *cq;
> +	void *context;
> +	int ret;
> +
> +	ret = ibv_poll_cq(id->send_cq, 1, wc);
> +	if (ret)
> +		return ret;
> +
> +	ret = ibv_req_notify_cq(id->send_cq, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = ibv_poll_cq(id->send_cq, 1, wc);
> +	if (ret)
> +		return ret;
> +
> +	ret = ibv_get_cq_event(id->send_cq_channel, &cq, &context);
> +	if (ret)
> +		return ret;
>   

This doesn't look correct.  If the send isn't complete by the time the 
2nd ibv_poll_cq() completes, then this function will return without 
having filled in the wc.  Or am I missing something?  Shouldn't the 
ibv_get_cq_event() be the first thing this function does?  The same 
issue/question exists for rdma_get_recv_comp().



Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
