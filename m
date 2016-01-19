From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/31] staging/rdma/hfi1: Add basic rdmavt capability flags
 for hfi1
Date: Tue, 19 Jan 2016 14:41:39 -0800
Message-ID: <20160119224138.32765.95149.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Most functionality is still being done in the driver, set flags so that
rdmavt will let hfi1 continue to handle mr, qp, and cq init.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 0692ec4..5e21132 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2074,6 +2074,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
+	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
+				   RVT_FLAG_QP_INIT_DRIVER |
+				   RVT_FLAG_CQ_INIT_DRIVER);
 
 	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
