From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 00/15]RDMA/bnxt_re: Bug fixes
Date: Wed, 17 May 2017 02:19:36 -0700
Message-ID: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch series includes some bug fixes for bnxt_re driver.
This series includes implementation of some of the workarounds
required for the HW and FW. The driver version is also updated
in this series.
I have added a new patch in this series to enable/disable FMR
support using a config option, as we found some issues with
curent implementation. We are currently debugging it.

Changes v1 -> v2:
	- Changes suggested by Leon in one of the patches
        - Updates commit message with more description
	- Disables FMR support using a config option

Doug,
 Please apply these changes to your repository.

Thanks,
Selvin Xavier

Devesh Sharma (3):
  RDMA/bnxt_re: Fixing the Control path command and response handling
  RDMA/bnxt_re: Free doorbell page index (DPI) during dealloc ucontext
  RDMA/bnxt_re: Fix RQE posting logic

Eddie Wai (2):
  RDMA/bnxt_re: HW workarounds for handling specific conditions
  RDMA/bnxt_re: Fixed the max_rd_atomic support for initiator and
    destination QP

Kalesh AP (1):
  RDMA/bnxt_re: Add vlan tag for untagged RoCE traffic when PFC is
    configured

Selvin Xavier (5):
  RDMA/bnxt_re: Dereg MR in FW before freeing the fast_reg_page_list
  RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
  RDMA/bnxt_re: Report supported value to IB stack in query_device
  RDMA/bnxt_re: Update the driver version
  RDMA/bnxt_re: Disable FMR by default

Somnath Kotur (4):
  RDMA/bnxt_re: Fix race between netdev register and unregister events
  RDMA/bnxt_re: Add HW workaround for avoiding stall for UD QPs
  RDMA/bnxt_re: Fix WQE Size posted to HW to prevent it from throwing
    error
  RDMA/bnxt_re: Specify RDMA component when allocating stats context

 drivers/infiniband/hw/bnxt_re/Kconfig      |   8 +
 drivers/infiniband/hw/bnxt_re/bnxt_re.h    |  21 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 552 +++++++++++++++++++++++------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h   |  20 +-
 drivers/infiniband/hw/bnxt_re/main.c       |  95 ++++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 393 ++++++++++----------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  18 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 314 ++++++++--------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  61 ++--
 drivers/infiniband/hw/bnxt_re/qplib_res.c  |  10 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h  |   6 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   | 404 ++++++++-------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h   |   4 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h   |   4 +-
 14 files changed, 1148 insertions(+), 762 deletions(-)

-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
