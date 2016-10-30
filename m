From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v4 10/10] IB/mlx5: Simplify completion into a wait_event
Date: Sun, 30 Oct 2016 23:17:57 +0200
Message-ID: <8ceb7dbf-d242-1427-199a-b6ec82876f23@grimberg.me>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-11-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-11-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 27/10/16 09:59, Binoy Jayan wrote:
> Convert the completion 'mlx5_ib_umr_context:done' to a wait_event as it
> just waits for the return value to be filled.
>
> Signed-off-by: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
>  drivers/infiniband/hw/mlx5/mr.c      | 9 +++++----
>  include/rdma/ib_verbs.h              | 1 +
>  3 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index de31b5f..cf496b5 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -524,7 +524,7 @@ struct mlx5_ib_mw {
>  struct mlx5_ib_umr_context {
>  	struct ib_cqe		cqe;
>  	enum ib_wc_status	status;
> -	struct completion	done;
> +	wait_queue_head_t	wq;
>  };
>
>  struct umr_common {
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index dfaf6f6..49ff2af 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -846,14 +846,14 @@ static void mlx5_ib_umr_done(struct ib_cq *cq, struct ib_wc *wc)
>  		container_of(wc->wr_cqe, struct mlx5_ib_umr_context, cqe);
>
>  	context->status = wc->status;
> -	complete(&context->done);
> +	wake_up(&context->wq);
>  }
>
>  static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
>  {
>  	context->cqe.done = mlx5_ib_umr_done;
> -	context->status = -1;
> -	init_completion(&context->done);
> +	context->status = IB_WC_STATUS_NONE;
> +	init_waitqueue_head(&context->wq);
>  }
>
>  static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> @@ -873,7 +873,8 @@ static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
>  	if (err) {
>  		mlx5_ib_warn(dev, "UMR post send failed, err %d\n", err);
>  	} else {
> -		wait_for_completion(&umr_context.done);
> +		wait_event(umr_context.wq,
> +			   umr_context.status != IB_WC_STATUS_NONE);

How is this simpler?


>  enum ib_wc_status {
> +	IB_WC_STATUS_NONE = -1,
>  	IB_WC_SUCCESS,
>  	IB_WC_LOC_LEN_ERR,
>  	IB_WC_LOC_QP_OP_ERR,
>

Huh? Where did this bogus status came from? IMHO, this is polluting
the verbs interface for no good reason at all, sorry.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
