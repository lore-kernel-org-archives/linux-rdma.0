Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F1E3F6C3B;
	Tue, 11 Aug 2026 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430141; cv=none; b=ctuG+p9F/umg1O8AO5anmLAMUAtiZINKIK5gHZvrElFhDWSdCth+VmJ5CHd4TSkD8M+f0z1P3XslX1EmaiOkJ9KVen8IfjAzc9liOYDxcd08PDAtBUXReM26limimVTSvR55VPDn9Etbe8nT+hvV+XSGaMVa/tPMt+7oTh2K/i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430141; c=relaxed/simple;
	bh=nUM7KtTfn6bWrb8uQAFWijjY5+27P8jJIWhqVOQJp3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIf0LTpfOfHC+FgegvMiKabcZJfpPgT+qha9g9yZI4gMBAM/lFdvE6O0307gloYwSnvl0osstINXN0a25u4T5GhH3X6a1WKbwBYlVChitQyBocpO6TR8d4c6qDIlongxs2LE6ot90m/KjQZajbRIf0PXI03Yy8UKGXBLwijYHxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id C0D6A20B712D; Mon, 10 Aug 2026 23:35:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C0D6A20B712D
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
	linux-kernel@vger.kernel.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>
Subject: [PATCH net-next v2 07/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Mon, 10 Aug 2026 23:35:04 -0700
Message-ID: <20260811063506.2428213-8-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063506.2428213-1-longli@microsoft.com>
References: <20260811063506.2428213-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

mana_detach() sets port_is_up = false before calling
mana_dealloc_queues(). If that call were to fail and return early,
netif_device_detach() and mana_cleanup_port_context() are skipped,
leaving the port in an inconsistent state where port_is_up is false but
netif_device_present() still returns true.

With the ethtool, MTU and XDP paths converted to pre-allocate and swap,
the callers that reach this code with from_close == false are the TX
timeout reset handler and the suspend path. For the reset handler the
inconsistent state is fatal: its mana_detach() would overwrite
port_st_save with false, so the following mana_attach() skips queue
allocation and leaves the port permanently dead. For suspend it leaves
the port context allocated across the transition.

Remove the early return so that mana_detach() always completes its full
teardown. mana_dealloc_queues() already performs best-effort cleanup
regardless of internal errors, and in practice cannot fail here since
port_is_up is already false, so continuing to netif_device_detach() and
mana_cleanup_port_context() is safe and keeps the state consistent.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index e554a776e8a941f80831047610066eed115c02b9..89d5215db160572f633e32711f251a6b1d82b276 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4659,10 +4659,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
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

