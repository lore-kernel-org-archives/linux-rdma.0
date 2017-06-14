From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 for-next 00/14] RDMA/bnxt_re: Bug fixes
Date: Wed, 14 Jun 2017 03:26:21 -0700
Message-ID: <1497435995-20480-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The patch series has some bug fixes for bnxt_re driver.
This series includes implementation of some of the workarounds
required for the HW and FW and removes the FMR verb support from
the driver.

This version fixes the build warnings reported by kbuild test robot
on 32 bit architectures. Also, rebasing the patch series to the latest
branch.

Doug,
 Please review and apply these changes to your repository. As discussed
earlier, please consider applying a subset of these patches to 4.12-rc
also.

Thanks,
Selvin Xavier

v4 -> v5 :
	- Fixes the build warnings reported on 32 bit architectures
	- Rebase one of the patches to for-4.13 branch

v3 -> v4:
	- Dropped the version change patch from this series

v2 -> v3:
	- Updates the commit log for the module version change patch
	- Removes temp variables from one of the patches
	- Fixes memory leak in one of the patches.
	- Removes the FMR verbs support

v1 -> v2:
	- Changes suggested by Leon in one of the patches
        - Updates commit message with more description
	- Disables FMR support using a config option

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

Selvin Xavier (4):
  RDMA/bnxt_re: Dereg MR in FW before freeing the fast_reg_page_list
  RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
  RDMA/bnxt_re: Report supported value to IB stack in query_device
  RDMA/bnxt_re: Remove FMR support

Somnath Kotur (4):
  RDMA/bnxt_re: Fix race between netdev register and unregister events
  RDMA/bnxt_re: Add HW workaround for avoiding stall for UD QPs
  RDMA/bnxt_re: Fix WQE Size posted to HW to prevent it from throwing
    error
  RDMA/bnxt_re: Specify RDMA component when allocating stats context

 drivers/infiniband/hw/bnxt_re/bnxt_re.h    |  19 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 593 ++++++++++++++++++++---------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h   |  25 +-
 drivers/infiniband/hw/bnxt_re/main.c       |  97 ++++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 394 ++++++++++---------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  18 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 314 +++++++--------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  61 +--
 drivers/infiniband/hw/bnxt_re/qplib_res.c  |  10 +
 drivers/infiniband/hw/bnxt_re/qplib_res.h  |   6 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c   | 412 +++++++-------------
 drivers/infiniband/hw/bnxt_re/qplib_sp.h   |   4 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h   |   4 +-
 13 files changed, 1105 insertions(+), 852 deletions(-)

-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
