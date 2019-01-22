From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 01/19] rdma: update uapi headers
Date: Tue, 22 Jan 2019 20:31:07 +0200
Message-ID: <20190122183125.15920-2-leon@kernel.org>
References: <20190122183125.15920-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122183125.15920-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 04c80ceb..a1e6d658 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -430,6 +430,16 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
 	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
 
+	/*
+	 * Indexes to get/set secific entry,
+	 * for QP use RDMA_NLDEV_ATTR_RES_LQPN
+	 */
+	RDMA_NLDEV_ATTR_RES_PDN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CQN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_MRN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CM_IDN,            /* u32 */
+	RDMA_NLDEV_ATTR_RES_CTXN,	       /* u32 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.19.1
