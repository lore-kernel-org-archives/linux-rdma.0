From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH] staging/rdma/hfi1: fix pio progress routine race with
 allocator
Date: Thu, 03 Dec 2015 14:34:18 -0500
Message-ID: <20151203193417.12617.62289.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The allocation code assumes that the shadow ring cannot
be overrun because the credits will limit the allocation.

Unfortuately, the progress mechanism in sc_release_update() updates
the free count prior to processing the shadow ring, allowing the
shadow ring to be overrun by an allocation.

Reviewed-by: Mark Debbage <mark.debbage@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/staging/rdma/hfi1/pio.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index eab58c1..8e10857 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1565,6 +1565,7 @@ void sc_release_update(struct send_context *sc)
 	u64 hw_free;
 	u32 head, tail;
 	unsigned long old_free;
+	unsigned long free;
 	unsigned long extra;
 	unsigned long flags;
 	int code;
@@ -1579,7 +1580,7 @@ void sc_release_update(struct send_context *sc)
 	extra = (((hw_free & CR_COUNTER_SMASK) >> CR_COUNTER_SHIFT)
 			- (old_free & CR_COUNTER_MASK))
 				& CR_COUNTER_MASK;
-	sc->free = old_free + extra;
+	free = old_free + extra;
 	trace_hfi1_piofree(sc, extra);
 
 	/* call sent buffer callbacks */
@@ -1589,7 +1590,7 @@ void sc_release_update(struct send_context *sc)
 	while (head != tail) {
 		pbuf = &sc->sr[tail].pbuf;
 
-		if (sent_before(sc->free, pbuf->sent_at)) {
+		if (sent_before(free, pbuf->sent_at)) {
 			/* not sent yet */
 			break;
 		}
@@ -1603,8 +1604,10 @@ void sc_release_update(struct send_context *sc)
 		if (tail >= sc->sr_size)
 			tail = 0;
 	}
-	/* update tail, in case we moved it */
 	sc->sr_tail = tail;
+	/* make sure tail is updated before free */
+	smp_wmb();
+	sc->free = free;
 	spin_unlock_irqrestore(&sc->release_lock, flags);
 	sc_piobufavail(sc);
 }
