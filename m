From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] IB: Move PCI dependency from root KConfig to HW's KConfigs
Date: Mon, 4 Sep 2017 17:48:29 +0200
Message-ID: <CAD+HZHVH7dUeQ0ibCWNZHgdO-1zh1KGT4C+9h09TiOHx=1Fddw@mail.gmail.com>
References: <20170904152848.3471-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170904152848.3471-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2017-09-04 17:28 GMT+02:00 Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
> No reason to have dependency on PCI for the entire infiniband stack so
> move it to KConfig of only the drivers that actually using PCI.
>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
>         * As suggested by Thomas Bogendoerfer:
>                 * Remove unneeded header inclusion from ipoib
>                 * Remove PCI dependency from ipoib's Kconfig
> ---
>  drivers/infiniband/Kconfig                | 1 -
>  drivers/infiniband/hw/cxgb3/Kconfig       | 1 +
>  drivers/infiniband/hw/cxgb4/Kconfig       | 1 +
>  drivers/infiniband/hw/hfi1/Kconfig        | 1 +
>  drivers/infiniband/hw/i40iw/Kconfig       | 1 +
>  drivers/infiniband/hw/qedr/Kconfig        | 1 +
>  drivers/infiniband/hw/qib/Kconfig         | 1 +
>  drivers/infiniband/sw/rdmavt/Kconfig      | 1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 -
>  9 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 234fe01904e7..568088a9298c 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -1,6 +1,5 @@
>  menuconfig INFINIBAND
>         tristate "InfiniBand support"
> -       depends on PCI || BROKEN
>         depends on HAS_IOMEM
>         depends on NET
>         depends on INET
> diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
> index 2b6352b85485..bd32926afa77 100644
> --- a/drivers/infiniband/hw/cxgb3/Kconfig
> +++ b/drivers/infiniband/hw/cxgb3/Kconfig
> @@ -1,5 +1,6 @@
>  config INFINIBAND_CXGB3
>         tristate "Chelsio RDMA Driver"
> +       depends on PCI || BROKEN
>         depends on CHELSIO_T3 && INET
>         select GENERIC_ALLOCATOR
>         ---help---
> diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
> index afe8b28e0878..7910fdd88619 100644
> --- a/drivers/infiniband/hw/cxgb4/Kconfig
> +++ b/drivers/infiniband/hw/cxgb4/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_CXGB4
>         tristate "Chelsio T4/T5 RDMA Driver"
>         depends on CHELSIO_T4 && INET && (IPV6 || IPV6=n)
> +       depends on PCI || BROKEN
>         select CHELSIO_LIB
>         select GENERIC_ALLOCATOR
>         ---help---
> diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
> index f6ea0881765a..5072d083f53b 100644
> --- a/drivers/infiniband/hw/hfi1/Kconfig
> +++ b/drivers/infiniband/hw/hfi1/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_HFI1
>         tristate "Intel OPA Gen1 support"
>         depends on X86_64 && INFINIBAND_RDMAVT && I2C
> +       depends on PCI || BROKEN
>         select MMU_NOTIFIER
>         select CRC32
>         select I2C_ALGOBIT
> diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
> index 6e7d27a14061..9cfef1370445 100644
> --- a/drivers/infiniband/hw/i40iw/Kconfig
> +++ b/drivers/infiniband/hw/i40iw/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_I40IW
>         tristate "Intel(R) Ethernet X722 iWARP Driver"
>         depends on INET && I40E
> +       depends on PCI || BROKEN
>         select GENERIC_ALLOCATOR
>         ---help---
>         Intel(R) Ethernet X722 iWARP Driver
> diff --git a/drivers/infiniband/hw/qedr/Kconfig b/drivers/infiniband/hw/qedr/Kconfig
> index 6c9f3923e838..8db2966f52c2 100644
> --- a/drivers/infiniband/hw/qedr/Kconfig
> +++ b/drivers/infiniband/hw/qedr/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_QEDR
>         tristate "QLogic RoCE driver"
>         depends on 64BIT && QEDE
> +       depends on PCI || BROKEN
>         select QED_LL2
>         select QED_RDMA
>         ---help---
> diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
> index e0fdb9201423..522a6fcaa9d8 100644
> --- a/drivers/infiniband/hw/qib/Kconfig
> +++ b/drivers/infiniband/hw/qib/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_QIB
>         tristate "Intel PCIe HCA support"
>         depends on 64BIT && INFINIBAND_RDMAVT
> +       depends on PCI || BROKEN
>         ---help---
>         This is a low-level driver for Intel PCIe QLE InfiniBand host
>         channel adapters.  This driver does not support the Intel
> diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
> index fdd001ce13d8..605bfb1da9df 100644
> --- a/drivers/infiniband/sw/rdmavt/Kconfig
> +++ b/drivers/infiniband/sw/rdmavt/Kconfig
> @@ -1,6 +1,7 @@
>  config INFINIBAND_RDMAVT
>         tristate "RDMA verbs transport library"
>         depends on 64BIT
> +       depends on PCI || BROKEN
>         select DMA_VIRT_OPS
>         ---help---
>         This is a common software verbs provider for RDMA networks.

does the RDMAVT really depends on PCI, to me looks not, we can also
remove  the included in drivers/infiniband/sw/rdmavt/vt.h?

Other than this, I think the change make sense to me!

Cheers,
Jack

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 6c77df34869d..3fc3b7b20297 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -51,7 +51,6 @@
>  #include <net/addrconf.h>
>  #include <linux/inetdevice.h>
>  #include <rdma/ib_cache.h>
> -#include <linux/pci.h>
>
>  #define DRV_VERSION "1.0.0"
>
> --
> 2.13.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
