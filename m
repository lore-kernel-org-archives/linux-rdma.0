Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC67D3955EC
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232183; cv=none; b=rGzvayUl4wAPL7PqHIO0D4eD1r7cK3il9JjBiEX13pEC/UUBWD9eZKXUwpNPaEgsqCf2PfvYCK3LcxiUlpOiONMWS5WCoUl7U16M823VDNMI1f0GRawzh++LqAOAIXVaoojTjMdxsbl2MBb+JeKJF1gTfXLMrxMm0qP9MfOnj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232183; c=relaxed/simple;
	bh=cHqkj9IQmM9UJezBHB4mIJEzWFGJ8nQ71hNpg9TPw/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGnqnYg/JQuSlKWRPOatyw/NHkbcz9X+yCMUsPyF2fibvyXr1ap9F3T917vCsxy5sF6+CghEcShQQT8S3KeVAlyCwNaiQY4fnmPMQuMDB3Pdvnl1NJNKBRc8cs10jJtQoiomRNF8gWtOcSAnKwLF3hTDKj17AWwBlb5Tyh7/8lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O55dK8Yy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O55dK8Yy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EtZTXBp7wCPKWuWjKaY6V1GUEMnphVn8b7/0mFctUso=;
	b=O55dK8YyYsRARGZXQLzKVkVpQ2sh1xUcKq50e0LxfyXyGPHCmqW75zDglwqdadMaMM8kvc
	iR99nTBIAgtdHMT7u3vBtPNJdFXe7BlahqttGkT8I1dHZb0RX/n/VkG8Ct3fhfuL97ytHi
	AbG6cO17iNTu2m2XaYXTL6Cg4+mMcKs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-FAjaJGUEPmC_Rket_I28cA-1; Thu,
 24 Sep 2026 02:42:57 -0400
X-MC-Unique: FAjaJGUEPmC_Rket_I28cA-1
X-Mimecast-MFC-AGG-ID: FAjaJGUEPmC_Rket_I28cA_1790232175
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE84C187A5C0;
	Thu, 24 Sep 2026 06:42:54 +0000 (UTC)
Received: from fedora.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E72BB18005B8;
	Thu, 24 Sep 2026 06:42:48 +0000 (UTC)
From: Anirudh Virdi <avirdi@redhat.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shayd@nvidia.com,
	ohartoov@nvidia.com,
	maorg@nvidia.com,
	linux-rdma@vger.kernel.org,
	Anirudh Virdi <avirdi@redhat.com>
Subject: [PATCH net v2] net/mlx5: Fix slab-out-of-bounds when handling team device events
Date: Thu, 24 Sep 2026 12:12:44 +0530
Message-ID: <20260924064244.94045-1-avirdi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
functions check for LAG masters (which includes both bonding and team
devices) but only call bonding-specific APIs. When processing team device
events, calling bond_slave_get_rcu() and bond_is_slave_inactive() on
team_port structures causes KASAN to detect an out-of-bounds memory access
since team_port is smaller than bond slave.

Fix this by wrapping the bond-specific API calls with a check for bonding
devices. This allows the function to still process LAG events for both
bonding and teams but only calls bond-specific functions when dealing with
actual bonding devices.

For mlx5_handle_changeinfodata_event(), keep the explicit bond check as
mlx5 doesn't handle state information for team ports anyway.

Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
- Bonding: PASS (no regressions)
- Team device: PASS (no KASAN errors)

Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
Suggested-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Anirudh Virdi <avirdi@redhat.com>
---
Changes in v2:
- Changed mlx5_handle_changeupper_event() to keep netif_is_lag_master() check
  instead of using netif_is_bond_master() at the start
- Wrapped bond-specific API calls (bond_slave_get_rcu, bond_is_slave_inactive)
  with an explicit netif_is_bond_master() check inside the loop
- This allows both bonding and team events to be processed, but only calls
  bond-specific functions for actual bonding devices
- Suggested-by: Mark Bloch <mbloch@nvidia.com>
- Tested on hardware to confirm both bonding and team devices work without KASAN errors

 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 28d16fdc3f06..1c4107d9a408 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1918,9 +1918,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 			}
 		}
 		if (i < MLX5_MAX_PORTS) {
-			slave = bond_slave_get_rcu(ndev_tmp);
-			if (slave)
-				has_inactive |= bond_is_slave_inactive(slave);
+			if (netif_is_bond_master(upper)) {
+				slave = bond_slave_get_rcu(ndev_tmp);
+				if (slave)
+					has_inactive |= bond_is_slave_inactive(slave);
+			}
 			bond_status |= (1 << idx);
 		}
 
@@ -2004,7 +2006,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	bool has_inactive = 0;
 	int idx;
 
-	if (!netif_is_lag_master(ndev))
+	if (!netif_is_bond_master(ndev))
 		return 0;
 
 	rcu_read_lock();
-- 
2.55.0

