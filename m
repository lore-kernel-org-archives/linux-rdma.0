From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: change UMAD_METHOD_RESP to UMAD_METHOD_RESP_MASK
Date: Sat, 23 Feb 2013 15:38:26 -0800
Message-ID: <20130223153826.7b412622c46078588b7db1ad@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/infiniband/umad_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/umad_types.h b/include/infiniband/umad_types.h
index 199edd1..48ae284 100644
--- a/include/infiniband/umad_types.h
+++ b/include/infiniband/umad_types.h
@@ -82,7 +82,7 @@ enum {
 	UMAD_METHOD_REPORT		= 0x06,
 	UMAD_METHOD_REPORT_RESP		= 0x86,
 	UMAD_METHOD_TRAP_REPRESS	= 0x07,
-	UMAD_METHOD_RESP		= 0x80
+	UMAD_METHOD_RESP_MASK		= 0x80
 };
 
 enum {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
