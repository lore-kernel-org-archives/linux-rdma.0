From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/8] IB/rdmavt: Add post send to rdmavt
Date: Tue, 19 Jan 2016 18:23:14 +0200
Message-ID: <CAG9sBKOpDfxOaPU+dJ+M42JrbCVEoNAORi8jk1KJLay-KDhSSA@mail.gmail.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
	<20160109150007.8585.76575.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109150007.8585.76575.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 9, 2016 at 5:00 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Add in a post_send and post_one_send to rdmavt. The ULP will provide a WQE
> to rdmavt which will then walk and queue each element. Rdmavt will then
> queue the work to be done in the driver or kick the driver's progress
> routine.
>
> There needs to be a follow on patch which adds in another lock for the
> head of the queue so that it can be added to and read from in parallel.
> This will touch protocol handlers and require other changes in the
> drivers. This will be done separately.
>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/sw/rdmavt/qp.c |  183 +++++++++++++++++++++++++++++++++++--
>  include/rdma/rdma_vt.h            |    7 +
>  include/rdma/rdmavt_qp.h          |   26 +++++
>  3 files changed, 204 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
> index ee19eae..5063e25 100644
> --- a/drivers/infiniband/sw/rdmavt/qp.c
> +++ b/drivers/infiniband/sw/rdmavt/qp.c
> @@ -53,6 +53,27 @@
>  #include "qp.h"
>  #include "vt.h"
>
> +/*
> + * Note that it is OK to post send work requests in the SQE and ERR
> + * states; rvt_do_send() will process them and generate error
> + * completions as per IB 1.2 C10-96.
> + */
> +const int ib_rvt_state_ops[IB_QPS_ERR + 1] = {
> +       [IB_QPS_RESET] = 0,
> +       [IB_QPS_INIT] = RVT_POST_RECV_OK,
> +       [IB_QPS_RTR] = RVT_POST_RECV_OK | RVT_PROCESS_RECV_OK,
> +       [IB_QPS_RTS] = RVT_POST_RECV_OK | RVT_PROCESS_RECV_OK |
> +           RVT_POST_SEND_OK | RVT_PROCESS_SEND_OK |
> +           RVT_PROCESS_NEXT_SEND_OK,
> +       [IB_QPS_SQD] = RVT_POST_RECV_OK | RVT_PROCESS_RECV_OK |
> +           RVT_POST_SEND_OK | RVT_PROCESS_SEND_OK,
> +       [IB_QPS_SQE] = RVT_POST_RECV_OK | RVT_PROCESS_RECV_OK |
> +           RVT_POST_SEND_OK | RVT_FLUSH_SEND,
> +       [IB_QPS_ERR] = RVT_POST_RECV_OK | RVT_FLUSH_RECV |
> +           RVT_POST_SEND_OK | RVT_FLUSH_SEND,
> +};
> +EXPORT_SYMBOL(ib_rvt_state_ops);
> +
>  static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
>  {
>         unsigned long page = get_zeroed_page(GFP_KERNEL);
> @@ -556,7 +577,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
>
>         /*
>          * Return the address of the RWQ as the offset to mmap.
> -        * See hfi1_mmap() for details.
> +        * See rvt_mmap() for details.
>          */
>         if (udata && udata->outlen >= sizeof(__u64)) {
>                 if (!qp->r_rq.wq) {
> @@ -720,6 +741,118 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>  }
>
>  /**
> + * rvt_post_one_wr - post one RC, UC, or UD send work request
> + * @qp: the QP to post on
> + * @wr: the work request to send
> + */
> +static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
> +{
> +       struct rvt_swqe *wqe;
> +       u32 next;
> +       int i;
> +       int j;
> +       int acc;
> +       struct rvt_lkey_table *rkt;
> +       struct rvt_pd *pd;
> +       struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
> +
> +       /* IB spec says that num_sge == 0 is OK. */
> +       if (unlikely(wr->num_sge > qp->s_max_sge))
> +               return -EINVAL;
> +
> +       /*
> +        * Don't allow RDMA reads or atomic operations on UC or
> +        * undefined operations.
> +        * Make sure buffer is large enough to hold the result for atomics.
> +        */
> +       if (qp->ibqp.qp_type == IB_QPT_UC) {
> +               if ((unsigned)wr->opcode >= IB_WR_RDMA_READ)
> +                       return -EINVAL;
> +       } else if (qp->ibqp.qp_type != IB_QPT_RC) {
> +               /* Check IB_QPT_SMI, IB_QPT_GSI, IB_QPT_UD opcode */
> +               if (wr->opcode != IB_WR_SEND &&
> +                   wr->opcode != IB_WR_SEND_WITH_IMM)
> +                       return -EINVAL;
> +               /* Check UD destination address PD */
> +               if (qp->ibqp.pd != ud_wr(wr)->ah->pd)
> +                       return -EINVAL;
> +       } else if ((unsigned)wr->opcode > IB_WR_ATOMIC_FETCH_AND_ADD) {
> +               return -EINVAL;
> +       } else if (wr->opcode >= IB_WR_ATOMIC_CMP_AND_SWP &&
> +                  (wr->num_sge == 0 ||
> +                   wr->sg_list[0].length < sizeof(u64) ||
> +                   wr->sg_list[0].addr & (sizeof(u64) - 1))) {
> +               return -EINVAL;
> +       } else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic) {
> +               return -EINVAL;
> +       }
> +
> +       next = qp->s_head + 1;
> +       if (next >= qp->s_size)
> +               next = 0;
> +       if (next == qp->s_last)
> +               return -ENOMEM;
> +
> +       rkt = &rdi->lkey_table;
> +       pd = ibpd_to_rvtpd(qp->ibqp.pd);
> +       wqe = rvt_get_swqe_ptr(qp, qp->s_head);
> +
> +       if (qp->ibqp.qp_type != IB_QPT_UC &&
> +           qp->ibqp.qp_type != IB_QPT_RC)
> +               memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
> +       else if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
> +                wr->opcode == IB_WR_RDMA_WRITE ||
> +                wr->opcode == IB_WR_RDMA_READ)
> +               memcpy(&wqe->rdma_wr, rdma_wr(wr), sizeof(wqe->rdma_wr));
> +       else if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
> +                wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
> +               memcpy(&wqe->atomic_wr, atomic_wr(wr), sizeof(wqe->atomic_wr));
> +       else
> +               memcpy(&wqe->wr, wr, sizeof(wqe->wr));
> +
> +       wqe->length = 0;
> +       j = 0;
> +       if (wr->num_sge) {
> +               acc = wr->opcode >= IB_WR_RDMA_READ ?
> +                       IB_ACCESS_LOCAL_WRITE : 0;
> +               for (i = 0; i < wr->num_sge; i++) {
> +                       u32 length = wr->sg_list[i].length;
> +                       int ok;
> +
> +                       if (length == 0)
> +                               continue;
> +                       ok = rvt_lkey_ok(rkt, pd, &wqe->sg_list[j],
> +                                        &wr->sg_list[i], acc);
> +                       if (!ok)
> +                               goto bail_inval_free;
> +                       wqe->length += length;
> +                       j++;
> +               }
> +               wqe->wr.num_sge = j;
> +       }
> +       if (qp->ibqp.qp_type == IB_QPT_UC ||
> +           qp->ibqp.qp_type == IB_QPT_RC) {
> +               if (wqe->length > 0x80000000U)
> +                       goto bail_inval_free;
> +       } else {
> +               atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
> +       }
> +       wqe->ssn = qp->s_ssn++;
> +       qp->s_head = next;
> +
> +       return 0;
> +
> +bail_inval_free:
> +       /* release mr holds */
> +       while (j) {
> +               struct rvt_sge *sge = &wqe->sg_list[--j];
> +
> +               rvt_put_mr(sge->mr);
> +       }
> +       return -EINVAL;
> +}
> +
> +/**
>   * rvt_post_send - post a send on a QP
>   * @ibqp: the QP to post the send on
>   * @wr: the list of work requests to post
> @@ -730,20 +863,46 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
>  int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>                   struct ib_send_wr **bad_wr)
>  {
> +       struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
> +       struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
> +       unsigned long flags = 0;
> +       int call_send;
> +       unsigned nreq = 0;
> +       int err = 0;
> +
> +       spin_lock_irqsave(&qp->s_lock, flags);
> +
>         /*
> -        * VT-DRIVER-API: do_send()
> -        * Driver needs to have a do_send() call which is a single entry point
> -        * to take an already formed packet and throw it out on the wire. Once
> -        * the packet is sent the driver needs to make an upcall to rvt so the
> -        * completion queue can be notified and/or any other outstanding
> -        * work/book keeping can be finished.
Why was this design for do_send() removed?
This requires that each low level drivers do the packet formatting by
themselves --> code duplication.
> -        *
> -        * Note that there should also be a way for rvt to protect itself
> -        * against hangs in the driver layer. If a send doesn't actually
> -        * complete in a timely manor rvt needs to return an error event.
> +        * Ensure QP state is such that we can send. If not bail out early,
> +        * there is no need to do this every time we post a send.
>          */
> +       if (unlikely(!(ib_rvt_state_ops[qp->state] & RVT_POST_SEND_OK))) {
> +               spin_unlock_irqrestore(&qp->s_lock, flags);
> +               return -EINVAL;
> +       }
>
> -       return -EOPNOTSUPP;
> +       /*
> +        * If the send queue is empty, and we only have a single WR then just go
> +        * ahead and kick the send engine into gear. Otherwise we will always
> +        * just schedule the send to happen later.
> +        */
> +       call_send = qp->s_head == ACCESS_ONCE(qp->s_last) && !wr->next;
> +
> +       for (; wr; wr = wr->next) {
> +               err = rvt_post_one_wr(qp, wr);
> +               if (unlikely(err)) {
> +                       *bad_wr = wr;
> +                       goto bail;
> +               }
> +               nreq++;
> +       }
> +bail:
> +       if (nreq && !call_send)
> +               rdi->driver_f.schedule_send(qp);
> +       spin_unlock_irqrestore(&qp->s_lock, flags);
> +       if (nreq && call_send)
> +               rdi->driver_f.do_send(qp);
> +       return err;
>  }
Wouldn't it be better if scheduling for sending packets be done in RVT?
>
>  /**
> diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
> index f2d50b9..3d92239 100644
> --- a/include/rdma/rdma_vt.h
> +++ b/include/rdma/rdma_vt.h
> @@ -230,6 +230,8 @@ struct rvt_driver_provided {
>         void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
>         void (*qp_priv_free)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
>         void (*notify_qp_reset)(struct rvt_qp *qp);
> +       void (*schedule_send)(struct rvt_qp *qp);
> +       void (*do_send)(struct rvt_qp *qp);
A proper explanation about the meaning for each driver provided
function is required.
This is true for the 2 new added function and for any other that was
already there
>
>         /*--------------------*/
>         /* Optional functions */
> @@ -311,6 +313,11 @@ static inline struct rvt_srq *ibsrq_to_rvtsrq(struct ib_srq *ibsrq)
>         return container_of(ibsrq, struct rvt_srq, ibsrq);
>  }
>
> +static inline struct rvt_qp *ibqp_to_rvtqp(struct ib_qp *ibqp)
> +{
> +       return container_of(ibqp, struct rvt_qp, ibqp);
> +}
> +
>  static inline unsigned rvt_get_npkeys(struct rvt_dev_info *rdi)
>  {
>         /*
> diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
> index bce0a03..3189f19 100644
> --- a/include/rdma/rdmavt_qp.h
> +++ b/include/rdma/rdmavt_qp.h
> @@ -129,6 +129,17 @@
>  /* Number of bits to pay attention to in the opcode for checking qp type */
>  #define RVT_OPCODE_QP_MASK 0xE0
>
> +/* Flags for checking QP state (see ib_rvt_state_ops[]) */
> +#define RVT_POST_SEND_OK                0x01
> +#define RVT_POST_RECV_OK                0x02
> +#define RVT_PROCESS_RECV_OK             0x04
> +#define RVT_PROCESS_SEND_OK             0x08
> +#define RVT_PROCESS_NEXT_SEND_OK        0x10
> +#define RVT_FLUSH_SEND                 0x20
> +#define RVT_FLUSH_RECV                 0x40
> +#define RVT_PROCESS_OR_FLUSH_SEND \
> +       (RVT_PROCESS_SEND_OK | RVT_FLUSH_SEND)
> +
>  /*
>   * Send work request queue entry.
>   * The size of the sg_list is determined when the QP is created and stored
> @@ -373,4 +384,19 @@ struct rvt_qp_ibdev {
>         struct rvt_qpn_table qpn_table;
>  };
>
> +/*
> + * Since struct rvt_swqe is not a fixed size, we can't simply index into
> + * struct hfi1_qp.s_wq.  This function does the array index computation.
> + */
> +static inline struct rvt_swqe *rvt_get_swqe_ptr(struct rvt_qp *qp,
> +                                               unsigned n)
> +{
> +       return (struct rvt_swqe *)((char *)qp->s_wq +
> +                                    (sizeof(struct rvt_swqe) +
> +                                     qp->s_max_sge *
> +                                     sizeof(struct rvt_sge)) * n);
> +}
> +
> +extern const int  ib_rvt_state_ops[];
> +
>  #endif          /* DEF_RDMAVT_INCQP_H */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
