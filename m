From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 10/11] IB/srpt: Increase lid and sm_lid to 32 bits
Date: Fri, 23 Sep 2016 13:44:33 -0400
Message-ID: <1474652674-13110-11-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

srpt contains lid and sm_lid fields which are 16 bits in
length, increase them to 32 bits.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c14071afc78a..883bbfe08e0e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -514,8 +514,8 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		goto err_query_port;
 
-	sport->sm_lid = (u16)port_attr.sm_lid;
-	sport->lid = (u16)port_attr.lid;
+	sport->sm_lid = port_attr.sm_lid;
+	sport->lid = port_attr.lid;
 
 	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
 			   NULL);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 581878782854..580bb75a8815 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -322,8 +322,8 @@ struct srpt_port {
 	bool			enabled;
 	u8			port_guid[64];
 	u8			port;
-	u16			sm_lid;
-	u16			lid;
+	u32			sm_lid;
+	u32			lid;
 	union ib_gid		gid;
 	struct work_struct	work;
 	struct se_portal_group	port_tpg_1;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
