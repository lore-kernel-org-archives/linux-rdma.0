Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4737D10F
	for <linux-rdma@vger.kernel.org>; Mon,  1 Jun 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342693; cv=none; b=KVDl0UNYtHYcWc7v5s9y6c8oxWm4ug5HYPns4sBGCHRNAn4WjNy0a2oQrWQ69PdKt2ytcalb+PiHMghYAiWw05HY0o3P705mxSfrSdCNU9rvubyvN1Ub0Vw757o6a7tHH9+IseN5WcmlmmC4abK3AFqQVWDyRKibK6xX1+cYwQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342693; c=relaxed/simple;
	bh=r9mJlcWklKmtokMJ1n5QpD07n+PIUangyhZE/GTYoTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ezDRk+1Y8Y7MGePh/kPHmWbpHxJa0AXND7P92aJvNUQHMj5/Xjb0InnjAu7JoE1xnhRn+geJ49OJ3pmU1CQZ0JIY3pZpAw0eCtmWX8jHcCB2f1d0TFC01lIMJFB0RQes+eNnFdDZ7JsOvSZqJI59QG0N5OC8WAYka3WyggRKCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net; spf=pass smtp.mailfrom=theesfeld.net; dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b=eqV5FG75; arc=none smtp.client-ip=109.224.244.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theesfeld.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=theesfeld.net header.i=@theesfeld.net header.b="eqV5FG75"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=theesfeld.net;
	s=protonmail2; t=1780342683; x=1780601883;
	bh=9wrJNg+FxScttXG57uNVoUp25+imnVKPCNzJdOd95RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=eqV5FG75GjCsdvHm7g1EvY4g3BBUCauxnXU6GZBNXfMuW8tWFwcD40MgKobSkusKn
	 B2bItjSShhWZzrDsR8BPa8UdeHGLvEj2jEFhtVxQRXrRztIQyBJ2XYiUv0TYa+xgYn
	 kCIRBrHYyQr9XZ0uo57Ns2U7SZ4d+W/PhUmav3p5+U1GN50kaTHKB1L6otShSJNEEG
	 Z1zKqVK9jgikAZj1qhBsQi6swjlh9nsIbcnyaxu7AC8qR34xmGbppD18L388WEKpDh
	 AyxllU9CxuHMNX+2h3wCPDJ0+eXBRrpCtrWLwj2KQKNJ1YxJMkgSOI/K9L07OfDxpV
	 9+VLjohHk98yw==
X-Pm-Submission-Id: 4gTklD022Sz2Scpw
From: William Theesfeld <william@theesfeld.net>
To: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: convert miss_list allocation to kvmalloc_array()
Date: Mon,  1 Jun 2026 15:37:58 -0400
Message-ID: <20260601193758.626537-1-william@theesfeld.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dr_icm_buddy_init_ste_cache() allocates the per-buddy miss_list using
the open-coded kvmalloc(n * sizeof(*p), ...) form.  The neighbouring
allocations in the same function already use the kvcalloc()/
kvzalloc_objs() forms; switch this last one to kvmalloc_array() for
consistency and for the size_mul overflow check that kvmalloc_array()
performs.

The semantics are unchanged: kvmalloc_array() returns a non-zeroed
buffer, just like the previous kvmalloc() call.  Existing callers of
buddy->miss_list initialise each list_head before use.

Signed-off-by: William Theesfeld <william@theesfeld.net>
---
 .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
index 7a0a15822..fa4d24b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
@@ -239,7 +239,7 @@ static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
 	if (!buddy->hw_ste_arr)
 		goto free_ste_arr;
 
-	buddy->miss_list = kvmalloc(num_of_entries * sizeof(struct list_head), GFP_KERNEL);
+	buddy->miss_list = kvmalloc_array(num_of_entries, sizeof(struct list_head), GFP_KERNEL);
 	if (!buddy->miss_list)
 		goto free_hw_ste_arr;
 
-- 
2.54.0

