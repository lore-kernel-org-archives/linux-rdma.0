From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] InfiniBand-iSER-target: One jump label less in
 isert_reg_sig_mr()
Date: Sun, 27 Dec 2015 13:41:46 +0100
Message-ID: <567FDC8A.6000602@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <567FDB4E.2040000@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <567FDB4E.2040000@users.sourceforge.net>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 27 Dec 2015 12:54:52 +0100

This issue was detected by using the Coccinelle software.

1. Let us return directly if a call of the function "isert_set_sig_attrs"
   or "ib_post_send" failed.

2. Delete the jump label "err" then.

3. Return zero as a constant at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8a51c3b..9b22db0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2660,7 +2660,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	memset(&sig_attrs, 0, sizeof(sig_attrs));
 	ret = isert_set_sig_attrs(se_cmd, &sig_attrs);
 	if (ret)
-		goto err;
+		return ret;
 
 	sig_attrs.check_mask = isert_set_prot_checks(se_cmd->prot_checks);
 
@@ -2688,7 +2688,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	ret = ib_post_send(isert_conn->qp, wr, &bad_wr);
 	if (ret) {
 		isert_err("fast registration failed, ret:%d\n", ret);
-		goto err;
+		return ret;
 	}
 	fr_desc->ind &= ~ISERT_SIG_KEY_VALID;
 
@@ -2706,8 +2706,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn,
 	isert_dbg("sig_sge: addr: 0x%llx  length: %u lkey: %x\n",
 		  rdma_wr->ib_sg[SIG].addr, rdma_wr->ib_sg[SIG].length,
 		  rdma_wr->ib_sg[SIG].lkey);
-err:
-	return ret;
+	return 0;
 }
 
 static int
-- 
2.6.3
