From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] DONT_TRAP support for mlx5 flow steering
Date: Mon,  7 Mar 2016 18:51:44 +0200
Message-ID: <1457369507-30999-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

This series adds support for mlx5 driver DONE_TRAP flow steering
rules. DONT_TRAP rules are rules which allow their attached QPs
to receive the traffic, but also continue matching rules which
are in lower or equal priorities.

The series includes three patches:
The first patch creates a flow table which is used as an end anchor of
the RX NIC name space. This simplifies the implementation of downstream
patches in this series.

The second patch introduces MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO
flow steering action. This action forwards the packet to the first
flow table of the next priority in order to continue matching
in lower or equal priorities.

The third implements the DONT_TRAP feature in mlx5_ib driver. This
is implemented by using another flow table in each user priority.
All rules in this new flow table forward the packet to TIRs and to
the next flow table.

This series depends on
'commit a3100a787941 ("IB/core: Add don't trap flag to flow creation")'
which was accepted to your mlx4 branch.

Thanks,
Maor and Matan

Maor Gottlieb (3):
  net/mlx5_core: Create anchor of last flow table
  net/mlx5_core: Introduce forward to next priority action
  IB/mlx5: Add support for don't trap rules

 drivers/infiniband/hw/mlx5/main.c                 |  54 +++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 225 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  15 ++
 include/linux/mlx5/device.h                       |   7 +-
 include/linux/mlx5/fs.h                           |   5 +
 include/linux/mlx5/mlx5_ifc.h                     |   3 +-
 7 files changed, 289 insertions(+), 22 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
