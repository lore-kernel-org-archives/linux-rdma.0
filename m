From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Corrected description of max_sge and max_sge_rd
Date: Wed, 10 May 2017 19:24:25 +0300
Message-ID: <1494433465-1883-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch corrects ambiguity in documentation of max_sge and max_sge_rd
fields. This ambiguity seems to be created due to [1] and due to mention
of "RD and non RD QPs" in man page.

Here RD can be understood as reliable datagram QP of Infiniband
specification as opposed to "read".

max_sge_rd: Maximum number of sges per WR for RDMA Read operations.
max_sge: Maximum number of sges per WR for QP for non RDMA Read
operations.

[1] http://www.rdmamojo.com/2012/07/13/ibv_query_device/

Signed-off-by: Parav Pandit<parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/131

 libibverbs/man/ibv_query_device.3 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibverbs/man/ibv_query_device.3 b/libibverbs/man/ibv_query_device.3
index 35daa53..0e9d286 100644
--- a/libibverbs/man/ibv_query_device.3
+++ b/libibverbs/man/ibv_query_device.3
@@ -33,8 +33,8 @@ uint32_t                hw_ver;                 /* Hardware version */
 int                     max_qp;                 /* Maximum number of supported QPs */
 int                     max_qp_wr;              /* Maximum number of outstanding WR on any work queue */
 int                     device_cap_flags;       /* HCA capabilities mask */
-int                     max_sge;                /* Maximum number of s/g per WR for non-RD QPs */
-int                     max_sge_rd;             /* Maximum number of s/g per WR for RD QPs */
+int                     max_sge;                /* Maximum number of s/g per WR for SQ & RQ of QP for non RDMA Read operations */
+int                     max_sge_rd;             /* Maximum number of s/g per WR for RDMA Read operations */
 int                     max_cq;                 /* Maximum number of supported CQs */
 int                     max_cqe;                /* Maximum number of CQE capacity per CQ */
 int                     max_mr;                 /* Maximum number of supported MRs */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
