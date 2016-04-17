From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/5] Add scatter FCS support
Date: Sun, 17 Apr 2016 17:19:33 +0300
Message-ID: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Frame Check Sequence (FCS) is an error detecting code that terminates
an Ethernet frame. When using Raw Ethernet, users sometimes want
to validate the FCS themselves, and therefore it should be scattered
to the receive buffers.

This series adds the above support.

The user can control scattering the FCS using Queue-Pair(QP) creation
flag called IB_QP_CREATE_SCATTER_FCS.

Also, to report this new device capability, we had to add a new
device capability flags in the uverbs response called
device_cap_flags_ex, since all the current device_cap_flags are
occupied.

device_cap_flags_ex 0-31 bits are identical to the legacy
device_cap_flags, and the upper 32 bits (32-63 bits) report new
extended device capabilities.

Devices that support scattering the FCS should report it in
device_cap_flags_ex using IB_DEVICE_RAW_SCATTER_FCS.

This patch depends on the mlx5 core shared code that was sent to both
IB and net trees and was already accepted by Dave Miller:
net/mlx5: Update mlx5_ifc hardware features
net/mlx5: Fix mlx5 ifc cmd_hca_cap bad offsets

Moreover, this patch conflicts with the LSO series (that will be
sent soon). The resolution of this conflict is available in
Mellanox's tree.

Thanks,
Majd and Matan

Majd Dibbiny (5):
  IB/core: Add extended device capability flags
  IB/core: Add Raw Scatter FCS device capability
  IB/core: Add Scatter FCS create flag
  IB/mlx5: Add Scatter FCS support for Raw Packet QP
  IB/mlx5: Report Scatter FCS device capability when supported

 drivers/infiniband/core/uverbs_cmd.c |  8 +++++++-
 drivers/infiniband/hw/mlx5/main.c    |  4 ++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 20 +++++++++++++++++++-
 include/rdma/ib_verbs.h              |  2 ++
 include/uapi/rdma/ib_user_verbs.h    |  1 +
 6 files changed, 34 insertions(+), 2 deletions(-)

-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
