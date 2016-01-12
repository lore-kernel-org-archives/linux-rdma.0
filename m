From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/nes: checking for NULL instead of IS_ERR
Date: Tue, 12 Jan 2016 12:27:43 +0300
Message-ID: <20160112092743.GA29804@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

nes_reg_phys_mr() returns ERR_PTRs on error.  It doesn't return NULL.

This bug has been there for a while, but we recently changed from
calling a function pointer to calling nes_reg_phys_mr() directly so now
Smatch is able to detect the bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 179490d..cb9f0f2 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3320,14 +3320,14 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 				nesqp->ietf_frame_pbase + mpa_frame_offset,
 				buff_len, IB_ACCESS_LOCAL_WRITE,
 				&tagged_offset);
-		if (!ibmr) {
+		if (IS_ERR(ibmr)) {
 			nes_debug(NES_DBG_CM, "Unable to register memory region"
 				  "for lSMM for cm_node = %p \n",
 				  cm_node);
 			pci_free_consistent(nesdev->pcidev,
 					    nesqp->private_data_len + nesqp->ietf_frame_size,
 					    nesqp->ietf_frame, nesqp->ietf_frame_pbase);
-			return -ENOMEM;
+			return PTR_ERR(ibmr);
 		}
 
 		ibmr->pd = &nespd->ibpd;
