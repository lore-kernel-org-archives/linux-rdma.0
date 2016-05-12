From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/15] IB/hfi1: Immediately apply congestion setting MAD
Date: Thu, 12 May 2016 10:23:41 -0700
Message-ID: <20160512172340.9741.61846.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The handling of the congestion setting MAD packet only
saved off the values, waiting for a congestion control
table packet before going active.  Instead, immediately
apply the values.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   93 +++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index ed58cf2..17882dc 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3363,6 +3363,50 @@ static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
 	return reply((struct ib_mad_hdr *)smp);
 }
 
+/*
+ * Apply congestion control information stored in the ppd to the
+ * active structure.
+ */
+static void apply_cc_state(struct hfi1_pportdata *ppd)
+{
+	struct cc_state *old_cc_state, *new_cc_state;
+
+	new_cc_state = kzalloc(sizeof(*new_cc_state), GFP_KERNEL);
+	if (!new_cc_state)
+		return;
+
+	/*
+	 * Hold the lock for updating *and* to prevent ppd information
+	 * from changing during the update.
+	 */
+	spin_lock(&ppd->cc_state_lock);
+
+	old_cc_state = get_cc_state(ppd);
+	if (!old_cc_state) {
+		/* never active, or shutting down */
+		spin_unlock(&ppd->cc_state_lock);
+		kfree(new_cc_state);
+		return;
+	}
+
+	*new_cc_state = *old_cc_state;
+
+	new_cc_state->cct.ccti_limit = ppd->total_cct_entry - 1;
+	memcpy(new_cc_state->cct.entries, ppd->ccti_entries,
+	       ppd->total_cct_entry * sizeof(struct ib_cc_table_entry));
+
+	new_cc_state->cong_setting.port_control = IB_CC_CCS_PC_SL_BASED;
+	new_cc_state->cong_setting.control_map = ppd->cc_sl_control_map;
+	memcpy(new_cc_state->cong_setting.entries, ppd->congestion_entries,
+	       OPA_MAX_SLS * sizeof(struct opa_congestion_setting_entry));
+
+	rcu_assign_pointer(ppd->cc_state, new_cc_state);
+
+	spin_unlock(&ppd->cc_state_lock);
+
+	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
+}
+
 static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
 				       struct ib_device *ibdev, u8 port,
 				       u32 *resp_len)
@@ -3374,6 +3418,11 @@ static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
 	struct opa_congestion_setting_entry_shadow *entries;
 	int i;
 
+	/*
+	 * Save details from packet into the ppd.  Hold the cc_state_lock so
+	 * our information is consistent with anyone trying to apply the state.
+	 */
+	spin_lock(&ppd->cc_state_lock);
 	ppd->cc_sl_control_map = be32_to_cpu(p->control_map);
 
 	entries = ppd->congestion_entries;
@@ -3384,6 +3433,10 @@ static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
 			p->entries[i].trigger_threshold;
 		entries[i].ccti_min = p->entries[i].ccti_min;
 	}
+	spin_unlock(&ppd->cc_state_lock);
+
+	/* now apply the information */
+	apply_cc_state(ppd);
 
 	return __subn_get_opa_cong_setting(smp, am, data, ibdev, port,
 					   resp_len);
@@ -3526,7 +3579,6 @@ static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 	int i, j;
 	u32 sentry, eentry;
 	u16 ccti_limit;
-	struct cc_state *old_cc_state, *new_cc_state;
 
 	/* sanity check n_blocks, start_block */
 	if (n_blocks == 0 ||
@@ -3546,45 +3598,20 @@ static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	new_cc_state = kzalloc(sizeof(*new_cc_state), GFP_KERNEL);
-	if (!new_cc_state)
-		goto getit;
-
+	/*
+	 * Save details from packet into the ppd.  Hold the cc_state_lock so
+	 * our information is consistent with anyone trying to apply the state.
+	 */
 	spin_lock(&ppd->cc_state_lock);
-
-	old_cc_state = get_cc_state(ppd);
-
-	if (!old_cc_state) {
-		spin_unlock(&ppd->cc_state_lock);
-		kfree(new_cc_state);
-		return reply((struct ib_mad_hdr *)smp);
-	}
-
-	*new_cc_state = *old_cc_state;
-
-	new_cc_state->cct.ccti_limit = ccti_limit;
-
-	entries = ppd->ccti_entries;
 	ppd->total_cct_entry = ccti_limit + 1;
-
+	entries = ppd->ccti_entries;
 	for (j = 0, i = sentry; i < eentry; j++, i++)
 		entries[i].entry = be16_to_cpu(p->ccti_entries[j].entry);
-
-	memcpy(new_cc_state->cct.entries, entries,
-	       eentry * sizeof(struct ib_cc_table_entry));
-
-	new_cc_state->cong_setting.port_control = IB_CC_CCS_PC_SL_BASED;
-	new_cc_state->cong_setting.control_map = ppd->cc_sl_control_map;
-	memcpy(new_cc_state->cong_setting.entries, ppd->congestion_entries,
-	       OPA_MAX_SLS * sizeof(struct opa_congestion_setting_entry));
-
-	rcu_assign_pointer(ppd->cc_state, new_cc_state);
-
 	spin_unlock(&ppd->cc_state_lock);
 
-	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
+	/* now apply the information */
+	apply_cc_state(ppd);
 
-getit:
 	return __subn_get_opa_cc_table(smp, am, data, ibdev, port, resp_len);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
