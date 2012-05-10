From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/6] IB/core: Fix IB_SA_COMP_MASK macro
Date: Thu, 10 May 2012 23:28:07 +0300
Message-ID: <1336681689-16668-5-git-send-email-ogerlitz@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

It needs parentheses around the argument, so that it can
be used with complex arguments (e.g., n+5 say).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 include/rdma/ib_mad.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index b513f57..3d81b90 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -160,7 +160,7 @@ struct ib_rmpp_hdr {
 
 typedef u64 __bitwise ib_sa_comp_mask;
 
-#define IB_SA_COMP_MASK(n) ((__force ib_sa_comp_mask) cpu_to_be64(1ull << n))
+#define IB_SA_COMP_MASK(n) ((__force ib_sa_comp_mask) cpu_to_be64(1ull << (n)))
 
 /*
  * ib_sa_hdr and ib_sa_mad structures must be packed because they have
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
