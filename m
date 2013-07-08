From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 0/2] Fixes to issues in mlx5 code found by static checker
Date: Mon,  8 Jul 2013 15:58:55 +0300
Message-ID: <1373288337-15420-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

All Reported-by Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

changes from V0:
 - replaced space with tabs in few places

Or Gerlitz (2):
  mlx5: Use simple_open when possible
  IB/mlx5: Removes unneeded semicolons

 drivers/infiniband/hw/mlx5/mr.c                   |   15 ++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c     |   13 +++----------
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c |   15 ++-------------
 3 files changed, 9 insertions(+), 34 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
