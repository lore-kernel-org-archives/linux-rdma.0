From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for local
Date: Thu, 31 Aug 2017 14:50:56 -0600
Message-ID: <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To avoid clashing with user variables.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 util/util.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/util/util.h b/util/util.h
index cbf0deca2dde7b..30d32ee6b51e24 100644
--- a/util/util.h
+++ b/util/util.h
@@ -8,8 +8,8 @@
  * error */
 #define check_snprintf(buf, len, fmt, ...)                                     \
 	({                                                                     \
-		int rc = snprintf(buf, len, fmt, ##__VA_ARGS__);               \
-		(rc < len && rc >= 0);                                         \
+		int __rc__ = snprintf(buf, len, fmt, ##__VA_ARGS__);           \
+		(__rc__ < len && __rc__ >= 0);                                 \
 	})
 
 /* a CMP b. See also the BSD macro timercmp(). */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
