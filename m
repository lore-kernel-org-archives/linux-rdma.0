Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D993544D73
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085111; cv=none; b=bYZQI15J192m/3T20z2mIdq0C7wwL2ghZM5Qrn4oxBD7MxZFPww31oqIRyBGPLU92l/mgoYu8vhaOGdpUrYQn9Og1xWz5yq0zFHH+GVMraYsacqJFkfLuxpuX8JVGbA9A4ZRKy/Zf2KWHMOyVIkaCLHDkPRtyWEhrT4KYpCVSMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085111; c=relaxed/simple;
	bh=PHHeBkTUUbVe48PRib7ybGU4knWph0NCvNZx7jPeJAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nDQI6bSztD+MqKqBfm85xvGoHGlxn8LKR7UrtexrsDCHabxdB1q8tp1LBZ1zeU72WrFdvaBlkKvFbw5cfqRYVYJ8hKrFf/8lvcT7twF+mebU1ZnuUbp7OepEg/5BA7Gqsec37/uLT9FHgu1+q1RNqG+wtBsKXlcazuNnJNzCrtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QnMiE56C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnMiE56C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790085109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E10+PWqTEjwyBWN9Zj4spCIBtKpKl/tBI/SnqZqASCg=;
	b=QnMiE56CjyxyuH37Q4PtctBEgWVqKlACIqf4EDwNUqRbzgprRd6JXvTbMlMgtVBkY5CJN4
	+zMngZNtNe00N0J/VPcy4R671IKuiPBMAiMyvTeaOCTdxhMP2UCtqL4lBueiWwzs+3Q86u
	8rl5wRtWQfM3wRqVA5Am0z8jFjmvmMo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-3AfWG8nzOBisTdzw4tULPw-1; Tue,
 22 Sep 2026 09:51:46 -0400
X-MC-Unique: 3AfWG8nzOBisTdzw4tULPw-1
X-Mimecast-MFC-AGG-ID: 3AfWG8nzOBisTdzw4tULPw_1790085104
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA01C184139F;
	Tue, 22 Sep 2026 13:51:43 +0000 (UTC)
Received: from fedora.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04E2D30001B9;
	Tue, 22 Sep 2026 13:51:37 +0000 (UTC)
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
Subject: [PATCH net] net/mlx5: Fix slab-out-of-bounds when handling team device events
Date: Tue, 22 Sep 2026 19:21:23 +0530
Message-ID: <20260922135123.46205-1-avirdi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
functions assume the upper device is a bonding device and call bonding-
specific
APIs like bond_slave_get_rcu() and bond_is_slave_inactive().

When a device is enslaved to a team master instead of bonding, the code
attempts to access the team_port structure as if it were a bond slave
structure. Since team_port is smaller than slave, this causes KASAN to
detect an out-of-bounds memory access.

Fix this by checking explicitly for bonding devices using
netif_is_bond_master() instead of the generic netif_is_lag_master() which
includes both bonding and team devices. This ensures mlx5 only processes
bonding events, not team events, preventing the invalid memory access.

Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
- Bonding: PASS (no regressions)
- Team device: PASS (no KASAN errors)

Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
Signed-off-by: Anirudh Virdi <avirdi@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 28d16fdc3f06..022a69cdebaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1897,7 +1897,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	int changed = 0;
 	int i, idx = -1;
 
-	if (!netif_is_lag_master(upper))
+	if (!netif_is_bond_master(upper))
 		return 0;
 
 	if (info->linking)
@@ -2004,7 +2004,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	bool has_inactive = 0;
 	int idx;
 
-	if (!netif_is_lag_master(ndev))
+	if (!netif_is_bond_master(ndev))
 		return 0;
 
 	rcu_read_lock();
-- 
2.55.0

