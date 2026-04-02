Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7E537C900;
	Thu,  2 Apr 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154431; cv=none; b=hi5s0GyGX4A8VXiEQpEkbBTIpDfs41xKN3Mdl0czDKIH/8WWdm9SpJmRoLhv/45qmMYBIs2VaE1oUKYLJ9dU5pKiP3xQdCC+d6ZaRhL18OftXXzWAom54rcdfvJCbSMUJmL2AkuYThNuSg4drJ/yZgS5f1zLllPpTY/NaJntAnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154431; c=relaxed/simple;
	bh=N4eNRpQCrw7NZoaNxW3YoRSNiVllJamZZ8wWuACCQLs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcEawqfyPqdxwh0KlSF4ClwopmwLkiwGgO6cXyXSObQdlqUMr5r2k3VU890FYK84MyJFj3mWIZF7FUP0AUAh5td2KRVG3O+Sg/pdRHtgbLL88/JvzGnplmolJ7Etg7gfm1jqfnxATiYe+WT/XCBY8hGzMFUlh63YfHE4DLIAOIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=G5ljUs6X; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="G5ljUs6X"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id C4A8320B712B; Thu,  2 Apr 2026 11:27:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4A8320B712B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775154429;
	bh=RonUNZbWYP9sU9PMYjhdAeqR0g5714VVqoRILfMXZOA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G5ljUs6X5udD30pkeT0ZQs8GeAAhs3JU4WIa5a1wHDeqOO1mBi4MDDXHonTaQVrkb
	 c1kw5s/JQqdHBDOwjj5tG+2D2MbPaMPB6ftpkiyfYOKenQHuc+GhOz2jycRYbd58mJ
	 YSW6dNa+im1mF5ics1wOXlghHcoacpjwGtEAnn+c=
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	shirazsaleem@microsoft.com,
	yury.norov@gmail.com,
	kees@kernel.org,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v5 2/3] net: mana: Move current_speed debugfs file to mana_init_port()
Date: Thu,  2 Apr 2026 11:26:56 -0700
Message-ID: <20260402182704.2474739-3-ernis@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260402182704.2474739-1-ernis@linux.microsoft.com>
References: <20260402182704.2474739-1-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the current_speed debugfs file creation from mana_probe_port() to
mana_init_port(). The file was previously created only during initial
probe, but mana_cleanup_port_context() removes the entire vPort debugfs
directory during detach/attach cycles. Since mana_init_port() recreates
the directory on re-attach, moving current_speed here ensures it survives
these cycles.

Fixes: 75cabb46935b ("net: mana: Add support for net_shaper_ops")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
---
Changes in v5:
* New to the patchset.
Changes in v4, v3, v2:
* Not created.
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 565375cc20d3..78522205c5d0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3147,6 +3147,8 @@ static int mana_init_port(struct net_device *ndev)
 	eth_hw_addr_set(ndev, apc->mac_addr);
 	sprintf(vport, "vport%d", port_idx);
 	apc->mana_port_debugfs = debugfs_create_dir(vport, gc->mana_pci_debugfs);
+	debugfs_create_u32("current_speed", 0400, apc->mana_port_debugfs,
+			   &apc->speed);
 	return 0;
 
 reset_apc:
@@ -3425,8 +3427,6 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netif_carrier_on(ndev);
 
-	debugfs_create_u32("current_speed", 0400, apc->mana_port_debugfs, &apc->speed);
-
 	return 0;
 
 free_indir:
-- 
2.34.1

