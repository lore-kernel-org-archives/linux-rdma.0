From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/7] infiniband: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:28 +0900
Message-ID: <1264938810-4173-5-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753329Ab0AaL6B@vger.kernel.org>
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/mad.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 7522008..a0b00ba 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1193,10 +1193,7 @@ static int method_in_use(struct ib_mad_mgmt_method_table **method,
 {
 	int i;
 
-	for (i = find_first_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS);
-	     i < IB_MGMT_MAX_METHODS;
-	     i = find_next_bit(mad_reg_req->method_mask, IB_MGMT_MAX_METHODS,
-			       1+i)) {
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS) {
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
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
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
+	for_each_bit(i, mad_reg_req->method_mask, IB_MGMT_MAX_METHODS)
 		(*method)->agent[i] = agent_priv;
-	}
+
 	return 0;
 
 error4:
-- 
1.6.0.6
