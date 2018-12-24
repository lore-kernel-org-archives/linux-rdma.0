From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] infiniband/qedr: Potential null ptr dereference of qp
Date: Mon, 24 Dec 2018 12:24:45 -0600
Message-ID: <20181224182445.21256-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

idr_find() may fail and return a NULL pointer. The fix checks the
return value of the function and returns an error in case of NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 505fa3648762..93b16237b767 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -492,6 +492,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	int i;
 
 	qp = idr_find(&dev->qpidr.idr, conn_param->qpn);
+	if (unlikely(!qp))
+		return -EINVAL;
 
 	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
 	raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
-- 
2.17.1
