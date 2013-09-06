From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/ocrdma: silence an integer underflow warning
Date: Fri, 6 Sep 2013 11:50:46 +0300
Message-ID: <20130906085046.GA32026@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Naresh Gottumukkala <bgottumukkala@emulex.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We recently added a cap on "max_wqe_allocated" in 43a6b4025c
('RDMA/ocrdma: Create IRD queue fix').

My static checker complains that the cap has a problem because it casts
large values to negative.  "attrs->cap.max_send_wr" is a u32.  It comes
from the user, but it's capped in ocrdma_check_qp_params() so it can't
wrap here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 4ed8235..db39146 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1783,7 +1783,7 @@ static int ocrdma_set_create_qp_sq_cmd(struct ocrdma_create_qp_req *cmd,
 	u32 max_sges = attrs->cap.max_send_sge;
 
 	/* QP1 may exceed 127 */
-	max_wqe_allocated = min_t(int, attrs->cap.max_send_wr + 1,
+	max_wqe_allocated = min_t(u32, attrs->cap.max_send_wr + 1,
 				dev->attr.max_wqe);
 
 	status = ocrdma_build_q_conf(&max_wqe_allocated,
