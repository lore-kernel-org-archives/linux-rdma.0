From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/8] verbs: Remove init_context/uninit_context
Date: Wed, 10 Jan 2018 11:29:13 +0530
Message-ID: <CANjDDBjN8+nLWKuTjvRg6xEDbtwjExqkeJMHk=K_gBgNQFxUgQ@mail.gmail.com>
References: <20180108212632.5183-1-jgg@ziepe.ca> <20180108212632.5183-6-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-6-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 9, 2018 at 2:56 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> All providers now use the alloc_context interface and support
> verbs_context. Remove the dead code.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/device.c      | 39 ++-------------------------------------
>  libibverbs/driver.h      |  9 ---------
>  providers/bnxt_re/main.c |  4 ----
>  providers/mlx4/mlx4.c    |  4 ----
>  providers/mlx5/mlx5.c    |  4 ----
>  5 files changed, 2 insertions(+), 58 deletions(-)
>
> diff --git a/libibverbs/device.c b/libibverbs/device.c
> index e42e37bd0a1f8d..db6dae5b25af59 100644
> --- a/libibverbs/device.c
> +++ b/libibverbs/device.c
> @@ -259,29 +259,6 @@ err_free:
>         return NULL;
>  }
>
> -/* Use the init_context flow to create a verbs_context */
> -static struct verbs_context *alloc_context(struct verbs_device *device,
> -                                          int cmd_fd)
> -{
> -       struct verbs_context *context;
> -
> -       context = _verbs_init_and_alloc_context(
> -               &device->device, cmd_fd,
> -               sizeof(*context) + device->size_of_context, NULL);
> -       if (!context)
> -               return NULL;
> -
> -       if (device->ops->init_context(device, &context->context, cmd_fd))
> -               goto err_uninit;
> -
> -       return context;
> -
> -err_uninit:
> -       verbs_uninit_context(context);
> -       free(context);
> -       return NULL;
> -}
> -
>  LATEST_SYMVER_FUNC(ibv_open_device, 1_1, "IBVERBS_1.1",
>                    struct ibv_context *,
>                    struct ibv_device *device)
> @@ -304,15 +281,11 @@ LATEST_SYMVER_FUNC(ibv_open_device, 1_1, "IBVERBS_1.1",
>         if (cmd_fd < 0)
>                 return NULL;
>
> -       if (!verbs_device->ops->init_context)
> -               context_ex = verbs_device->ops->alloc_context(device, cmd_fd);
> -       else
> -               context_ex = alloc_context(verbs_device, cmd_fd);
> -
>         /*
>          * cmd_fd ownership is transferred into alloc_context, if it fails
>          * then it closes cmd_fd and returns NULL
>          */
> +       context_ex = verbs_device->ops->alloc_context(device, cmd_fd);
>         if (context_ex == NULL)
>                 return NULL;
>
> @@ -338,15 +311,7 @@ LATEST_SYMVER_FUNC(ibv_close_device, 1_1, "IBVERBS_1.1",
>  {
>         struct verbs_device *verbs_device = verbs_get_device(context->device);
>
> -       if (verbs_device->ops->uninit_context) {
> -               struct verbs_context *context_ex =
> -                       container_of(context, struct verbs_context, context);
> -
> -               verbs_device->ops->uninit_context(verbs_device, context);
> -               verbs_uninit_context(context_ex);
> -       } else {
> -               verbs_device->ops->free_context(context);
> -       }
> +       verbs_device->ops->free_context(context);
>
>         return 0;
>  }
> diff --git a/libibverbs/driver.h b/libibverbs/driver.h
> index 809c4f5c8cdf39..00847a41bc468e 100644
> --- a/libibverbs/driver.h
> +++ b/libibverbs/driver.h
> @@ -152,17 +152,10 @@ struct verbs_device_ops {
>
>         bool (*match_device)(struct verbs_sysfs_dev *sysfs_dev);
>
> -       /* Old interface, do not use in new code. */
>         struct verbs_context *(*alloc_context)(struct ibv_device *device,
>                                                int cmd_fd);
>         void (*free_context)(struct ibv_context *context);
>
> -       /* New interface */
> -       int (*init_context)(struct verbs_device *device,
> -                           struct ibv_context *ctx, int cmd_fd);
> -       void (*uninit_context)(struct verbs_device *device,
> -                              struct ibv_context *ctx);
> -
>         struct verbs_device *(*alloc_device)(struct verbs_sysfs_dev *sysfs_dev);
>         void (*uninit_device)(struct verbs_device *device);
>  };
> @@ -171,8 +164,6 @@ struct verbs_device_ops {
>  struct verbs_device {
>         struct ibv_device device; /* Must be first */
>         const struct verbs_device_ops *ops;
> -       size_t  sz;
> -       size_t  size_of_context;
>         atomic_int refcount;
>         struct list_node entry;
>         struct verbs_sysfs_dev *sysfs;
> diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
> index c225f09eaa58f7..d689b392d05b5d 100644
> --- a/providers/bnxt_re/main.c
> +++ b/providers/bnxt_re/main.c
> @@ -179,10 +179,6 @@ bnxt_re_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
>         if (!dev)
>                 return NULL;
>
> -       dev->vdev.sz = sizeof(*dev);
> -       dev->vdev.size_of_context =
> -               sizeof(struct bnxt_re_context) - sizeof(struct ibv_context);
> -

Looks good, for bnxt_re provider:
Reviewed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

>         return &dev->vdev;
>  }
>
> diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
> index 3d64b8c8ebae65..f0d63b57792602 100644
> --- a/providers/mlx4/mlx4.c
> +++ b/providers/mlx4/mlx4.c
> @@ -298,10 +298,6 @@ static struct verbs_device *mlx4_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
>         dev->page_size   = sysconf(_SC_PAGESIZE);
>         dev->abi_version = sysfs_dev->abi_ver;
>
> -       dev->verbs_dev.sz = sizeof(*dev);
> -       dev->verbs_dev.size_of_context =
> -               sizeof(struct mlx4_context) - sizeof(struct ibv_context);
> -
>         return &dev->verbs_dev;
>  }
>
> diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
> index 7e8dc9b1951192..41b484fce29683 100644
> --- a/providers/mlx5/mlx5.c
> +++ b/providers/mlx5/mlx5.c
> @@ -1099,10 +1099,6 @@ static struct verbs_device *mlx5_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
>         dev->page_size   = sysconf(_SC_PAGESIZE);
>         dev->driver_abi_ver = sysfs_dev->abi_ver;
>
> -       dev->verbs_dev.sz = sizeof(*dev);
> -       dev->verbs_dev.size_of_context = sizeof(struct mlx5_context) -
> -               sizeof(struct ibv_context);
> -
>         return &dev->verbs_dev;
>  }
>
> --
> 2.15.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
