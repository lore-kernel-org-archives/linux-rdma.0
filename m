From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] i40iw: Add missing memory barrier
Date: Fri, 23 Jun 2017 16:04:00 -0500
Message-ID: <20170623210402.19988-7-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add missing write memory barrier before writing the
header containing valid bit to the WQE in i40iw_puda_send.

Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_puda.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
index db41ab4..1bb1681 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.c
@@ -408,6 +408,9 @@ enum i40iw_status_code i40iw_puda_send(struct i40iw_sc_qp *qp,
 	set_64bit_val(wqe, 0, info->paddr);
 	set_64bit_val(wqe, 8, LS_64(info->len, I40IWQPSQ_FRAG_LEN));
 	set_64bit_val(wqe, 16, header[0]);
+
+	/* Ensure all data is written before writing valid bit */
+	wmb();
 	set_64bit_val(wqe, 24, header[1]);
 
 	i40iw_debug_buf(qp->dev, I40IW_DEBUG_PUDA, "PUDA SEND WQE", wqe, 32);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
