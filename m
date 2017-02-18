From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 11/14] ocrdma: Update to use new udma write barriers
Date: Sat, 18 Feb 2017 21:51:58 +0530
Message-ID: <CANjDDBj418f7GC91dc356-8u_57jAAGZ87O_gWAa7ssaO6NHAA@mail.gmail.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com> <1487272989-8215-12-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-12-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks good!

Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Feb 17, 2017 at 12:53 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> Move the barriers closer to the actual action being protected eg
> put udma_to_device_barrier in ocrdma_ring_*.
>
> Add a wc_wmb() barrier before starting WC writes for consistency
> with other drivers.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  providers/ocrdma/ocrdma_verbs.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
> index 7fc841a194127d..3725d63a9b88f3 100644
> --- a/providers/ocrdma/ocrdma_verbs.c
> +++ b/providers/ocrdma/ocrdma_verbs.c
> @@ -1111,18 +1111,24 @@ int ocrdma_destroy_qp(struct ibv_qp *ibqp)
>  static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)
>  {
>         uint32_t db_val = ocrdma_cpu_to_le((qp->sq.dbid | (1 << 16)));
> +
> +       udma_to_device_barrier();
>         *(uint32_t *) (((uint8_t *) qp->db_sq_va)) = db_val;
>  }
>
>  static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)
>  {
>         uint32_t db_val = ocrdma_cpu_to_le((qp->rq.dbid | (1 << qp->db_shift)));
> +
> +       udma_to_device_barrier();
>         *(uint32_t *) ((uint8_t *) qp->db_rq_va) = db_val;
>  }
>
>  static void ocrdma_ring_srq_db(struct ocrdma_srq *srq)
>  {
>         uint32_t db_val = ocrdma_cpu_to_le(srq->rq.dbid | (1 << srq->db_shift));
> +
> +       udma_to_device_barrier();
>         *(uint32_t *) (srq->db_va) = db_val;
>  }
>
> @@ -1141,6 +1147,7 @@ static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
>                 val |= (1 << OCRDMA_DB_CQ_SOLICIT_SHIFT);
>         val |= (num_cqe << OCRDMA_DB_CQ_NUM_POPPED_SHIFT);
>
> +       udma_to_device_barrier();
>         *(uint32_t *) ((uint8_t *) (cq->db_va) + OCRDMA_DB_CQ_OFFSET) =
>             ocrdma_cpu_to_le(val);
>  }
> @@ -1322,6 +1329,9 @@ static void ocrdma_build_dpp_wqe(void *va, struct ocrdma_hdr_wqe *wqe,
>  {
>         uint32_t pyld_len = (wqe->cw >> OCRDMA_WQE_SIZE_SHIFT) * 2;
>         uint32_t i = 0;
> +
> +       mmio_wc_start();
> +
>         /* convert WQE header to LE format */
>         for (; i < hdr_len; i++)
>                 *((uint32_t *) va + i) =
> @@ -1329,7 +1339,8 @@ static void ocrdma_build_dpp_wqe(void *va, struct ocrdma_hdr_wqe *wqe,
>         /* Convertion of data is done in HW */
>         for (; i < pyld_len; i++)
>                 *((uint32_t *) va + i) = (*((uint32_t *) wqe + i));
> -       wc_wmb();
> +
> +       mmio_flush_writes();
>  }
>
>  static void ocrdma_post_dpp_wqe(struct ocrdma_qp *qp,
> @@ -1439,7 +1450,6 @@ int ocrdma_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
>                                       OCRDMA_WQE_SIZE_MASK) *
>                                       OCRDMA_WQE_STRIDE);
>
> -               wmb();
>                 ocrdma_ring_sq_db(qp);
>
>                 /* update pointer, counter for next wr */
> @@ -1501,7 +1511,6 @@ int ocrdma_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
>                 rqe = ocrdma_hwq_head(&qp->rq);
>                 ocrdma_build_rqe(rqe, wr, 0);
>                 qp->rqe_wr_id_tbl[qp->rq.head] = wr->wr_id;
> -               wmb();
>                 ocrdma_ring_rq_db(qp);
>
>                 /* update pointer, counter for next wr */
> @@ -2082,7 +2091,6 @@ int ocrdma_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
>                 ocrdma_build_rqe(rqe, wr, tag);
>                 srq->rqe_wr_id_tbl[tag] = wr->wr_id;
>
> -               wmb();
>                 ocrdma_ring_srq_db(srq);
>
>                 /* update pointer, counter for next wr */
> --
> 2.7.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
