From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.11 3/3] rdma/cm: Only call cma_save_ib_info for CM REQs
Date: Wed, 24 Jul 2013 15:06:09 -0700
Message-ID: <1374703569-16668-4-git-send-email-sean.hefty@intel.com>
References: <1374703569-16668-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374703569-16668-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Calling cma_save_ib_info for CM SIDR REQs results in a crash
accessing an invalid path record pointer.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 4314655..7c0f953 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -879,7 +879,8 @@ static int cma_save_net_info(struct rdma_cm_id *id, struct rdma_cm_id *listen_id
 {
 	struct cma_hdr *hdr;
 
-	if (listen_id->route.addr.src_addr.ss_family == AF_IB) {
+	if ((listen_id->route.addr.src_addr.ss_family == AF_IB) &&
+	    (ib_event->event == IB_CM_REQ_RECEIVED)) {
 		cma_save_ib_info(id, listen_id, ib_event->param.req_rcvd.primary_path);
 		return 0;
 	}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
