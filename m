From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 04/28] cxgb3/4: Display correct version number in error message
Date: Mon,  5 Sep 2016 15:07:54 -0600
Message-ID: <1473109698-31408-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Copy&Paste error was showing the major, not minor version.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/src/iwch.c | 2 +-
 libcxgb4/src/dev.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libcxgb3/src/iwch.c b/libcxgb3/src/iwch.c
index cc6b37cad775..32447e427146 100644
--- a/libcxgb3/src/iwch.c
+++ b/libcxgb3/src/iwch.c
@@ -228,7 +228,7 @@ found:
 	if (fw_min < FW_MIN) {
 		PDBG("libcxgb3: non-fatal firmware version mismatch.  "
 			"Firmware minor number is %u and libcxgb3 needs %u.\n",
-			fw_maj, FW_MAJ);	
+			fw_min, FW_MIN);
 		fflush(stderr);
 	}
 
diff --git a/libcxgb4/src/dev.c b/libcxgb4/src/dev.c
index 657ed192764c..cd3217af77b2 100644
--- a/libcxgb4/src/dev.c
+++ b/libcxgb4/src/dev.c
@@ -448,7 +448,7 @@ found:
 	if (fw_min < FW_MIN) {
 		PDBG("libcxgb4: non-fatal firmware version mismatch.  "
 			"Firmware minor number is %u and libcxgb4 needs %u.\n",
-			fw_maj, FW_MAJ);
+			fw_min, FW_MIN);
 		fflush(stderr);
 	}
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
