From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v3 5/9] libbnxt_re: Allow apps to poll for flushed completions
Date: Thu, 16 Mar 2017 20:52:27 +0530
Message-ID: <CANjDDBgPrPPDBOy9N4X=XdU9AUTFpL2pE9-9kPvqAcYj09vDLA@mail.gmail.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-6-git-send-email-devesh.sharma@broadcom.com> <20170315192028.GI2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315192028.GI2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 16, 2017 at 12:50 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Mar 15, 2017 at 06:37:29AM -0400, Devesh Sharma wrote:
>> This patch adds support for reporting flush completions.
>> following is the overview of the algorithm used.
>>
>> Step-1: Poll a completion from h/w CQ.
>> Step-2: check the status, if it is error goto step3 else report
>>         completion to user based on the con_idx reported.
>> Step-3: Report the completion with actual error to consumer, and
>>         without bothering about the con_idx reported in the
>>         completion do following:
>>         3a. Add this QP to the CQ flush list if it was not there
>>             already. If this is req-error, add the QP to send-flush
>>             list, else add it to recv-flush-list.
>>         3b. Change QP-soft-state to ERROR if it was not in error
>>             already.
>>
>> Step-4: If next CQE is TERM CQE, extract this CQE. make sure this CQE
>>         is not reported to the consumer. Do the following steps as
>>         further processing:
>>         4a. Add this QP to both send-flush-list and recv-flush-list
>>             if QP is absent from any of the flush lists.
>>         4b. Change QP-soft-state to ERROR if it was not in error
>>             already.
>> Step5: Continue polling from both h/w CQ and flush-lists until
>>        all the queues are empty.
>>
>> The QP is removed from the flush list during destroy-qp.
>>
>> Further, it adds network to host format conversion on
>> the received immediate data.
>>
>> This patch also takes care of Hardware specific requirement
>> to skip reporting h/w flush error CQEs to consumer but ring
>> the CQ-DB for them.
>>
>> v1->v2
>>  -- Used ccan/list.h instead.
>>
>> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  providers/bnxt_re/flush.h  |  85 ++++++++++++++++
>>  providers/bnxt_re/main.c   |   5 +
>>  providers/bnxt_re/main.h   |   6 ++
>>  providers/bnxt_re/memory.h |   5 +
>>  providers/bnxt_re/verbs.c  | 243 ++++++++++++++++++++++++++++++++++++++++-----
>>  5 files changed, 320 insertions(+), 24 deletions(-)
>>  create mode 100644 providers/bnxt_re/flush.h
>>
>> diff --git a/providers/bnxt_re/flush.h b/providers/bnxt_re/flush.h
>> new file mode 100644
>> index 0000000..a39ea71
>> --- /dev/null
>> +++ b/providers/bnxt_re/flush.h
>> @@ -0,0 +1,85 @@
>> +/*
>> + * Broadcom NetXtreme-E User Space RoCE driver
>> + *
>> + * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
>> + * Broadcom refers to Broadcom Limited and/or its subsidiaries.
>> + *
>> + * This software is available to you under a choice of one of two
>> + * licenses.  You may choose to be licensed under the terms of the GNU
>> + * General Public License (GPL) Version 2, available from the file
>> + * COPYING in the main directory of this source tree, or the
>> + * BSD license below:
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions
>> + * are met:
>> + *
>> + * 1. Redistributions of source code must retain the above copyright
>> + *    notice, this list of conditions and the following disclaimer.
>> + * 2. Redistributions in binary form must reproduce the above copyright
>> + *    notice, this list of conditions and the following disclaimer in
>> + *    the documentation and/or other materials provided with the
>> + *    distribution.
>> + *
>> + * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
>> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
>> + * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
>> + * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
>> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
>> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
>> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
>> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
>> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
>> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
>> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> + *
>> + * Description: A few wrappers for flush queue management
>> + */
>> +
>> +#ifndef __FLUSH_H__
>> +#define __FLUSH_H__
>> +
>> +#include <ccan/list.h>
>> +
>> +struct bnxt_re_fque_node {
>> +     uint8_t valid;
>> +     struct list_node list;
>> +};
>> +
>> +static inline void fque_init_node(struct bnxt_re_fque_node *node)
>> +{
>> +     list_node_init(&node->list);
>> +     node->valid = false;
>> +}
>> +
>> +static inline void fque_add_node_tail(struct list_head *head,
>> +                                   struct bnxt_re_fque_node *new)
>> +{
>> +     list_add_tail(head, &new->list);
>> +     new->valid = true;
>> +}
>> +
>> +static inline void fque_del_node(struct bnxt_re_fque_node *entry)
>> +{
>> +     entry->valid = false;
>> +     list_del(&entry->list);
>> +}
>> +
>
> I don't see the point of these wrappers.

Wanted to keep "entry->valid" as a property of list element rather
mixing it in the QP structure to keep things clean. Thus, could not
resist to keep those.

>
>> +static inline uint8_t _fque_node_valid(struct bnxt_re_fque_node *node)
>> +{
>> +     return node->valid;
>> +}
>> +
>> +static inline void bnxt_re_fque_add_node(struct list_head *head,
>> +                                      struct bnxt_re_fque_node *node)
>> +{
>> +     if (!_fque_node_valid(node))
>> +             fque_add_node_tail(head, node);
>> +}
>> +
>> +static inline void bnxt_re_fque_del_node(struct bnxt_re_fque_node *node)
>> +{
>> +     if (_fque_node_valid(node))
>> +             fque_del_node(node);
>> +}
>> +#endif       /* __FLUSH_H__ */
>> diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
>> index 60ad653..b33ea35 100644
>> --- a/providers/bnxt_re/main.c
>> +++ b/providers/bnxt_re/main.c
>> @@ -128,6 +128,7 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
>>       dev->pg_size = resp.pg_size;
>>       dev->cqe_size = resp.cqe_size;
>>       dev->max_cq_depth = resp.max_cqd;
>> +     pthread_spin_init(&cntx->fqlock, PTHREAD_PROCESS_PRIVATE);
>>       ibvctx->ops = bnxt_re_cntx_ops;
>>
>>       return 0;
>> @@ -136,7 +137,11 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
>>  static void bnxt_re_uninit_context(struct verbs_device *vdev,
>>                                  struct ibv_context *ibvctx)
>>  {
>> +     struct bnxt_re_context *cntx;
>> +
>> +     cntx = to_bnxt_re_context(ibvctx);
>>       /* Unmap if anything device specific was mapped in init_context. */
>> +     pthread_spin_destroy(&cntx->fqlock);
>>  }
>>
>>  static struct verbs_device_ops bnxt_re_dev_ops = {
>> diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
>> index bfe7089..d324ef6 100644
>> --- a/providers/bnxt_re/main.h
>> +++ b/providers/bnxt_re/main.h
>> @@ -50,6 +50,7 @@
>>
>>  #include "bnxt_re-abi.h"
>>  #include "memory.h"
>> +#include "flush.h"
>>
>>  #define DEV  "bnxtre : "
>
> Isn't "bnxt_re"?

True, I will fix it.

>
>>
>> @@ -69,6 +70,8 @@ struct bnxt_re_cq {
>>       uint32_t cqid;
>>       struct bnxt_re_queue cqq;
>>       struct bnxt_re_dpi *udpi;
>> +     struct list_head sfhead;
>> +     struct list_head rfhead;
>>       uint32_t cqe_size;
>>       uint8_t  phase;
>>  };
>> @@ -104,6 +107,8 @@ struct bnxt_re_qp {
>>       struct bnxt_re_cq *rcq;
>>       struct bnxt_re_dpi *udpi;
>>       struct bnxt_re_qpcap cap;
>> +     struct bnxt_re_fque_node snode;
>> +     struct bnxt_re_fque_node rnode;
>>       uint32_t qpid;
>>       uint32_t tbl_indx;
>>       uint32_t sq_psn;
>> @@ -133,6 +138,7 @@ struct bnxt_re_context {
>>       uint32_t max_qp;
>>       uint32_t max_srq;
>>       struct bnxt_re_dpi udpi;
>> +     pthread_spinlock_t fqlock;
>>  };
>>
>>  /* DB ring functions used internally*/
>> diff --git a/providers/bnxt_re/memory.h b/providers/bnxt_re/memory.h
>> index f812eb8..debb31a 100644
>> --- a/providers/bnxt_re/memory.h
>> +++ b/providers/bnxt_re/memory.h
>> @@ -89,6 +89,11 @@ static inline uint32_t bnxt_re_is_que_full(struct bnxt_re_queue *que)
>>       return (((que->tail + 1) & (que->depth - 1)) == que->head);
>>  }
>>
>> +static inline uint32_t bnxt_re_is_que_empty(struct bnxt_re_queue *que)
>> +{
>> +     return que->tail == que->head;
>> +}
>> +
>>  static inline uint32_t bnxt_re_incr(uint32_t val, uint32_t max)
>>  {
>>       return (++val & (max - 1));
>> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
>> index 8230daf..1617af2 100644
>> --- a/providers/bnxt_re/verbs.c
>> +++ b/providers/bnxt_re/verbs.c
>> @@ -202,6 +202,9 @@ struct ibv_cq *bnxt_re_create_cq(struct ibv_context *ibvctx, int ncqe,
>>       cq->cqq.tail = resp.tail;
>>       cq->udpi = &cntx->udpi;
>>
>> +     list_head_init(&cq->sfhead);
>> +     list_head_init(&cq->rfhead);
>> +
>>       return &cq->ibvcq;
>>  cmdfail:
>>       bnxt_re_free_aligned(&cq->cqq);
>> @@ -230,6 +233,47 @@ int bnxt_re_destroy_cq(struct ibv_cq *ibvcq)
>>       return 0;
>>  }
>>
>> +static uint8_t bnxt_re_poll_err_scqe(struct bnxt_re_qp *qp,
>> +                                  struct ibv_wc *ibvwc,
>> +                                  struct bnxt_re_bcqe *hdr,
>> +                                  struct bnxt_re_req_cqe *scqe, int *cnt)
>> +{
>> +     struct bnxt_re_queue *sq = qp->sqq;
>> +     struct bnxt_re_context *cntx;
>> +     struct bnxt_re_wrid *swrid;
>> +     struct bnxt_re_psns *spsn;
>> +     struct bnxt_re_cq *scq;
>> +     uint32_t head = sq->head;
>> +     uint8_t status;
>> +
>> +     scq = to_bnxt_re_cq(qp->ibvqp.send_cq);
>> +     cntx = to_bnxt_re_context(scq->ibvcq.context);
>> +     swrid = &qp->swrid[head];
>> +     spsn = swrid->psns;
>> +
>> +     *cnt = 1;
>> +     status = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_STATUS_SHIFT) &
>> +               BNXT_RE_BCQE_STATUS_MASK;
>> +     ibvwc->status = bnxt_re_to_ibv_wc_status(status, true);
>> +     ibvwc->wc_flags = 0;
>> +     ibvwc->wr_id = swrid->wrid;
>> +     ibvwc->qp_num = qp->qpid;
>> +     ibvwc->opcode = (le32toh(spsn->opc_spsn) >>
>> +                     BNXT_RE_PSNS_OPCD_SHIFT) &
>> +                     BNXT_RE_PSNS_OPCD_MASK;
>> +     ibvwc->byte_len = 0;
>> +
>> +     bnxt_re_incr_head(qp->sqq);
>> +
>> +     if (qp->qpst != IBV_QPS_ERR)
>> +             qp->qpst = IBV_QPS_ERR;
>> +     pthread_spin_lock(&cntx->fqlock);
>> +     bnxt_re_fque_add_node(&scq->sfhead, &qp->snode);
>> +     pthread_spin_unlock(&cntx->fqlock);
>> +
>> +     return false;
>> +}
>> +
>>  static uint8_t bnxt_re_poll_success_scqe(struct bnxt_re_qp *qp,
>>                                        struct ibv_wc *ibvwc,
>>                                        struct bnxt_re_bcqe *hdr,
>> @@ -284,21 +328,53 @@ static uint8_t bnxt_re_poll_scqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
>>
>>       status = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_STATUS_SHIFT) &
>>                 BNXT_RE_BCQE_STATUS_MASK;
>> -     if (status == BNXT_RE_REQ_ST_OK) {
>> +     if (status == BNXT_RE_REQ_ST_OK)
>>               pcqe = bnxt_re_poll_success_scqe(qp, ibvwc, hdr, scqe, cnt);
>> -     } else {
>> -             /* TODO: Handle error completion properly. */
>> -             fprintf(stderr, "%s(): swc with error, vendor status = %d\n",
>> -                     __func__, status);
>> -             *cnt = 1;
>> -             ibvwc->status = bnxt_re_to_ibv_wc_status(status, true);
>> -             ibvwc->wr_id = qp->swrid[qp->sqq->head].wrid;
>> -             bnxt_re_incr_head(qp->sqq);
>> -     }
>> +     else
>> +             pcqe = bnxt_re_poll_err_scqe(qp, ibvwc, hdr, scqe, cnt);
>>
>>       return pcqe;
>>  }
>>
>> +static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp,
>> +                              struct ibv_wc *ibvwc,
>> +                              struct bnxt_re_bcqe *hdr,
>> +                              struct bnxt_re_rc_cqe *rcqe)
>> +{
>> +     struct bnxt_re_queue *rq = qp->rqq;
>> +     struct bnxt_re_wrid *rwrid;
>> +     struct bnxt_re_cq *rcq;
>> +     struct bnxt_re_context *cntx;
>> +     uint32_t head = rq->head;
>> +     uint8_t status;
>> +
>> +     rcq = to_bnxt_re_cq(qp->ibvqp.recv_cq);
>> +     cntx = to_bnxt_re_context(rcq->ibvcq.context);
>> +
>> +     rwrid = &qp->rwrid[head];
>> +     status = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_STATUS_SHIFT) &
>> +               BNXT_RE_BCQE_STATUS_MASK;
>> +     /* skip h/w flush errors */
>> +     if (status == BNXT_RE_RSP_ST_HW_FLUSH)
>> +             return 0;
>> +     ibvwc->status = bnxt_re_to_ibv_wc_status(status, false);
>> +     /* TODO: Add SRQ Processing here */
>> +     if (qp->rqq) {
>> +             ibvwc->wr_id = rwrid->wrid;
>> +             ibvwc->qp_num = qp->qpid;
>> +             ibvwc->opcode = IBV_WC_RECV;
>> +             ibvwc->byte_len = 0;
>> +             bnxt_re_incr_head(qp->rqq);
>> +             if (qp->qpst != IBV_QPS_ERR)
>> +                     qp->qpst = IBV_QPS_ERR;
>> +             pthread_spin_lock(&cntx->fqlock);
>> +             bnxt_re_fque_add_node(&rcq->rfhead, &qp->rnode);
>> +             pthread_spin_unlock(&cntx->fqlock);
>> +     }
>> +
>> +     return 1;
>> +}
>> +
>>  static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
>>                                     struct ibv_wc *ibvwc,
>>                                     struct bnxt_re_bcqe *hdr,
>> @@ -346,18 +422,37 @@ static uint8_t bnxt_re_poll_rcqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
>>
>>       status = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_STATUS_SHIFT) &
>>                 BNXT_RE_BCQE_STATUS_MASK;
>> -     if (status == BNXT_RE_RSP_ST_OK) {
>> +     *cnt = 1;
>> +     if (status == BNXT_RE_RSP_ST_OK)
>>               bnxt_re_poll_success_rcqe(qp, ibvwc, hdr, rcqe);
>> -             *cnt = 1;
>> -     } else {
>> -             /* TODO: Process error completions properly.*/
>> -             *cnt = 1;
>> -             ibvwc->status = bnxt_re_to_ibv_wc_status(status, false);
>> -             if (qp->rqq) {
>> -                     ibvwc->wr_id = qp->rwrid[qp->rqq->head].wrid;
>> -                     bnxt_re_incr_head(qp->rqq);
>> -             }
>> -     }
>> +     else
>> +             *cnt = bnxt_re_poll_err_rcqe(qp, ibvwc, hdr, rcqe);
>> +
>> +     return pcqe;
>> +}
>> +
>> +static uint8_t bnxt_re_poll_term_cqe(struct bnxt_re_qp *qp,
>> +                                  struct ibv_wc *ibvwc, void *cqe, int *cnt)
>> +{
>> +     struct bnxt_re_context *cntx;
>> +     struct bnxt_re_cq *scq, *rcq;
>> +     uint8_t pcqe = false;
>> +
>> +     scq = to_bnxt_re_cq(qp->ibvqp.send_cq);
>> +     rcq = to_bnxt_re_cq(qp->ibvqp.recv_cq);
>> +     cntx = to_bnxt_re_context(scq->ibvcq.context);
>> +     /* For now just add the QP to flush list without
>> +      * considering the index reported in the CQE.
>> +      * Continue reporting flush completions until the
>> +      * SQ and RQ are empty.
>> +      */
>> +     *cnt = 0;
>> +     if (qp->qpst != IBV_QPS_ERR)
>> +             qp->qpst = IBV_QPS_ERR;
>> +     pthread_spin_lock(&cntx->fqlock);
>> +     bnxt_re_fque_add_node(&rcq->rfhead, &qp->rnode);
>> +     bnxt_re_fque_add_node(&scq->sfhead, &qp->snode);
>> +     pthread_spin_unlock(&cntx->fqlock);
>>
>>       return pcqe;
>>  }
>> @@ -410,6 +505,12 @@ static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
>>               case BNXT_RE_WC_TYPE_RECV_RAW:
>>                       break;
>>               case BNXT_RE_WC_TYPE_TERM:
>> +                     scqe = cqe;
>> +                     qp_handle = (uint64_t *)&scqe->qp_handle;
>> +                     qp = (struct bnxt_re_qp *)(uintptr_t)scqe->qp_handle;
>> +                     if (!qp)
>> +                             break;
>> +                     pcqe = bnxt_re_poll_term_cqe(qp, wc, cqe, &cnt);
>>                       break;
>>               case BNXT_RE_WC_TYPE_COFF:
>>                       break;
>> @@ -442,22 +543,107 @@ bail:
>>       return dqed;
>>  }
>>
>> +static int bnxt_re_poll_flush_wcs(struct bnxt_re_queue *que,
>> +                               struct bnxt_re_wrid *wridp,
>> +                               struct ibv_wc *ibvwc, uint32_t qpid,
>> +                               int nwc)
>> +{
>> +     struct bnxt_re_wrid *wrid;
>> +     struct bnxt_re_psns *psns;
>> +     uint32_t cnt = 0, head;
>> +     uint8_t opcode = IBV_WC_RECV;
>> +
>> +     while (nwc) {
>> +             if (bnxt_re_is_que_empty(que))
>> +                     break;
>> +             head = que->head;
>> +             wrid = &wridp[head];
>> +             if (wrid->psns) {
>> +                     psns = wrid->psns;
>> +                     opcode = (psns->opc_spsn >> BNXT_RE_PSNS_OPCD_SHIFT) &
>> +                               BNXT_RE_PSNS_OPCD_MASK;
>> +             }
>> +
>> +             ibvwc->status = IBV_WC_WR_FLUSH_ERR;
>> +             ibvwc->opcode = opcode;
>> +             ibvwc->wr_id = wrid->wrid;
>> +             ibvwc->qp_num = qpid;
>> +             ibvwc->byte_len = 0;
>> +             ibvwc->wc_flags = 0;
>> +
>> +             bnxt_re_incr_head(que);
>> +             nwc--;
>> +             cnt++;
>> +             ibvwc++;
>> +     }
>> +
>> +     return cnt;
>> +}
>> +
>> +static int bnxt_re_poll_flush_lists(struct bnxt_re_cq *cq, uint32_t nwc,
>> +                                 struct ibv_wc *ibvwc)
>> +{
>> +     struct bnxt_re_fque_node *cur, *tmp;
>> +     struct bnxt_re_qp *qp;
>> +     struct bnxt_re_queue *que;
>> +     int dqed = 0, left;
>> +
>> +     /* Check if flush Qs are empty */
>> +     if (list_empty(&cq->sfhead) && list_empty(&cq->rfhead))
>> +             return 0;
>> +
>> +     if (!list_empty(&cq->sfhead)) {
>> +             list_for_each_safe(&cq->sfhead, cur, tmp, list) {
>> +                     qp = container_of(cur, struct bnxt_re_qp, snode);
>> +                     que = qp->sqq;
>> +                     if (bnxt_re_is_que_empty(que))
>> +                             continue;
>> +                     dqed = bnxt_re_poll_flush_wcs(que, qp->swrid, ibvwc,
>> +                                                   qp->qpid, nwc);
>> +             }
>> +     }
>> +
>> +     left = nwc - dqed;
>> +     if (!left)
>> +             return dqed;
>> +
>> +     if (!list_empty(&cq->rfhead)) {
>> +             list_for_each_safe(&cq->rfhead, cur, tmp, list) {
>> +                     qp = container_of(cur, struct bnxt_re_qp, rnode);
>> +                     que = qp->rqq;
>> +                     if (!que || bnxt_re_is_que_empty(que))
>> +                             continue;
>> +                     dqed += bnxt_re_poll_flush_wcs(que, qp->rwrid,
>> +                                                    ibvwc + dqed, qp->qpid,
>> +                                                    left);
>> +             }
>> +     }
>> +
>> +     return dqed;
>> +}
>> +
>>  int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc)
>>  {
>>       struct bnxt_re_cq *cq = to_bnxt_re_cq(ibvcq);
>> -     int dqed;
>> +     struct bnxt_re_context *cntx = to_bnxt_re_context(ibvcq->context);
>> +     int dqed, left = 0;
>>
>>       pthread_spin_lock(&cq->cqq.qlock);
>>       dqed = bnxt_re_poll_one(cq, nwc, wc);
>>       pthread_spin_unlock(&cq->cqq.qlock);
>> -
>> -     /* TODO: Flush Management*/
>> +     /* Check if anything is there to flush. */
>> +     pthread_spin_lock(&cntx->fqlock);
>> +     left = nwc - dqed;
>> +     if (left)
>> +             dqed += bnxt_re_poll_flush_lists(cq, left, (wc + dqed));
>> +     pthread_spin_unlock(&cntx->fqlock);
>>
>>       return dqed;
>>  }
>>
>>  static void bnxt_re_cleanup_cq(struct bnxt_re_qp *qp, struct bnxt_re_cq *cq)
>>  {
>> +     struct bnxt_re_context *cntx;
>>       struct bnxt_re_queue *que = &cq->cqq;
>>       struct bnxt_re_bcqe *hdr;
>>       struct bnxt_re_req_cqe *scqe;
>> @@ -465,6 +651,8 @@ static void bnxt_re_cleanup_cq(struct bnxt_re_qp *qp, struct bnxt_re_cq *cq)
>>       void *cqe;
>>       int indx, type;
>>
>> +     cntx = to_bnxt_re_context(cq->ibvcq.context);
>> +
>>       pthread_spin_lock(&que->qlock);
>>       for (indx = 0; indx < que->depth; indx++) {
>>               cqe = que->va + indx * bnxt_re_get_cqe_sz();
>> @@ -487,6 +675,11 @@ static void bnxt_re_cleanup_cq(struct bnxt_re_qp *qp, struct bnxt_re_cq *cq)
>>
>>       }
>>       pthread_spin_unlock(&que->qlock);
>> +
>> +     pthread_spin_lock(&cntx->fqlock);
>> +     bnxt_re_fque_del_node(&qp->snode);
>> +     bnxt_re_fque_del_node(&qp->rnode);
>> +     pthread_spin_unlock(&cntx->fqlock);
>>  }
>>
>>  void bnxt_re_cq_event(struct ibv_cq *ibvcq)
>> @@ -679,6 +872,8 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
>>       cap->max_rsge = attr->cap.max_recv_sge;
>>       cap->max_inline = attr->cap.max_inline_data;
>>       cap->sqsig = attr->sq_sig_all;
>> +     fque_init_node(&qp->snode);
>> +     fque_init_node(&qp->rnode);
>>
>>       return &qp->ibvqp;
>>  failcmd:
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
