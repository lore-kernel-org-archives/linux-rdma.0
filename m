From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 2/7] staging/rdma/hfi1: Fix camel case variables
Date: Mon, 16 Nov 2015 17:32:35 -0500
Message-ID: <1447713160-24858-3-git-send-email-ira.weiny@intel.com>
References: <1447713160-24858-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447713160-24858-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

physState, linkState, and devState should be phys_state, link_state, and
dev_state

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index c5cc2db1b559..c2839473f983 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
