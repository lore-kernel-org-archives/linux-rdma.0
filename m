From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iwcm: rem_ref() - don't touch cm_id after deref.
Date: Thu, 21 Nov 2013 15:40:14 -0600
Message-ID: <20131121214014.27527.79925.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rem_ref() calls iwcm_deref_id(), which will wake up any blockers on
cm_id_priv->destroy_comp if the refcnt hits 0.  That will unblock someone
in iw_destroy_cm_id() which will free the cmid.  If that happens before
rem_ref() calls test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags),
then the test_bit() will touch freed memory.

The fix is to read the bit first, then deref.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index c47c203..0717940 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -181,9 +181,16 @@ static void add_ref(struct iw_cm_id *cm_id)
 static void rem_ref(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
+	int cb_destroy;
+
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
-	if (iwcm_deref_id(cm_id_priv) &&
-	    test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags)) {
+
+	/*
+	 * Test bit before deref in case the cm_id gets freed on another
+	 * thread.
+	 */
+	cb_destroy = test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
+	if (iwcm_deref_id(cm_id_priv) && cb_destroy) {
 		BUG_ON(!list_empty(&cm_id_priv->work_list));
 		free_cm_id(cm_id_priv);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
