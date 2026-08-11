Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA543876B5;
	Tue, 11 Aug 2026 02:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415934; cv=none; b=BJcFY3nwniSTWT0XSOVYVaftcHWUoZuI3kJ6l4ibCagkMuVn/6mmfNCNfnfVoooLaECAhZVC1hgtI0Zy3dLtNiqI5TlMqAPZiNmcVaa+RhLIxI4Q1NIejyW3WNmcyhqqPX6BMyVHRCL/YNSEoMbMSQyFFRHaGQMjpt92JMj0fJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415934; c=relaxed/simple;
	bh=yqdiSu6S/XTKHVh7OgNycZ0kiuWgguKYIbkIxxSxwYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jESSANp/cVmWap0mjDUE51OWI3hkeN4HjYyXgTYH9xucwAsZbD1LfQ9hNRYwGAtop5rjCbFVz+881qBSlO/zkfFWeHK/SwDQhUmh5lJ6KC2NSW+J8vJtZcv61dwlgsvXgfkpAprsamYSkwcATVqU3h9wZYnQ2F5YRi01oSAS3Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 36D9220B7167; Mon, 10 Aug 2026 19:38:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36D9220B7167
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
Subject: [PATCH net v6 3/7] net: mana: free HWC comp_buf after destroying the EQ
Date: Mon, 10 Aug 2026 19:38:17 -0700
Message-ID: <20260811023823.2391255-4-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811023823.2391255-1-longli@microsoft.com>
References: <20260811023823.2391255-1-longli@microsoft.com>
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
Changes in v6:
 - None.

Changes in v5:
 - No code changes since v4 (resend as a standalone thread).

Changes in v4:
 - No functional change since v3; the teardown-ordering guarantees this
   patch relies on are made explicit in patch 5.

 .../net/ethernet/microsoft/mana/hw_channel.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 3f011ebbe7b3e3de2665bfa164c678c89b9b3005..19896bb5ce1a4e365a3a8363b78b005242f84e8b 100644
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

