From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 05/18] IB/rxe: Initialize ib_ah_attr during query_ah
Date: Sat, 29 Apr 2017 14:41:17 -0400
Message-ID: <1493491290-31621-6-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Zero out ib_ah_attr before calling query_ah. Set ah_flags
appropriately.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 604f6fe..88a4a7f 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -69,6 +69,7 @@ int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
 		   struct ib_ah_attr *attr)
 {
 	memcpy(&attr->grh, &av->grh, sizeof(av->grh));
+	attr->ah_flags = IB_AH_GRH;
 	attr->port_num = av->port_num;
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index dbede30..b35201d 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -378,6 +378,7 @@ static int rxe_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
 	struct rxe_dev *rxe = to_rdev(ibah->device);
 	struct rxe_ah *ah = to_rah(ibah);
 
+	memset(attr, 0, sizeof(*attr));
 	rxe_av_to_attr(rxe, &ah->av, attr);
 	return 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
