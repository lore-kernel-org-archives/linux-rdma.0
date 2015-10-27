From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 2/2] iser-target: Remove explicit mlx4 work-around
Date: Tue, 27 Oct 2015 11:40:46 +0200
Message-ID: <1445938846-9240-3-git-send-email-sagig@mellanox.com>
References: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1445938846-9240-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

The driver now exposes sufficient limits so we can
avoid having mlx4 specific work-around.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 96336a9..303cea7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -141,14 +141,8 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.recv_cq = comp->cq;
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
-	/*
-	 * FIXME: Use devattr.max_sge - 2 for max_send_sge as
-	 * work-around for RDMA_READs with ConnectX-2.
-	 *
-	 * Also, still make sure to have at least two SGEs for
-	 * outgoing control PDU responses.
-	 */
-	attr.cap.max_send_sge = max(2, device->ib_device->max_sge - 2);
+	attr.cap.max_send_sge = min(device->ib_device->max_sge,
+				    device->ib_device->max_sge_rd);
 	isert_conn->max_sge = attr.cap.max_send_sge;
 
 	attr.cap.max_recv_sge = 1;
-- 
1.7.1
