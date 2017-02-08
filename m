From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/14] RDMA/cxgb4: Adjust three checks for null pointers
Date: Wed, 8 Feb 2017 22:17:42 +0100
Message-ID: <14a380a4-2aa3-b2cc-3207-99e86b5964ea@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 17:10:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 90fa96abb5bc..7f30bfd71eb2 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1126,10 +1126,10 @@ static inline int recv_rx_pkt(struct c4iw_dev *dev, const struct pkt_gl *gl,
 		goto out;
 
 	skb = copy_gl_to_skb_pkt(gl , rsp, dev->rdev.lldi.sge_pktshift);
-	if (skb == NULL)
+	if (!skb)
 		goto out;
 
-	if (c4iw_handlers[opcode] == NULL) {
+	if (!c4iw_handlers[opcode]) {
 		pr_info("%s no handler opcode 0x%x...\n", __func__,
 		       opcode);
 		kfree_skb(skb);
@@ -1149,7 +1149,7 @@ static int c4iw_uld_rx_handler(void *handle, const __be64 *rsp,
 	struct sk_buff *skb;
 	u8 opcode;
 
-	if (gl == NULL) {
+	if (!gl) {
 		/* omit RSS and rsp_ctrl at end of descriptor */
 		unsigned int len = 64 - sizeof(struct rsp_ctrl) - 8;
 
-- 
2.11.1
