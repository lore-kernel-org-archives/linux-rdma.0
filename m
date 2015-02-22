From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 18/30] IB/mlx4: Remove gid table management for RoCE
Date: Sun, 22 Feb 2015 13:41:10 +0200
Message-ID: <54E9C056.1070609@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <250dc054-e0c4-40b4-8855-7315489c0f58@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <250dc054-e0c4-40b4-8855-7315489c0f58-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/20/2015 12:02 AM, Somnath Kotur wrote:
> From: Moni Shoua<monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> RoCE GID table management moved to InfiniBand core driver. Core driver is now responsible to populate the GID table and supply query and lookup functions for GIDs. HW drivers are responsible only modify GID table in network adapters. The query_gid hook should now return the answer from the cache when link layer is Ethernet.
>
> Signed-off-by: Moni Shoua<monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur<somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx4/main.c    |  495 +---------------------------------

And we are left with pretty much nothing else... that is, this series 
isn't bisectable, please fix it.


>   drivers/infiniband/hw/mlx4/mlx4_ib.h |    4 -
>   2 files changed, 14 insertions(+), 485 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
