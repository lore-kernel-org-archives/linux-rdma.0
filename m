From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH  1/3] IB/core: Fix reading capability mask of the port info class
Date: Thu, 11 Feb 2016 10:24:42 +0200
Message-ID: <1455179084-4778-2-git-send-email-matanb@mellanox.com>
References: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455179084-4778-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When checking specific attribute from a bit mask, need to use bitwise
AND and not logical AND, fixed that.

Fixes: 145d9c541032 ('IB/core: Display extended counter set if
available')
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 3de9351..e981f6a 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -722,12 +722,11 @@ static struct attribute_group *get_counter_table(struct ib_device *dev,
 
 	if (get_perf_mad(dev, port_num, IB_PMA_CLASS_PORT_INFO,
 				&cpi, 40, sizeof(cpi)) >= 0) {
-
-		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH)
+		if (cpi.capability_mask & IB_PMA_CLASS_CAP_EXT_WIDTH)
 			/* We have extended counters */
 			return &pma_group_ext;
 
-		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
+		if (cpi.capability_mask & IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
 			/* But not the IETF ones */
 			return &pma_group_noietf;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
