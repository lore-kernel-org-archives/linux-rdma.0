From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 16/28] umad: Fix incorrect arguments to umad_register2 in tests
Date: Mon,  5 Sep 2016 15:08:06 -0600
Message-ID: <1473109698-31408-17-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code was attempting to pass int* instead of uint32_t* to
umad_register2, which is not OK.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/tests/umad_reg2_compat.c | 2 +-
 libibumad/tests/umad_register2.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 413a3bec6d58..6dd4a48a59b2 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -154,7 +154,7 @@ void test_fall_back(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
-	int agent_id;
+	uint32_t agent_id;
 	int fd;
 
 	fd = open_test_device();
diff --git a/libibumad/tests/umad_register2.c b/libibumad/tests/umad_register2.c
index c2d7846038bd..ed7e816bb63c 100644
--- a/libibumad/tests/umad_register2.c
+++ b/libibumad/tests/umad_register2.c
@@ -92,8 +92,8 @@ void test_fail(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
-	int agent_id;
-	int agent_id2;
+	uint32_t agent_id;
+	uint32_t agent_id2;
 	int fd;
 
 	printf("\n *****\nBegin invalid tests\n");
@@ -200,7 +200,7 @@ void test_oui(void)
 {
 	int rc = 0;
 	struct umad_reg_attr reg_attr;
-	int agent_id;
+	uint32_t agent_id;
 	int fd;
 
 	printf("\n *****\nStart valid oui tests\n");
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
