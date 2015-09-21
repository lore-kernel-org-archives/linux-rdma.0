From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] staging: rdma: add a blank line after function
Date: Mon, 21 Sep 2015 23:39:08 +0800
Message-ID: <43f0dc92984109a1953848fa5c6546e3ffb34ad5.1442849672.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Marciniszyn <infinipath@intel.com>, Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixed warnings found by checkpatch.pl:

Please use a blank line after function/struct/union/enum declarations
  FILE: drivers/staging/rdma/amso1100/c2_mq.c:158:
  FILE: drivers/staging/rdma/hfi1/file_ops.c:2069:
  FILE: drivers/staging/rdma/hfi1/sdma.c:744:
  FILE: drivers/staging/rdma/hfi1/verbs.c:1202:

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/amso1100/c2_mq.c | 1 +
 drivers/staging/rdma/hfi1/file_ops.c  | 1 +
 drivers/staging/rdma/hfi1/sdma.c      | 1 +
 drivers/staging/rdma/hfi1/verbs.c     | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/staging/rdma/amso1100/c2_mq.c b/drivers/staging/rdma/amso1100/c2_mq.c
index 0cddc49..7827fb8 100644
--- a/drivers/staging/rdma/amso1100/c2_mq.c
+++ b/drivers/staging/rdma/amso1100/c2_mq.c
@@ -155,6 +155,7 @@ void c2_mq_req_init(struct c2_mq *q, u32 index, u32 q_size, u32 msg_size,
 	q->hint_count = 0;
 	return;
 }
+
 void c2_mq_rep_init(struct c2_mq *q, u32 index, u32 q_size, u32 msg_size,
 		    u8 *pool_start, u16 __iomem *peer, u32 type)
 {
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 72d3850..9a77221 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -2066,6 +2066,7 @@ static const struct file_operations ui_file_ops = {
 	.open = ui_open,
 	.release = ui_release,
 };
+
 #define UI_OFFSET 192	/* device minor offset for UI devices */
 static int create_ui = 1;
 
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index aecd1a7..78d016b 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -741,6 +741,7 @@ u16 sdma_get_descq_cnt(void)
 		return SDMA_DESCQ_CNT;
 	return count;
 }
+
 /**
  * sdma_select_engine_vl() - select sdma engine
  * @dd: devdata
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 41bb59e..a43fccd 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1199,6 +1199,7 @@ pio_bail:
 	}
 	return 0;
 }
+
 /*
  * egress_pkey_matches_entry - return 1 if the pkey matches ent (ent
  * being an entry from the ingress partition key table), return 0
-- 
2.5.0
