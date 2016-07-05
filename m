From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 0/2] IB/rxe: Replace in kernel memory registration support
Date: Tue,  5 Jul 2016 19:05:48 +0300
Message-ID: <1467734750-20298-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Registering memory regions in ULPs is implemented with 2 sets of API, FMR
and FastReg. FMR is considered obsolete and FastReg is what modern drivers
should implement.
The patches in this series add FastReg and remove FMR support form the
SoftRoCE driver.

Moni Shoua (1):
  IB/rxe: Remove FMR support

Sagi Grimberg (1):
  IB/rxe: Add fast memory registraion and remote invalidation) support

 drivers/infiniband/hw/rxe/rxe.c        | 18 ++-----
 drivers/infiniband/hw/rxe/rxe_loc.h    |  3 --
 drivers/infiniband/hw/rxe/rxe_mr.c     | 44 ++-------------
 drivers/infiniband/hw/rxe/rxe_opcode.c |  4 +-
 drivers/infiniband/hw/rxe/rxe_opcode.h |  1 +
 drivers/infiniband/hw/rxe/rxe_param.h  | 11 ++--
 drivers/infiniband/hw/rxe/rxe_pool.c   | 10 +---
 drivers/infiniband/hw/rxe/rxe_pool.h   |  1 -
 drivers/infiniband/hw/rxe/rxe_req.c    | 36 +++++++++++++
 drivers/infiniband/hw/rxe/rxe_resp.c   | 16 ++++++
 drivers/infiniband/hw/rxe/rxe_verbs.c  | 98 +++++++++++++---------------------
 drivers/infiniband/hw/rxe/rxe_verbs.h  |  8 +--
 include/uapi/rdma/ib_user_rxe.h        |  5 ++
 13 files changed, 114 insertions(+), 141 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
