From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 0/5] User-space time-stamping support for mlx5_ib
Date: Tue, 15 Dec 2015 20:30:08 +0200
Message-ID: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

This patch-set adds user-space support for time-stamping in mlx5_ib.
It implements the necessary API:
(a) ib_create_cq_ex - Add support for CQ creation flags
(b) ib_query_device - return timestamp_mask and hca_core_clock.

We also add support for mmaping the HCA's free running clock.
In order to do so, we use the response of the vendor's extended
part in init_ucontext. This allows us to pass the page offset
of the free running clock register to the user-space driver.
In order to implement it in a future extensible manner, we  use the
same mechanism of verbs extensions to the mlx5 vendor part as well.

Regards,
Matan

Changes from v1:
 * Change ib_is_udata_cleared to use memchr_inv.

Changes from v0:
 * Limit mmap PAGE_SIZE to 4K (security wise).
 * Optimize ib_is_udata_cleared.
 * Pass hca_core_clock_offset in the vendor's response part of init_ucontext.

Matan Barak (5):
  IB/mlx5: Add create_cq extended command
  IB/core: Add ib_is_udata_cleared
  IB/mlx5: Add support for hca_core_clock and timestamp_mask
  IB/mlx5: Add hca_core_clock_offset to udata in init_ucontext
  IB/mlx5: Mmap the HCA's core clock register to user-space

 drivers/infiniband/hw/mlx5/cq.c      |  7 ++++
 drivers/infiniband/hw/mlx5/main.c    | 67 +++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +++-
 drivers/infiniband/hw/mlx5/user.h    | 12 +++++--
 include/linux/mlx5/device.h          |  7 ++--
 include/linux/mlx5/mlx5_ifc.h        |  9 +++--
 include/rdma/ib_verbs.h              | 27 +++++++++++++++
 7 files changed, 120 insertions(+), 16 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
