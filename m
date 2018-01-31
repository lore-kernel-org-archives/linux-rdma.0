From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core 3/3] libbnxt_re: Update and sort device pci-id table
Date: Wed, 31 Jan 2018 09:51:51 -0500
Message-ID: <1517410311-23623-4-git-send-email-devesh.sharma@broadcom.com>
References: <1517410311-23623-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517410311-23623-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sort the pci-id table in increasing order of the
device IDs. Add new PCI-ID for BCM880xx series of
devices.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index 520bf57..eae50b0 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -54,24 +54,29 @@
 
 #define CNA(v, d) VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, d, NULL)
 static const struct verbs_match_ent cna_table[] = {
+	CNA(BROADCOM, 0x1605),  /* BCM57454 NPAR */
+	CNA(BROADCOM, 0x1606),  /* BCM57454 VF */
+	CNA(BROADCOM, 0x1614),  /* BCM57454 */
 	CNA(BROADCOM, 0x16C0),  /* BCM57417 NPAR */
+	CNA(BROADCOM, 0x16C1),  /* BMC57414 VF */
 	CNA(BROADCOM, 0x16CE),  /* BMC57311 */
 	CNA(BROADCOM, 0x16CF),  /* BMC57312 */
-	CNA(BROADCOM, 0x16DF),  /* BMC57314 */
-	CNA(BROADCOM, 0x16E5),  /* BMC57314 VF */
-	CNA(BROADCOM, 0x16E2),  /* BMC57417 */
-	CNA(BROADCOM, 0x16E3),  /* BMC57416 */
 	CNA(BROADCOM, 0x16D6),  /* BMC57412*/
 	CNA(BROADCOM, 0x16D7),  /* BMC57414 */
 	CNA(BROADCOM, 0x16D8),  /* BMC57416 Cu */
 	CNA(BROADCOM, 0x16D9),  /* BMC57417 Cu */
-	CNA(BROADCOM, 0x16C1),  /* BMC57414 VF */
-	CNA(BROADCOM, 0x16EF),  /* BCM57416 NPAR */
+	CNA(BROADCOM, 0x16DF),  /* BMC57314 */
+	CNA(BROADCOM, 0x16E2),  /* BMC57417 */
+	CNA(BROADCOM, 0x16E3),  /* BMC57416 */
+	CNA(BROADCOM, 0x16E5),  /* BMC57314 VF */
 	CNA(BROADCOM, 0x16ED),  /* BCM57414 NPAR */
 	CNA(BROADCOM, 0x16EB),  /* BCM57412 NPAR */
+	CNA(BROADCOM, 0x16EF),  /* BCM57416 NPAR */
 	CNA(BROADCOM, 0x16F0),  /* BCM58730 */
 	CNA(BROADCOM, 0x16F1),  /* BCM57452 */
+	CNA(BROADCOM, 0xD800),  /* BCM880xx VF */
 	CNA(BROADCOM, 0xD802),  /* BCM58802 */
+	CNA(BROADCOM, 0xD804),   /* BCM8804 SR */
 	{}
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
