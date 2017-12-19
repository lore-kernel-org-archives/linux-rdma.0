From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next] iw_cxgb4: Change error/warn prints to pr_debug
Date: Tue, 19 Dec 2017 13:16:39 -0700
Message-ID: <20171219201639.GA14814@ziepe.ca>
References: <1513680256-8153-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513680256-8153-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 04:14:16PM +0530, Potnuri Bharat Teja wrote:
> @@ -64,12 +64,6 @@
>  #define DRV_NAME "iw_cxgb4"
>  #define MOD DRV_NAME ":"
>  
> -#ifdef pr_fmt
> -#undef pr_fmt
> -#endif
> -
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -

Lots of other places in RDMA set a prefix, can we come to some agreement if we
should drop or keep this unverisally?

drivers/infiniband/core/mad.c:#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
drivers/infiniband/core/netlink.c:#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
drivers/infiniband/core/user_mad.c:#define pr_fmt(fmt) "user_mad: " fmt
drivers/infiniband/hw/cxgb3/cxio_hal.h:#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
drivers/infiniband/hw/cxgb4/iw_cxgb4.h:#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
drivers/infiniband/hw/hfi1/driver.c:#define pr_fmt(fmt) DRIVER_NAME ": " fmt
drivers/infiniband/hw/hfi1/file_ops.c:#define pr_fmt(fmt) DRIVER_NAME ": " fmt
drivers/infiniband/hw/hfi1/init.c:#define pr_fmt(fmt) DRIVER_NAME ": " fmt
drivers/infiniband/hw/mlx4/mlx4_ib.h:#define pr_fmt(fmt)        "<" MLX4_IB_DRV_NAME "> %s: " fmt, __func__
drivers/infiniband/hw/qib/qib_diag.c:#define pr_fmt(fmt) QIB_DRV_NAME ": " fmt
drivers/infiniband/hw/qib/qib_file_ops.c:#define pr_fmt(fmt) QIB_DRV_NAME ": " fmt
drivers/infiniband/hw/qib/qib_iba7322.c:#define pr_fmt(fmt) QIB_DRV_NAME " " fmt
drivers/infiniband/hw/qib/qib_init.c:#define pr_fmt(fmt) QIB_DRV_NAME ": " fmt
drivers/infiniband/sw/rxe/rxe.h:#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
drivers/infiniband/ulp/srp/ib_srp.c:#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
drivers/infiniband/ulp/srpt/ib_srpt.c:#define pr_fmt(fmt) DRV_NAME " " fmt
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
