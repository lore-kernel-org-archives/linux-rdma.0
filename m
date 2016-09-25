From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/13] IB/hfi1: Increase default settings of max_cqes and
 max_qps
Date: Sun, 25 Sep 2016 07:41:18 -0700
Message-ID: <20160925144116.10261.70434.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ib_write_bw test allows using up to 16384 QPs. When a relatively
large number of QPs (within that range) is used, the test can fail
because the number of CQ entries needed exceeds the limit set by the
driver.

This patch increases the default setting of max_cqes from 0x2FFFF
(196607) to 0x2FFFFF(3145727), which is sufficient to cover the
maximum number needed by the ib_write_bw test (2097152). The default
setting of max_qps is also increased from 16384 to 32768 to allow
the test to run successfully with 16383 or 16384 QPs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 0a0e93e..1f19334 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -76,7 +76,7 @@ static unsigned int hfi1_max_ahs = 0xFFFF;
 module_param_named(max_ahs, hfi1_max_ahs, uint, S_IRUGO);
 MODULE_PARM_DESC(max_ahs, "Maximum number of address handles to support");
 
-unsigned int hfi1_max_cqes = 0x2FFFF;
+unsigned int hfi1_max_cqes = 0x2FFFFF;
 module_param_named(max_cqes, hfi1_max_cqes, uint, S_IRUGO);
 MODULE_PARM_DESC(max_cqes,
 		 "Maximum number of completion queue entries to support");
@@ -89,7 +89,7 @@ unsigned int hfi1_max_qp_wrs = 0x3FFF;
 module_param_named(max_qp_wrs, hfi1_max_qp_wrs, uint, S_IRUGO);
 MODULE_PARM_DESC(max_qp_wrs, "Maximum number of QP WRs to support");
 
-unsigned int hfi1_max_qps = 16384;
+unsigned int hfi1_max_qps = 32768;
 module_param_named(max_qps, hfi1_max_qps, uint, S_IRUGO);
 MODULE_PARM_DESC(max_qps, "Maximum number of QPs to support");
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
