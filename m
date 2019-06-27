From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 80/95] IB/hfi1: Wakeup QPs orphaned on wait list after flush
Date: Wed, 26 Jun 2019 20:30:05 -0400
Message-ID: <20190627003021.19867-80-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit f972775b1cc0441ae22c9f8d06dd16b118463632 ]

Once an SDMA engine is taken down due to a link failure, any waiting QPs
that do not have outstanding descriptors in the ring will stay
on the dmawait list as long as the port is down.

Since there is no timer running, they will stay there for a long time.

The fix is to wake up all iowaits linked to dmawait. The send engine
will build and post packets that get flushed back.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index b0110728f541..1cde1b8f0c8b 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -405,6 +405,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	struct sdma_txreq *txp, *txp_next;
 	LIST_HEAD(flushlist);
 	unsigned long flags;
+	uint seq;
 
 	/* flush from head to tail */
 	sdma_flush_descq(sde);
@@ -418,6 +419,22 @@ static void sdma_flush(struct sdma_engine *sde)
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
 		complete_tx(sde, txp, SDMA_TXREQ_S_ABORTED);
+	/* wakeup QPs orphaned on the dmawait list */
+	do {
+		struct iowait *w, *nw;
+
+		seq = read_seqbegin(&sde->waitlock);
+		if (!list_empty(&sde->dmawait)) {
+			write_seqlock(&sde->waitlock);
+			list_for_each_entry_safe(w, nw, &sde->dmawait, list) {
+				if (w->wakeup) {
+					w->wakeup(w, SDMA_AVAIL_REASON);
+					list_del_init(&w->list);
+				}
+			}
+			write_sequnlock(&sde->waitlock);
+		}
+	} while (read_seqretry(&sde->waitlock, seq));
 }
 
 /*
-- 
2.20.1
