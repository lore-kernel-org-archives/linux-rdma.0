From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/hfi1: Change slid arg in
 ingress_pkey_table_fail to 32bit
Date: Fri, 22 Dec 2017 08:46:00 -0800
Message-ID: <20171222164557.29731.16649.stgit@scvm10.sc.intel.com>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222164036.29731.43475.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the slid arg to ingress_pkey_table_fail() to a full
32Bits and do not convert to 16Bits in caller. This is so we
can keep everything 32bit in the kernel and only change to
16bit at the uapi boundary.

Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h |    2 +-
 drivers/infiniband/hw/hfi1/mad.c |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 869c2bf..dc5b133 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1627,7 +1627,7 @@ static int ingress_pkey_table_search(struct hfi1_pportdata *ppd, u16 pkey)
  * the 'error info' for this failure.
  */
 static void ingress_pkey_table_fail(struct hfi1_pportdata *ppd, u16 pkey,
-				    u16 slid)
+				    u32 slid)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index cf8dba3..34547a4 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -4348,11 +4348,7 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
 	 */
 	if (pkey == LIM_MGMT_P_KEY || pkey == FULL_MGMT_P_KEY)
 		return 0;
-	/*
-	 * On OPA devices it is okay to lose the upper 16 bits of LID as this
-	 * information is obtained elsewhere. Mask off the upper 16 bits.
-	 */
-	ingress_pkey_table_fail(ppd, pkey, ib_lid_cpu16(0xFFFF & in_wc->slid));
+	ingress_pkey_table_fail(ppd, pkey, in_wc->slid);
 	return 1;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
