From: ira.weiny@intel.com
Subject: [PATCH v3 08/13] staging/rdma/hfi1: Fix camel case variables
Date: Wed,  2 Dec 2015 00:43:33 -0500
Message-ID: <1449035018-26396-9-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
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

From: Ira Weiny <ira.weiny@intel.com>

physState, linkState, and devState should be phys_state, link_state, and
dev_state

Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index a050e09699d8..eb74e492eca1 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -964,9 +964,9 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	void *filter_value = NULL;
 	long ret = 0;
 	int value = 0;
-	u8 physState = 0;
-	u8 linkState = 0;
-	u16 devState = 0;
+	u8 phys_state = 0;
+	u8 link_state = 0;
+	u16 dev_state = 0;
 	unsigned long flags = 0;
 	unsigned long *argp = NULL;
 	struct hfi1_packet_filter_command filter_cmd = {0};
@@ -1030,31 +1030,31 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			}
 
 			/* What we want to transition to */
-			physState = (value >> 4) & 0xF;
-			linkState = value & 0xF;
+			phys_state = (value >> 4) & 0xF;
+			link_state = value & 0xF;
 			snoop_dbg("Setting link state 0x%x", value);
 
-			switch (linkState) {
+			switch (link_state) {
 			case IB_PORT_NOP:
-				if (physState == 0)
+				if (phys_state == 0)
 					break;
 					/* fall through */
 			case IB_PORT_DOWN:
-				switch (physState) {
+				switch (phys_state) {
 				case 0:
-					devState = HLS_DN_DOWNDEF;
+					dev_state = HLS_DN_DOWNDEF;
 					break;
 				case 2:
-					devState = HLS_DN_POLL;
+					dev_state = HLS_DN_POLL;
 					break;
 				case 3:
-					devState = HLS_DN_DISABLE;
+					dev_state = HLS_DN_DISABLE;
 					break;
 				default:
 					ret = -EINVAL;
 					goto done;
 				}
-				ret = set_link_state(ppd, devState);
+				ret = set_link_state(ppd, dev_state);
 				break;
 			case IB_PORT_ARMED:
 				ret = set_link_state(ppd, HLS_UP_ARMED);
-- 
1.8.2
