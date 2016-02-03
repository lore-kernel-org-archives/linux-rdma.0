From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 52/54] staging/rdma/hfi1: Replacement of goto's for
 break/returns
Date: Wed, 03 Feb 2016 14:37:59 -0800
Message-ID: <20160203223755.5923.77914.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It replaces goto's for break and return statements in process_perf_opa().

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   56 +++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 97bdcb7..a315579 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3828,7 +3828,7 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 	if (smp->class_version != OPA_SMI_CLASS_VERSION) {
 		smp->status |= IB_SMP_UNSUP_VERSION;
 		ret = reply((struct ib_mad_hdr *)smp);
-		goto bail;
+		return ret;
 	}
 	ret = check_mkey(ibp, (struct ib_mad_hdr *)smp, mad_flags, smp->mkey,
 			 smp->route.dr.dr_slid, smp->route.dr.return_path,
@@ -3854,7 +3854,7 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 					  smp->route.dr.return_path,
 					  smp->hop_cnt);
 		ret = IB_MAD_RESULT_FAILURE;
-		goto bail;
+		return ret;
 	}
 
 	*resp_len = opa_get_smp_header_size(smp);
@@ -3866,23 +3866,25 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 			clear_opa_smp_data(smp);
 			ret = subn_get_opa_sma(attr_id, smp, am, data,
 					       ibdev, port, resp_len);
-			goto bail;
+			break;
 		case OPA_ATTRIB_ID_AGGREGATE:
 			ret = subn_get_opa_aggregate(smp, ibdev, port,
 						     resp_len);
-			goto bail;
+			break;
 		}
+		break;
 	case IB_MGMT_METHOD_SET:
 		switch (attr_id) {
 		default:
 			ret = subn_set_opa_sma(attr_id, smp, am, data,
 					       ibdev, port, resp_len);
-			goto bail;
+			break;
 		case OPA_ATTRIB_ID_AGGREGATE:
 			ret = subn_set_opa_aggregate(smp, ibdev, port,
 						     resp_len);
-			goto bail;
+			break;
 		}
+		break;
 	case IB_MGMT_METHOD_TRAP:
 	case IB_MGMT_METHOD_REPORT:
 	case IB_MGMT_METHOD_REPORT_RESP:
@@ -3893,13 +3895,13 @@ static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
 		 * Just tell the caller to process it normally.
 		 */
 		ret = IB_MAD_RESULT_SUCCESS;
-		goto bail;
+		break;
 	default:
 		smp->status |= IB_SMP_UNSUP_METHOD;
 		ret = reply((struct ib_mad_hdr *)smp);
+		break;
 	}
 
-bail:
 	return ret;
 }
 
@@ -3915,7 +3917,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 	if (smp->class_version != 1) {
 		smp->status |= IB_SMP_UNSUP_VERSION;
 		ret = reply((struct ib_mad_hdr *)smp);
-		goto bail;
+		return ret;
 	}
 
 	ret = check_mkey(ibp, (struct ib_mad_hdr *)smp, mad_flags,
@@ -3942,7 +3944,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 					  (__force __be32)smp->dr_slid,
 					  smp->return_path, smp->hop_cnt);
 		ret = IB_MAD_RESULT_FAILURE;
-		goto bail;
+		return ret;
 	}
 
 	switch (smp->method) {
@@ -3950,15 +3952,15 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 		switch (smp->attr_id) {
 		case IB_SMP_ATTR_NODE_INFO:
 			ret = subn_get_nodeinfo(smp, ibdev, port);
-			goto bail;
+			break;
 		default:
 			smp->status |= IB_SMP_UNSUP_METH_ATTR;
 			ret = reply((struct ib_mad_hdr *)smp);
-			goto bail;
+			break;
 		}
+		break;
 	}
 
-bail:
 	return ret;
 }
 
@@ -3983,44 +3985,46 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
 		switch (pmp->mad_hdr.attr_id) {
 		case IB_PMA_CLASS_PORT_INFO:
 			ret = pma_get_opa_classportinfo(pmp, ibdev, resp_len);
-			goto bail;
+			break;
 		case OPA_PM_ATTRIB_ID_PORT_STATUS:
 			ret = pma_get_opa_portstatus(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		case OPA_PM_ATTRIB_ID_DATA_PORT_COUNTERS:
 			ret = pma_get_opa_datacounters(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		case OPA_PM_ATTRIB_ID_ERROR_PORT_COUNTERS:
 			ret = pma_get_opa_porterrors(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		case OPA_PM_ATTRIB_ID_ERROR_INFO:
 			ret = pma_get_opa_errorinfo(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		default:
 			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
 			ret = reply((struct ib_mad_hdr *)pmp);
-			goto bail;
+			break;
 		}
+		break;
 
 	case IB_MGMT_METHOD_SET:
 		switch (pmp->mad_hdr.attr_id) {
 		case OPA_PM_ATTRIB_ID_CLEAR_PORT_STATUS:
 			ret = pma_set_opa_portstatus(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		case OPA_PM_ATTRIB_ID_ERROR_INFO:
 			ret = pma_set_opa_errorinfo(pmp, ibdev, port,
 								resp_len);
-			goto bail;
+			break;
 		default:
 			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
 			ret = reply((struct ib_mad_hdr *)pmp);
-			goto bail;
+			break;
 		}
+		break;
 
 	case IB_MGMT_METHOD_TRAP:
 	case IB_MGMT_METHOD_GET_RESP:
@@ -4030,14 +4034,14 @@ static int process_perf_opa(struct ib_device *ibdev, u8 port,
 		 * Just tell the caller to process it normally.
 		 */
 		ret = IB_MAD_RESULT_SUCCESS;
-		goto bail;
+		break;
 
 	default:
 		pmp->mad_hdr.status |= IB_SMP_UNSUP_METHOD;
 		ret = reply((struct ib_mad_hdr *)pmp);
+		break;
 	}
 
-bail:
 	return ret;
 }
 
@@ -4102,12 +4106,12 @@ static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
 	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
 		ret = process_subn(ibdev, mad_flags, port, in_mad, out_mad);
-		goto bail;
+		break;
 	default:
 		ret = IB_MAD_RESULT_SUCCESS;
+		break;
 	}
 
-bail:
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
