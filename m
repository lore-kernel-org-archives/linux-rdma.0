From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 0/3] Arbitrary SG list registration support
Date: Thu, 24 Sep 2015 20:41:18 +0300
Message-ID: <1443116481-14533-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds arbitrary SG list memory registration support
which is pending on the device capability.

Now that the core is able to handle sg lists, the addition of
this support is pretty straight-forward and with minimal changes
to the core and ULP conversion.

Just add another MR creation type which is capable of handling
SG lists with gaps (pending on the device capability).

The code is available at:
https://github.com/sagigrimberg/linux/tree/arb_sg.1

Sagi Grimberg (3):
  IB/core: Add arbitrary sg_list support
  mlx5: Add arbitrary sg list support
  iser: Accept arbitrary sg lists mapping if the device supports it

 drivers/infiniband/core/verbs.c          |  2 ++
 drivers/infiniband/hw/mlx5/main.c        |  4 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
 drivers/infiniband/hw/mlx5/mr.c          | 50 ++++++++++++++++++++++++++++----
 drivers/infiniband/hw/mlx5/qp.c          | 15 ++++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.c | 11 ++++++-
 drivers/infiniband/ulp/iser/iser_verbs.c | 22 +++++++++-----
 include/rdma/ib_verbs.h                  | 10 +++++++
 8 files changed, 98 insertions(+), 17 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
