From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/hfi1: fix pstateinfo from returning improperly byteswapped value
Date: Wed,  9 Sep 2015 01:28:21 -0400
Message-ID: <1441776501-5881-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christian.gomez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Byteswap link_width_downgrade_*_active values before sending on the wire.  In
addition properly define the Port State Info structure.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Christian Gomez <christian.gomez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Rimmer, Todd <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c | 4 ++--
 include/rdma/opa_port_info.h    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 37269eb90c34..b2c1b72d38ce 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1717,9 +1717,9 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 	psi->port_states.portphysstate_portstate =
 		(hfi1_ibphys_portstate(ppd) << 4) | (lstate & 0xf);
 	psi->link_width_downgrade_tx_active =
-	  ppd->link_width_downgrade_tx_active;
+		cpu_to_be16(ppd->link_width_downgrade_tx_active);
 	psi->link_width_downgrade_rx_active =
-	  ppd->link_width_downgrade_rx_active;
+		cpu_to_be16(ppd->link_width_downgrade_rx_active);
 	if (resp_len)
 		*resp_len += sizeof(struct opa_port_state_info);
 
diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
index 391dae1931c0..a0fa975cd1c1 100644
--- a/include/rdma/opa_port_info.h
+++ b/include/rdma/opa_port_info.h
@@ -294,8 +294,8 @@ struct opa_port_states {
 
 struct opa_port_state_info {
 	struct opa_port_states port_states;
-	u16 link_width_downgrade_tx_active;
-	u16 link_width_downgrade_rx_active;
+	__be16 link_width_downgrade_tx_active;
+	__be16 link_width_downgrade_rx_active;
 };
 
 struct opa_port_info {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
