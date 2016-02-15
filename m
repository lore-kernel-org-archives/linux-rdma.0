From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/21] staging/rdma/hfi1: Remove unnecessary parentheses
Date: Sun, 14 Feb 2016 20:20:33 -0800
Message-ID: <20160215042030.351.24464.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove unnecessary parentheses around addressof single $Lvals to fix
checkpatch check:
CHECK: Unnecessary parentheses around $var

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index ae594f4..36bd6fa 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2416,7 +2416,7 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	tmp = read_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL);
 	rsp->uncorrectable_errors = tmp < 0x100 ? (tmp & 0xff) : 0xff;
 
-	vlinfo = &(rsp->vls[0]);
+	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	/* The vl_select_mask has been checked above, and we know
 	 * that it contains only entries which represent valid VLs.
@@ -2609,7 +2609,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		return reply((struct ib_mad_hdr *)pmp);
 	}
 
-	rsp = (struct _port_dctrs *)&(req->port[0]);
+	rsp = (struct _port_dctrs *)&req->port[0];
 	memset(rsp, 0, sizeof(*rsp));
 
 	rsp->port_number = port;
@@ -2632,7 +2632,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		cpu_to_be64(get_error_counter_summary(ibdev, port,
 						      res_lli, res_ler));
 
-	vlinfo = &(rsp->vls[0]);
+	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	/* The vl_select_mask has been checked above, and we know
 	 * that it contains only entries which represent valid VLs.
@@ -2816,7 +2816,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 		return reply((struct ib_mad_hdr *)pmp);
 	}
 
-	rsp = (struct _port_ectrs *)&(req->port[0]);
+	rsp = (struct _port_ectrs *)&req->port[0];
 
 	ibp = to_iport(ibdev, port_num);
 	ppd = ppd_from_ibp(ibp);
@@ -2836,7 +2836,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 
 	rsp->uncorrectable_errors = tmp < 0x100 ? (tmp & 0xff) : 0xff;
 
-	vlinfo = (struct _vls_ectrs *)&(rsp->vls[0]);
+	vlinfo = (struct _vls_ectrs *)&rsp->vls[0];
 	vfi = 0;
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
 	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
@@ -2952,7 +2952,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	u64 reg;
 
 	req = (struct opa_port_error_info_msg *)pmp->data;
-	rsp = (struct _port_ei *)&(req->port[0]);
+	rsp = (struct _port_ei *)&req->port[0];
 
 	num_ports = OPA_AM_NPORT(be32_to_cpu(pmp->mad_hdr.attr_mod));
 	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));
@@ -3192,7 +3192,7 @@ static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 	u32 error_info_select;
 
 	req = (struct opa_port_error_info_msg *)pmp->data;
-	rsp = (struct _port_ei *)&(req->port[0]);
+	rsp = (struct _port_ei *)&req->port[0];
 
 	num_ports = OPA_AM_NPORT(be32_to_cpu(pmp->mad_hdr.attr_mod));
 	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
