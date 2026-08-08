Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF24E32B113;
	Sat,  8 Aug 2026 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786156486; cv=none; b=BgpF+1MXuft0wN2mj1j9KYWShwFkSYN7SMxlgtNiz5P3mWnfBcmMFoW8+3i/K1gLOgLlX5m+gAW1alvGGcd67wYrYVuyQ59M0P+0uQGqs3GnpjJ4bmAJhcXb1r/4LYuBYfsBbE39PgFcO/wnVNq+sSHMGKfn9TKI4SMxnusgu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786156486; c=relaxed/simple;
	bh=bz9BAHxfS4mtjHdw7JzIkCbIa3xWtmGWpt5vEKWxg1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qe+QyHfQrJxDu6lcPw1/be5VUwQ3aeJ+Cd6NCmotZPfPgaFDhdTQNeiSPg5kOtE1jGW/SvBSxrSQaR4ufHGqIlBa3nGOCZDHZYbIFMFWxLXXQe1IkrApbxFf8Pm8Vn9nsVLQb998loJClFRgmszuDMH/nQxn208dWTEBcUBy6Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id BB75E20B710C; Fri,  7 Aug 2026 19:34:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BB75E20B710C
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
	stephen@networkplumber.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Kees Cook <kees@kernel.org>,
	Shachar Raindel <shacharr@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v4 3/7] net: mana: free HWC comp_buf after destroying the EQ
Date: Fri,  7 Aug 2026 19:34:12 -0700
Message-ID: <20260808023417.1746886-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260803234355.636038-1-longli@microsoft.com>
References: <20260803234355.636038-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

mana_hwc_destroy_cq() freed hwc_cq->comp_buf and destroyed the CQ before
the EQ.  That was unsafe while the EQ was still registered: the EQ
interrupt handler reaches comp_buf via mana_hwc_comp_event() and the CQ
object (hwc->cq->gdma_cq) via mana_hwc_init_event_handler(), so a late
EQE dispatched after the free could touch freed memory.

Destroy the EQ first.  mana_gd_destroy_queue() on the EQ deregisters its
IRQ and waits out in-flight handlers, fencing all EQE dispatch; only then
free the CQ and comp_buf.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v4:
 - No functional change since v3; the teardown-ordering guarantees this
   patch relies on are made explicit in patch 5.

 .../net/ethernet/microsoft/mana/hw_channel.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 3f011ebbe7b3..19896bb5ce1a 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -384,14 +384,24 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	kfree(hwc_cq->comp_buf);
+	/* Destroy the EQ before the CQ.  mana_gd_destroy_queue() on the EQ
+	 * deregisters its IRQ and waits out in-flight handlers, fencing all
+	 * EQE dispatch — both the completion path and HWC init/reconfig
+	 * events.  Freeing the CQ first would leave the EQ live and able to
+	 * dispatch an event that dereferences hwc->cq->gdma_cq (e.g.
+	 * mana_hwc_init_event_handler()) after it has been freed.
+	 */
+	if (hwc_cq->gdma_eq)
+		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
 
+	/* comp_buf is reached only by mana_hwc_comp_event(), invoked from
+	 * the now-fenced EQ handler, so it is safe to free once the EQ and
+	 * CQ are gone.
+	 */
 	if (hwc_cq->gdma_cq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
 
-	if (hwc_cq->gdma_eq)
-		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
-
+	kfree(hwc_cq->comp_buf);
 	kfree(hwc_cq);
 }
 
-- 
2.43.0

