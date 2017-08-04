From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 27/27] IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi
 driver to support extended LIDs
Date: Fri, 04 Aug 2017 13:54:53 -0700
Message-ID: <20170804205452.17853.27563.stgit@scvm10.sc.intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804204842.17853.14858.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Enabling this bit helps core components query for extended address
support using the rdma_cap_opa_ah interface.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index eee2320..e340b02 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1912,7 +1912,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.dparms.psn_mask = PSN_MASK;
 	dd->verbs_dev.rdi.dparms.psn_shift = PSN_SHIFT;
 	dd->verbs_dev.rdi.dparms.psn_modify_mask = PSN_MODIFY_MASK;
-	dd->verbs_dev.rdi.dparms.core_cap_flags = RDMA_CORE_PORT_INTEL_OPA;
+	dd->verbs_dev.rdi.dparms.core_cap_flags = RDMA_CORE_PORT_INTEL_OPA |
+						RDMA_CORE_CAP_OPA_AH;
 	dd->verbs_dev.rdi.dparms.max_mad_size = OPA_MGMT_MAD_SIZE;
 
 	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
