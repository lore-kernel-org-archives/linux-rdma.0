From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] bnxt_re:update and sort pci device id table
Date: Fri,  8 Sep 2017 14:01:27 -0400
Message-ID: <1504893687-6101-2-git-send-email-devesh.sharma@broadcom.com>
References: <1504893687-6101-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504893687-6101-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch updates and sorts the pci-device id table to
allow new roce device support.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index 29ac7cd..3c21bec 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -60,6 +60,7 @@ static const struct {
 	unsigned int vendor;
 	unsigned int device;
 } cna_table[] = {
+	CNA(BROADCOM, 0x1614),  /* BCM57454 */
 	CNA(BROADCOM, 0x16C0),  /* BCM57417 NPAR */
 	CNA(BROADCOM, 0x16CE),  /* BMC57311 */
 	CNA(BROADCOM, 0x16CF),  /* BMC57312 */
@@ -74,7 +75,10 @@ static const struct {
 	CNA(BROADCOM, 0x16C1),  /* BMC57414 VF */
 	CNA(BROADCOM, 0x16EF),  /* BCM57416 NPAR */
 	CNA(BROADCOM, 0x16ED),  /* BCM57414 NPAR */
-	CNA(BROADCOM, 0x16EB)   /* BCM57412 NPAR */
+	CNA(BROADCOM, 0x16EB),  /* BCM57412 NPAR */
+	CNA(BROADCOM, 0x16F0),  /* BCM58730 */
+	CNA(BROADCOM, 0x16F1),  /* BCM57452 */
+	CNA(BROADCOM, 0xD802)   /* BCM58802 */
 };
 
 static struct ibv_context_ops bnxt_re_cntx_ops = {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
