From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/4] More Mellanox mlx5 driver updates for 3.13
Date: Thu, 24 Oct 2013 12:00:59 +0300
Message-ID: <1382605263-6822-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are some additional fixes to the mlx5 driver for the 3.13 merge window.
The patches should be applied on top of the previous patches that I sent
earlier and can be found here:
http://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg17420.html

Eli

Eli Cohen (4):
  IB/mlx5: Remove dead code in mr.c
  IB/mlx5: Remove "Always false" comparison
  IB/mlx5: Update opt param mask for RTS2RTS
  mlx5: Use enum to indicate adapter page size

 drivers/infiniband/hw/mlx5/cq.c              |  2 +-
 drivers/infiniband/hw/mlx5/mr.c              | 10 +++-------
 drivers/infiniband/hw/mlx5/qp.c              | 13 ++++++++-----
 drivers/infiniband/hw/mlx5/srq.c             |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  2 +-
 include/linux/mlx5/device.h                  |  4 ++++
 6 files changed, 19 insertions(+), 16 deletions(-)

-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
