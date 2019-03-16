From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/iser: remove uninitialized variable len
Date: Sat, 16 Mar 2019 23:05:12 +0000
Message-ID: <20190316230512.8933-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable len is not being inintialized and the uninitialized
value is being returned. However, this return path is never reached
because the default case in the switch statement returns -ENOSYS.
Clean up the code by replacing the return -ENOSYS with a break
for the default case and returning -ENOSYS at the end of the
function.  This allows len to be removed.  Also remove redundant
break that follows a return statement.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8c707accd148..9c185a8dabd3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -763,7 +763,6 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
 				   enum iscsi_param param, char *buf)
 {
 	struct iser_conn *iser_conn = ep->dd_data;
-	int len;
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -774,12 +773,10 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
 		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
 				&iser_conn->ib_conn.cma_id->route.addr.dst_addr,
 				param, buf);
-		break;
 	default:
-		return -ENOSYS;
+		break;
 	}
-
-	return len;
+	return -ENOSYS;
 }
 
 /**
-- 
2.20.1
