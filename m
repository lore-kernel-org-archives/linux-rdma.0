From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/7] IB/rdmavt: Allow reserving just one qpn
Date: Fri, 22 Jan 2016 12:50:30 -0800
Message-ID: <20160122205029.4351.71451.stgit@scvm10.sc.intel.com>
References: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204807.4351.24569.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

qib needs to reserve only one qpn for non-verbs stuff. Also fixed the for
loop to reserve the end qpn.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 44485ad..ee19eae 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -79,7 +79,7 @@ static int init_qpn_table(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt)
 	struct rvt_qpn_map *map;
 	int ret = 0;
 
-	if (!(rdi->dparms.qpn_res_end > rdi->dparms.qpn_res_start))
+	if (!(rdi->dparms.qpn_res_end >= rdi->dparms.qpn_res_start))
 		return -EINVAL;
 
 	spin_lock_init(&qpt->lock);
@@ -105,7 +105,7 @@ static int init_qpn_table(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt)
 
 	rvt_pr_info(rdi, "Reserving QPNs from 0x%x to 0x%x for non-verbs use\n",
 		    rdi->dparms.qpn_res_start, rdi->dparms.qpn_res_end);
-	for (i = rdi->dparms.qpn_res_start; i < rdi->dparms.qpn_res_end; i++) {
+	for (i = rdi->dparms.qpn_res_start; i <= rdi->dparms.qpn_res_end; i++) {
 		if (!map->page) {
 			get_map_page(qpt, map);
 			if (!map->page) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
