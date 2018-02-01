From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next] IB/core: Avoid a potential OOPs for an unused
 optional parameter
Date: Thu, 01 Feb 2018 12:31:06 -0800
Message-ID: <20180201203103.11832.81537.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

The ev_file is an optional parameter for CQ creation. If the parameter
is not passed, the ev_file pointer will be NULL.  Using that pointer
to set the cq_context will result in an OOPs.

Verify that ev_file is not NULL before using.

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: 9ee79fce3642 ("IB/core: Add completion queue (cq) object actions")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/core/uverbs_std_types.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index b571176..cab0ac3 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -316,7 +316,7 @@ static int uverbs_create_cq_handler(struct ib_device *ib_dev,
 	cq->uobject       = &obj->uobject;
 	cq->comp_handler  = ib_uverbs_comp_handler;
 	cq->event_handler = ib_uverbs_cq_event_handler;
-	cq->cq_context    = &ev_file->ev_queue;
+	cq->cq_context    = ev_file ? &ev_file->ev_queue : NULL;
 	obj->uobject.object = cq;
 	obj->uobject.user_handle = user_handle;
 	atomic_set(&cq->usecnt, 0);
