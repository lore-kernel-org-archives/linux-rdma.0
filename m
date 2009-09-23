From: Eli Cohen <eli@mellanox.co.il>
Subject: [ofa-general] [PATCH v2] mlx4: configure cache line size
Date: Wed, 23 Sep 2009 10:36:58 +0300
Message-ID: <20090923073658.GA23252@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, general-list <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

ConnectX can work more efficiently if the CPU cache line size is configured to
it at INIT_HCA. This patch configures the CPU cache line size.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
As per Roland's comments, the following changes were made:
1. Remove #ifdef cache_line_size and include linux/cache.h
2. Assume cache line size is a power of 2 and use ilog2 instead of
order_base_2

 drivers/net/mlx4/fw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index cee199c..3c16602 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/mlx4/cmd.h>
+#include <linux/cache.h>
 
 #include "fw.h"
 #include "icm.h"
@@ -698,6 +699,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define INIT_HCA_IN_SIZE		 0x200
 #define INIT_HCA_VERSION_OFFSET		 0x000
 #define	 INIT_HCA_VERSION		 2
+#define INIT_HCA_CACHELINE_SZ_OFFSET	 0x0e
 #define INIT_HCA_FLAGS_OFFSET		 0x014
 #define INIT_HCA_QPC_OFFSET		 0x020
 #define	 INIT_HCA_QPC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x10)
@@ -735,6 +737,9 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 
 	*((u8 *) mailbox->buf + INIT_HCA_VERSION_OFFSET) = INIT_HCA_VERSION;
 
+	*((u8 *) mailbox->buf + INIT_HCA_CACHELINE_SZ_OFFSET) =
+		(ilog2(cache_line_size()) - 4) << 5;
+
 #if defined(__LITTLE_ENDIAN)
 	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) &= ~cpu_to_be32(1 << 1);
 #elif defined(__BIG_ENDIAN)
-- 
1.6.4.3
