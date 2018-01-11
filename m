From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error state
Date: Thu, 11 Jan 2018 13:27:57 +0200
Message-ID: <CAG9sBKM=Pfvis95=d9s=jObwVZR98Fj1HSqaOWYgnD-XQ1bYaQ@mail.gmail.com>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180109192340.25702-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 9, 2018 at 9:23 PM, Bart Van Assche <bart.vanassche@wdc.com> wrote:
> The following sequence:
> * Change queue pair state into IB_QPS_ERR.
> * Post a work request on the queue pair.
> Triggers the following race condition in the rdma_rxe driver:
> * rxe_qp_error() triggers an asynchronous call of rxe_completer(), the function
>   that examines the QP send queue.
> * rxe_post_send() posts a work request on the QP send queue.
> Avoid that this race causes a work request to be ignored by scheduling
> an rxe_completer() call from rxe_post_send() for queues that are in the
> error state.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Moni Shoua <monis@mellanox.com>
> Cc: <stable@vger.kernel.org> # v4.8
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index a6fbed48db8a..8f631d64c192 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -814,6 +814,8 @@ static int rxe_post_send_kernel(struct rxe_qp *qp, struct ib_send_wr *wr,
>                         (queue_count(qp->sq.queue) > 1);
>
>         rxe_run_task(&qp->req.task, must_sched);
> +       if (unlikely(qp->req.state == QP_STATE_ERROR))
> +               rxe_run_task(&qp->comp.task, 1);
>
>         return err;
>  }
> --
> 2.15.1
>

Maybe I am missing something but I think that the race is when qp is
in ERROR state and the following functions run in parallel
* rxe_drain_req_pkts (called from rxe_requester after post_send)
* rxe_drain_resp_pkts (called from rxe_completer after modify to ERROR)

Am I right?
