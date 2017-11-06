From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/11] IB/hfi1: Fix a wrapping test to insure the
 correct timeout
Date: Mon, 06 Nov 2017 06:38:38 -0800
Message-ID: <20171106143835.27539.12196.stgit@scvm10.sc.intel.com>
References: <20171106143510.27539.65950.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106143510.27539.65950.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The "2 * UINT_MAX"  statement:
	if ((u64)(ts - cce->timestamp) > 2 * UINT_MAX) {

is equivalent to:
	if ((u64)(ts - cce->timestamp) > UINT_MAX - 1) {

This results in a premature timeout of the cong log entry.

Fix by using unsigned 64 bit integers, removing casts, and using
an algebraic equivalent test to avoid the "2 * UINT_MAX" issue.

Also make use of kernel API to get nanoseconds instead of
open coding.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |    6 +++---
 drivers/infiniband/hw/hfi1/mad.h |    2 +-
 drivers/infiniband/hw/hfi1/rc.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index e648f58..0a867e5 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3760,7 +3760,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	struct opa_hfi1_cong_log *cong_log = (struct opa_hfi1_cong_log *)data;
-	s64 ts;
+	u64 ts;
 	int i;
 
 	if (am || smp_length_check(sizeof(*cong_log), max_len)) {
@@ -3778,7 +3778,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 	       ppd->threshold_cong_event_map,
 	       sizeof(cong_log->threshold_cong_event_map));
 	/* keep timestamp in units of 1.024 usec */
-	ts = ktime_to_ns(ktime_get()) / 1024;
+	ts = ktime_get_ns() / 1024;
 	cong_log->current_time_stamp = cpu_to_be32(ts);
 	for (i = 0; i < OPA_CONG_LOG_ELEMS; i++) {
 		struct opa_hfi1_cong_log_event_internal *cce =
@@ -3790,7 +3790,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 		 * required to wrap the counter are supposed to
 		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
 		 */
-		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
+		if ((ts - cce->timestamp) / 2 > U32_MAX)
 			continue;
 		memcpy(cong_log->events[i].local_qp_cn_entry, &cce->lqpn, 3);
 		memcpy(cong_log->events[i].remote_qp_number_cn_entry,
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index a4f8ac1..c4938f3 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -239,7 +239,7 @@ struct opa_hfi1_cong_log_event_internal {
 	u8 sl;
 	u8 svc_type;
 	u32 rlid;
-	s64 timestamp; /* wider than 32 bits to detect 32 bit rollover */
+	u64 timestamp; /* wider than 32 bits to detect 32 bit rollover */
 };
 
 struct opa_hfi1_cong_log_event {
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 32d7bbe..3f21b05 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1965,7 +1965,7 @@ static void log_cca_event(struct hfi1_pportdata *ppd, u8 sl, u32 rlid,
 	cc_event->svc_type = svc_type;
 	cc_event->rlid = rlid;
 	/* keep timestamp in units of 1.024 usec */
-	cc_event->timestamp = ktime_to_ns(ktime_get()) / 1024;
+	cc_event->timestamp = ktime_get_ns() / 1024;
 
 	spin_unlock_irqrestore(&ppd->cc_log_lock, flags);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
