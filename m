From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] Mellanox mlx4 IB driver fixes 29-Jan-2015
Date: Thu, 29 Jan 2015 10:41:40 +0200
Message-ID: <1422520903-22007-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This is small batch of mlx4 IB driver fixes, please apply for for 3.20

Note that there's another mlx4 IB driver fix I sent for 3.19 and you 
didn't pick yet, "IB/mlx4: Fix wrong usage of IPv4 protocol for multicast 
attach/detach" https://patchwork.kernel.org/patch/5507181 -- add it too.

Or.

Jack Morgenstein (1):
  IB/mlx4: In mlx4_ib_demux_cm, print out GUID in host-endian order

Majd Dibbiny (2):
  IB/mlx4: Fix memory leak in __mlx4_ib_modify_qp
  IB/mlx4: Bug fixes in mlx4_ib_resize_cq

 drivers/infiniband/hw/mlx4/cm.c |    2 +-
 drivers/infiniband/hw/mlx4/cq.c |    7 +++----
 drivers/infiniband/hw/mlx4/qp.c |    6 ++++--
 3 files changed, 8 insertions(+), 7 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
