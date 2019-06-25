From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Date: Tue, 25 Jun 2019 14:14:17 -0700
Message-ID: <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190625205701.17849-11-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tal Gilboa <talgi@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yamin Friedman <yaminf@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> +static int ib_poll_dim_handler(struct irq_poll *iop, int budget)
> +{
> +	struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
> +	struct dim *dim = cq->dim;
> +	int completed;
> +
> +	completed = __ib_process_cq(cq, budget, cq->wc, IB_POLL_BATCH);
> +	if (completed < budget) {
> +		irq_poll_complete(&cq->iop);
> +		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> +			irq_poll_sched(&cq->iop);
> +	}
> +
> +	rdma_dim(dim, completed);

Why duplicate the entire thing for a one-liner?

> +
> +	return completed;
> +}
> +
>   static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
>   {
>   	irq_poll_sched(&cq->iop);
> @@ -105,14 +157,18 @@ static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
>   
>   static void ib_cq_poll_work(struct work_struct *work)
>   {
> -	struct ib_cq *cq = container_of(work, struct ib_cq, work);
> +	struct ib_cq *cq = container_of(work, struct ib_cq,
> +					work);

Why was that changed?

>   	int completed;
>   
>   	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE, cq->wc,
>   				    IB_POLL_BATCH);
> +

newline?

>   	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>   	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>   		queue_work(cq->comp_wq, &cq->work);
> +	else if (cq->dim)
> +		rdma_dim(cq->dim, completed);
>   }
>   
>   static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
> @@ -166,6 +222,8 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
>   	rdma_restrack_set_task(&cq->res, caller);
>   	rdma_restrack_kadd(&cq->res);
>   
> +	rdma_dim_init(cq);
> +
>   	switch (cq->poll_ctx) {
>   	case IB_POLL_DIRECT:
>   		cq->comp_handler = ib_cq_completion_direct;
> @@ -173,7 +231,13 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
>   	case IB_POLL_SOFTIRQ:
>   		cq->comp_handler = ib_cq_completion_softirq;
>   
> -		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> +		if (cq->dim) {
> +			irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ,
> +				      ib_poll_dim_handler);
> +		} else
> +			irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ,
> +				      ib_poll_handler);
> +
>   		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>   		break;
>   	case IB_POLL_WORKQUEUE:
> @@ -226,6 +290,9 @@ void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
>   		WARN_ON_ONCE(1);
>   	}
>   
> +	if (cq->dim)
> +		cancel_work_sync(&cq->dim->work);
> +	kfree(cq->dim);
>   	kfree(cq->wc);
>   	rdma_restrack_del(&cq->res);
>   	ret = cq->device->ops.destroy_cq(cq, udata);
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index abac70ad5c7c..b1b45dbe24a5 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -6305,6 +6305,8 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
>   	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
>   		mutex_init(&dev->lb.mutex);
>   
> +	dev->ib_dev.use_cq_dim = true;
> +

Please don't. This is a bad choice to opt it in by default.
