From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH fixes/for-3.6 0/3] few more IB fixes for 3.6
Date: Sat, 8 Sep 2012 22:48:22 +0300
Message-ID: <CAJZOPZKWfQ7J4i26mv-19v+T2hu_9vuYw72O_7BJ4wbSnUUAbg@mail.gmail.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346253275-12347-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 29, 2012 at 6:14 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Hi Roland,
>
> This short series include two more fixes from Shlomo to the newly
> introduced IPoIB neighbour table, and a fix for Yishai that completes
> the support for memory registration of up to 8TB.

Roland,

AFAIK 3.6-rc5 should be out by tonight, these are fixes to known bugs
in there which I sent you eleven days ago and didn't get any comment,
could you get them in and/or react in some way?

thanks,

Or.

>
> Shlomo Pongratz (2):
>   IB/ipoib: Fix memory leak in the neigh table deletion flow
>   IB/ipoib: Fix AB-BA deadlock when deleting neighbours
>
> Yishai Hadas (1):
>   net/mlx4_core: Enable 8TB memory registration
>
>  drivers/infiniband/ulp/ipoib/ipoib.h           |    4 +-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |  101 +++++++++++------------
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 -
>  drivers/net/ethernet/mellanox/mlx4/icm.c       |   30 ++++---
>  drivers/net/ethernet/mellanox/mlx4/icm.h       |   10 +-
>  5 files changed, 74 insertions(+), 73 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
