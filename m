From: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/9] infiniband: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:38 +0900
Message-ID: <1265037040-23413-7-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/mad.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7522008..58463da 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1193,10 +1193,7 @@ static int method_in_use(struct ib_mad_mgmt_method_table **method,
 {
 	int i;
 
-	for (i = find_first_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS) {
 		if ((*method)->agent[i]) {
 			printk(KERN_ERR PFX "Method %d already in use\n", i);
 			return -EINVAL;
@@ -1330,13 +1327,9 @@ static int add_nonoui_reg_req(struct ib_mad_reg_req *mad_reg_req,
 		goto error3;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error3:
@@ -1429,13 +1422,9 @@ check_in_use:
 		goto error4;
 
 	/* Finally, add in methods being registered */
-	for (i = find_first_bit(mad_reg_req->method_mask,
-				IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_set_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error4:
-- 
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
