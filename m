From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/18] IB/hfi1: Clean up port state structure
 definition
Date: Fri, 01 Jul 2016 16:00:49 -0700
Message-ID: <20160701230048.20160.28146.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The definition of port state changed mid development and the
old structure was kept accidentally.  Remove this dead code.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   12 ------------
 drivers/infiniband/hw/hfi1/mad.h |    7 -------
 include/rdma/opa_port_info.h     |   16 ----------------
 3 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index fca07a1..223dd46 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -588,7 +588,6 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 
 	pi->port_phys_conf = (ppd->port_type & 0xf);
 
-#if PI_LED_ENABLE_SUP
 	pi->port_states.ledenable_offlinereason = ppd->neighbor_normal << 4;
 	pi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
@@ -602,11 +601,6 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	pi->port_states.ledenable_offlinereason |= is_beaconing_active << 6;
 	pi->port_states.ledenable_offlinereason |=
 		ppd->offline_disabled_reason;
-#else
-	pi->port_states.offline_reason = ppd->neighbor_normal << 4;
-	pi->port_states.offline_reason |= ppd->is_sm_config_started << 5;
-	pi->port_states.offline_reason |= ppd->offline_disabled_reason;
-#endif /* PI_LED_ENABLE_SUP */
 
 	pi->port_states.portphysstate_portstate =
 		(hfi1_ibphys_portstate(ppd) << 4) | state;
@@ -1752,17 +1746,11 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 	if (start_of_sm_config && (lstate == IB_PORT_INIT))
 		ppd->is_sm_config_started = 1;
 
-#if PI_LED_ENABLE_SUP
 	psi->port_states.ledenable_offlinereason = ppd->neighbor_normal << 4;
 	psi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
 	psi->port_states.ledenable_offlinereason |=
 		ppd->offline_disabled_reason;
-#else
-	psi->port_states.offline_reason = ppd->neighbor_normal << 4;
-	psi->port_states.offline_reason |= ppd->is_sm_config_started << 5;
-	psi->port_states.offline_reason |= ppd->offline_disabled_reason;
-#endif /* PI_LED_ENABLE_SUP */
 
 	psi->port_states.portphysstate_portstate =
 		(hfi1_ibphys_portstate(ppd) << 4) | (lstate & 0xf);
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index 8b734aa..5aa3fd1 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -48,15 +48,8 @@
 #define _HFI1_MAD_H
 
 #include <rdma/ib_pma.h>
-#define USE_PI_LED_ENABLE	1 /*
-				   * use led enabled bit in struct
-				   * opa_port_states, if available
-				   */
 #include <rdma/opa_smi.h>
 #include <rdma/opa_port_info.h>
-#ifndef PI_LED_ENABLE_SUP
-#define PI_LED_ENABLE_SUP 0
-#endif
 #include "opa_compat.h"
 
 /*
diff --git a/include/rdma/opa_port_info.h b/include/rdma/opa_port_info.h
index 2b95c2c..9303e0e 100644
--- a/include/rdma/opa_port_info.h
+++ b/include/rdma/opa_port_info.h
@@ -33,11 +33,6 @@
 #if !defined(OPA_PORT_INFO_H)
 #define OPA_PORT_INFO_H
 
-/* Temporary until HFI driver is updated */
-#ifndef USE_PI_LED_ENABLE
-#define USE_PI_LED_ENABLE 0
-#endif
-
 #define OPA_PORT_LINK_MODE_NOP	0		/* No change */
 #define OPA_PORT_LINK_MODE_OPA	4		/* Port mode is OPA */
 
@@ -274,23 +269,12 @@ enum port_info_field_masks {
 	OPA_PI_MASK_MTU_CAP                       = 0x0F,
 };
 
-#if USE_PI_LED_ENABLE
 struct opa_port_states {
 	u8     reserved;
 	u8     ledenable_offlinereason;   /* 1 res, 1 bit, 6 bits */
 	u8     reserved2;
 	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
 };
-#define PI_LED_ENABLE_SUP 1
-#else
-struct opa_port_states {
-	u8     reserved;
-	u8     offline_reason;            /* 2 res, 6 bits */
-	u8     reserved2;
-	u8     portphysstate_portstate;   /* 4 bits, 4 bits */
-};
-#define PI_LED_ENABLE_SUP 0
-#endif
 
 struct opa_port_state_info {
 	struct opa_port_states port_states;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
