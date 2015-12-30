From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Fix dereference before check
Date: Wed, 30 Dec 2015 16:14:18 +0200
Message-ID: <1451484858-1530-3-git-send-email-matanb@mellanox.com>
References: <1451484858-1530-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451484858-1530-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse complains about dereference before check. Fixing this by
moving the check before the dereference.

Fixes: 200298326b27 ('IB/core: Validate route when we init ah')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Doug,

This patch eliminates a deference before check sparse false warning.
This was introduced in the RoCE v2 series.

Regards,
Matan

 drivers/infiniband/core/addr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0b5f245..791cc98 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -497,13 +497,14 @@ int rdma_resolve_ip_route(struct sockaddr *src_addr,
 	struct sockaddr_storage ssrc_addr = {};
 	struct sockaddr *src_in = (struct sockaddr *)&ssrc_addr;
 
-	if (src_addr->sa_family != dst_addr->sa_family)
-		return -EINVAL;
+	if (src_addr) {
+		if (src_addr->sa_family != dst_addr->sa_family)
+			return -EINVAL;
 
-	if (src_addr)
 		memcpy(src_in, src_addr, rdma_addr_size(src_addr));
-	else
+	} else {
 		src_in->sa_family = dst_addr->sa_family;
+	}
 
 	return addr_resolve(src_in, dst_addr, addr, false);
 }
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
