From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/4] User-space time-stamping support for mlx5_ib
Date: Mon,  9 Nov 2015 18:30:53 +0200
Message-ID: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

This patch-set adds user-space support for time-stamping in mlx5_ib.
It implements the necessary API:
(a) ib_create_cq_ex - Add support for CQ creation flags
(b) ib_query_device - return timestamp_mask and hca_core_clock.

We also add support for mmaping the HCA's free running clock.
In order to do so, we use the response of the vendor's extended
part in ib_query_device. This allows us to pass the page offset
of the free running clock register to the user-space driver.
In order to implement it in a future extensible manner, we  use the
same mechanism of verbs extensions to the mlx5 vendor part as well.

Regards,
Matan



Matan Barak (4):
  IB/mlx5: Add create_cq extended command
  IB/core: Add ib_is_udata_cleared
  IB/mlx5: Add support querying timestamp related fields in query_device
  IB/mlx5: Mmap the HCA's core clock register to user-space

 drivers/infiniband/hw/mlx5/cq.c      |  7 ++++
 drivers/infiniband/hw/mlx5/main.c    | 69 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 22 +++++++++++-
 include/linux/mlx5/device.h          | 10 +++---
 include/linux/mlx5/mlx5_ifc.h        |  9 +++--
 include/rdma/ib_verbs.h              | 20 +++++++++++
 6 files changed, 125 insertions(+), 12 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
