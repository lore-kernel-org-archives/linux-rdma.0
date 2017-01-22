From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] IB/cxgb3: fix misspelling in header guard
Date: Sun, 22 Jan 2017 14:41:22 +0100
Message-ID: <20170122134122.10352-1-nicolas.iooss_linux@m4x.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Iooss <nicolas.iooss_linux@m4x.org>
List-Id: linux-rdma@vger.kernel.org

Use CXGB3_... instead of CXBG3_...

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 include/uapi/rdma/cxgb3-abi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/rdma/cxgb3-abi.h b/include/uapi/rdma/cxgb3-abi.h
index 48a19bda071b..d24eee12128f 100644
--- a/include/uapi/rdma/cxgb3-abi.h
+++ b/include/uapi/rdma/cxgb3-abi.h
@@ -30,7 +30,7 @@
  * SOFTWARE.
  */
 #ifndef CXGB3_ABI_USER_H
-#define CXBG3_ABI_USER_H
+#define CXGB3_ABI_USER_H
 
 #include <linux/types.h>
 
-- 
2.11.0
