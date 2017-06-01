From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] i40iw: Add a value assignment to avoid sleep-in-atomic bug caused by uninitialized value
Date: Thu,  1 Jun 2017 10:11:16 +0800
Message-ID: <1496283076-6915-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-rdma@vger.kernel.org

The value "cqp_request->waiting" indicates whether the sleeping operation 
should be performed, and it is not assigned in i40iw_get_cqp_request, so 
the driver may sleep in interrupt handling. The function call path is:

i40iw_dpc (tasklet_init indicates it handles interrupt)
  i40iw_process_aeq
    i40iw_next_iw_state
      i40iw_hw_modify_qp (call i40iw_get_cqp_request)
        i40iw_handle_cqp_op
          i40iw_wait_event --> may sleep

To fix it, "cqp_request->waiting" is assigned in "else" branch in
i40iw_get_cqp_request.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 409a378..0f4e633 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -326,6 +326,7 @@ struct i40iw_cqp_request *i40iw_get_cqp_request(struct i40iw_cqp *cqp, bool wait
 		cqp_request->waiting = true;
 	} else {
 		atomic_set(&cqp_request->refcount, 1);
+		cqp_request->waiting = false;
 	}
 	return cqp_request;
 }
-- 
1.7.9.5
