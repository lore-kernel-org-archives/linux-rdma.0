From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 02/15] umad: Include umad.h in the canonical way
Date: Mon, 22 Aug 2016 12:13:25 -0600
Message-ID: <1471889618-1605-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Should always be:

#include <infiniband/umad.h>

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/src/umad.c               | 2 +-
 libibumad/tests/umad_reg2_compat.c | 2 +-
 libibumad/tests/umad_register2.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibumad/src/umad.c b/libibumad/src/umad.c
index 7b799f9512bb..a7879d385466 100644
--- a/libibumad/src/umad.c
+++ b/libibumad/src/umad.c
@@ -50,7 +50,7 @@
 #include <ctype.h>
 #include <inttypes.h>
 
-#include "umad.h"
+#include <infiniband/umad.h>
 
 #define IB_OPENIB_OUI                 (0x001405)
 
diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 4f433062b57d..413a3bec6d58 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -39,7 +39,7 @@
 #include <stdio.h>
 #include <inttypes.h>
 
-#include "umad.h"
+#include <infiniband/umad.h>
 
 #define UNLIKELY_MGMT_CLASS 0x2F
 #define UNLIKELY_RMPP_MGMT_CLASS 0x4F
diff --git a/libibumad/tests/umad_register2.c b/libibumad/tests/umad_register2.c
index 93692ee7a856..c2d7846038bd 100644
--- a/libibumad/tests/umad_register2.c
+++ b/libibumad/tests/umad_register2.c
@@ -41,7 +41,7 @@
 #include <errno.h>
 #include <sys/ioctl.h>
 
-#include "umad.h"
+#include <infiniband/umad.h>
 
 #define UNLIKELY_MGMT_CLASS 0x2F
 #define UNLIKELY_RMPP_MGMT_CLASS 0x4F
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
