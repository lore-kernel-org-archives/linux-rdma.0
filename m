From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/8] bnxt_re: Convert from init_context to alloc_context
Date: Wed, 10 Jan 2018 11:23:16 +0530
Message-ID: <CANjDDBjwmtO2aOtY5NCObrU_VJVmHjw=fdJOk_VvfZx+8+4Ejw@mail.gmail.com>
References: <20180108212632.5183-1-jgg@ziepe.ca> <20180108212632.5183-3-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-3-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 9, 2018 at 2:56 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Now that alloc_context can create a verbs_context directly we do
> not need two init APIs.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxt_re/main.c  | 45 +++++++++++++++++++++++----------------------
>  providers/bnxt_re/main.h  |  4 ++--
>  providers/bnxt_re/verbs.c |  4 ++--
>  3 files changed, 27 insertions(+), 26 deletions(-)
>
> diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
> index 5e83f9d1c12f35..c225f09eaa58f7 100644
> --- a/providers/bnxt_re/main.c
> +++ b/providers/bnxt_re/main.c
> @@ -104,23 +104,22 @@ static struct ibv_context_ops bnxt_re_cntx_ops = {
>  };
>
>  /* Context Init functions */
> -static int bnxt_re_init_context(struct verbs_device *vdev,
> -                               struct ibv_context *ibvctx, int cmd_fd)
> +static struct verbs_context *bnxt_re_alloc_context(struct ibv_device *vdev,
> +                                                  int cmd_fd)
>  {
>         struct ibv_get_context cmd;
>         struct bnxt_re_cntx_resp resp;
> -       struct bnxt_re_dev *dev;
> +       struct bnxt_re_dev *dev = to_bnxt_re_dev(vdev);
>         struct bnxt_re_context *cntx;
> -       struct verbs_context *verbs_ctx = verbs_get_ctx(ibvctx);
>
> -       dev = to_bnxt_re_dev(&vdev->device);
> -       cntx = to_bnxt_re_context(ibvctx);
> +       cntx = verbs_init_and_alloc_context(vdev, cmd_fd, cntx, ibvctx);
> +       if (!cntx)
> +               return NULL;
>
>         memset(&resp, 0, sizeof(resp));
> -       ibvctx->cmd_fd = cmd_fd;
> -       if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd), &resp.resp,
> -                               sizeof(resp)))
> -               return errno;
> +       if (ibv_cmd_get_context(&cntx->ibvctx, &cmd, sizeof(cmd),
> +                               &resp.resp, sizeof(resp)))
> +               goto failed;
>
>         cntx->dev_id = resp.dev_id;
>         cntx->max_qp = resp.max_qp;
> @@ -137,22 +136,21 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
>         }
>         pthread_mutex_init(&cntx->shlock, NULL);
>
> -       ibvctx->ops = bnxt_re_cntx_ops;
> +       cntx->ibvctx.context.ops = bnxt_re_cntx_ops;
> +
> +       return &cntx->ibvctx;
>
> -       return 0;
>  failed:
> -       fprintf(stderr, DEV "Failed to allocate context for device\n");
> -       return errno;
> +       verbs_uninit_context(&cntx->ibvctx);
> +       free(cntx);
> +       return NULL;
>  }
>
> -static void bnxt_re_uninit_context(struct verbs_device *vdev,
> -                                  struct ibv_context *ibvctx)
> +static void bnxt_re_free_context(struct ibv_context *ibvctx)
>  {
> -       struct bnxt_re_dev *dev;
> -       struct bnxt_re_context *cntx;
> +       struct bnxt_re_context *cntx = to_bnxt_re_context(ibvctx);
> +       struct bnxt_re_dev *dev = to_bnxt_re_dev(ibvctx->device);
>
> -       dev = to_bnxt_re_dev(&vdev->device);
> -       cntx = to_bnxt_re_context(ibvctx);
>         /* Unmap if anything device specific was mapped in init_context. */
>         pthread_mutex_destroy(&cntx->shlock);
>         if (cntx->shpg)
> @@ -167,6 +165,9 @@ static void bnxt_re_uninit_context(struct verbs_device *vdev,
>                 munmap(cntx->udpi.dbpage, dev->pg_size);
>                 cntx->udpi.dbpage = NULL;
>         }
> +
> +       verbs_uninit_context(&cntx->ibvctx);
> +       free(cntx);
>  }
>
>  static struct verbs_device *
> @@ -191,7 +192,7 @@ static const struct verbs_device_ops bnxt_re_dev_ops = {
>         .match_max_abi_version = BNXT_RE_ABI_VERSION,
>         .match_table = cna_table,
>         .alloc_device = bnxt_re_device_alloc,
> -       .init_context = bnxt_re_init_context,
> -       .uninit_context = bnxt_re_uninit_context,
> +       .alloc_context = bnxt_re_alloc_context,
> +       .free_context = bnxt_re_free_context,
>  };
>  PROVIDER_DRIVER(bnxt_re_dev_ops);
> diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
> index 33f531ba6d4b1d..affe24f01141ed 100644
> --- a/providers/bnxt_re/main.h
> +++ b/providers/bnxt_re/main.h
> @@ -141,7 +141,7 @@ struct bnxt_re_dev {
>  };
>
>  struct bnxt_re_context {
> -       struct ibv_context ibvctx;
> +       struct verbs_context ibvctx;
>         uint32_t dev_id;
>         uint32_t max_qp;
>         uint32_t max_srq;
> @@ -167,7 +167,7 @@ static inline struct bnxt_re_dev *to_bnxt_re_dev(struct ibv_device *ibvdev)
>  static inline struct bnxt_re_context *to_bnxt_re_context(
>                 struct ibv_context *ibvctx)
>  {
> -       return container_of(ibvctx, struct bnxt_re_context, ibvctx);
> +       return container_of(ibvctx, struct bnxt_re_context, ibvctx.context);
>  }
>
>  static inline struct bnxt_re_pd *to_bnxt_re_pd(struct ibv_pd *ibvpd)
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index 9d4e02bb328fae..bab2d732d71fa3 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -730,7 +730,7 @@ static int bnxt_re_check_qp_limits(struct bnxt_re_context *cntx,
>         struct ibv_device_attr devattr;
>         int ret;
>
> -       ret = bnxt_re_query_device(&cntx->ibvctx, &devattr);
> +       ret = bnxt_re_query_device(&cntx->ibvctx.context, &devattr);
>         if (ret)
>                 return ret;
>         if (attr->cap.max_send_sge > devattr.max_sge)
> @@ -865,7 +865,7 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
>         struct bnxt_re_qpcap *cap;
>
>         struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
> -       struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
> +       struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.context.device);
>
>         if (bnxt_re_check_qp_limits(cntx, attr))
>                 return NULL;
> --
> 2.15.1
>

Looks good, will test and comeback if there are any failures seen.
Reveiwed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
