From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-core v3 9/9] libbnxt_re: Add support for SRQ in user lib
Date: Sun, 19 Mar 2017 20:04:08 +0530
Message-ID: <CANjDDBgM0qUL_qG6_kVf01s0_n+bggKj4E1oO45G2e=nEokGaw@mail.gmail.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-10-git-send-email-devesh.sharma@broadcom.com> <20170315192408.GJ2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315192408.GJ2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Okay, I will fix it in v4.

On Thu, Mar 16, 2017 at 12:54 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Mar 15, 2017 at 06:37:33AM -0400, Devesh Sharma wrote:
>> This patch adds support for shared receive
>> queue. Following are the changes:
>>  - Add ABI for user/kernel information exchange.
>>  - Add function to handle SRQ ARMing and DB-ring.
>>  - Add function to create/destroy SRQ.
>>  - Add function to query/modify SRQ.
>>  - Add function to post RQE on a SRQ.
>>
>> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>>  providers/bnxt_re/bnxt_re-abi.h |  15 +++
>>  providers/bnxt_re/db.c          |  18 +++
>>  providers/bnxt_re/main.h        |  32 ++++-
>>  providers/bnxt_re/verbs.c       | 259 ++++++++++++++++++++++++++++++++++------
>>  4 files changed, 286 insertions(+), 38 deletions(-)
>>
>> diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
>> index 557221b..8dbb7b9 100644
>> --- a/providers/bnxt_re/bnxt_re-abi.h
>> +++ b/providers/bnxt_re/bnxt_re-abi.h
>> @@ -214,6 +214,7 @@ struct bnxt_re_mr_resp {
>>       struct ibv_reg_mr_resp resp;
>>  };
>>
>> +/* CQ */
>>  struct bnxt_re_cq_req {
>>       struct ibv_create_cq cmd;
>>       __u64 cq_va;
>> @@ -261,6 +262,7 @@ struct bnxt_re_term_cqe {
>>       __u64 rsvd1;
>>  };
>>
>> +/* QP */
>>  struct bnxt_re_qp_req {
>>       struct ibv_create_qp cmd;
>>       __u64 qpsva;
>> @@ -352,6 +354,19 @@ struct bnxt_re_rqe {
>>       __u64 rsvd[2];
>>  };
>>
>> +/* SRQ */
>> +struct bnxt_re_srq_req {
>> +     struct ibv_create_srq cmd;
>> +     __u64 srqva;
>> +     __u64 srq_handle;
>> +};
>> +
>> +struct bnxt_re_srq_resp {
>> +     struct ibv_create_srq_resp resp;
>> +     __u32 srqid;
>> +     __u32 rsvd;
>> +};
>> +
>>  struct bnxt_re_srqe {
>>       __u32 srq_tag; /* 20 bits are valid */
>>       __u32 rsvd1;
>> diff --git a/providers/bnxt_re/db.c b/providers/bnxt_re/db.c
>> index 6804946..3a85b2f 100644
>> --- a/providers/bnxt_re/db.c
>> +++ b/providers/bnxt_re/db.c
>> @@ -75,6 +75,24 @@ void bnxt_re_ring_sq_db(struct bnxt_re_qp *qp)
>>       bnxt_re_ring_db(qp->udpi, &hdr);
>>  }
>>
>> +void bnxt_re_ring_srq_db(struct bnxt_re_srq *srq)
>> +{
>> +     struct bnxt_re_db_hdr hdr;
>> +
>> +     bnxt_re_init_db_hdr(&hdr, srq->srqq->tail, srq->srqid,
>> +                         BNXT_RE_QUE_TYPE_SRQ);
>> +     bnxt_re_ring_db(srq->udpi, &hdr);
>> +}
>> +
>> +void bnxt_re_ring_srq_arm(struct bnxt_re_srq *srq)
>> +{
>> +     struct bnxt_re_db_hdr hdr;
>> +
>> +     bnxt_re_init_db_hdr(&hdr, srq->cap.srq_limit, srq->srqid,
>> +                         BNXT_RE_QUE_TYPE_SRQ_ARM);
>> +     bnxt_re_ring_db(srq->udpi, &hdr);
>> +}
>> +
>>  void bnxt_re_ring_cq_db(struct bnxt_re_cq *cq)
>>  {
>>       struct bnxt_re_db_hdr hdr;
>> diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
>> index a417328..3ddffde 100644
>> --- a/providers/bnxt_re/main.h
>> +++ b/providers/bnxt_re/main.h
>> @@ -76,10 +76,6 @@ struct bnxt_re_cq {
>>       uint8_t  phase;
>>  };
>>
>> -struct bnxt_re_srq {
>> -     struct ibv_srq ibvsrq;
>> -};
>> -
>>  struct bnxt_re_wrid {
>>       struct bnxt_re_psns *psns;
>>       uint64_t wrid;
>> @@ -96,6 +92,16 @@ struct bnxt_re_qpcap {
>>       uint8_t sqsig;
>>  };
>>
>> +struct bnxt_re_srq {
>> +     struct ibv_srq ibvsrq;
>> +     struct ibv_srq_attr cap;
>> +     struct bnxt_re_queue *srqq;
>> +     struct bnxt_re_wrid *srwrid;
>> +     struct bnxt_re_dpi *udpi;
>> +     uint32_t srqid;
>> +     uint32_t pre_count;
>> +};
>> +
>>  struct bnxt_re_qp {
>>       struct ibv_qp ibvqp;
>>       struct bnxt_re_queue *sqq;
>> @@ -151,6 +157,7 @@ struct bnxt_re_context {
>>  /* DB ring functions used internally*/
>>  void bnxt_re_ring_rq_db(struct bnxt_re_qp *qp);
>>  void bnxt_re_ring_sq_db(struct bnxt_re_qp *qp);
>> +void bnxt_re_ring_srq_arm(struct bnxt_re_srq *srq);
>>  void bnxt_re_ring_srq_db(struct bnxt_re_srq *srq);
>>  void bnxt_re_ring_cq_db(struct bnxt_re_cq *cq);
>>  void bnxt_re_ring_cq_arm_db(struct bnxt_re_cq *cq, uint8_t aflag);
>> @@ -182,6 +189,11 @@ static inline struct bnxt_re_qp *to_bnxt_re_qp(struct ibv_qp *ibvqp)
>>       return container_of(ibvqp, struct bnxt_re_qp, ibvqp);
>>  }
>>
>> +static inline struct bnxt_re_srq *to_bnxt_re_srq(struct ibv_srq *ibvsrq)
>> +{
>> +     return container_of(ibvsrq, struct bnxt_re_srq, ibvsrq);
>> +}
>> +
>>  static inline struct bnxt_re_ah *to_bnxt_re_ah(struct ibv_ah *ibvah)
>>  {
>>          return container_of(ibvah, struct bnxt_re_ah, ibvah);
>> @@ -211,6 +223,18 @@ static inline uint32_t bnxt_re_get_rqe_hdr_sz(void)
>>       return sizeof(struct bnxt_re_brqe) + sizeof(struct bnxt_re_rqe);
>>  }
>>
>> +static inline uint32_t bnxt_re_get_srqe_hdr_sz(void)
>> +{
>> +     return sizeof(struct bnxt_re_brqe) + sizeof(struct bnxt_re_srqe);
>> +}
>> +
>> +static inline uint32_t bnxt_re_get_srqe_sz(void)
>> +{
>> +     return sizeof(struct bnxt_re_brqe) +
>> +            sizeof(struct bnxt_re_srqe) +
>> +            BNXT_RE_MAX_INLINE_SIZE;
>> +}
>> +
>>  static inline uint32_t bnxt_re_get_cqe_sz(void)
>>  {
>>       return sizeof(struct bnxt_re_req_cqe) + sizeof(struct bnxt_re_bcqe);
>> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
>> index 85d77cd..dafe55b 100644
>> --- a/providers/bnxt_re/verbs.c
>> +++ b/providers/bnxt_re/verbs.c
>> @@ -339,36 +339,40 @@ static uint8_t bnxt_re_poll_scqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
>>  static int bnxt_re_poll_err_rcqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
>>                                struct bnxt_re_bcqe *hdr, void *cqe)
>>  {
>> -     struct bnxt_re_queue *rq = qp->rqq;
>> +     struct bnxt_re_queue *rq;
>>       struct bnxt_re_wrid *rwrid;
>>       struct bnxt_re_cq *rcq;
>>       struct bnxt_re_context *cntx;
>> -     uint32_t head = rq->head;
>>       uint8_t status;
>>
>>       rcq = to_bnxt_re_cq(qp->ibvqp.recv_cq);
>>       cntx = to_bnxt_re_context(rcq->ibvcq.context);
>>
>> -     rwrid = &qp->rwrid[head];
>> +     if (!qp->srq) {
>> +             rq = qp->rqq;
>> +             rwrid = &qp->rwrid[rq->head];
>> +     } else {
>> +             rq = qp->srq->srqq;
>> +             rwrid = &qp->srq->srwrid[rq->head];
>> +     }
>> +
>>       status = (hdr->flg_st_typ_ph >> BNXT_RE_BCQE_STATUS_SHIFT) &
>>                 BNXT_RE_BCQE_STATUS_MASK;
>>       /* skip h/w flush errors */
>>       if (status == BNXT_RE_RSP_ST_HW_FLUSH)
>>               return 0;
>> +
>>       ibvwc->status = bnxt_re_to_ibv_wc_status(status, false);
>> -     /* TODO: Add SRQ Processing here */
>> -     if (qp->rqq) {
>> -             ibvwc->wr_id = rwrid->wrid;
>> -             ibvwc->qp_num = qp->qpid;
>> -             ibvwc->opcode = IBV_WC_RECV;
>> -             ibvwc->byte_len = 0;
>> -             ibvwc->wc_flags = 0;
>> -             if (qp->qptyp == IBV_QPT_UD)
>> -                     ibvwc->src_qp = 0;
>> +     ibvwc->wr_id = rwrid->wrid;
>> +     ibvwc->qp_num = qp->qpid;
>> +     ibvwc->opcode = IBV_WC_RECV;
>> +     ibvwc->byte_len = 0;
>> +     ibvwc->wc_flags = 0;
>> +     if (qp->qptyp == IBV_QPT_UD)
>> +             ibvwc->src_qp = 0;
>> +     bnxt_re_incr_head(rq);
>>
>> -             bnxt_re_incr_head(qp->rqq);
>> -             if (qp->qpst != IBV_QPS_ERR)
>> -                     qp->qpst = IBV_QPS_ERR;
>> +     if (!qp->srq) {
>>               pthread_spin_lock(&cntx->fqlock);
>>               bnxt_re_fque_add_node(&rcq->rfhead, &qp->rnode);
>>               pthread_spin_unlock(&cntx->fqlock);
>> @@ -396,14 +400,19 @@ static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
>>                                     struct ibv_wc *ibvwc,
>>                                     struct bnxt_re_bcqe *hdr, void *cqe)
>>  {
>> -     struct bnxt_re_queue *rq = qp->rqq;
>> +     struct bnxt_re_queue *rq;
>>       struct bnxt_re_wrid *rwrid;
>>       struct bnxt_re_rc_cqe *rcqe;
>> -     uint32_t head = rq->head;
>>       uint8_t flags, is_imm, is_rdma;
>>
>>       rcqe = cqe;
>> -     rwrid = &qp->rwrid[head];
>> +     if (!qp->srq) {
>> +             rq = qp->rqq;
>> +             rwrid = &qp->rwrid[rq->head];
>> +     } else {
>> +             rq = qp->srq->srqq;
>> +             rwrid = &qp->srq->srwrid[rq->head];
>> +     }
>>
>>       ibvwc->status = IBV_WC_SUCCESS;
>>       ibvwc->wr_id = rwrid->wrid;
>> @@ -512,9 +521,6 @@ static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
>>                       qp = (struct bnxt_re_qp *)(uintptr_t)rcqe->qp_handle;
>>                       if (!qp)
>>                               break; /*stale cqe. should be rung.*/
>> -                     if (qp->srq)
>> -                             goto bail; /*TODO: Add SRQ poll */
>> -
>>                       pcqe = bnxt_re_poll_rcqe(qp, wc, cqe, &cnt);
>>                       break;
>>               case BNXT_RE_WC_TYPE_RECV_RAW:
>> @@ -554,7 +560,7 @@ skipp_real:
>>
>>       if (hw_polled)
>>               bnxt_re_ring_cq_db(cq);
>> -bail:
>> +
>>       return dqed;
>>  }
>>
>> @@ -752,9 +758,7 @@ static int bnxt_re_alloc_queue_ptr(struct bnxt_re_qp *qp,
>>       qp->sqq = calloc(1, sizeof(struct bnxt_re_queue));
>>       if (!qp->sqq)
>>               return -ENOMEM;
>> -     if (attr->srq)
>> -             qp->srq = NULL;/*TODO: to_bnxt_re_srq(attr->srq);*/
>> -     else {
>> +     if (!attr->srq) {
>>               qp->rqq = calloc(1, sizeof(struct bnxt_re_queue));
>>               if (!qp->rqq) {
>>                       free(qp->sqq);
>> @@ -767,10 +771,12 @@ static int bnxt_re_alloc_queue_ptr(struct bnxt_re_qp *qp,
>>
>>  static void bnxt_re_free_queues(struct bnxt_re_qp *qp)
>>  {
>> -     if (qp->rwrid)
>> -             free(qp->rwrid);
>> -     pthread_spin_destroy(&qp->rqq->qlock);
>> -     bnxt_re_free_aligned(qp->rqq);
>> +     if (qp->rqq) {
>> +             if (qp->rwrid)
>> +                     free(qp->rwrid);
>> +             pthread_spin_destroy(&qp->rqq->qlock);
>> +             bnxt_re_free_aligned(qp->rqq);
>> +     }
>>
>>       if (qp->swrid)
>>               free(qp->swrid);
>> @@ -881,6 +887,8 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
>>       qp->qpst = IBV_QPS_RESET;
>>       qp->scq = to_bnxt_re_cq(attr->send_cq);
>>       qp->rcq = to_bnxt_re_cq(attr->recv_cq);
>> +     if (attr->srq)
>> +             qp->srq = to_bnxt_re_srq(attr->srq);
>>       qp->udpi = &cntx->udpi;
>>       /* Save/return the altered Caps. */
>>       attr->cap.max_send_wr = cap->max_swr;
>> @@ -1319,32 +1327,215 @@ int bnxt_re_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
>>       return 0;
>>  }
>>
>> +static void bnxt_re_srq_free_queue_ptr(struct bnxt_re_srq *srq)
>> +{
>> +     if (srq && srq->srqq)
>> +             free(srq->srqq);
>> +     if (srq)
>> +             free(srq);
>
> No need to check for NULL before calling to free().
>
>> +}
>> +
>> +static struct bnxt_re_srq *bnxt_re_srq_alloc_queue_ptr(void)
>> +{
>> +     struct bnxt_re_srq *srq;
>> +
>> +     srq = calloc(1, sizeof(struct bnxt_re_srq));
>> +     if (!srq)
>> +             return NULL;
>> +
>> +     srq->srqq = calloc(1, sizeof(struct bnxt_re_queue));
>> +     if (!srq->srqq) {
>> +             free(srq);
>> +             return NULL;
>> +     }
>> +
>> +     return srq;
>> +}
>> +
>> +static void bnxt_re_srq_free_queue(struct bnxt_re_srq *srq)
>> +{
>> +     if (srq->srwrid)
>> +             free(srq->srwrid);
>> +     pthread_spin_destroy(&srq->srqq->qlock);
>> +     bnxt_re_free_aligned(srq->srqq);
>> +}
>> +
>> +static int bnxt_re_srq_alloc_queue(struct bnxt_re_srq *srq,
>> +                                struct ibv_srq_init_attr *attr,
>> +                                uint32_t pg_size)
>> +{
>> +     struct bnxt_re_queue *que;
>> +     int ret;
>> +
>> +     que = srq->srqq;
>> +     que->depth = roundup_pow_of_two(attr->attr.max_wr + 1);
>> +     que->stride = bnxt_re_get_srqe_sz();
>> +     ret = bnxt_re_alloc_aligned(que, pg_size);
>> +     if (ret)
>> +             goto bail;
>> +     pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
>> +     /* For SRQ only bnxt_re_wrid.wrid is used. */
>> +     srq->srwrid = calloc(que->depth, sizeof(struct bnxt_re_wrid));
>> +     if (!srq->srwrid) {
>> +             ret = -ENOMEM;
>> +             goto bail;
>> +     }
>> +     /*TODO: update actual max depth. */
>> +     return 0;
>> +bail:
>> +     bnxt_re_srq_free_queue(srq);
>> +     return ret;
>> +}
>> +
>>  struct ibv_srq *bnxt_re_create_srq(struct ibv_pd *ibvpd,
>>                                  struct ibv_srq_init_attr *attr)
>>  {
>> +     struct bnxt_re_srq *srq;
>> +     struct bnxt_re_srq_req cmd;
>> +     struct bnxt_re_srq_resp resp;
>> +     struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
>> +     struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
>> +     int ret;
>> +
>> +     /*TODO: Check max limit on queue depth and sge.*/
>> +     srq = bnxt_re_srq_alloc_queue_ptr();
>> +     if (!srq)
>> +             goto fail;
>> +
>> +     if (bnxt_re_srq_alloc_queue(srq, attr, dev->pg_size))
>> +             goto fail;
>> +
>> +     cmd.srqva = (uintptr_t)srq->srqq->va;
>> +     cmd.srq_handle = (uintptr_t)srq;
>> +     ret = ibv_cmd_create_srq(ibvpd, &srq->ibvsrq, attr,
>> +                              &cmd.cmd, sizeof(cmd),
>> +                              &resp.resp, sizeof(resp));
>> +     if (ret)
>> +             goto fail;
>> +
>> +     srq->srqid = resp.srqid;
>> +     srq->udpi = &cntx->udpi;
>> +     srq->cap.max_wr = srq->srqq->depth;
>> +     srq->cap.max_sge = attr->attr.max_sge;
>> +     srq->cap.srq_limit = attr->attr.srq_limit;
>> +     srq->pre_count = 0;
>> +
>> +     return &srq->ibvsrq;
>> +fail:
>> +     bnxt_re_srq_free_queue_ptr(srq);
>>       return NULL;
>>  }
>>
>>  int bnxt_re_modify_srq(struct ibv_srq *ibvsrq, struct ibv_srq_attr *attr,
>> -                    int init_attr)
>> +                    int attr_mask)
>>  {
>> -     return -ENOSYS;
>> +     struct bnxt_re_srq *srq = to_bnxt_re_srq(ibvsrq);
>> +     struct ibv_modify_srq cmd;
>> +     int status = 0;
>> +
>> +     status =  ibv_cmd_modify_srq(ibvsrq, attr, attr_mask,
>> +                                  &cmd, sizeof(cmd));
>> +     if (!status && ((attr_mask & IBV_SRQ_LIMIT) &&
>> +                     (srq->cap.srq_limit != attr->srq_limit))) {
>> +             srq->cap.srq_limit = attr->srq_limit;
>> +     }
>> +
>> +     return status;
>>  }
>>
>>  int bnxt_re_destroy_srq(struct ibv_srq *ibvsrq)
>>  {
>> -     return -ENOSYS;
>> +     struct bnxt_re_srq *srq = to_bnxt_re_srq(ibvsrq);
>> +     int ret;
>> +
>> +     ret = ibv_cmd_destroy_srq(ibvsrq);
>> +     if (ret)
>> +             return ret;
>> +     bnxt_re_srq_free_queue(srq);
>> +     bnxt_re_srq_free_queue_ptr(srq);
>> +
>> +     return 0;
>>  }
>>
>>  int bnxt_re_query_srq(struct ibv_srq *ibvsrq, struct ibv_srq_attr *attr)
>>  {
>> -     return -ENOSYS;
>> +     struct ibv_query_srq cmd;
>> +     int status;
>> +
>> +     status = ibv_cmd_query_srq(ibvsrq, attr, &cmd, sizeof(cmd));
>> +     if (status)
>> +             return status;
>> +
>> +     return 0;
>
> You can return status directly without need of if(..).
>
>> +}
>> +
>> +static int bnxt_re_build_srqe(struct bnxt_re_srq *srq,
>> +                           struct ibv_recv_wr *wr, void *srqe)
>> +{
>> +     struct bnxt_re_brqe *hdr = srqe;
>> +     struct bnxt_re_rqe *rwr;
>> +     struct bnxt_re_sge *sge;
>> +     struct bnxt_re_wrid *wrid;
>> +     int wqe_sz, len;
>> +
>> +     rwr = (srqe + sizeof(struct bnxt_re_brqe));
>> +     sge = (srqe + bnxt_re_get_srqe_hdr_sz());
>> +     wrid = &srq->srwrid[srq->srqq->tail];
>> +
>> +     len = bnxt_re_build_sge(sge, wr->sg_list, wr->num_sge, false);
>> +     hdr->rsv_ws_fl_wt = BNXT_RE_WR_OPCD_RECV;
>> +     wqe_sz = wr->num_sge + (bnxt_re_get_srqe_hdr_sz() >> 4); /* 16B align */
>> +     hdr->rsv_ws_fl_wt |= ((wqe_sz & BNXT_RE_HDR_WS_MASK) <<
>> +                            BNXT_RE_HDR_WS_SHIFT);
>> +     rwr->wrid = srq->srqq->tail;
>> +
>> +     /* Fill wrid */
>> +     wrid->wrid = wr->wr_id;
>> +     wrid->bytes = len; /* N.A. for RQE */
>> +     wrid->sig = 0; /* N.A. for RQE */
>> +
>> +     return len;
>>  }
>>
>>  int bnxt_re_post_srq_recv(struct ibv_srq *ibvsrq, struct ibv_recv_wr *wr,
>>                         struct ibv_recv_wr **bad)
>>  {
>> -     return -ENOSYS;
>> +     struct bnxt_re_srq *srq = to_bnxt_re_srq(ibvsrq);
>> +     struct bnxt_re_queue *rq = srq->srqq;
>> +     void *srqe;
>> +     int ret;
>> +
>> +     pthread_spin_lock(&rq->qlock);
>> +     while (wr) {
>> +             if (bnxt_re_is_que_full(rq) ||
>> +                 wr->num_sge > srq->cap.max_sge) {
>> +                     *bad = wr;
>> +                     pthread_spin_unlock(&rq->qlock);
>> +                     return ENOMEM;
>> +             }
>> +
>> +             srqe = (void *)(rq->va + (rq->tail * rq->stride));
>> +             memset(srqe, 0, bnxt_re_get_srqe_sz());
>> +             ret = bnxt_re_build_srqe(srq, wr, srqe);
>> +             if (ret < 0) {
>> +                     pthread_spin_unlock(&rq->qlock);
>> +                     *bad = wr;
>> +                     return ENOMEM;
>> +             }
>> +
>> +             bnxt_re_host_to_le64((uint64_t *)srqe, rq->stride);
>> +             bnxt_re_incr_tail(rq);
>> +             wr = wr->next;
>> +             bnxt_re_ring_srq_db(srq);
>> +             if ((srq->pre_count < srq->srqq->depth) &&
>> +                 (++srq->pre_count > srq->cap.srq_limit)) {
>> +                     srq->pre_count = srq->srqq->depth;
>> +                     bnxt_re_ring_srq_arm(srq);
>> +             }
>> +     }
>> +     pthread_spin_unlock(&rq->qlock);
>> +
>> +     return 0;
>>  }
>>
>>  struct ibv_ah *bnxt_re_create_ah(struct ibv_pd *ibvpd, struct ibv_ah_attr *attr)
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
