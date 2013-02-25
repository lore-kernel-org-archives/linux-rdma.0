From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: add UMAD_SA_STATUS_PRI_SUGGESTED to SA status.
Date: Mon, 25 Feb 2013 10:08:42 -0800
Message-ID: <20130225100842.80371605421a69961735f1a0@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Per: A13.5.2 Subnet Administration Status Values (QoS)

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/infiniband/umad_sa.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/umad_sa.h b/include/infiniband/umad_sa.h
index 5d6efe1..aaf2ac1 100644
--- a/include/infiniband/umad_sa.h
+++ b/include/infiniband/umad_sa.h
@@ -68,7 +68,8 @@ enum {
 	UMAD_SA_STATUS_TOO_MANY_RECORDS	= 4,
 	UMAD_SA_STATUS_INVALID_GID	= 5,
 	UMAD_SA_STATUS_INSUF_COMPS	= 6,
-	UMAD_SA_STATUS_REQ_DENIED	= 7
+	UMAD_SA_STATUS_REQ_DENIED	= 7,
+	UMAD_SA_STATUS_PRI_SUGGESTED	= 8
 };
 
 /* SA attributes */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
