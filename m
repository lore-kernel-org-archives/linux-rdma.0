From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/nes: Neaten nes_alloc_mw
Date: Mon,  6 Mar 2017 16:34:08 -0800
Message-ID: <72ea61362cbbd596fbf395ef32c63b64b62cddb8.1488845045.git.joe@perches.com>
References: <1488825451.2210.14.camel@perches.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488825451.2210.14.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Convert the function to follow more typical kernel style.

Use an error return block instead of individual returns.

Reduces the object code size a trivial amount.
$ size drivers/infiniband/hw/nes/nes_verbs.o*
   text	   data	    bss	    dec	    hex	filename
  26864	     96	     12	  26972	   695c	drivers/infiniband/hw/nes/nes_verbs.o.new
  26932	     96	     12	  27040	   69a0	drivers/infiniband/hw/nes/nes_verbs.o.old

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---

Markus, please try to improve the code for
human readers instead of doing these mechanical
conversions.

Something like the below seems nicer to me.

I hope one day it'll seem nicer to you too
and you make the effort to understand and
then fix the code style a little more than
doing those apparently completely mindless
conversions.

 drivers/infiniband/hw/nes/nes_verbs.c | 73 ++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ccf0a4cffe9c..5fe5af39f834 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -86,15 +86,15 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
 	next_stag_index %= nesadapter->max_mr;
 
 	ret = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
-			nesadapter->max_mr, &stag_index, &next_stag_index, NES_RESOURCE_MW);
-	if (ret) {
+				 nesadapter->max_mr, &stag_index,
+				 &next_stag_index, NES_RESOURCE_MW);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	nesmr = kzalloc(sizeof(*nesmr), GFP_KERNEL);
 	if (!nesmr) {
-		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err_free_res;
 	}
 
 	stag = stag_index << 8;
@@ -102,49 +102,55 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
 	stag += (u32)stag_key;
 
 	nes_debug(NES_DBG_MR, "Registering STag 0x%08X, index = 0x%08X\n",
-			stag, stag_index);
+		  stag, stag_index);
 
 	/* Register the region with the adapter */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
-		kfree(nesmr);
-		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-		return ERR_PTR(-ENOMEM);
+	if (!cqp_request) {
+		ret = -ENOMEM;
+		goto err_kfree;
 	}
 
 	cqp_request->waiting = 1;
 	cqp_wqe = &cqp_request->cqp_wqe;
 
 	cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX] =
-			cpu_to_le32( NES_CQP_ALLOCATE_STAG | NES_CQP_STAG_RIGHTS_REMOTE_READ |
-			NES_CQP_STAG_RIGHTS_REMOTE_WRITE | NES_CQP_STAG_VA_TO |
-			NES_CQP_STAG_REM_ACC_EN);
+		cpu_to_le32((NES_CQP_ALLOCATE_STAG |
+			     NES_CQP_STAG_RIGHTS_REMOTE_READ |
+			     NES_CQP_STAG_RIGHTS_REMOTE_WRITE |
+			     NES_CQP_STAG_VA_TO |
+			     NES_CQP_STAG_REM_ACC_EN));
 
 	nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
-	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX, (nespd->pd_id & 0x00007fff));
-	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, stag);
+	set_wqe_32bit_value(cqp_wqe->wqe_words,
+			    NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX,
+			    nespd->pd_id & 0x00007fff);
+	set_wqe_32bit_value(cqp_wqe->wqe_words,
+			    NES_CQP_STAG_WQE_STAG_IDX,
+			    stag);
 
 	atomic_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
-	ret = wait_event_timeout(cqp_request->waitq, (cqp_request->request_done != 0),
-			NES_EVENT_TIMEOUT);
-	nes_debug(NES_DBG_MR, "Register STag 0x%08X completed, wait_event_timeout ret = %u,"
-			" CQP Major:Minor codes = 0x%04X:0x%04X.\n",
-			stag, ret, cqp_request->major_code, cqp_request->minor_code);
-	if ((!ret) || (cqp_request->major_code)) {
-		nes_put_cqp_request(nesdev, cqp_request);
-		kfree(nesmr);
-		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-		if (!ret) {
-			return ERR_PTR(-ETIME);
-		} else {
-			return ERR_PTR(-ENOMEM);
-		}
-	}
+	ret = wait_event_timeout(cqp_request->waitq,
+				 cqp_request->request_done != 0,
+				 NES_EVENT_TIMEOUT);
+
+	nes_debug(NES_DBG_MR, "Register STag 0x%08X completed, wait_event_timeout ret = %u, CQP Major:Minor codes = 0x%04X:0x%04X\n",
+		  stag, ret, cqp_request->major_code, cqp_request->minor_code);
+
 	nes_put_cqp_request(nesdev, cqp_request);
 
+	if (!ret) {
+		ret = -ETIME;
+		goto err_kfree;
+	}
+	if (cqp_request->major_code) {
+		ret = -ENOMEM;
+		goto err_kfree;
+	}
+
 	nesmr->ibmw.rkey = stag;
 	nesmr->mode = IWNES_MEMREG_TYPE_MW;
 	ibmw = &nesmr->ibmw;
@@ -152,8 +158,13 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
 	nesmr->pbls_used = 0;
 
 	return ibmw;
-}
 
+err_kfree:
+	kfree(nesmr);
+err_free_res:
+	nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+	return ERR_PTR(ret);
+}
 
 /**
  * nes_dealloc_mw
-- 
2.10.0.rc2.1.g053435c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
