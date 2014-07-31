From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/8] IB/iser: Seperate iser_conn and iscsi_endpoint storage space
Date: Thu, 31 Jul 2014 13:27:47 +0300
Message-ID: <1406802471-23359-5-git-send-email-ogerlitz@mellanox.com>
References: <1406802471-23359-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406802471-23359-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

iser connection needs asynchronous cleanup completions which are triggered in
ep_disconnect. As a result we are keeping the corresponding iscsi_endpoint
structure hanging for no good reason. In order to avoid that, we seperate
iser_conn from iscsi_endpoint storage space to have their destruction being
independent.

iscsi_endpoint will be destroyed at ep_disconnect stage, while the iser connection
will wait for asynchronous completions to be released in an orderly fashion.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   16 +++++++++++++---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1a53fd2..d7acd4b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -596,19 +596,28 @@ iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct iser_conn *ib_conn;
 	struct iscsi_endpoint *ep;
 
-	ep = iscsi_create_endpoint(sizeof(*ib_conn));
+	ep = iscsi_create_endpoint(0);
 	if (!ep)
 		return ERR_PTR(-ENOMEM);
 
-	ib_conn = ep->dd_data;
+	ib_conn = kzalloc(sizeof(*ib_conn), GFP_KERNEL);
+	if (!ib_conn) {
+		err = -ENOMEM;
+		goto failure;
+	}
+
+	ep->dd_data = ib_conn;
 	ib_conn->ep = ep;
 	iser_conn_init(ib_conn);
 
 	err = iser_connect(ib_conn, NULL, dst_addr, non_blocking);
 	if (err)
-		return ERR_PTR(err);
+		goto failure;
 
 	return ep;
+failure:
+	iscsi_destroy_endpoint(ep);
+	return ERR_PTR(err);
 }
 
 static int
@@ -658,6 +667,7 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 	} else {
 		iser_conn_release(ib_conn);
 	}
+	iscsi_destroy_endpoint(ep);
 }
 
 static umode_t iser_attr_is_visible(int param_type, int param)
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6c7d8ce..fffb4ac 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -620,7 +620,7 @@ void iser_conn_release(struct iser_conn *ib_conn)
 		rdma_destroy_id(ib_conn->cma_id);
 		ib_conn->cma_id = NULL;
 	}
-	iscsi_destroy_endpoint(ib_conn->ep);
+	kfree(ib_conn);
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
