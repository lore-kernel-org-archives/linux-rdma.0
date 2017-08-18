From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma-next v1 13/22] RDMA/hns: Remove empty functions
Date: Fri, 18 Aug 2017 15:16:12 +0530
Message-ID: <CA+sbYW2ZJj2SdchU8M4dZz-KOGSxw2EPX-9oGJhMf3LSzMtA2A@mail.gmail.com>
References: <20170813101816.3120-1-leon@kernel.org> <20170813101816.3120-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101816.3120-14-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 Removing the "modify_port" hook is causing some issues with ib_cm module.
While adding a mad agent for the new device, ib_cm invokes
ib_modify_port  which fails
with return value -ENOSYS. So the mad agent gets unregistered. This
break the connection
establishment. It is broken for bnxt_re also.

The following patch helps. But it is like a workaround to solve the problem.

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d5ca101..59911dd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4189,7 +4189,7 @@ static void cm_add_one(struct ib_device *ib_device)
                        goto error2;

                ret = ib_modify_port(ib_device, i, 0, &port_modify);
-               if (ret)
+               if (ret && ret != -ENOSYS)
                        goto error3;

                count++;

Or should we have the modify_port hook with some basic checks?

Thanks,
Selvin

On Sun, Aug 13, 2017 at 3:48 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The functions which are not implemented can be simply ignored
> instead of defining empty function. This patch removes such functions
> from hns driver.
>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_main.c | 14 --------------
>  1 file changed, 14 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
> index d9777b662eba..250e2059ef07 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_main.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_main.c
> @@ -285,12 +285,6 @@ static enum rdma_link_layer hns_roce_get_link_layer(struct ib_device *device,
>         return IB_LINK_LAYER_ETHERNET;
>  }
>
> -static int hns_roce_query_gid(struct ib_device *ib_dev, u8 port_num, int index,
> -                             union ib_gid *gid)
> -{
> -       return 0;
> -}
> -
>  static int hns_roce_query_pkey(struct ib_device *ib_dev, u8 port, u16 index,
>                                u16 *pkey)
>  {
> @@ -316,12 +310,6 @@ static int hns_roce_modify_device(struct ib_device *ib_dev, int mask,
>         return 0;
>  }
>
> -static int hns_roce_modify_port(struct ib_device *ib_dev, u8 port_num, int mask,
> -                               struct ib_port_modify *props)
> -{
> -       return 0;
> -}
> -
>  static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
>                                                    struct ib_udata *udata)
>  {
> @@ -462,10 +450,8 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
>         ib_dev->modify_device           = hns_roce_modify_device;
>         ib_dev->query_device            = hns_roce_query_device;
>         ib_dev->query_port              = hns_roce_query_port;
> -       ib_dev->modify_port             = hns_roce_modify_port;
>         ib_dev->get_link_layer          = hns_roce_get_link_layer;
>         ib_dev->get_netdev              = hns_roce_get_netdev;
> -       ib_dev->query_gid               = hns_roce_query_gid;
>         ib_dev->add_gid                 = hns_roce_add_gid;
>         ib_dev->del_gid                 = hns_roce_del_gid;
>         ib_dev->query_pkey              = hns_roce_query_pkey;
> --
> 2.14.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
