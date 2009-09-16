From: Eli Cohen <eli@mellanox.co.il>
Subject: [ofa-general] [PATCH] mlx4: confiugre cache line size
Date: Wed, 16 Sep 2009 14:03:03 +0300
Message-ID: <20090916110302.GA32767@mtls03>
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

ConnectX can work more efficiently if the CPU cache line size is confiugred to
it at INIT_HCA. This patch configures cache line size for systems that report
it.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
 drivers/net/mlx4/fw.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 20526ce..aa38c06 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -699,6 +699,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define INIT_HCA_IN_SIZE		 0x200
 #define INIT_HCA_VERSION_OFFSET		 0x000
 #define	 INIT_HCA_VERSION		 2
+#define INIT_HCA_CACHELINE_SZ_OFFSET	 0x0e
 #define INIT_HCA_FLAGS_OFFSET		 0x014
 #define INIT_HCA_QPC_OFFSET		 0x020
 #define	 INIT_HCA_QPC_BASE_OFFSET	 (INIT_HCA_QPC_OFFSET + 0x10)
@@ -736,6 +737,12 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 
 	*((u8 *) mailbox->buf + INIT_HCA_VERSION_OFFSET) = INIT_HCA_VERSION;
 
+#if defined(cache_line_size)
+	*((u8 *) mailbox->buf + INIT_HCA_CACHELINE_SZ_OFFSET) =
+		order_base_2(cache_line_size() / 16) << 5;
+#endif
+
+
 #if defined(__LITTLE_ENDIAN)
 	*(inbox + INIT_HCA_FLAGS_OFFSET / 4) &= ~cpu_to_be32(1 << 1);
 #elif defined(__BIG_ENDIAN)
-- 
1.6.4.3
