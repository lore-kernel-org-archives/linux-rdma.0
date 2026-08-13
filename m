Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFA63A0EB3;
	Thu, 13 Aug 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642996; cv=none; b=FPdZueIBcyreFX0irI8BfPTME8u8fA5jFFKDGHCUwuTQQHlpfIE/JCUP/u+F5zZrGSpy5kALXXfALNhTAGnV3zfYpeLlPlHn+YwaVvl5wA/4zKkq/GO/KIxH5YiyDLYt/USSSGVxrXbNsnhIj5S98cf9Q8GQoCCbiMXSG9If4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642996; c=relaxed/simple;
	bh=SL7WJ47bzQJfuqEmzsTV/rSJsKKDtJ6GqfQyzTibg+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4XnZHZiEXHxvTYxOvbAUWSpnSxSW8uUaTYCWSG4r6kPXfCnB9f3xEwSsoeVQ0JWbtE9f98+xM04S1OTVZ6bf87fkqwopqMsxrSyyusjeevplNV7kQQtepbYizf5rUVEPJNQ88WxLn0y94HTk1xLQ0VuwduzkTicO/DSxXHgRU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 8BDFA20B712B; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8BDFA20B712B
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
Subject: [PATCH net v7 3/7] net: mana: free HWC comp_buf after destroying the EQ
Date: Thu, 13 Aug 2026 10:42:35 -0700
Message-ID: <20260813174243.3044348-4-longli@microsoft.com>
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

mana_hwc_destroy_cq() freed comp_buf and the CQ before the EQ.  While the
EQ was still registered its handler could reach comp_buf (via
mana_hwc_comp_event()) and the CQ (via mana_hwc_init_event_handler()), so
a late EQE could touch freed memory.

Destroy the EQ first: mana_gd_destroy_queue() deregisters its IRQ and
waits out in-flight handlers, so no EQE can dispatch; only then free the
CQ and comp_buf.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes since v6:
Commit-message and comment wording only; no code change.
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index ccef9bf9c6bfde754c28f86103f0b05489091f02..7e01596df11b639b1801bef7bdb09c91dfeb0543 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -384,14 +384,17 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	kfree(hwc_cq->comp_buf);
+	/* Destroy the EQ first: it deregisters the IRQ and drains in-flight
+	 * handlers, so none can touch the CQ after it is freed.
+	 */
+	if (hwc_cq->gdma_eq)
+		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
 
+	/* Safe to free now that the EQ handler is fenced. */
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

