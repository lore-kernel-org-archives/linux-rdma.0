From: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Sat, 10 Sep 2016 14:10:10 +0800
Message-ID: <20160910061010.GD3042@linux-kyyb.suse>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
 <20160908140752.GN18398@leon.nu>
 <20160909025527.GC3042@linux-kyyb.suse>
 <CAJ3xEMhK4e9tD3awWt0uFdg=ptai3c5kCeDUmOBudQ2nu46rRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhK4e9tD3awWt0uFdg=ptai3c5kCeDUmOBudQ2nu46rRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 09, 2016 at 01:39:18PM +0300, Or Gerlitz wrote:
> > Without the patch, we got the following message.
> > [    8.456327] mlx5_core 0000:03:00.0: firmware version: 12.12.780
> > ...
> > [   10.417421] mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2014)
> > [   10.419282] ------------[ cut here ]------------
> > [   10.419291] WARNING: CPU: 2 PID: 2517 at ../drivers/infiniband/core/cache.c:702 ib_cache_gid_set_default_gid+0x2f8/0x340 [ib_core]()
> 
> 
> and this reproduces 100% over Eth ports or just sometimes?

Feedback from the customer.
It was consistently seen with fw:12.12.780
It was never seen after updating the firmware to 12.14.1100 or higher.
Currently in fw ver:12.16.1020.

Thanks,
David Chang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
