From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/9] IB/core: add a need_inval flag to struct ib_mr
Date: Mon, 29 Feb 2016 23:20:07 +0100
Message-ID: <1456784410-20166-7-git-send-email-hch@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@chelsio.com>

This is the first step toward moving MR invalidation decisions
to the core.  It will be needed by the upcoming RW API.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 include/rdma/ib_verbs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1e68dae..2b94cea 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1431,6 +1431,7 @@ struct ib_mr {
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
+	bool		   need_inval;
 	union {
 		struct ib_uobject	*uobject;	/* user */
 		struct list_head	qp_entry;	/* FR */
-- 
2.1.4
