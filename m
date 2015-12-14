From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 02/15] IB/hfi1: Add basic rdmavt capability flags for
 hfi1
Date: Mon, 14 Dec 2015 12:28:04 -0500
Message-ID: <20151214172803.11576.12983.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Most functionality is still being done in the driver, set flags so that
rdmavt will let hfi1 continue to handle mr, qp, and cq init.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 4292d52..c457e82 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -2075,6 +2075,9 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
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
