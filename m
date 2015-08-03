From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/core, cma: Make __attribute_const__ declarations
 sparse-friendly
Date: Mon, 3 Aug 2015 10:01:52 -0700
Message-ID: <55BF9E80.3030306@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Move the __attribute_const__ declarations such that sparse understands
that these apply to the function itself and not to the return type.
This avoids that sparse reports error messages like the following:

drivers/infiniband/core/verbs.c:73:12: error: symbol 'ib_event_msg' redeclared with different type (originally declared at include/rdma/ib_verbs.h:470) - different modifiers

Fixes: 2b1b5b601230 ("IB/core, cma: Nice log-friendly string helpers")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c   | 2 +-
 drivers/infiniband/core/verbs.c | 4 ++--
 include/rdma/ib_verbs.h         | 4 ++--
 include/rdma/rdma_cm.h          | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 143ded2..a7c1788 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -84,7 +84,7 @@ static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 = "timewait exit",
 };
 
-const char *rdma_event_msg(enum rdma_cm_event_type event)
+const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 {
 	size_t index = event;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2e5fd89..50fe99f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -70,7 +70,7 @@ static const char * const ib_events[] = {
 	[IB_EVENT_GID_CHANGE]		= "GID changed",
 };
 
-const char *ib_event_msg(enum ib_event_type event)
+const char *__attribute_const__ ib_event_msg(enum ib_event_type event)
 {
 	size_t index = event;
 
@@ -104,7 +104,7 @@ static const char * const wc_statuses[] = {
 	[IB_WC_GENERAL_ERR]		= "general error",
 };
 
-const char *ib_wc_status_msg(enum ib_wc_status status)
+const char *__attribute_const__ ib_wc_status_msg(enum ib_wc_status status)
 {
 	size_t index = status;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a2c328b..1d07ba7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -467,7 +467,7 @@ enum ib_event_type {
 	IB_EVENT_GID_CHANGE,
 };
 
-__attribute_const__ const char *ib_event_msg(enum ib_event_type event);
+const char *__attribute_const__ ib_event_msg(enum ib_event_type event);
 
 struct ib_event {
 	struct ib_device	*device;
@@ -718,7 +718,7 @@ enum ib_wc_status {
 	IB_WC_GENERAL_ERR
 };
 
-__attribute_const__ const char *ib_wc_status_msg(enum ib_wc_status status);
+const char *__attribute_const__ ib_wc_status_msg(enum ib_wc_status status);
 
 enum ib_wc_opcode {
 	IB_WC_SEND,
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c92522c..31afb5c 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -62,7 +62,7 @@ enum rdma_cm_event_type {
 	RDMA_CM_EVENT_TIMEWAIT_EXIT
 };
 
-__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event_type event);
+const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event);
 
 enum rdma_port_space {
 	RDMA_PS_SDP   = 0x0001,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
