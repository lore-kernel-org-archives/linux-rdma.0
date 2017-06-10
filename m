From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rdma] IB/hns: Support compile test for hns RoCE driver
Date: Sat, 10 Jun 2017 16:42:46 +0800
Message-ID: <b000119f-b734-7b5f-43f4-a3c69ff957c7@huawei.com>
References: <1496931830-116773-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496931830-116773-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/6/8 22:23, Matan Barak Ð´µÀ:
> Compiling the hns RoCE driver requires ARM architecture.
> In order to simplify development of IB/core, support
> compile test. Add the necessary includes for that too.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Hi Lijun and Wei,
>
> This simple patch allow the hns RoCE driver to be compiled in other
> architectures other than ARM. This simplifies testing IB/core and
> avoids unnecessary breaks of your driver.
> Since I don't have a hns hardware, I can't test this, so please do.
>
> Regards,
> Matan
ok£¬ that is good

Thanks
Lijun Ou
>  drivers/infiniband/hw/hns/Kconfig          | 2 +-
>  drivers/infiniband/hw/hns/hns_roce_alloc.c | 1 +
>  drivers/infiniband/hw/hns/hns_roce_mr.c    | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
> index e1a6e05..cbe6b51 100644
> --- a/drivers/infiniband/hw/hns/Kconfig
> +++ b/drivers/infiniband/hw/hns/Kconfig
> @@ -1,7 +1,7 @@
>  config INFINIBAND_HNS
>  	tristate "HNS RoCE Driver"
>  	depends on NET_VENDOR_HISILICON
> -	depends on ARM64 && HNS && HNS_DSAF && HNS_ENET
> +	depends on (ARM64 || COMPILE_TEST) && HNS && HNS_DSAF && HNS_ENET
>  	---help---
>  	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine. The engine
>  	  is used in Hisilicon Hi1610 and more further ICT SoC.
> diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
> index 605962f..e1b433c 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
> @@ -32,6 +32,7 @@
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/vmalloc.h>
>  #include "hns_roce_device.h"
>  
>  int hns_roce_bitmap_alloc(struct hns_roce_bitmap *bitmap, unsigned long *obj)
> diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
> index 80fc01f..e387360 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_mr.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
> @@ -32,6 +32,7 @@
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/vmalloc.h>
>  #include <rdma/ib_umem.h>
>  #include "hns_roce_device.h"
>  #include "hns_roce_cmd.h"



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
