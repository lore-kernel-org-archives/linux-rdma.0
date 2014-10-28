From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes for-3.18 2/6] IB/iser: Fix catas error flow hang
Date: Tue, 28 Oct 2014 11:49:09 +0200
Message-ID: <1414489753-29199-3-git-send-email-ogerlitz@mellanox.com>
References: <1414489753-29199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414489753-29199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of the HCA going into catasrophic error flow, the
beacon post_send is likely to fail, so surely there will
be no completion for it.

In this case, use a best effort approach and don't wait for
beacon completion if we failed to post send it.

Reported-by: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 2ccbc64..7f78af5 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -677,8 +677,10 @@ int iser_conn_terminate(struct iser_conn *iser_conn)
 
 		/* post an indication that all flush errors were consumed */
 		err = ib_post_send(ib_conn->qp, &ib_conn->beacon, &bad_wr);
-		if (err)
+		if (err) {
 			iser_err("conn %p failed to post beacon", ib_conn);
+			return 1;
+		}
 
 		wait_for_completion(&ib_conn->flush_comp);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
