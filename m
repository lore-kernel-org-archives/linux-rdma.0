From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH, RFC] mlx4_ib: Make steering support independent of
 MLX4_BMME_FLAG_TYPE_2_WIN
Date: Wed, 1 Jun 2016 17:07:17 -0700
Message-ID: <2a929a48-559e-41ad-c42e-a722801c11d0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

Can anyone who is familiar with the mlx4 driver tell me whether or not
the patch below makes sense? I ran into this code by analyzing the mlx4
source code with smatch.

Thanks,

Bart.

---
 drivers/infiniband/hw/mlx4/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b01ef6e..db7d0bc 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -505,9 +505,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		else
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
+	}
 	if (dev->steering_support ==  MLX4_STEERING_MODE_DEVICE_MANAGED)
 		props->device_cap_flags |= IB_DEVICE_MANAGED_FLOW_STEERING;
-	}
 
 	props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
