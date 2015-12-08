From: "Shah, Yash (Y.)" <yshah1@visteon.com>
Subject: [PATCH] Staging: rdma:Delete unnecessary NULL check before calling
 function "kmem_cache_destroy"
Date: Tue, 8 Dec 2015 10:24:17 +0000
Message-ID: <20151208102404.GA26085@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Language: en-US
Content-ID: <32E3FDD54F6152489982526F4B7E97B1@eurprd06.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "a.hajda@samsung.com" <a.hajda@samsung.com>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "matanb@mellanox.com" <matanb@mellanox.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>, "cse.anjalimenon@gmail.com" <cse.anjalimenon@gmail.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "roland@purestorage.com" <roland@purestorage.com>, "haggaie@mellanox.com" <haggaie@mellanox.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yash Shah <yshah1@visteon.com>

The kmem_cache_destroy() function tests whether its argument is NULL
and then returns immediately. 
Thus the NULL check before calling this function is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Yash Shah <yshah1@visteon.com>
---
 drivers/staging/rdma/ehca/ehca_av.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_cq.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_main.c | 3 +--
 drivers/staging/rdma/ehca/ehca_mrmw.c | 6 ++----
 drivers/staging/rdma/ehca/ehca_pd.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_qp.c   | 3 +--
 6 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_av.c b/drivers/staging/rdma/ehca/ehca_av.c
index fd7b6d0..94e088c 100644
--- a/drivers/staging/rdma/ehca/ehca_av.c
+++ b/drivers/staging/rdma/ehca/ehca_av.c
@@ -275,6 +275,5 @@ int ehca_init_av_cache(void)
 
 void ehca_cleanup_av_cache(void)
 {
-	if (av_cache)
-		kmem_cache_destroy(av_cache);
+	kmem_cache_destroy(av_cache);
 }
diff --git a/drivers/staging/rdma/ehca/ehca_cq.c b/drivers/staging/rdma/ehca/ehca_cq.c
index ea1b5c1..1aa7931 100644
--- a/drivers/staging/rdma/ehca/ehca_cq.c
+++ b/drivers/staging/rdma/ehca/ehca_cq.c
@@ -393,6 +393,5 @@ int ehca_init_cq_cache(void)
 
 void ehca_cleanup_cq_cache(void)
 {
-	if (cq_cache)
-		kmem_cache_destroy(cq_cache);
+	kmem_cache_destroy(cq_cache);
 }
diff --git a/drivers/staging/rdma/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
index 8246418..860b974 100644
--- a/drivers/staging/rdma/ehca/ehca_main.c
+++ b/drivers/staging/rdma/ehca/ehca_main.c
@@ -245,8 +245,7 @@ static void ehca_destroy_slab_caches(void)
 	ehca_cleanup_cq_cache();
 	ehca_cleanup_pd_cache();
 #ifdef CONFIG_PPC_64K_PAGES
-	if (ctblk_cache)
-		kmem_cache_destroy(ctblk_cache);
+	kmem_cache_destroy(ctblk_cache);
 #endif
 }
 
diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index f914b30..553e883 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -2251,10 +2251,8 @@ int ehca_init_mrmw_cache(void)
 
 void ehca_cleanup_mrmw_cache(void)
 {
-	if (mr_cache)
-		kmem_cache_destroy(mr_cache);
-	if (mw_cache)
-		kmem_cache_destroy(mw_cache);
+	kmem_cache_destroy(mr_cache);
+	kmem_cache_destroy(mw_cache);
 }
 
 static inline int ehca_init_top_bmap(struct ehca_top_bmap *ehca_top_bmap,
diff --git a/drivers/staging/rdma/ehca/ehca_pd.c b/drivers/staging/rdma/ehca/ehca_pd.c
index 351577a..2a8aae4 100644
--- a/drivers/staging/rdma/ehca/ehca_pd.c
+++ b/drivers/staging/rdma/ehca/ehca_pd.c
@@ -119,6 +119,5 @@ int ehca_init_pd_cache(void)
 
 void ehca_cleanup_pd_cache(void)
 {
-	if (pd_cache)
-		kmem_cache_destroy(pd_cache);
+	kmem_cache_destroy(pd_cache);
 }
diff --git a/drivers/staging/rdma/ehca/ehca_qp.c b/drivers/staging/rdma/ehca/ehca_qp.c
index 2e89356..896c01f 100644
--- a/drivers/staging/rdma/ehca/ehca_qp.c
+++ b/drivers/staging/rdma/ehca/ehca_qp.c
@@ -2252,6 +2252,5 @@ int ehca_init_qp_cache(void)
 
 void ehca_cleanup_qp_cache(void)
 {
-	if (qp_cache)
-		kmem_cache_destroy(qp_cache);
+	kmem_cache_destroy(qp_cache);
 }
-- 
1.9.1
