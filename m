From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/7] Second round of mlx4/mlx5 fixes for 4.8
Date: Mon, 12 Sep 2016 19:16:17 +0300
Message-ID: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are seven patches which fix different bugs mostly crashes and one
patch with code cleanup. This code cleanup was needed to create fix
without checkpatch warnings.

Available in the "topic/fixes-for-4.8-2" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fixes-for-4.8-2

Alex Vesker (1):
  IB/mlx4: Fix incorrect MC join state bit-masking on SR-IOV

Jack Morgenstein (3):
  IB/mlx4: Fix code indentation in QP1 MAD flow
  IB/mlx4: Use correct subnet-prefix in QP1 mads under SRIOV
  IB/mlx4: Fix possible vl/sl field mismatch in LRH header in QP1
    packets

Kamal Heib (1):
  IB/mlx4: Diagnostic HW counters are not supported in slave mode

Maor Gottlieb (1):
  IB/mlx5: Set source mac address in FTE

Noa Osherovich (1):
  IB/mlx5: Enable MAD_IFC commands for IB ports only

 drivers/infiniband/hw/mlx4/mad.c        |  87 +++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/main.c       | 113 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mcg.c        |  14 ++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   9 ++-
 drivers/infiniband/hw/mlx4/qp.c         |  60 ++++++++++++-----
 drivers/infiniband/hw/mlx5/main.c       |  11 +++-
 drivers/net/ethernet/mellanox/mlx4/fw.c |  13 ++--
 include/linux/mlx4/device.h             |  13 +++-
 8 files changed, 284 insertions(+), 36 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
