Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5EB3CEB84;
	Tue,  1 Sep 2026 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227134; cv=none; b=gJVT8h5HFnUZUkR8OEfThC7WJvHxIz7PksbDpSdD/6oYmohGvEzYqAnsoE3C4JSwSFhMWMuKubJYqX+GHF/yYWPr4xLf3Reje2JSqndyWZ/qOkvkc+pNRB0gfxa+EL1Rxn7l9lACiE0xsyxv5fN8AMct4Q3SVLsKcDOL6MwXLys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227134; c=relaxed/simple;
	bh=zQkGw7ksMFnupUTs/IA8WLfjU15uQMWoYdqV4IhPs0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjCsvdiDhMtpI3DIh3uK8j4OSz3jwZhbmKkhUWw6bemWkaW+l3zCIBNsH2A23+LzpkASmfz9D4TcedOl8fL5UKoDpDM2PwlNGpvs/k2G/MeqVb5FDXLX6N3ZwuWjzFqKwaOuReFJ4PpNBriR8AoSiUzgKx9PUIKcow4FfZc4PAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 6060F20B7007; Mon, 31 Aug 2026 18:44:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6060F20B7007
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
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>
Subject: [PATCH net-next v3 08/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Mon, 31 Aug 2026 18:44:37 -0700
Message-ID: <20260901014442.2945689-9-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901014442.2945689-1-longli@microsoft.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
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
index af2fdd5e876eb100cfafb00f2eb0ad7aa9a165c7..5c5d1edd20f84d0d1a20d2a5bc0ecefea0d7aaed 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4594,10 +4594,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
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

