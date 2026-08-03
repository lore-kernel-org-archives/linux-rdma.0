Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11E73947B0;
	Mon,  3 Aug 2026 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800665; cv=none; b=FdAVw2ZfZgoWdMi0luxWZprbjjav2Kyr7TTmiM89f8AlUUdZ/I5tN8nMRBF/aOFTVsmkEXo04KbRoVZcYqxA78Ma8nP4pJdtWx2rXadibpVKiPy8Zey0ve2IabCYPiU7k4GvxDDq9bFFF++fc5JfoYPIUPCMVRSA/T6BuUv8Kn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800665; c=relaxed/simple;
	bh=1iPJmpiIMapFaNbicnppV3lURzURIP0eJ2OgEi3Lnes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek06TJpuO6IyXU2eNLOyKLjW0S5Vb/B7WE8pyBro2MUrU74R+WiM+9JT5sDl8AIO0q2xvFx5WT8+CdnxY7en44l22xujyfDXBlg94qsvFSgxC1B/iaEkUa3MlOs5Nfsg7+iL3QcxIoOI6mtkpYPk5nACnt8w6YMvywUVaYLbZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 2E45620B716B; Mon,  3 Aug 2026 16:44:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2E45620B716B
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
Subject: [PATCH net v3 3/6] net: mana: free HWC comp_buf after destroying the EQ
Date: Mon,  3 Aug 2026 16:43:41 -0700
Message-ID: <20260803234355.636038-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_hwc_destroy_cq() freed hwc_cq->comp_buf before destroying the CQ and
EQ.  comp_buf is dereferenced by mana_hwc_comp_event(), which the EQ
interrupt handler invokes; freeing it while the EQ was still registered
let a late handler touch freed memory.

Destroy the CQ and EQ first -- the EQ teardown deregisters the IRQ and
fences in-flight handlers -- then free comp_buf and hwc_cq.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index cbb56c764787..d701c427fe47 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -384,14 +384,20 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	kfree(hwc_cq->comp_buf);
-
 	if (hwc_cq->gdma_cq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
 
+	/* comp_buf is reached only by mana_hwc_comp_event(), which the
+	 * EQ handler invokes via cq_table[id].  The CQ destroy above
+	 * already cleared that slot and ran synchronize_rcu(), so no
+	 * handler can reach comp_buf once it returns.  Destroying the EQ
+	 * here additionally tears down the IRQ (defense in depth) before
+	 * comp_buf and hwc_cq are freed below.
+	 */
 	if (hwc_cq->gdma_eq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
 
+	kfree(hwc_cq->comp_buf);
 	kfree(hwc_cq);
 }
 
-- 
2.43.0

