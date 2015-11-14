From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 04/18] staging/rdma/hfi1: Fix qp.h comments
Date: Fri, 13 Nov 2015 19:37:02 -0800
Message-ID: <1447472236-622-4-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

This patch fixes a few qp.h comments.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/qp.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index b9c1575..8ef64cd 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -212,7 +212,7 @@ int hfi1_qp_init(struct hfi1_ibdev *dev);
 void hfi1_qp_exit(struct hfi1_ibdev *dev);
 
 /**
- * hfi1_qp_waitup - wake up on the indicated event
+ * hfi1_qp_wakeup - wake up on the indicated event
  * @qp: the QP
  * @flag: flag the qp on which the qp is stalled
  */
@@ -223,19 +223,19 @@ struct sdma_engine *qp_to_sdma_engine(struct hfi1_qp *qp, u8 sc5);
 struct qp_iter;
 
 /**
- * qp_iter_init - wake up on the indicated event
+ * qp_iter_init - initialize the iterator for the qp hash list
  * @dev: the hfi1_ibdev
  */
 struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev);
 
 /**
- * qp_iter_next - wakeup on the indicated event
+ * qp_iter_next - Find the next qp in the hash list
  * @iter: the iterator for the qp hash list
  */
 int qp_iter_next(struct qp_iter *iter);
 
 /**
- * qp_iter_next - wake up on the indicated event
+ * qp_iter_print - print the qp information to seq_file
  * @s: the seq_file to emit the qp information on
  * @iter: the iterator for the qp hash list
  */
-- 
1.7.0.7
