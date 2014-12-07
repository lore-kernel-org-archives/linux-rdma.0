From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 12/16] IB/iser: Use more completion queues
Date: Sun,  7 Dec 2014 16:10:03 +0200
Message-ID: <1417961407-10139-13-git-send-email-ogerlitz@mellanox.com>
References: <1417961407-10139-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417961407-10139-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

No reason to settle with four, can use the min between
device max comp vectors and number of cores.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    4 +---
 drivers/infiniband/ulp/iser/iser_verbs.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index e34263c..4234a9c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -326,8 +326,6 @@ struct iser_rx_desc {
 	char		             pad[ISER_RX_PAD_SIZE];
 } __attribute__((packed));
 
-#define ISER_MAX_CQ 4
-
 struct iser_conn;
 struct ib_conn;
 struct iscsi_iser_task;
@@ -378,7 +376,7 @@ struct iser_device {
 	struct list_head             ig_list;
 	int                          refcount;
 	int			     comps_used;
-	struct iser_comp	     comps[ISER_MAX_CQ];
+	struct iser_comp	     *comps;
 	int                          (*iser_alloc_rdma_reg_res)(struct ib_conn *ib_conn,
 								unsigned cmds_max);
 	void                         (*iser_free_rdma_reg_res)(struct ib_conn *ib_conn);
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ad493d2..5d69927 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -104,9 +104,14 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		return -1;
 	}
 
-	device->comps_used = min(ISER_MAX_CQ,
+	device->comps_used = min_t(int, num_online_cpus(),
 				 device->ib_device->num_comp_vectors);
 
+	device->comps = kcalloc(device->comps_used, sizeof(*device->comps),
+				GFP_KERNEL);
+	if (!device->comps)
+		goto comps_err;
+
 	max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
 
 	iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
@@ -165,6 +170,8 @@ cq_err:
 	}
 	ib_dealloc_pd(device->pd);
 pd_err:
+	kfree(device->comps);
+comps_err:
 	iser_err("failed to allocate an IB resource\n");
 	return -1;
 }
@@ -190,6 +197,9 @@ static void iser_free_device_ib_res(struct iser_device *device)
 	(void)ib_dereg_mr(device->mr);
 	(void)ib_dealloc_pd(device->pd);
 
+	kfree(device->comps);
+	device->comps = NULL;
+
 	device->mr = NULL;
 	device->pd = NULL;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
