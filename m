From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] IB/core: Add vendor's specific data to alloc
 mw
Date: Tue, 1 Mar 2016 11:04:38 +0200
Message-ID: <56D55B26.3050102@mellanox.com>
References: <1456761930-11222-1-git-send-email-matanb@mellanox.com>
 <1456761930-11222-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456761930-11222-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/29/2016 6:05 PM, Matan Barak wrote:
> Passing udata to the vendor's driver in order to pass data from the
> user-space driver to the kernel-space driver. This data will be
> used in downstream patches.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/uverbs_cmd.c        | 8 +++++++-
>   drivers/infiniband/hw/cxgb3/iwch_provider.c | 3 ++-
>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h      | 3 ++-
>   drivers/infiniband/hw/cxgb4/mem.c           | 4 +++-
>   drivers/infiniband/hw/mlx4/mlx4_ib.h        | 3 ++-
>   drivers/infiniband/hw/mlx4/mr.c             | 4 +++-
>   drivers/infiniband/hw/nes/nes_verbs.c       | 3 ++-
>   include/rdma/ib_verbs.h                     | 3 ++-
>   8 files changed, 23 insertions(+), 8 deletions(-)
>

Looks good,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
