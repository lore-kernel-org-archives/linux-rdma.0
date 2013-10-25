From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix txselect regression
Date: Fri, 25 Oct 2013 11:17:59 -0400
Message-ID: <20131025151759.22484.58987.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 7fac3301("IB/qib: checkpatch fixes") was over
zealous in removing a simple_strtoul for a parse
routine, setup_txselect().  That routine is required
to handle a multi-value string.

Unwind that aspect of the fix.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 016e742..5bfc02f 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6190,21 +6190,20 @@ static int setup_txselect(const char *str, struct kernel_param *kp)
 {
 	struct qib_devdata *dd;
 	unsigned long val;
-	int ret;
-
+	char *n;
 	if (strlen(str) >= MAX_ATTEN_LEN) {
 		pr_info("txselect_values string too long\n");
 		return -ENOSPC;
 	}
-	ret = kstrtoul(str, 0, &val);
-	if (ret || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
+	val = simple_strtoul(str, &n, 0);
+	if (n == str || val >= (TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ +
 				TXDDS_MFG_SZ)) {
 		pr_info("txselect_values must start with a number < %d\n",
 			TXDDS_TABLE_SZ + TXDDS_EXTRA_SZ + TXDDS_MFG_SZ);
-		return ret ? ret : -EINVAL;
+		return -EINVAL;
 	}
-
 	strcpy(txselect_list, str);
+
 	list_for_each_entry(dd, &qib_dev_list, list)
 		if (dd->deviceid == PCI_DEVICE_ID_QLOGIC_IB_7322)
 			set_no_qsfp_atten(dd, 1);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
