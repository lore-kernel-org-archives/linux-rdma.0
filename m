From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/8] RDMA/bnxt_re: Misc fixes for bnxt_re
Date: Thu, 31 Aug 2017 09:27:27 +0530
Message-ID: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series includes bug fixes for bnxt_re.
Doug,
	Please review apply for 4.14.
Thanks
Somnath

Devesh Sharma (2):
  bnxt_re: Fix update of qplib_qp.mtu when modified
  bnxt_re: Fix compare and swap atomic operands

Selvin Xavier (1):
  bnxt_re: Fix memory leak in FRMR path

Somnath Kotur (5):
  bnxt_re: Stop issuing further cmds to FW once a cmd times out
  bnxt_re: Free up devices in module_exit path
  bnxt_re: Fix race between the netdev register and unregister events
  bnxt_re: Remove RTNL lock dependency in bnxt_re_query_port
  bnxt_re: Don't issue cmd to delete GID for QP1 GID entry before the QP
    is destroyed

 drivers/infiniband/hw/bnxt_re/bnxt_re.h    | 14 +++++++----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 40 +++++++++++++++++++++---------
 drivers/infiniband/hw/bnxt_re/main.c       | 28 +++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 +++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  3 ++-
 5 files changed, 71 insertions(+), 18 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
