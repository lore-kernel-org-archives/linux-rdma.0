From: Jonathan Perkins <perkinjo-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: ibv_open_xrc_domain error
Date: Wed, 6 Mar 2013 14:29:50 -0500
Message-ID: <20130306192950.GA12863@cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear list:
Recently we have experienced failures using the ibv_open_xrc_domain
which gives an invalid parameter error code.  This failure started to
appear randomly after upgrading the kernel to 2.6.32-279.19.1.el6.x86_64
and seems to require us to reboot the node.  Whenever this happens we
notice that /var/log messages contain many of the following messages...

Feb 26 20:56:07 magny4 kernel: mlx4_core 0000:02:00.0: mlx4_eq_int:
MLX4_EVENT_TYPE_SRQ_LIMIT

Does anyone have any idea of what may be going wrong or how to debug
this issue?

Also, we've noticed that there is no user-space XRC support in OFED-3.5.
Will this support be added back in a future release?

Below is some information about our setup.

OFED-1.5.4.1
RHEL6 (2.6.32-279.19.1.el6.x86_64)

We're using many different platforms but here are two of them which show
the error.

Platform A:
CPU: AMD Magny Cour
HCA: Mellanox ConnectX VPI MT26428

Platform B:
CPU: Intel Kentsfield
HCA: Mellanox ConnectX VPI MT25418

-- 
Jonathan Perkins
http://www.cse.ohio-state.edu/~perkinjo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
