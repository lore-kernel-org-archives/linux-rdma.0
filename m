From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rc-fixes 2/2] IB/mlx4: Do not attemp to report HCA clock offset on VFs
Date: Wed,  1 Jul 2015 14:31:02 +0300
Message-ID: <1435750262-32210-3-git-send-email-ogerlitz@mellanox.com>
References: <1435750262-32210-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435750262-32210-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx4 VFs can provide CQE raw time-stamping services, but they
don't have the hca core clock mapped to their PCI bars.

As such, we should not attempt to query and report the clock offset
to user space for VFs. Doing so causes query_device over VFs to fail
with -ENOSUPP.

Fixes: 4b664c4355b2 ('IB/mlx4: Add support for CQ time-stamping')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 067a691..f419a72 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -253,14 +253,15 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->hca_core_clock = dev->dev->caps.hca_core_clock * 1000UL;
 	props->timestamp_mask = 0xFFFFFFFFFFFFULL;
 
-	err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-	if (err)
-		goto out;
+	if (!mlx4_is_slave(dev->dev))
+		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
 
 	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
-		resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
 		resp.response_length += sizeof(resp.hca_core_clock_offset);
-		resp.comp_mask |= QUERY_DEVICE_RESP_MASK_TIMESTAMP;
+		if (!err && !mlx4_is_slave(dev->dev)) {
+			resp.comp_mask |= QUERY_DEVICE_RESP_MASK_TIMESTAMP;
+			resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
+		}
 	}
 
 	if (uhw->outlen) {
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
