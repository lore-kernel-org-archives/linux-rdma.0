From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/mlx4: Fix device managed flow steering support test
Date: Fri, 3 Jun 2016 07:58:32 -0700
Message-ID: <33c3370d-3568-a9aa-906f-683b0e1b1a5f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Perform the test for device managed flow steering support even if
memory windows are not supported. I noticed this because smatch
reported inconsistent indentation for the device managed flow
steering support test.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b01ef6e..0eb09e1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -505,9 +505,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		else
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
-	if (dev->steering_support ==  MLX4_STEERING_MODE_DEVICE_MANAGED)
-		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 	}
+	if (dev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED)
+		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
 
 	props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
