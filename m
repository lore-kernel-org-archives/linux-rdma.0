From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] Arbitrary SG list registration support
Date: Mon, 29 Feb 2016 19:07:31 +0200
Message-ID: <1456765654-27592-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds arbitrary SG list memory registration support
which is pending on the device capability (Introduced in Mellanox
ConnectX-4).

Now that the core is able to handle sg lists, the addition of
this support is pretty straight-forward and with minimal changes
to the core and ULP conversion.

Just add another MR creation type which is capable of handling
SG lists with gaps (pending on the device capability).

Patch 0001 - IB core flagging
Patch 0002 - mlx5 support
Patch 0003 - First consumer, iser initiator (more will follow!)

This has come up just now because I've been waiting for FW cap
exposure that now is included in patchset "Add memory window user-space
support to mlx5" by Matan (so it obviously depends on it).

Code is available at:
git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:sagigrimberg/linux.git arb_sg.3

Sagi Grimberg (3):
  IB/core: Add arbitrary sg_list support
  mlx5: Add arbitrary sg list support
  iser: Accept arbitrary sg lists mapping if the device supports it

 drivers/infiniband/core/verbs.c          |  2 ++
 drivers/infiniband/hw/mlx5/main.c        |  2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
 drivers/infiniband/hw/mlx5/mr.c          | 50 ++++++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/qp.c          | 15 ++++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.c | 11 ++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c | 23 ++++++++++-----
 include/rdma/ib_verbs.h                  |  6 ++++
 8 files changed, 93 insertions(+), 17 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
