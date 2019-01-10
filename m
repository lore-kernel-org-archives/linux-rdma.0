From: Myungho Jung <mhjungk@gmail.com>
Subject: [PATCH v2] RDMA/cma: Rollback source IP address if failing to
 acquire device
Date: Wed, 9 Jan 2019 22:27:31 -0800
Message-ID: <20190110062727.GA25844@myunghoj-Precision-5530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

If cma_acquire_dev_by_src_ip() returns error in addr_handler(), the
device state changes back to RDMA_CM_ADDR_BOUND but the resolved source
IP address is still left. After that, if rdma_destroy_id() is called
after rdma_listen(), the device is freed without removed from
listen_any_list in cma_cancel_operation(). Revert to the previous IP
address if acquiring device fails.

Reported-by: syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com
Signed-off-by: Myungho Jung <mhjungk@gmail.com>
---
 drivers/infiniband/core/cma.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 63a7cc00bae0..8cd113b0ddfb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2963,13 +2963,22 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 {
 	struct rdma_id_private *id_priv = context;
 	struct rdma_cm_event event = {};
+	struct sockaddr *addr;
+	struct sockaddr_storage old_addr;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY,
 			   RDMA_CM_ADDR_RESOLVED))
 		goto out;
 
-	memcpy(cma_src_addr(id_priv), src_addr, rdma_addr_size(src_addr));
+	/*
+	 * Store the previous src address, so that if we fail to acquire
+	 * matching rdma device, old address can be restored back, which helps
+	 * to cancel the cma listen operation correctly.
+	 */
+	addr = cma_src_addr(id_priv);
+	memcpy(&old_addr, addr, rdma_addr_size(addr));
+	memcpy(addr, src_addr, rdma_addr_size(src_addr));
 	if (!status && !id_priv->cma_dev) {
 		status = cma_acquire_dev_by_src_ip(id_priv);
 		if (status)
@@ -2980,6 +2989,8 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 	}
 
 	if (status) {
+		memcpy(addr, &old_addr,
+		       rdma_addr_size((struct sockaddr *)&old_addr));
 		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED,
 				   RDMA_CM_ADDR_BOUND))
 			goto out;
-- 
2.17.1
