From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/54] staging/rdma/hfi1: HFI reports wrong offline disabled
 reason when cable removed
Date: Wed, 03 Feb 2016 14:30:49 -0800
Message-ID: <20160203223046.5923.88509.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan Morgan <bryan.c.morgan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bryan Morgan <bryan.c.morgan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Removing QSFP cable should report 'No Local Media' instead of
'Transient' as reported by 'opaportinfo'.
Workaround is to change the state to
OPA_LINKDOWN_REASON_LOCAL_MEDIA_NOT_INSTALLED in cable handler.

With cable still removed, 'opaportinfo bounce' should not cause a
state change to Polling, as reported by 'opaportinfo'.
Resolution is to prevent physical state change from Offline->Polling.

Use a macro to mask lower nibble of OPA_LINKDOWN_REASON* as needed
for offline_disabled_reason.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bryan Morgan <bryan.c.morgan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   18 +++++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h  |    2 ++
 drivers/staging/rdma/hfi1/intr.c |    3 ++-
 drivers/staging/rdma/hfi1/mad.c  |   24 +++++++++++++++---------
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 93e152d..16e2ff2 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5857,6 +5857,16 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 						ASIC_QSFP2_INVERT :
 						ASIC_QSFP1_INVERT,
 				qsfp_int_mgmt);
+
+			if ((ppd->offline_disabled_reason >
+			  HFI1_ODR_MASK(
+			  OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED)) ||
+			  (ppd->offline_disabled_reason ==
+			  HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE)))
+				ppd->offline_disabled_reason =
+				HFI1_ODR_MASK(
+				OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED);
+
 			if (ppd->host_link_state == HLS_DN_POLL) {
 				/*
 				 * The link is still in POLL. This means
@@ -9615,9 +9625,10 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 				ret);
 			return -EINVAL;
 		}
-		if (ppd->offline_disabled_reason == OPA_LINKDOWN_REASON_NONE)
+		if (ppd->offline_disabled_reason ==
+				HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
 			ppd->offline_disabled_reason =
-			OPA_LINKDOWN_REASON_TRANSIENT;
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_TRANSIENT);
 	}
 
 	if (do_wait) {
@@ -9972,7 +9983,8 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 				ret = -EINVAL;
 			}
 		}
-		ppd->offline_disabled_reason = OPA_LINKDOWN_REASON_NONE;
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE);
 		/*
 		 * If an error occurred above, go back to offline.  The
 		 * caller may reschedule another attempt.
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index e6a5fed..57014b0 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -99,6 +99,8 @@ extern unsigned long hfi1_cap_mask;
 #define HFI1_CAP_IS_USET(cap) (!!HFI1_CAP_UGET(cap))
 #define HFI1_MISC_GET() ((hfi1_cap_mask >> HFI1_CAP_MISC_SHIFT) & \
 			HFI1_CAP_MISC_MASK)
+/* Offline Disabled Reason is 4-bits */
+#define HFI1_ODR_MASK(rsn) ((rsn) & OPA_PI_MASK_OFFLINE_REASON)
 
 /*
  * Control context is always 0 and handles the error packets.
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 1283f2d..9adab86 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -152,7 +152,8 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 
 		/* physical link went up */
 		ppd->linkup = 1;
-		ppd->offline_disabled_reason = OPA_LINKDOWN_REASON_NONE;
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE);
 
 		/* link widths are not available until the link is fully up */
 		get_linkup_link_widths(ppd);
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 9cadf77..303dfee 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -590,12 +590,11 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	pi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
 	pi->port_states.ledenable_offlinereason |=
-		ppd->offline_disabled_reason & OPA_PI_MASK_OFFLINE_REASON;
+		ppd->offline_disabled_reason;
 #else
 	pi->port_states.offline_reason = ppd->neighbor_normal << 4;
 	pi->port_states.offline_reason |= ppd->is_sm_config_started << 5;
-	pi->port_states.offline_reason |= ppd->offline_disabled_reason &
-						OPA_PI_MASK_OFFLINE_REASON;
+	pi->port_states.offline_reason |= ppd->offline_disabled_reason;
 #endif /* PI_LED_ENABLE_SUP */
 
 	pi->port_states.portphysstate_portstate =
@@ -930,6 +929,14 @@ static int port_states_transition_allowed(struct hfi1_pportdata *ppd,
 		return HFI_TRANSITION_IGNORED;
 
 	/*
+	 * A change request of Physical Port State from
+	 * 'Offline' to 'Polling' should be ignored.
+	 */
+	if ((physical_old == OPA_PORTPHYSSTATE_OFFLINE) &&
+	    (physical_new == IB_PORTPHYSSTATE_POLLING))
+		return HFI_TRANSITION_IGNORED;
+
+	/*
 	 * Either physical_allowed or logical_allowed is
 	 * HFI_TRANSITION_ALLOWED.
 	 */
@@ -993,11 +1000,11 @@ static int set_port_states(struct hfi1_pportdata *ppd, struct opa_smp *smp,
 		set_link_state(ppd, link_state);
 		if (link_state == HLS_DN_DISABLE &&
 		    (ppd->offline_disabled_reason >
-		     OPA_LINKDOWN_REASON_SMA_DISABLED ||
+		     HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED) ||
 		     ppd->offline_disabled_reason ==
-		     OPA_LINKDOWN_REASON_NONE))
+		     HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE)))
 			ppd->offline_disabled_reason =
-			OPA_LINKDOWN_REASON_SMA_DISABLED;
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED);
 		/*
 		 * Don't send a reply if the response would be sent
 		 * through the disabled port.
@@ -1710,12 +1717,11 @@ static int __subn_get_opa_psi(struct opa_smp *smp, u32 am, u8 *data,
 	psi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
 	psi->port_states.ledenable_offlinereason |=
-		ppd->offline_disabled_reason & OPA_PI_MASK_OFFLINE_REASON;
+		ppd->offline_disabled_reason;
 #else
 	psi->port_states.offline_reason = ppd->neighbor_normal << 4;
 	psi->port_states.offline_reason |= ppd->is_sm_config_started << 5;
-	psi->port_states.offline_reason |= ppd->offline_disabled_reason &
-				OPA_PI_MASK_OFFLINE_REASON;
+	psi->port_states.offline_reason |= ppd->offline_disabled_reason;
 #endif /* PI_LED_ENABLE_SUP */
 
 	psi->port_states.portphysstate_portstate =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
