From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH linux-next v2] infiniband/ipoib: fix possible NULL pointer dereference in ipoib_get_iflink
Date: Wed, 15 Apr 2015 00:26:50 +0800
Message-ID: <1429028811-29888-1-git-send-email-honli@redhat.com>
References: <1429024817-21561-1-git-send-email-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024817-21561-1-git-send-email-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1) Droped ipvlan/macvlan/dsa patches.
2) Do not check the pointer returned by netdev_priv.
3) Add the FIX tag.

--------------------- console log ---------------
ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
[  OK  ]
ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
Shutting down interface cxgb4_1:  ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff88026eb1c000, priv = ffff88026eb1c7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
ipoib_get_iflink  dev = ffff880225c8a000, priv = ffff880225c8a7c0, priv->parent =           (null)
--------------------- console log ---------------

Honggang Li (1):
  infiniband/ipoib: fix possible NULL pointer dereference in
    ipoib_get_iflink

 drivers/infiniband/ulp/ipoib/ipoib_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
