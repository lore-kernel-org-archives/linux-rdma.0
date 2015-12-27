From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] InfiniBand-iSER: One jump label less in iser_reg_sig_mr()
Date: Sun, 27 Dec 2015 13:40:13 +0100
Message-ID: <567FDC2D.2090706@users.sourceforge.net>
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
Date: Sun, 27 Dec 2015 11:41:42 +0100

This issue was detected by using the Coccinelle software.

1. Let us return directly if a call of the iser_set_sig_attrs()
   function failed.

2. Delete the jump label "err" then.

3. Return zero as a constant at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ea765fb..14e08b3 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -443,7 +443,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	memset(sig_attrs, 0, sizeof(*sig_attrs));
 	ret = iser_set_sig_attrs(iser_task->sc, sig_attrs);
 	if (ret)
-		goto err;
+		return ret;
 
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
@@ -475,8 +475,7 @@ iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	iser_dbg("lkey=0x%x rkey=0x%x addr=0x%llx length=%u\n",
 		 sig_reg->sge.lkey, sig_reg->rkey, sig_reg->sge.addr,
 		 sig_reg->sge.length);
-err:
-	return ret;
+	return 0;
 }
 
 static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
-- 
2.6.3
