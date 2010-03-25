From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [for-2.6.34] rdma/cm: set num_paths when manually assigning path records
Date: Thu, 25 Mar 2010 12:12:36 -0700
Message-ID: <3946EFA63D2D4C2A93F45CF7CD715B5C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When manually assigning the path records to use for a connection,
save the number of paths that were saved.  Otherwise, checks
against num_path will show 0, even though path record data is
available.

This was discovered by manually setting the path records from
user space, then querying the kernel to see if the correct
path records were assigned, only to discover that the kernel
returned 0 path records to the query.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 42d51b5..38906f2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1783,6 +1783,7 @@ int rdma_set_ib_paths(struct rdma_cm_id *id,
 	}
 
 	memcpy(id->route.path_rec, path_rec, sizeof *path_rec * num_paths);
+	id->route.num_paths = num_paths;
 	return 0;
 err:
 	cma_comp_exch(id_priv, CMA_ROUTE_RESOLVED, CMA_ADDR_RESOLVED);



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
