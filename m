Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3C93ACF02;
	Thu, 13 Aug 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642998; cv=none; b=sDeHMIIcac6+2mIJuf2PNl6VHQWGNYBdar9tiEwyOjzGTA6FSEHd8/Om1owSlcvfGsddWzxrh1X6HFRpOR8dqL0xYK2ztheWh6pCixMU0kkXaAwNSJUsqFYFTNhJ/p08lFHQiCxVpgxolN/BVVU7fyKlScGcGnYbE2q+BjuZzTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642998; c=relaxed/simple;
	bh=ynfVnk93C+noMeDmaiZZ+dBSNXBHil1jFlwwtet2QFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQwpmC9Ddj8eCUy4aCw9tyBzU02t9JEwzbM3xUd3lV2NvH14d56n3tPMikmL420DFg4eOgSzAaOKlPi/xBmQ9C9ftFayEvnsgpOEmRUy8APrgT1lKBcsibKx5UxvhMPu8B+XwAi3x9tn6ZFLkB5+l3zgBuP2P7bhZLceEQvz0dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C672A20B7138; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C672A20B7138
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v7 7/7] net: mana: keep max_num_cqs immutable once cq_table is allocated
Date: Thu, 13 Aug 2026 10:42:39 -0700
Message-ID: <20260813174243.3044348-8-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260813174243.3044348-1-longli@microsoft.com>
References: <20260813174243.3044348-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_hwc_init_event_handler() applied every HWC_INIT_DATA_MAX_NUM_CQS
event straight to gc->max_num_cqs, but that handler stays live for the
whole channel lifetime, not just bootstrap.

cq_table is allocated once, sized to the bootstrap max_num_cqs, and every
reader bounds-checks a CQ index against gc->max_num_cqs before indexing
it.  A later event with a larger value -- from the device or a malicious
host -- inflates the bound past the allocation, so an out-of-range CQ id
then passes the check and indexes cq_table out of bounds (an OOB read in
the EQ path, or an OOB pointer write in mana_create_rxq()/txq()).

Stop writing gc->max_num_cqs from the handler.  Store the reported value
in hwc_init_max_num_cqs (WRITE_ONCE()) and let
mana_hwc_establish_channel() commit it to gc->max_num_cqs once
(READ_ONCE()), from the same snapshot that sizes cq_table.  The bound then
always matches the allocation and no later event can change it.

Reject an out-of-range CQ id with a rate-limited error and -EPROTO rather
than WARN_ON(): both operands are device-controlled -- a host that omits
MAX_NUM_CQS leaves the bound at 0 -- so WARN_ON() would let a malformed
response panic a panic_on_warn guest.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
- Reject an out-of-range CQ id with a rate-limited dev_err() and -EPROTO
  instead of WARN_ON(): both operands are device-controlled, so WARN_ON()
  could panic a panic_on_warn guest.
- Tightened the commit message.
 .../net/ethernet/microsoft/mana/hw_channel.c  | 33 +++++++++++++++----
 include/net/mana/hw_channel.h                 |  1 +
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index b1269f7da0563a22c3cbe599df55572e36908139..d9bff4634dc35be772eaeea2c56bfe2562c9d6aa 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -209,7 +209,11 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_MAX_NUM_CQS:
-			gd->gdma_context->max_num_cqs = val;
+			/* Store only; establish_channel() commits it to
+			 * max_num_cqs once, so a later event cannot grow the
+			 * bound past the allocation.  Pairs with its READ_ONCE().
+			 */
+			WRITE_ONCE(hwc->hwc_init_max_num_cqs, val);
 			break;
 
 		case HWC_INIT_DATA_PDID:
@@ -783,6 +787,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
 	struct gdma_queue __rcu **cq_table;
+	u32 num_cqs;
+	u32 cq_id;
 	int err;
 
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -810,17 +816,32 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
-	/* Both were set in mana_hwc_init_event_handler(). */
-	if (WARN_ON(cq->id >= gc->max_num_cqs))
+	/* Snapshot the device-reported count and id once, so the same value
+	 * sizes, bounds and indexes cq_table even across the sleeping
+	 * vcalloc() and a concurrent init event.
+	 */
+	num_cqs = READ_ONCE(hwc->hwc_init_max_num_cqs);
+	cq_id = READ_ONCE(cq->id);
+
+	/* Both operands come from untrusted HWC bootstrap events; a missing
+	 * MAX_NUM_CQS leaves num_cqs at 0.  Reject rather than WARN_ON() so a
+	 * malformed device response cannot panic a panic_on_warn guest.
+	 */
+	if (cq_id >= num_cqs) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC: bad CQ id %u >= max %u\n",
+				    cq_id, num_cqs);
 		return -EPROTO;
+	}
 
-	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
+	cq_table = vcalloc(num_cqs, sizeof(*cq_table));
 	if (!cq_table)
 		return -ENOMEM;
 
-	/* Publish the initialised table; pairs with smp_load_acquire()
-	 * in mana_gd_get_cq().
+	/* Publish the bound and the initialised table together; the release
+	 * pairs with smp_load_acquire() in mana_gd_get_cq().
 	 */
+	gc->max_num_cqs = num_cqs;
 	smp_store_release(&gc->cq_table, cq_table);
 
 	/* Publish the HWC CQ now that the table is in place. */
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index ceabdc6242573f13d1284a967ea73bc01698e37d..f6cac0b0e44c5abd72c308ddc9278e4d85ed41ab 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -202,6 +202,7 @@ struct hw_channel_context {
 	u16 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
+	u32 hwc_init_max_num_cqs;
 
 	struct completion hwc_init_eqe_comp;
 
-- 
2.43.0

