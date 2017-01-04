From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv2 1/1] IB/srp: fix invalid indirect_sg_entries parameter value
Date: Wed,  4 Jan 2017 15:59:37 +0200
Message-ID: <1483538377-19379-2-git-send-email-maxg@mellanox.com>
References: <1483538377-19379-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483538377-19379-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

After setting indirect_sg_entries module_param to huge value (e.g 500,000),
srp_alloc_req_data() fails to allocate indirect descriptors for the request
ring (kmalloc fails). This commit enforces the maximum value of indirect_sg_entries
to be SG_MAX_SEGMENTS as signified in module param description.

Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0f67cf9..79bf484 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3699,6 +3699,12 @@ static int __init srp_init_module(void)
 		indirect_sg_entries = cmd_sg_entries;
 	}
 
+	if (indirect_sg_entries > SG_MAX_SEGMENTS) {
+		pr_warn("Clamping indirect_sg_entries to %u\n",
+			SG_MAX_SEGMENTS);
+		indirect_sg_entries = SG_MAX_SEGMENTS;
+	}
+
 	srp_remove_wq = create_workqueue("srp_remove");
 	if (!srp_remove_wq) {
 		ret = -ENOMEM;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
