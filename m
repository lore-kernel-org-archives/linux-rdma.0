From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB: Add additional info on CNP
Date: Mon, 03 Aug 2015 12:36:58 -0400
Message-ID: <20150803163658.8594.61765.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit c50f8564f283 ("IB: Add CNP opcode enumeration.")
added an opcode from the IBTA 3.1 specification.

Add a comment in the source referencing the relevant
specification sections.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/TODO |    2 --
 include/rdma/ib_pack.h    |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/hfi1/TODO b/drivers/staging/hfi1/TODO
index 2529149..cc2e51d 100644
--- a/drivers/staging/hfi1/TODO
+++ b/drivers/staging/hfi1/TODO
@@ -3,5 +3,3 @@ July, 2015
 - Remove unneeded file entries in sysfs
 - Remove software processing of IB protocol and place in library for use
   by qib, ipath (if still present), hfi1, and eventually soft-roce
-- Clean up comments in code around CNP opcode
-
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 03f5217..709a533 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -76,6 +76,7 @@ enum {
 	IB_OPCODE_UC                                = 0x20,
 	IB_OPCODE_RD                                = 0x40,
 	IB_OPCODE_UD                                = 0x60,
+	/* per IBTA 3.1 Table 38, A10.3.2 */
 	IB_OPCODE_CNP                               = 0x80,
 
 	/* operations -- just used to define real constants */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
