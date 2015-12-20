From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH V1 0/3] Add cross-channel support
Date: Sun, 20 Dec 2015 12:16:08 +0200
Message-ID: <1450606571-15877-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patchset adds cross-channel support.

The cross-channel feature allows to execute WQEs that involve
synchronization of I/O operations=E2=80=99 on different QPs.

This capability enables to program complex flows with a single
function call, hereby significantly reducing overhead associated
with I/O processing.

Changes from v0:
  * Set UAR to be the same for QP and CQ.

Leon Romanovsky (3):
  IB/core: Align coding style of ib_device_cap_flags structure
  IB/core: Add cross-channel support
  IB/mlx5: Add driver cross-channel support

 drivers/infiniband/core/uverbs_cmd.c |  5 ++-
 drivers/infiniband/hw/mlx5/cq.c      |  7 +++-
 drivers/infiniband/hw/mlx5/main.c    |  3 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 16 ++++++++
 drivers/infiniband/hw/mlx5/qp.c      | 54 ++++++++++++++++++++++-----
 include/linux/mlx5/qp.h              |  3 ++
 include/rdma/ib_verbs.h              | 71 +++++++++++++++++++++-------=
--------
 7 files changed, 117 insertions(+), 42 deletions(-)

--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
