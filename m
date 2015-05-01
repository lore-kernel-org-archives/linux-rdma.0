From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] IB/mad: Clean up comments in smi.c
Date: Fri,  1 May 2015 00:07:21 -0400
Message-ID: <1430453241-20869-3-git-send-email-ira.weiny@intel.com>
References: <1430453241-20869-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430453241-20869-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Return values of 0 do not make sense for functions which return enum
smi_action

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/smi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 5855e44..e6c6810 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -41,7 +41,7 @@
 
 /*
  * Fixup a directed route SMP for sending
- * Return 0 if the SMP should be discarded
+ * Return IB_SMI_DISCARD if the SMP should be discarded
  */
 enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 				       u8 node_type, int port_num)
@@ -126,7 +126,7 @@ enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 
 /*
  * Adjust information for a received SMP
- * Return 0 if the SMP should be dropped
+ * Return IB_SMI_DISCARD if the SMP should be dropped
  */
 enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
 				       int port_num, int phys_port_cnt)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
