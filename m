From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] IB/core: Use memdup_user() rather than duplicating its
 implementation
Date: Sun, 21 Aug 2016 19:42:11 +0200
Message-ID: <7eb9ab74-b609-44d3-86f2-60137817aeed@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 18:45:22 +0200

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 include/rdma/ib_verbs.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6f667dd..033610b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2205,16 +2205,11 @@ static inline bool ib_is_udata_cleared(struct ib_udata *udata,
 	if (len > USHRT_MAX)
 		return false;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
+	buf = memdup_user(p, len);
+	if (IS_ERR(buf))
 		return false;
 
-	if (copy_from_user(buf, p, len))
-		goto free;
-
 	ret = !memchr_inv(buf, 0, len);
-
-free:
 	kfree(buf);
 	return ret;
 }
-- 
2.9.3
