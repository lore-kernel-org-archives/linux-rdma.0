From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/mlx5: Add memory windows allocation
 support
Date: Tue, 1 Mar 2016 11:11:39 +0200
Message-ID: <56D55CCB.1090804@mellanox.com>
References: <1456761930-11222-1-git-send-email-matanb@mellanox.com>
 <1456761930-11222-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456761930-11222-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/29/2016 6:05 PM, Matan Barak wrote:
> This patch adds user-space support for memory windows allocation and
> deallocation. It also exposes the supported types via
> query_device_caps verb.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx5/main.c    | 13 ++++++
>   drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 ++++++
>   drivers/infiniband/hw/mlx5/mr.c      | 83 ++++++++++++++++++++++++++++++++++++
>   drivers/infiniband/hw/mlx5/user.h    |  7 +++
>   include/linux/mlx5/mlx5_ifc.h        |  4 +-
>   5 files changed, 120 insertions(+), 1 deletion(-)
>

Looks good., I've tested the alloc func with num_klms = 16 for the 
erasure coding.

Tested-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
