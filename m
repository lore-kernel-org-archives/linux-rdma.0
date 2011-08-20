From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 20/37] add rxe_cq.c
Date: Sat, 20 Aug 2011 17:53:12 +0200
Message-ID: <CAO+b5-rpJGQMG7sW+Ewsg0UEj_LL3t=WSPM+b9hK8zHekARvzQ@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.112267527@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.112267527-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +int rxe_cq_chk_attr(struct rxe_dev *rxe, struct rxe_cq *cq,
> +		    int cqe, int comp_vector, struct ib_udata *udata)
> +{
> +	int count;
> +
> +	if (cqe <= 0) {
> +		pr_warn("cqe(%d) <= 0\n", cqe);
> +		goto err1;
> +	}

Shouldn't that be dev_warn() instead of pr_warn() ?

> +int rxe_cq_from_init(struct rxe_dev *rxe, struct rxe_cq *cq, int cqe,
> +		     int comp_vector, struct ib_ucontext *context,
> +		     struct ib_udata *udata)
> +{
> +	int err;
> +
> +	cq->queue = rxe_queue_init(rxe, (unsigned int *)&cqe,
> +				   sizeof(struct rxe_cqe));
> +	if (!cq->queue) {
> +		pr_warn("unable to create cq\n");
> +		return -ENOMEM;
> +	}
> +
> +	err = do_mmap_info(rxe, udata, 0, context, cq->queue->buf,
> +			   cq->queue->buf_size, &cq->queue->ip);
> +	if (err) {
> +		vfree(cq->queue->buf);
> +		kfree(cq->queue);
> +	}

In the above I see that cq->queue->buf and cq->queue are both
allocated via a single function call but that they are freed
individually. That doesn't look very symmetric to me.

> +	memcpy(producer_addr(cq->queue), cqe, sizeof(*cqe));
> +
> +	/* make sure all changes to the CQ are written before
> +	   we update the producer pointer */
> +	wmb();
> +
> +	advance_producer(cq->queue);

Almost all advance_producer() calls are preceded by a wmb() call. Has
it been considered to move the wmb() call into that function and to
add a numeric argument to advance_producer() specifying by how much
the producer index should be advanced ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
