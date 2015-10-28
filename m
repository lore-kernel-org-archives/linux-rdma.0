From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2] Loopback prevention support
Date: Wed, 28 Oct 2015 02:58:33 +0200
Message-ID: <1445993915-111262-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This two patch series adds support for loopback prevention in mlx5_ib for
userspace consumers.

Eli

*** Resending since may have had some problem with my subscription so the
*** patchest did not make it to the rdma list

Eli Cohen (2):
  IB/mlx5: Add debug print to signify if block multicast is used
  IB/mlx5: Publish mlx5 driver support for extended create QP

 drivers/infiniband/hw/mlx5/main.c |    3 ++-
 drivers/infiniband/hw/mlx5/qp.c   |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
