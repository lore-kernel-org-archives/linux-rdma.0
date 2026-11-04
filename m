Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811872;
	b=OrB1mdzxiu77dhHZUjeKd5Dh9fwo5VcHLOj1nmUJ6x/8KJ5Xt4Vgr6yq5sZBL5LueQlB
	 uw+T1R8fsvhQVNxRVFkTKo/78D3AH00iZ8/MWKee9meKXasIpZu0RuSd7iZPJrLDEKy+g
	 m2amg+hREGJjrSDu8QVvPiqABO/BH5E6QXHaBlK9d0QSPCRQ3XPi5dH8whnHnorr4SPqa
	 c3MWdNrI8QR8U1K6h3pK5Pa77k8DFfmdS/ZNHFrg2SodBl0GWbJQAYJaBshv0s4rlXrhc
	 tQRQiIBQEv+v9AJJZw+G9dLL0hN45t+Jq+QSW3Ggcpxj8QSQUaL3XtUP2DPScrC/WVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811872;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=uk4o3l+cI6AUeTKrPcS2F8cKNnNOt3JCQtSUOlfoC4U=;
	b=nZbAW6qdTQeX2Ti7amTkJOGIGjZ19zU2j6pA/tmTuqEQTf+3sAGrYZoQypjK0v5exUFS
	 DuMfMk6IxsNfPltJMrcgSxGH6RS06BDTLaRy8unV+RmXVMXNh+uPDaIszElQEpYjIrkh1
	 xanQU2SMqd0JHbnIIlJlcfxAoJNv/bRxKL1a8aWs+p0F31S4n31oItUJ8YGGESr3yehdW
	 VpEtg5D9eAjby1MYrFcHBM+jjEmx8d3lL74Kx97QnK57PIpxf3kBjObef/9NYN+fuqcyg
	 tH7sDHXjTTLhKaueshkC5sk26n9Y3bR9nsdrbDkIf0TeEueQoP5jyVui0nDMlGtK71Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b="Wy/Nfw9n";
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5E606A328;
	Wed,  4 Nov 2026 17:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51F5E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Wy/Nfw9n
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=uk4o3l+cI6AUeTKrPcS2F8cKNnNOt3JCQtSUOlfoC4U=; b=Wy/Nfw9nAGXrezygvqCJUcWDuP
	4tgj9tSVq9W21pEAPZZ9e6czTmt5vPLa3mjxAKu+VopWXU1bLEI6w1m4C9tz+LxLDoIrOpv/AFWdL
	7ifGkJ3Gm7GGZZiRqwp4QZlll2MusDoLdUSyk1jgb6jvIbFJ+8S52iLM2w1eVpz5cNz3x54dRDXK5
	6Krp4Nho2/k3OmuX0nuYY58Vsx5czGjZf/fTUbXYftJwo6QS7LB16RwIRSkIlulkfDnW08RGCrG3m
	brKhMGLNMCjYQdus0nbmlMvJmgwdnIjcEmggGy5V9J+mXcRAjLgfK7U6zI+FZTcZSlrEf1cpCTZFt
	6qBwWb9w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOePQ-007sJp-24;
	Wed, 04 Nov 2026 17:04:24 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 04 Nov 2026 09:04:11 -0800
Subject: [PATCH net] net/mlx5e: Fix queue stats access to queues without
 stats
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org>
X-B4-Tracking: v=1; b=H4sIAIpl62oC/yWM2w6CMBAFf4Xss5vQyiX6K8YHLgdYU6t2iyEh/
 DtFH2eSmZUUQaB0zVYK+IrKyycwp4y6qfEjWPrEZHNbGZMX/HRLCf5obKKyn53j86WvCosaGGp
 K3TtgkOX3vJFHpPtf6tw+0MXjRtu2A31tYDF6AAAA
X-Change-ID: 20261104-mlx5e-qstats-null-39d642e7eef7
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Joe Damato <joe@dama.to>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2484; i=leitao@debian.org;
 h=from:subject:message-id; bh=DiyLilUFtJe6EmmoocnPaoco145t0qJs//3Ho1BL0Wk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq62WVgMUdZQ4y0rzCThMu01r/F/P+jSPB3bkZk
 b3M/nIuo0mJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCautllQAKCRA1o5Of/Hh3
 bWRlD/99Y/6qRsFFNX71O1qu3CGXHscsZwfh3YL61/vLVI4DDqf7GnBdpkBU9zJ0Clyrp/KBMuR
 ZkOBaMoBvm+E+HRVEaORAGGYwbNzJGN0DwfGFL6ZG/7gb0ckFh61uFAlqyendRGKcbwkN4PXVnt
 3784zfyNWda0EeWDNGjD+oABU4Era2v0ljujk5bsWfXnqeqI38rI85R9TonKew6agHkGDQ0cZtW
 1Vcg3fUW3dyFSlaOxfia3zO8rh78fEB3RQxK4K1yk9hYZ8xFv4U/KD762bj2Jfco2DxJg+VoJMo
 Or+yg1erejs5oFsMAcHq4oCXpcD3q/N+D5MvukWOfDHxMTAmaDVgeS032FFfyqj9jTbILWpAsuT
 7dON+rw/NX8kXgszgNYGQNGxd7hSKHHKsigSzydZy/zsG6l2nhoWAT0k7d+pVKzudM95mBgZDSt
 SRW8xhs+znClLYOAdvI7jvFafPY+Q4S4NxSzyn8xvajoXTDi79YBIUtx897Nh3XV4tI/5uuvWrf
 e47uy6ZdyuJQOME4L7wlAW8Z5ufI09HuiibVAZek1y7rgYWD+a9RF21R8xw6oKM0QswLoIggMN8
 KETDdftzW6rDlVuM/rav9jpM2r7/XW0E8XngG/IR2qj3JXDOS+dhjwQFFNLGgyT64mFI756+Lxo
 z92N/uGV2L24xlQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

I am seeing the following mlx5e crash in the Meta fleet:

  pc : mlx5e_get_queue_stats_rx+0x4c/0xc8
  Call trace:
   mlx5e_get_queue_stats_rx+0x4c/0xc8 (P)
   netdev_stat_queue_sum+0x78/0x480
   netdev_nl_qstats_get_dump_one+0xf0/0x268
   netdev_nl_qstats_get_dumpit+0x7c/0x1f8

When dumping device-wide qstats, the core calls the per-queue callbacks
for every queue below real_num_{rx,tx}_queues, regardless of whether the
netdev is up. Some of those queues have no stats behind them:

 - RX stats live in priv->channel_stats[], which only has entries for
   channels that have been opened (stats_nch). real_num_rx_queues can
   be larger, for example after the channel count is raised while the
   netdev is down, or after opening the channels failed part way.

 - TX stats are looked up in priv->txq2sq_stats[], which is NULL for
   SQs that were never activated and for HTB queues while the channels
   are closed.

In both cases the callback dereferences a NULL pointer. The dump needs
no privileges, so any user can trigger it.

Return early for RX queues at or above stats_nch and for TX queues
without SQ stats.

Fixes: 7b66ae536a78 ("net/mlx5e: Add per queue netdev-genl stats")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f32..72bca10c579df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5489,7 +5489,7 @@ static void mlx5e_get_queue_stats_rx(struct net_device *dev, int i,
 	struct mlx5e_rq_stats *xskrq_stats;
 	struct mlx5e_rq_stats *rq_stats;
 
-	if (mlx5e_is_uplink_rep(priv) || !mlx5e_stats_nch_read(priv))
+	if (mlx5e_is_uplink_rep(priv) || i >= mlx5e_stats_nch_read(priv))
 		return;
 
 	channel_stats = priv->channel_stats[i];
@@ -5521,6 +5521,9 @@ static void mlx5e_get_queue_stats_tx(struct net_device *dev, int i,
 	 * inactive sqs.
 	 */
 	sq_stats = priv->txq2sq_stats[i];
+	if (!sq_stats)
+		return;
+
 	stats->packets = sq_stats->packets;
 	stats->bytes = sq_stats->bytes;
 

---
base-commit: 241dec6f9ab74d8c3ef246764f3611666b96b9e1
change-id: 20261104-mlx5e-qstats-null-39d642e7eef7

Best regards,
--  
Breno Leitao <leitao@debian.org>

