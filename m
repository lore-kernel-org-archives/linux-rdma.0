From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Adding memory re-registration for mlx5
Date: Mon, 29 Feb 2016 16:46:49 +0200
Message-ID: <1456757211-8112-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

This series adds memory re-registration support for the mlx5 driver.
Re-registration of memory region uses UMR if the current MKey is large
enough to encompass the requested length. When this is not possible,
a new MKey is created using the firmware command interface. In this
case, new LKey and RKey are created and must be communicated to
remote peers by the user.

The MR's umem is kept only through a PD-only change. Otherwise, it is
replaced as well.

The series contains 2 patches:
The first patch refactors the register and deregister MR flow so that
some code parts could be shared later on with the re-registration
flow.
The second patch introduces the actual re-registration flow.

Thanks,
Noa and Matan

Noa Osherovich (2):
  IB/mlx5: Refactoring register MR code
  IB/mlx5: Added support for re-registration of MRs

 drivers/infiniband/hw/mlx5/main.c    |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   9 +
 drivers/infiniband/hw/mlx5/mr.c      | 375 ++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/qp.c      |  51 ++++-
 4 files changed, 359 insertions(+), 78 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
