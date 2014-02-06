From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
Subject: RE: [patch] RDMA/nes: clean up a conditon
Date: Thu, 6 Feb 2014 17:41:57 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB0D887D7E@FMSMSX104.amr.corp.intel.com>
References: <20140206124822.GB16998@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140206124822.GB16998@elgon.mountain>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "Latif, Faisal" <faisal.latif@intel.com>
Cc: Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hello Dan,

Your patch seems fine. If you want, feel free to add:

Reviewed-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

Thank you,
Tatyana

-----Original Message-----
From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Dan Carpenter
Sent: Thursday, February 06, 2014 6:48 AM
To: Latif, Faisal
Cc: Roland Dreier; Hefty, Sean; Hal Rosenstock; linux-rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [patch] RDMA/nes: clean up a conditon

We don't need to test "ret" twice and also the white space is messed up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8308e3634767..2db2b58f70d9 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3134,9 +3134,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				" original_last_aeq = 0x%04X. last_aeq = 0x%04X.\n",
 				nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
 				original_last_aeq, nesqp->last_aeq);
-		if ((!ret) ||
-				((original_last_aeq != NES_AEQE_AEID_RDMAP_ROE_BAD_LLP_CLOSE) &&
-				(ret))) {
+		if (!ret || original_last_aeq != 
+NES_AEQE_AEID_RDMAP_ROE_BAD_LLP_CLOSE) {
 			if (dont_wait) {
 				if (nesqp->cm_id && nesqp->hw_tcp_state != 0) {
 					nes_debug(NES_DBG_MOD_QP, "QP%u Queuing fake disconnect for QP refcount (%d),"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
