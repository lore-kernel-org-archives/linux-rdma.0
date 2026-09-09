Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7D4493D58;
	Wed,  9 Sep 2026 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992717; cv=none; b=aXAZmILY+T27D872Nj//SqitJ0wwg2kv3Lu6IHPRBhjNbKbQU1bvv94Ubat19JfSnSkbzyNtq4qKRj39FS0VuH9ZwmbEFv8NWJZY+TJ4oTB8ZGYMfYULb9KjBtJllRfvItDJlUbvBDhSry45wFiD2A1Am++nG5Jm+Yr8hkE2qAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992717; c=relaxed/simple;
	bh=eD9tFiZQkj0UUL66ipyPBrQRIvJWNeJq69DUrTdvu4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRiUeho59i/CF6rbZr/ANvVBoNWNB/C2EsshfTLO18UUQKL218lI89vKjaX2XWullUJ2sZGzgcvu8A3J7k1Rlp/MrgHdUJAgc09kFu2gaS2FvGZy129Rjs+r6fgXBSNkL0KD4zPuUZEANfzv1EkgwW5M89mMryTCvoyLId4nxy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 9D6FE20B7171; Wed,  9 Sep 2026 15:24:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9D6FE20B7171
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>
Subject: [PATCH net-next v5 08/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Wed,  9 Sep 2026 15:24:11 -0700
Message-ID: <20260909222416.884246-9-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260909222416.884246-1-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

Remove the early return after mana_dealloc_queues() so detach continues
its device and port-context cleanup.

The return is currently unreachable: mana_dealloc_queues() only rejects
an up port, and mana_detach() clears port_is_up before calling it. This
is a robustness cleanup, not a fix for a reachable reset failure.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
Changes in v5:
  - Rebased onto current net-next; no changes to this patch.

Changes in v4:
  - Frame this as removal of an unreachable error return, not a fix
    for a reachable fatal reset failure.

 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 62c11af2fc422206f0ab8e144a4d082d62f7737d..5752e3745ccc6ba26bdd8f9be3108e4f3de69be0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4340,10 +4340,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
 	if (apc->port_st_save) {
 		err = mana_dealloc_queues(ndev);
-		if (err) {
+		if (err)
 			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, err);
-			return err;
-		}
 	}
 
 	if (!from_close) {
-- 
2.43.0
