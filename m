From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/6] RDMA/cma: Fix returning correct path record entry for RoCE
Date: Mon,  8 Jan 2018 17:04:48 +0200
Message-ID: <20180108150448.29069-7-leon@kernel.org>
References: <20180108150448.29069-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108150448.29069-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are 4 types of path records IB, OPA, RoCEv1, RoCEv2.
Recent change only considered two path records - IB and OPA.
This results into converting RoCE path records as OPA and returning
garbage data in path record entry.
This incorrect decoding broke applications using RoCE transport.
IB, RoCEv1 and RoCEv2 are identical path records to user.
This patch avoids decoding RoCE(v1,v2) path record as OPA path record.

Fixes: 57520751445b ("IB/SA: Add OPA path record type")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 7b25226b608e..29a81e6cfc96 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -904,13 +904,14 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 
 		resp->path_data[i].flags = IB_PATH_GMP | IB_PATH_PRIMARY |
 					   IB_PATH_BIDIRECTIONAL;
-		if (rec->rec_type == SA_PATH_REC_TYPE_IB) {
-			ib_sa_pack_path(rec, &resp->path_data[i].path_rec);
-		} else {
+		if (rec->rec_type == SA_PATH_REC_TYPE_OPA) {
 			struct sa_path_rec ib;
 
 			sa_convert_path_opa_to_ib(&ib, rec);
 			ib_sa_pack_path(&ib, &resp->path_data[i].path_rec);
+
+		} else {
+			ib_sa_pack_path(rec, &resp->path_data[i].path_rec);
 		}
 	}
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
