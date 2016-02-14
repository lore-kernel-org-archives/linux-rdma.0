From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/12] IB/qib,rdmavt: Move smi_ah to qib
Date: Sun, 14 Feb 2016 12:10:55 -0800
Message-ID: <20160214201050.1410.7572.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rdmavt adopted an smi_ah from qib which is not needed by hfi1. Move this
back to qib and get it out of the common library.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   10 +++++-----
 drivers/infiniband/hw/qib/qib_verbs.h   |    1 +
 include/rdma/rdma_vt.h                  |    1 -
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index a159922..ca28c19 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2910,8 +2910,8 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 			spin_unlock_irqrestore(&dd->cspec->gpio_lock, flags);
 			qib_qsfp_deinit(&dd->pport[i].cpspec->qsfp_data);
 		}
-		if (dd->pport[i].ibport_data.rvp.smi_ah)
-			ib_destroy_ah(&dd->pport[i].ibport_data.rvp.smi_ah->ibah);
+		if (dd->pport[i].ibport_data.smi_ah)
+			ib_destroy_ah(&dd->pport[i].ibport_data.smi_ah->ibah);
 	}
 }
 
@@ -5507,7 +5507,7 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 	if (IS_ERR(send_buf))
 		goto retry;
 
-	if (!ibp->rvp.smi_ah) {
+	if (!ibp->smi_ah) {
 		struct ib_ah *ah;
 
 		ah = qib_create_qp0_ah(ibp, be16_to_cpu(IB_LID_PERMISSIVE));
@@ -5515,11 +5515,11 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 			ret = PTR_ERR(ah);
 		else {
 			send_buf->ah = ah;
-			ibp->rvp.smi_ah = ibah_to_rvtah(ah);
+			ibp->smi_ah = ibah_to_rvtah(ah);
 			ret = 0;
 		}
 	} else {
-		send_buf->ah = &ibp->rvp.smi_ah->ibah;
+		send_buf->ah = &ibp->smi_ah->ibah;
 		ret = 0;
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index d137d71..4b76a8d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -219,6 +219,7 @@ struct qib_pma_counters {
 
 struct qib_ibport {
 	struct rvt_ibport rvp;
+	struct rvt_ah *smi_ah;
 	__be64 guids[QIB_GUIDS_PER_PORT	- 1];	/* writable GUIDs */
 	struct qib_pma_counters __percpu *pmastats;
 	u64 z_unicast_xmit;     /* starting count for PMA */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index ec658d8..2c3a04c 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -137,7 +137,6 @@ struct rvt_ibport {
 	u16 *pkey_table;
 
 	struct rvt_ah *sm_ah;
-	struct rvt_ah *smi_ah;
 };
 
 #define RVT_CQN_MAX 16 /* maximum length of cq name */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
