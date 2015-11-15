From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] staging-EHCA: Delete unnecessary checks before the function
 call "kmem_cache_destroy"
Date: Sun, 15 Nov 2015 22:08:32 +0100
Message-ID: <5648F450.3050004@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 15 Nov 2015 21:58:45 +0100

The kmem_cache_destroy() function tests whether its argument is NULL
and then returns immediately. Thus the test around the calls is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/rdma/ehca/ehca_av.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_cq.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_main.c | 3 +--
 drivers/staging/rdma/ehca/ehca_mrmw.c | 6 ++----
 drivers/staging/rdma/ehca/ehca_pd.c   | 3 +--
 drivers/staging/rdma/ehca/ehca_qp.c   | 3 +--
 6 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_av.c b/drivers/staging/rdma/ehca/ehca_av.c
index 4659263..04b9398 100644
--- a/drivers/staging/rdma/ehca/ehca_av.c
+++ b/drivers/staging/rdma/ehca/ehca_av.c
@@ -272,6 +272,5 @@ int ehca_init_av_cache(void)
 
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
2.6.2
