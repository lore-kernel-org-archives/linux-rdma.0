From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/isert: fix spelling mistake: "teminating" -> "terminating"
Date: Fri, 30 Dec 2016 14:38:05 +0000
Message-ID: <20161230143805.13549-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in isert_warn message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 314e955..91cbe86 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -728,7 +728,7 @@ isert_disconnected_handler(struct rdma_cm_id *cma_id,
 		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
 		break;
 	default:
-		isert_warn("conn %p teminating in state %d\n",
+		isert_warn("conn %p terminating in state %d\n",
 			   isert_conn, isert_conn->state);
 	}
 	mutex_unlock(&isert_conn->mutex);
-- 
2.10.2
