From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/11] IB/hfi1: Prohibit invalid Init to Armed
 state transition
Date: Mon, 06 Nov 2017 06:38:59 -0800
Message-ID: <20171106143857.27539.35714.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is invalid to change Link state from Init to Armed if
IsSmConfigurationStarted bit is not set in Attribute modifier
for Set subnet management method in case of PortInfo
and PortStateInfo attribute.
Set response MAD status field bits accordingly to react correctly
in such situations and avoid changing Link state.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Grzegorz Morys <grzegorz.morys-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 0a867e5..1277e1c 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1238,8 +1238,7 @@ static int port_states_transition_allowed(struct hfi1_pportdata *ppd,
 }
 
 static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
-			   u32 logical_state, u32 phys_state,
-			   int suppress_idle_sma)
+			   u32 logical_state, u32 phys_state)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	u32 link_state;
@@ -1320,7 +1319,7 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 		break;
 	case IB_PORT_ARMED:
 		ret = set_link_state(ppd, HLS_UP_ARMED);
-		if ((ret == 0) && (suppress_idle_sma == 0))
+		if (!ret)
 			send_idle_sma(dd, SMA_IDLE_ARM);
 		break;
 	case IB_PORT_ACTIVE:
@@ -1614,8 +1613,10 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 			if (ls_new == ls_old || (ls_new == IB_PORT_ARMED))
 				ppd->is_sm_config_started = 1;
 		} else if (ls_new == IB_PORT_ARMED) {
-			if (ppd->is_sm_config_started == 0)
+			if (ppd->is_sm_config_started == 0) {
 				invalid = 1;
+				smp->status |= IB_SMP_INVALID_FIELD;
+			}
 		}
 	}
 
@@ -1632,9 +1633,11 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	 * is down or is being set to down.
 	 */
 
-	ret = set_port_states(ppd, smp, ls_new, ps_new, invalid);
-	if (ret)
-		return ret;
+	if (!invalid) {
+		ret = set_port_states(ppd, smp, ls_new, ps_new);
+		if (ret)
+			return ret;
+	}
 
 	ret = __subn_get_opa_portinfo(smp, am, data, ibdev, port, resp_len,
 				      max_len);
@@ -2111,17 +2114,18 @@ static int __subn_set_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 			if (ls_new == ls_old || (ls_new == IB_PORT_ARMED))
 				ppd->is_sm_config_started = 1;
 		} else if (ls_new == IB_PORT_ARMED) {
-			if (ppd->is_sm_config_started == 0)
+			if (ppd->is_sm_config_started == 0) {
 				invalid = 1;
+				smp->status |= IB_SMP_INVALID_FIELD;
+			}
 		}
 	}
 
-	ret = set_port_states(ppd, smp, ls_new, ps_new, invalid);
-	if (ret)
-		return ret;
-
-	if (invalid)
-		smp->status |= IB_SMP_INVALID_FIELD;
+	if (!invalid) {
+		ret = set_port_states(ppd, smp, ls_new, ps_new);
+		if (ret)
+			return ret;
+	}
 
 	return __subn_get_opa_psi(smp, am, data, ibdev, port, resp_len,
 				  max_len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
