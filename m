From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/8] IB/rdmavt: Use kzalloc_node
Date: Thu, 19 May 2016 05:21:31 -0700
Message-ID: <20160519122130.30706.89609.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use kzalloc_node instead of kzalloc for rdmavt memory region segment
allocation to optimize for performance on NUMA platforms.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 0ff765b..0f4d450 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -124,11 +124,13 @@ static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
 			    int count)
 {
 	int m, i = 0;
+	struct rvt_dev_info *dev = ib_to_rvt(pd->device);
 
 	mr->mapsz = 0;
 	m = (count + RVT_SEGSZ - 1) / RVT_SEGSZ;
 	for (; i < m; i++) {
-		mr->map[i] = kzalloc(sizeof(*mr->map[0]), GFP_KERNEL);
+		mr->map[i] = kzalloc_node(sizeof(*mr->map[0]), GFP_KERNEL,
+					  dev->dparms.node);
 		if (!mr->map[i]) {
 			rvt_deinit_mregion(mr);
 			return -ENOMEM;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
