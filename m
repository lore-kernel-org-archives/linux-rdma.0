From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/hfi1: Use 4096 for default active MTU in
 query_qp
Date: Tue, 14 Nov 2017 04:34:45 -0800
Message-ID: <20171114123443.10579.31606.stgit@scvm10.sc.intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114122859.10579.79788.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, if a port is queried that has an invalid
Maximum Transmission Unit, driver reports default MTU of 2048.
This in incorrect.

Use default value of 4096 if invalid.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index a38785e..6d27c85 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1486,7 +1486,7 @@ static int query_port(struct rvt_dev_info *rdi, u8 port_num,
 	props->max_mtu = mtu_to_enum((!valid_ib_mtu(hfi1_max_mtu) ?
 				      4096 : hfi1_max_mtu), IB_MTU_4096);
 	props->active_mtu = !valid_ib_mtu(ppd->ibmtu) ? props->max_mtu :
-		mtu_to_enum(ppd->ibmtu, IB_MTU_2048);
+		mtu_to_enum(ppd->ibmtu, IB_MTU_4096);
 
 	/*
 	 * sm_lid of 0xFFFF needs special handling so that it can

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
