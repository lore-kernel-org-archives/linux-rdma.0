From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v9 3/4] IB/sa: Allocate SA query with kzalloc
Date: Fri, 14 Aug 2015 08:52:08 -0400
Message-ID: <1439556729-27876-4-git-send-email-kaike.wan@intel.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439556729-27876-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Replace kmalloc with kzalloc so that all uninitialized fields in SA query
will be zero-ed out to avoid unintentional consequence. This prepares the
SA query structure to accept new fields in the future.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index d40be36..968c66f 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -740,7 +740,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -862,7 +862,7 @@ int ib_sa_service_rec_query(struct ib_sa_client *client,
 	    method != IB_SA_METHOD_DELETE)
 		return -EINVAL;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -954,7 +954,7 @@ int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -1051,7 +1051,7 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
