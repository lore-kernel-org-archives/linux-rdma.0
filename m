From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/mlx5: Remove superfluous include of
 io-mapping.h
Date: Tue, 23 Aug 2016 23:35:05 -0400 (EDT)
Message-ID: <1070024890.2212210.1472009705267.JavaMail.zimbra@redhat.com>
References: <20160823201626.13926-1-chris@chris-wilson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823201626.13926-1-chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Chris Wilson" <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Chris Wilson" <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, "Eli Cohen" <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Jack
> Morgenstein" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Or Gerlitz" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Matan Barak" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
> "Hal Rosenstock" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Sent: Tuesday, August 23, 2016 4:16:26 PM
> Subject: [PATCH] infiniband/mlx5: Remove superfluous include of io-mapping.h
> 
> This file does not use any structs or functions defined by io-mapping.h
> (nor does it directly use iomap, ioremap, iounamp or friends). Remove it
> to simplify verification of changes to io-mapping.h
> 
> The include existed since its inception in
> 
> commit e126ba97dba9edeb6fafa3665b5f8497fc9cdf8c
> Author: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date:   Sun Jul 7 17:25:49 2013 +0300
> 
>     mlx5: Add driver for Mellanox Connect-IB adapters
> 
> which looks like a copy across from the Mellanox ethernet driver.
> 
> Signed-off-by: Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/infiniband/hw/mlx5/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c
> b/drivers/infiniband/hw/mlx5/main.c
> index a84bb766fc62..1b4094baa2de 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -37,7 +37,6 @@
>  #include <linux/pci.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> -#include <linux/io-mapping.h>
>  #if defined(CONFIG_X86)
>  #include <asm/pat.h>
>  #endif
> --
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
I compiled and tested this with no issues on my mlx5 test bed.

Reviewed-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
