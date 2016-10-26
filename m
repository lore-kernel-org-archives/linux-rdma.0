From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 8/9] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Wed, 26 Oct 2016 10:48:26 +0200
Message-ID: <12933685.Se3eQHi9An@wuerfel>
References: <1477468874-16328-1-git-send-email-binoy.jayan@linaro.org> <1477468874-16328-9-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477468874-16328-9-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wednesday, October 26, 2016 1:31:13 PM CEST Binoy Jayan wrote:
> +static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> +                                        struct mlx5_umr_wr *umrwr)
> +{
> +       struct umr_common *umrc = &dev->umrc;
> +       struct ib_send_wr *bad;
> +       int err;
> +       struct mlx5_ib_umr_context umr_context;
> +
> +       mlx5_ib_init_umr_context(&umr_context);
> +       umrwr->wr.wr_cqe = &umr_context.cqe;
> +
> +       down(&umrc->sem);
> +       err = ib_post_send(umrc->qp, &umrwr->wr, &bad);
> +       if (err) {
> +               mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
> +       } else {
> +               wait_for_completion(&umr_context.done);
> +               if (umr_context.status != IB_WC_SUCCESS) {
> +                       mlx5_ib_warn(dev, "reg umr failed (%u)\n",
> +                                    umr_context.status);
> +                       err = -EFAULT;
> +               }
> +       }
> +       up(&umrc->sem);
> +       return err;
> +}
> 

Looks nice!

Now that this has become the only use of the semaphore (and the
last one in infiniband I guess), I wonder if we can agree on a way
to get rid of that one too. How about

	/* limit number of concurrent ib_post_send() on qp */
	wait_event(&umrc->wq, atomic_add_unless(&umrc->users, 1, MAX_UMR_WR);
	...
	atomic_dec(&umrc->users);
	wake_up(&umrc->wq);

That would be a fairly simple conversion and document better
what we actually do here: the down() looks like a simple mutex,
which it isn't.

In terms of efficiency, the wait_event() is actually better
here for the common case that the semaphore is not contented
as it only needs a single atomic operation and a branch
instead of an external function call and a spinlock in down().
However, the wake_up() is slightly better than atomic_dec()+up()
as it avoids the additional atomic.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
