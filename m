From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/10] IB/mlx5: Use wr.ud.pkey_index in GSI QP
Date: Mon, 29 Feb 2016 15:45:02 +0200
Message-ID: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The check of BTH P_Key for RDMA_CM requests was introduced in patch
4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA CM").
A side effect of that change was the unexpected behavior of the mlx5 driver
in handling the pkey_index in ib_send_wr.ud in GSI packets.  The pkey_index
in ib_wc was not set correctly [1], and in addition, we found out that the
mlx5 driver did not respect the pkey_index in ib_send_wr.ud for GSI
packets. Since the pkey_index in a Work Request is not explicitly required
by the IBA specifications, the Connect-IB and ConnectX-4 adapter cards do
not support it.

This patch fixes the issue inside the mlx5_ib module. It emulates a single
GSI QP by creating multiple QPs underneath the surface. An ordinary GSI QP
is created for receiving MADs destined at QP 1, and multiple transmission
QPs are created for sending MADs. These QPs behave like UD QPs, although
they use QP 1 as their source QP number. The QPs are created on-demand, one
for each non-zero P_Key in the P_Key table.

The driver handles reordering of the completions to make sure they are
reported in the same order their matching Work Requests were posted.

A spinlock in the emulated GSI QP struct protects concurrent access to the
transmission QPs from post send operations and from their creation
following a P_Key table change. In addition, it protects the Work Request
list that maintains the completion order.

The patchset is divided as follows. The first patch adds the infrastructure
required for creating additional QPs that send as QP 1. The following patch
adds some helpful debugging prints to the QP modification code. Patch 3
adds a skeleton code for an emulated GSI QP. The next two patches create
the multiple transmission QPs. Patches 6-7 handle the reordering of the
completions. Patches 8-9 enable the use of the created QPs and remove the
send queue buffer from the receive GSI QP. Finally patch 10 reverts the
change in "IB/cma: Use inner P_Key to determine netdev".

These patches apply against kernel v4.5-rc6.

[1] mlx5: Fix incorrect wc pkey_index assignment for GSI messages
http://www.spinics.net/lists/linux-rdma/msg28374.html

Haggai Eran (10):
  IB/mlx5: Add support for setting source QP number
  IB/mlx5: Modify QP debugging prints
  IB/mlx5: Add GSI QP wrapper
  IB/mlx5: Create multiple transmission GSI QPs
  IB/mlx5: Create GSI transmission QPs when P_Key table is changed
  IB/mlx5: Generate completions in software
  IB/mlx5: Reorder GSI completions
  IB/mlx5: Pick the right GSI transmission QP for sending
  IB/mlx5: Eliminate GSI RX QP's send buffers
  IB/cma: Print warning on different inner and header P_Keys

 drivers/infiniband/core/cma.c        |   8 +
 drivers/infiniband/hw/mlx5/Makefile  |   2 +-
 drivers/infiniband/hw/mlx5/cq.c      |  83 +++++-
 drivers/infiniband/hw/mlx5/gsi.c     | 548 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c    |  30 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  57 +++-
 drivers/infiniband/hw/mlx5/qp.c      |  95 ++++--
 include/linux/mlx5/mlx5_ifc.h        |   3 +-
 include/linux/mlx5/qp.h              |   3 +-
 9 files changed, 802 insertions(+), 27 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/gsi.c

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
