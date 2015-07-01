From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH V3 3/4] RDMA/iser: limit sg tablesize to device fastreg max
 depth
Date: Wed, 01 Jul 2015 11:30:53 -0500
Message-ID: <20150701163052.6501.27775.stgit@build.ogc.int>
References: <20150701162936.6501.45512.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150701162936.6501.45512.stgit@build.ogc.int>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: roid@mellanox.com, linux-rdma@vger.kernel.org, sagig@mellanox.com, infinipath@intel.com, target-devel@vger.kernel.org, eli@mellanox.com, ogerlitz@mellanox.com
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6a594aa..ec692f7 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -640,6 +640,13 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 						   SHOST_DIX_GUARD_CRC);
 		}
 
+		/*
+		 * Limit the sg_tablesize based on the device max fastreg page
+		 * list length.
+		 */
+		shost->sg_tablesize = min_t(u32, shost->sg_tablesize,
+			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
+
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
 			mutex_unlock(&iser_conn->state_mutex);
