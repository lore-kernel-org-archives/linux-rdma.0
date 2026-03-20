Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC385846F;
	Fri, 20 Mar 2026 23:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774049442; cv=none; b=kRSkVs+ZRKl0MPGn5C3VP0BvPdtbyIWGhGJNWfH0Z8jMzumizTJyMxXTn1CN0ew8yh364EIk1inNgGCvCT56+nGLdnh54TAeysgPerYPWvkJzSzXMnpE0pRzHOi10nDTRF0Wa9SzrrE+r4Yu8CkVRQCvdxPYQh47TlymC76uwHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774049442; c=relaxed/simple;
	bh=55x65rcI3Xy68ox8Qxvc+GJMDplJ+mxBUGukF8cGD7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sXFA7VuGH5IY6up/IA3xdyKKLX9k5iGxgr5r4n9v/kLSq0MNVpxw1ROSPy51RYs9AX8fwlpchQjjAZ3OqsM8/0voW7CIMB3aJ5CKHehUG9UluG18koYlBXpgQ56SG7But9ECzAyP9XVkvDFdnHUemAYJ+yHQ/De9zC4vdyzezzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id D9EBE20B710C; Fri, 20 Mar 2026 16:30:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9EBE20B710C
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
	Dexuan Cui <decui@microsoft.com>
Cc: Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mana: Set default number of queues to 16
Date: Fri, 20 Mar 2026 16:30:27 -0700
Message-ID: <20260320233027.1603495-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the default number of queues per vPort to MANA_DEF_NUM_QUEUES (16),
as 16 queues can achieve optimal throughput for typical workloads. Users
can increase the number of queues up to max_queues via ethtool if needed.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 include/net/mana/mana.h                       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 49c65cc1697c..7cae8a7b9f31 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3357,7 +3357,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->ac = ac;
 	apc->ndev = ndev;
 	apc->max_queues = gc->max_num_queues;
-	apc->num_queues = gc->max_num_queues;
+	apc->num_queues = min(gc->max_num_queues, MANA_DEF_NUM_QUEUES);
 	apc->tx_queue_size = DEF_TX_BUFFERS_PER_QUEUE;
 	apc->rx_queue_size = DEF_RX_BUFFERS_PER_QUEUE;
 	apc->port_handle = INVALID_MANA_HANDLE;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 3336688fed5e..96d21cbbdee2 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -1007,6 +1007,7 @@ struct mana_deregister_filter_resp {
 #define STATISTICS_FLAGS_TX_ERRORS_GDMA_ERROR		0x0000000004000000
 
 #define MANA_MAX_NUM_QUEUES 64
+#define MANA_DEF_NUM_QUEUES 16
 
 #define MANA_SHORT_VPORT_OFFSET_MAX ((1U << 8) - 1)
 
-- 
2.43.0

