From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/54] staging/rdma/hfi1: Get port type from configuration
 file
Date: Wed, 03 Feb 2016 14:31:22 -0800
Message-ID: <20160203223119.5923.57841.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current code employs a heuristic to guess the port type.
The canonical location to identify the port type of the
designed platform is from the platform configuration data.

This patch uses the previously fetched port type from the platform
configuration and removes the now obsolete heuristic routine
and its associated defines.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c        |   12 +-----------
 drivers/staging/rdma/hfi1/opa_compat.h |   15 ---------------
 2 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 303dfee..5146f5d 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -503,16 +503,6 @@ void read_ltp_rtt(struct hfi1_devdata *dd)
 		write_lcb_cache(DC_LCB_STS_ROUND_TRIP_LTP_CNT, reg);
 }
 
-static u8 __opa_porttype(struct hfi1_pportdata *ppd)
-{
-	if (qsfp_mod_present(ppd)) {
-		if (ppd->qsfp_info.cache_valid)
-			return OPA_PORT_TYPE_STANDARD;
-		return OPA_PORT_TYPE_DISCONNECTED;
-	}
-	return OPA_PORT_TYPE_UNKNOWN;
-}
-
 static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 				   struct ib_device *ibdev, u8 port,
 				   u32 *resp_len)
@@ -583,7 +573,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	if (start_of_sm_config && (state == IB_PORT_INIT))
 		ppd->is_sm_config_started = 1;
 
-	pi->port_phys_conf = __opa_porttype(ppd) & 0xf;
+	pi->port_phys_conf = (ppd->port_type & 0xf);
 
 #if PI_LED_ENABLE_SUP
 	pi->port_states.ledenable_offlinereason = ppd->neighbor_normal << 4;
diff --git a/drivers/staging/rdma/hfi1/opa_compat.h b/drivers/staging/rdma/hfi1/opa_compat.h
index f64eec1..30f7707 100644
--- a/drivers/staging/rdma/hfi1/opa_compat.h
+++ b/drivers/staging/rdma/hfi1/opa_compat.h
@@ -111,19 +111,4 @@ enum opa_port_phys_state {
 	/* values 12-15 are reserved/ignored */
 };
 
-/* OPA_PORT_TYPE_* definitions - these belong in opa_port_info.h */
-#define OPA_PORT_TYPE_UNKNOWN          0
-#define OPA_PORT_TYPE_DISCONNECTED     1
-/* port is not currently usable, CableInfo not available */
-#define OPA_PORT_TYPE_FIXED            2
-/* A fixed backplane port in a director class switch. All OPA ASICS */
-#define OPA_PORT_TYPE_VARIABLE         3
-/* A backplane port in a blade system, possibly mixed configuration */
-#define OPA_PORT_TYPE_STANDARD         4
-/* implies a SFF-8636 defined format for CableInfo (QSFP) */
-#define OPA_PORT_TYPE_SI_PHOTONICS      5
-/* A silicon photonics module implies TBD defined format for CableInfo
- * as defined by Intel SFO group */
-/* 6 - 15 are reserved */
-
 #endif /* _LINUX_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
