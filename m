From: Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH iproute2-next 1/3] rdma: Update kernel include file to support IB device renaming
Date: Thu, 20 Sep 2018 14:22:30 +0300
Message-ID: <20180920112232.9602-2-leon@kernel.org>
References: <20180920112232.9602-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112232.9602-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Bring kernel header file changes upto commit 908b44308eda
("RDMA/nldev: Allow IB device rename through RDMA netlink")

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 6513fb89..e2228c09 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -227,8 +227,9 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_UNSPEC,

 	RDMA_NLDEV_CMD_GET, /* can dump */
+	RDMA_NLDEV_CMD_SET,

-	/* 2 - 4 are free to use */
+	/* 3 - 4 are free to use */

 	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
