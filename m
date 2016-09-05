From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 25/28] Avoid gcc 5.4 warning -Wtype-limits
Date: Mon,  5 Sep 2016 15:08:15 -0600
Message-ID: <1473109698-31408-26-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eg: comparison of unsigned expression < 0 is always false

These are all harmless cases where some simple adjustments will
supress the warning.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/src/iwch.c    | 2 +-
 libcxgb4/src/dev.c     | 4 ++--
 libibverbs/src/neigh.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libcxgb3/src/iwch.c b/libcxgb3/src/iwch.c
index 32447e427146..dd0d3711f2e2 100644
--- a/libcxgb3/src/iwch.c
+++ b/libcxgb3/src/iwch.c
@@ -225,7 +225,7 @@ found:
 
 	DBGLOG("libcxgb3");
 
-	if (fw_min < FW_MIN) {
+	if ((signed int)fw_min < FW_MIN) {
 		PDBG("libcxgb3: non-fatal firmware version mismatch.  "
 			"Firmware minor number is %u and libcxgb3 needs %u.\n",
 			fw_min, FW_MIN);
diff --git a/libcxgb4/src/dev.c b/libcxgb4/src/dev.c
index cd3217af77b2..ebcc72ecc991 100644
--- a/libcxgb4/src/dev.c
+++ b/libcxgb4/src/dev.c
@@ -435,7 +435,7 @@ found:
 	cp = strtok(NULL, ".");
 	sscanf(cp, "%i", &fw_min);
 
-	if (fw_maj < FW_MAJ) {
+	if ((signed int)fw_maj < FW_MAJ) {
 		fprintf(stderr, "libcxgb4: Fatal firmware version mismatch.  "
 			"Firmware major number is %u and libcxgb4 needs %u.\n",
 			fw_maj, FW_MAJ);
@@ -445,7 +445,7 @@ found:
 
 	DBGLOG("libcxgb4");
 
-	if (fw_min < FW_MIN) {
+	if ((signed int)fw_min < FW_MIN) {
 		PDBG("libcxgb4: non-fatal firmware version mismatch.  "
 			"Firmware minor number is %u and libcxgb4 needs %u.\n",
 			fw_min, FW_MIN);
diff --git a/libibverbs/src/neigh.c b/libibverbs/src/neigh.c
index dc8c2bc99ae3..6b6e58cd52f8 100644
--- a/libibverbs/src/neigh.c
+++ b/libibverbs/src/neigh.c
@@ -727,7 +727,7 @@ uint16_t neigh_get_vlan_id_from_dev(struct get_neigh_handler *neigh_handler)
 
 void neigh_set_vlan_id(struct get_neigh_handler *neigh_handler, uint16_t vid)
 {
-	if (vid >= 0 && vid <= 0xfff)
+	if (vid <= 0xfff)
 		neigh_handler->vid = vid;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
