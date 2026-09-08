Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569A53242BE;
	Tue,  8 Sep 2026 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788838172; cv=none; b=PITC/Z7e5FHFBAhcx4HUBUv9qyYB50mZw7QIdosj8zDrSmwgZFLR23obYOwwhLCVBaxrHIfKnx2Eil1/lnCTgDtM+pejF/6hXXhnv84gI71T5ApWKE47WrN6bid419nNc59wQ5Tpeb1NDKKi3EBgH5AGQlK9440+UHzx/FEtdSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788838172; c=relaxed/simple;
	bh=OU05ud58Ncr7sPAfe9Mre/p6OwnL9gn/FeTUaqQ6hY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvTrG/HTnqPwG0h+Fl/tONvR2cgzorXf7p658Mj3ZU8JgYKotyNr+l61TE+9tmQ7nOE4FLt6TR2qJjxMWjw2hGDE1NX2I54BjUPJ8k7Rl+tkYQYC1+wZnYBlUsR+uWVPot/dkIrDIJM0skLAc1wL+62KLHbFTMSlyTMK6nTRRgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 34D8D20B7007; Mon,  7 Sep 2026 20:28:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 34D8D20B7007
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
Subject: [PATCH net-next v4 08/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Mon,  7 Sep 2026 20:28:38 -0700
Message-ID: <20260908032843.397667-9-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260908032843.397667-1-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
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
