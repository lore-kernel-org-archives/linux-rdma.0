From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 00/10] Add RoCE support to the mlx5 driver
Date: Thu, 20 Aug 2015 19:46:19 +0300
Message-ID: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
driver.

This patchset was applied and tested over patchset "Add RoCE v2
support" which was sent to the mailing list by Matan Barak.

Achiad Shochat (10):
  IB/mlx5: Support IB device's callback for getting the link layer
  IB/mlx5: Support IB device's callback for getting its netdev
  net/mlx5_core: Break down the vport mac address query function
  net/mlx5_core: Introduce access functions to enable/disable RoCE
  net/mlx5_core: Introduce access functions to query vport RoCE fields
  IB/mlx5: Extend query_device/port to support RoCE
  IB/mlx5: Set network_hdr_type upon RoCE responder completion
  IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
  IB/mlx5: Add RoCE fields to Address Vector
  IB/mlx5: Support RoCE

 drivers/infiniband/hw/mlx5/ah.c                 |  32 ++-
 drivers/infiniband/hw/mlx5/cq.c                 |  17 ++
 drivers/infiniband/hw/mlx5/main.c               | 318 ++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h            |  15 +-
 drivers/infiniband/hw/mlx5/qp.c                 |  42 +++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 139 ++++++++++-
 include/linux/mlx5/device.h                     |  26 ++
 include/linux/mlx5/driver.h                     |   7 -
 include/linux/mlx5/mlx5_ifc.h                   |  10 +-
 include/linux/mlx5/qp.h                         |  21 +-
 include/linux/mlx5/vport.h                      |   8 +
 11 files changed, 578 insertions(+), 57 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
