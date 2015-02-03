From: Tina Ruchandani <ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Remove unused field sent_ts
Date: Tue, 3 Feb 2015 17:17:47 +0530
Message-ID: <20150203114747.GA7370@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes the unused field sent_ts from struct nes_cm_tcp_context.
This patch is part of an effort to clean up instances of timekeeping data-types
like 'struct timeval' which will overflow on 32-bit systems in year 2038 and
beyond.

Signed-off-by: Tina Ruchandani <ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index f522cf6..98948f1 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -279,7 +279,6 @@ struct nes_cm_tcp_context {
 	u8  rcv_wscale;
 
 	struct nes_cm_tsa_context tsa_cntxt;
-	struct timeval            sent_ts;
 };
 
 
-- 
2.2.0.rc0.207.ga3a616c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
