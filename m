From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/4] mpxyd: log warning if running in COMPAT mode
Date: Fri, 12 Dec 2014 08:50:42 -0800
Message-ID: <1418403043-2221-4-git-send-email-arlin.r.davis@intel.com>
References: <1418403043-2221-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418403043-2221-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/svc/mcm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/dapl/svc/mcm.c b/dapl/svc/mcm.c
index 6f1cff3..c36948a 100644
--- a/dapl/svc/mcm.c
+++ b/dapl/svc/mcm.c
@@ -283,11 +283,12 @@ int mcm_init_cm_service(mcm_ib_dev_t *md)
 	/* save qp_num as part of ia_address, network order */
 	md->addr.qpn = htonl(md->qp->qp_num);
 
-	mlog(0, " IB LID 0x%x PORT %d GID %s QPN 0x%x: mic%d -> %s - %s, mic_ver %d\n",
+	mlog(0, " IB LID 0x%x PORT %d GID %s QPN 0x%x: mic%d -> %s - %s, mic_ver %d %s\n",
 		ntohs(md->addr.lid), md->port,
 		inet_ntop(AF_INET6, md->addr.gid, gid_str, sizeof(gid_str)),
 		md->qp->qp_num, md->mc->scif_id - 1, md->ibdev->name,
-	        md->addr.ep_map == MIC_SSOCK_DEV ? "MSS":"MXS", md->mc->ver);
+	        md->addr.ep_map == MIC_SSOCK_DEV ? "MSS":"MXS", md->mc->ver,
+	        md->mc->ver == MIX_COMP ? "WARN: OLD MPSS -> RUN COMP MODE":"");
 
 	return 0;
 bail:
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
