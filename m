From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.17 0/7] RoCE IP addressing fixes
Date: Tue, 2 Sep 2014 16:04:20 +0300
Message-ID: <5405C054.8040800@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/21/2014 2:28 PM, Or Gerlitz wrote:
> Hi Roland,
>
> This series contains RoCE related fixes to the mlx4 IB driver
> (and one uverbs patch), which deal with the IP addressing logic.
>
> Once applied into 3.17, we will further push them to -stable.

Roland,

This series addresses real bugs whose fixes should go upstream and from 
there into inbox drivers, can you please act to send post-rc1 update 
which contains these patches and whatever else is in the queue for 3.17-rc?

Note that for patch 7/7 there's V1, I sent it to you today.

Or.

>
> Or.
>
> Jack Morgenstein (1):
>    IB/mlx4: Fix lockdep splat for the iboe lock
>
> Matan Barak (1):
>    IB/core: When marsheling uverbs path, clear unused fields
>
> Moni Shoua (5):
>    IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
>    IB/mlx4: Don't duplicate the default RoCE GID
>    IB/mlx4: Reorder steps in RoCE GID table initialization
>    IB/mlx4: Get upper dev addresses as RoCE GIDs when port comes up
>    IB/mlx4: Avoid executing gid task when device is being removed
>
>   drivers/infiniband/core/uverbs_marshall.c |    4 +
>   drivers/infiniband/hw/mlx4/main.c         |  124 ++++++++++++++++++-----------
>   2 files changed, 81 insertions(+), 47 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
