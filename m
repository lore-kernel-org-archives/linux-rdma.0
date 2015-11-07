From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] staging: rdma: amso1100: Remove unnecessary variables
Date: Sun, 8 Nov 2015 01:42:03 +0530
Message-ID: <20151107201203.GA12265@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: dledford@redhat.com, hal.rosenstock@gmail.com, gregkh@linuxfoundation.org, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Remove unnecessary variable 'err' from functions c2_reject() and
c2_service_destroy() since it can be replaced by a single line of
code instead.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/staging/rdma/amso1100/c2_provider.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/staging/rdma/amso1100/c2_provider.c
index e44ad22..53bc1ec 100644
--- a/drivers/staging/rdma/amso1100/c2_provider.c
+++ b/drivers/staging/rdma/amso1100/c2_provider.c
@@ -620,12 +620,9 @@ static int c2_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *iw_param)
 
 static int c2_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
-	int err;
-
 	pr_debug("%s:%u\n", __func__, __LINE__);
 
-	err = c2_llp_reject(cm_id, pdata, pdata_len);
-	return err;
+	return c2_llp_reject(cm_id, pdata, pdata_len);
 }
 
 static int c2_service_create(struct iw_cm_id *cm_id, int backlog)
@@ -642,12 +639,9 @@ static int c2_service_create(struct iw_cm_id *cm_id, int backlog)
 
 static int c2_service_destroy(struct iw_cm_id *cm_id)
 {
-	int err;
 	pr_debug("%s:%u\n", __func__, __LINE__);
 
-	err = c2_llp_service_destroy(cm_id);
-
-	return err;
+	return c2_llp_service_destroy(cm_id);
 }
 
 static int c2_pseudo_up(struct net_device *netdev)
-- 
1.9.1
