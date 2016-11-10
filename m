From: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] i40iw: Remove variable flush_code and check to set
 qp->sq_flush
Date: Thu, 10 Nov 2016 04:17:29 +0000
Message-ID: <7F6CD2AB1343D04CBA3B1EDA4144D73897368DFB@fmsmsx118.amr.corp.intel.com>
References: <20161110034207.18016-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161110034207.18016-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please disregard this one. Accidently sent this one as part of a series.

-----Original Message-----
From: Orosco, Henry 
Sent: Wednesday, November 09, 2016 9:42 PM
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Orosco, Henry <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] i40iw: Remove variable flush_code and check to set qp->sq_flush

The flush_code variable in i40iw_bld_terminate_hdr() is obsolete and the check to set qp->sq_flush is unreachable. Currently flush code is populated in setup_term_hdr() and both SQ and RQ are flushed always as part of the tear down flow.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
index cd71444..57a4236 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
@@ -4045,7 +4045,6 @@ static int i40iw_bld_terminate_hdr(struct i40iw_sc_qp *qp,
 	u16 ddp_seg_len;
 	int copy_len = 0;
 	u8 is_tagged = 0;
-	enum i40iw_flush_opcode flush_code = FLUSH_INVALID;
 	u32 opcode;
 	struct i40iw_terminate_hdr *termhdr;
 
@@ -4218,9 +4217,6 @@ static int i40iw_bld_terminate_hdr(struct i40iw_sc_qp *qp,
 	if (copy_len)
 		memcpy(termhdr + 1, pkt, copy_len);
 
-	if (flush_code && !info->in_rdrsp_wr)
-		qp->sq_flush = (info->sq) ? true : false;
-
 	return sizeof(struct i40iw_terminate_hdr) + copy_len;  }
 
--
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
