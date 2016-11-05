From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 0/9] mlx4 fixes for 4.9
Date: Sat,  5 Nov 2016 21:57:13 +0200
Message-ID: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below fixes for mlx4 driver.

This patchset was generated against v4.9-rc3.

Available in the "topic/mlx4-fixes-4.9" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx4-fixes-4.9

Thanks

Daniel Jurgens (1):
  IB/mlx4: Check gid_index return value

Eran Ben Elisha (2):
  IB/mlx4: Add precondition for flow_steering_ib_uc_qp_range command
  IB/mlx4: Check if GRH is available before using it in modify_qp

Jack Morgenstein (1):
  IB/mlx4: Handle well-known-gid in mad_demux processing

Maor Gottlieb (2):
  IB/mlx4: Set traffic class in ah
  IB/mlx4: Put non zero value in max_ah device attribute

Matan Barak (1):
  IB/mlx4: Fix mlx4_ib_create_cq error flow

Moni Shoua (1):
  IB/{core, mlx4}: Handle IPv4 header when demultiplexing MAD

Saeed Mahameed (1):
  IB/mlx4: Fix port query for 56Gb Ethernet links

 drivers/infiniband/core/verbs.c   | 16 +++++++------
 drivers/infiniband/hw/mlx4/ah.c   | 11 ++++++---
 drivers/infiniband/hw/mlx4/cq.c   |  5 +++-
 drivers/infiniband/hw/mlx4/mad.c  | 49 +++++++++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c | 30 +++++++++++++++---------
 drivers/infiniband/hw/mlx4/qp.c   |  4 ++--
 include/rdma/ib_verbs.h           | 20 ++++++++++++++++
 7 files changed, 104 insertions(+), 31 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
