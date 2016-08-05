From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] iser-target: Fix error return code in isert_alloc_login_buf()
Date: Fri,  5 Aug 2016 13:49:28 +0000
Message-ID: <1470404968-17339-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fix to return error code -ENOMEM from the alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index ba6be06..65af523 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -449,6 +449,7 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
 	isert_conn->login_rsp_buf = kzalloc(ISER_RX_PAYLOAD_SIZE, GFP_KERNEL);
 	if (!isert_conn->login_rsp_buf) {
 		isert_err("Unable to allocate isert_conn->login_rspbuf\n");
+		ret = -ENOMEM;
 		goto out_unmap_login_req_buf;
 	}
