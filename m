From: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Init subsys if compiled to  vmlinuz-core
Date: Wed, 29 Nov 2017 12:07:38 +0300
Message-ID: <87r2shpi5h.fsf@openvz.org>
References: <20171127133905.8231-1-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171127133905.8231-1-dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
It is appeared that CM and SRP are also initalized incorrectly.
Please Ignore this one, I'll send updated patch.
> Once infiniband was compiled as core component it's subsystem must be
> enabled before device initialization. Otherwise this result NULL pointer
> dereference during mlx4_core init, calltrace:
> ->device_add
>   if (dev->class) {
>      deref  dev->class->p =>NULLPTR
>
> #Config
> CONFIG_NET_DEVLINK=y
> CONFIG_MAY_USE_DEVLINK=y
> CONFIG_MLX4_EN=y
>
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 84fc32a..5e1be49 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1253,5 +1253,5 @@ static void __exit ib_core_cleanup(void)
>  
>  MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_LS, 4);
>  
> -module_init(ib_core_init);
> +subsys_initcall(ib_core_init);
>  module_exit(ib_core_cleanup);
> -- 
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
