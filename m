From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 07/45] drivers: infiniband: remove duplicate includes
Date: Fri, 22 Dec 2017 09:45:22 -0700
Message-ID: <20171222164522.GA20267@ziepe.ca>
References: <1512578979-5115-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512578979-5115-1-git-send-email-pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 06, 2017 at 10:19:39PM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/core/mad.c                | 1 -
>  drivers/infiniband/core/netlink.c            | 2 --
>  drivers/infiniband/hw/mlx5/main.c            | 4 +---
>  drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 1 -
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 1 -
>  5 files changed, 1 insertion(+), 8 deletions(-)

I applied this to for-next, thanks

> index 543d0a4..fe435ed 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -50,16 +50,14 @@
>  #include <rdma/ib_cache.h>
>  #include <linux/mlx5/port.h>
>  #include <linux/mlx5/vport.h>
> +#include <linux/mlx5/fs.h>
>  #include <linux/list.h>
>  #include <rdma/ib_smi.h>
>  #include <rdma/ib_umem.h>
>  #include <linux/in.h>
>  #include <linux/etherdevice.h>
> -#include <linux/mlx5/fs.h>
> -#include <linux/mlx5/vport.h>
>  #include "mlx5_ib.h"
>  #include "cmd.h"
> -#include <linux/mlx5/vport.h>

Yep, ugh.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
