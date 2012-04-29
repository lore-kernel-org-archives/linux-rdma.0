From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/7] IB/iser: Fix buggy error flow in iser ep connection establishment
Date: Sun, 29 Apr 2012 17:04:21 +0300
Message-ID: <1335708267-30284-2-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current error flow code was releasing the IB connection object and
calling iscsi_destroy_endpoint directly without going through the
reference counting mechanism introduced in commit 39ff05d "IB/iser:
Enhance disconnection logic for multi-pathing". This resulted in double
free of the iscsi endpoint object that caused kernel NULL pointer dereference.
Fix that by plugging correctly to the IB conn reference counting.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    5 ++---
 drivers/infiniband/ulp/iser/iser_verbs.c |    3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index db43b31..0ab8c9c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -573,10 +573,9 @@ iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	err = iser_connect(ib_conn, NULL, (struct sockaddr_in *)dst_addr,
 			   non_blocking);
-	if (err) {
-		iscsi_destroy_endpoint(ep);
+	if (err)
 		return ERR_PTR(err);
-	}
+
 	return ep;
 }
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 14224ba..2dddabd 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -613,8 +613,9 @@ id_failure:
 	ib_conn->cma_id = NULL;
 addr_failure:
 	ib_conn->state = ISER_CONN_DOWN;
+	iser_conn_put(ib_conn, 1); /* deref ib conn's cma id */
 connect_failure:
-	iser_conn_release(ib_conn, 1);
+	iser_conn_put(ib_conn, 1); /* deref ib conn deallocate */
 	return err;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
