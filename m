From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [for-next 0/3] Add congestion control capability
Date: Tue, 22 Aug 2017 07:49:44 -0400
Message-ID: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series is to support congestion control capability
on Broadcom NetXtreme-E 10/25/40/50 RDMA Ethernet Controllers.

The implementation exposes congestion control related parameters
to administrator using configfs.

patch 0001 mostly implements the configfs interface to publish
all the required CC parameters.

patch 0002 updates the HSI declarations in broadcom's ethernet
driver. This will cause a merge conflict in Stephen Rothwells
tree and most likely should be dropped during merging in his tree.
The sole purpose of this patch in this series is to prevent build
break on Doug's tree.

patch 0003 implements dscp to priority mapping.

Devesh Sharma (3):
  RDMA/bnxt_re: expose cc parameters through configfs
  RDMA/bnxt: update bnxt_hsi to hold dscp2pri declaration
  RDMA/bnxt_re: setup dscp to priority map

 drivers/infiniband/hw/bnxt_re/Makefile        |   3 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |  14 +
 drivers/infiniband/hw/bnxt_re/configfs.c      | 761 ++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/configfs.h      |  93 ++++
 drivers/infiniband/hw/bnxt_re/main.c          | 229 +++++++-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c      |  88 +++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h      |  23 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h      | 152 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h |  92 ++++
 9 files changed, 1405 insertions(+), 50 deletions(-)
 create mode 100644 drivers/infiniband/hw/bnxt_re/configfs.c
 create mode 100644 drivers/infiniband/hw/bnxt_re/configfs.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
