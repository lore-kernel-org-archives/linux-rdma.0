Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1370F3939DA;
	Tue, 11 Aug 2026 02:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415936; cv=none; b=tYWSm6VaqvKL26AURlTFFsYKKuaSImJt79cfnaY87T0QtvyM9RmcG0oCfMsAC+9aboiouGf9BPqR0SXV5Ti2juOqPpEUXPty4rjT6Rm7OrknfQzUoP9hmyMmZRjNgz5Tl09y12gIEspPdV3ptH6u1Zm0n09W7sNshCqP9JBJaWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415936; c=relaxed/simple;
	bh=Ng0EreyZ3WAH3A0AsPPSNf53rfE+/qjwvdbAQXX5Cwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4e4Y6dHWch5m/eDr4htC1P+CnmLbgeSfNrZHUjQxl/C2OVy9rjF4KEAptjOeWB55V5rFPQy/kFJB2fnhEB20B+LkuajZWjW/u0WGiudRraErfH2vUWOB7a08TYu1TGK+rGO/W4whiIal06F/R4kY9gdRAuhgDAbTxsWRhQC7m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 6E7F520B6F1F; Mon, 10 Aug 2026 19:38:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E7F520B6F1F
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
Subject: [PATCH net v6 7/7] net: mana: keep max_num_cqs immutable once cq_table is allocated
Date: Mon, 10 Aug 2026 19:38:21 -0700
Message-ID: <20260811023823.2391255-8-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811023823.2391255-1-longli@microsoft.com>
References: <20260811023823.2391255-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_hwc_init_event_handler() applied every HWC_INIT_DATA_MAX_NUM_CQS
event straight to gc->max_num_cqs.  That handler stays live for the whole
channel lifetime -- it also services runtime reconfig and link events --
so it is not confined to the initial bootstrap.

gc->cq_table is allocated once, sized to the max_num_cqs seen at bootstrap,
and every reader (mana_gd_process_eqe(), mana_create_rxq() and
mana_create_txq()) bounds-checks a CQ index against gc->max_num_cqs before
indexing gc->cq_table.  A device -- or a malicious host in a confidential
VM -- that sends a later HWC_INIT_DATA_MAX_NUM_CQS with a larger value
inflates the bound past the allocation.  This includes an event timed to
land while mana_hwc_establish_channel() is between reading the count and
publishing cq_table.  A subsequent out-of-range CQ id then passes the
bounds check and indexes cq_table out of bounds: an out-of-bounds read in
the EQ fast path, or an out-of-bounds pointer write in
mana_create_rxq()/mana_create_txq(), corrupting guest kernel memory.

Stop writing gc->max_num_cqs from the event handler.  Store the reported
value in hwc_init_max_num_cqs, and let mana_hwc_establish_channel() commit
it to gc->max_num_cqs once, from the same snapshot that sizes cq_table.
The handler store uses WRITE_ONCE() and the establish-time read uses
READ_ONCE(), since the two run concurrently (EQ interrupt vs process
context); the single, non-reloadable read is what guarantees the value
that sizes cq_table is the same one published as the bound, even across
the sleeping vcalloc().  gc->max_num_cqs then always matches the
allocation and no later event can change the bound after the table is
published, so the existing bounds checks are sufficient.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v6:
 - None.

Changes in v5:
 - No code changes since v4 (resend as a standalone thread).

Changes in v4:
 - New patch in v4, split out of the v3 teardown-safety work in response
   to review: gc->max_num_cqs is set once when cq_table is allocated and
   never reset, so a spoofed post-init HWC event cannot inflate the
   bound past the allocation.

 .../net/ethernet/microsoft/mana/hw_channel.c  | 34 ++++++++++++++++---
 include/net/mana/hw_channel.h                 |  1 +
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 759b65040a159339a5ab9a2eb95acaaa2e452f53..a29955e0473aa63fde6aa6bca7c85d5c3f423a73 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -262,7 +262,15 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_MAX_NUM_CQS:
-			gd->gdma_context->max_num_cqs = val;
+			/* Store, don't apply: mana_hwc_establish_channel()
+			 * commits this to gc->max_num_cqs once, together
+			 * with sizing cq_table, so a spoofed post-init event
+			 * cannot inflate the bound past the allocation.
+			 * WRITE_ONCE() pairs with the READ_ONCE() there:
+			 * this store runs in EQ interrupt context,
+			 * concurrently with that process-context read.
+			 */
+			WRITE_ONCE(hwc->hwc_init_max_num_cqs, val);
 			break;
 
 		case HWC_INIT_DATA_PDID:
@@ -868,6 +876,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
 	struct gdma_queue __rcu **cq_table;
+	u32 num_cqs;
+	u32 cq_id;
 	int err;
 
 	init_completion(&hwc->hwc_init_eqe_comp);
@@ -902,15 +912,29 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
-	/* Both were set in mana_hwc_init_event_handler(). */
-	if (WARN_ON(cq->id >= gc->max_num_cqs))
+	/* Snapshot the device-reported CQ count and CQ id into locals and
+	 * use only the locals below, so the same value that sizes cq_table
+	 * also bounds and indexes it -- even across the sleeping vcalloc().
+	 * Both fields are written by mana_hwc_init_event_handler() from EQ
+	 * interrupt context: hwc_init_max_num_cqs under WRITE_ONCE() (paired
+	 * here), and cq->id as an ordinary store.  READ_ONCE() keeps each
+	 * read tear-free and, crucially, non-reloadable, so a spoofed
+	 * post-init event cannot make the WARN_ON() pass against one value
+	 * while the allocation or the index uses another.
+	 */
+	num_cqs = READ_ONCE(hwc->hwc_init_max_num_cqs);
+	cq_id = READ_ONCE(cq->id);
+
+	if (WARN_ON(cq_id >= num_cqs))
 		return -EPROTO;
 
-	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
+	cq_table = vcalloc(num_cqs, sizeof(*cq_table));
 	if (!cq_table)
 		return -ENOMEM;
 
-	rcu_assign_pointer(cq_table[cq->id], cq);
+	gc->max_num_cqs = num_cqs;
+
+	rcu_assign_pointer(cq_table[cq_id], cq);
 	/* Publish the fully-initialised table last; pairs with the
 	 * rcu_dereference(gc->cq_table) in mana_gd_process_eqe().
 	 */
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 23bf83e2a3ec6a5b19ab54db0a65ae41b74ad74c..c275150baf490bc5565a78611a4029ff6d6baf02 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -203,6 +203,7 @@ struct hw_channel_context {
 	u16 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
+	u32 hwc_init_max_num_cqs;
 
 	struct completion hwc_init_eqe_comp;
 
-- 
2.43.0

