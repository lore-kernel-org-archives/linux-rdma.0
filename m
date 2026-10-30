Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377921;
	b=Xkzx2zSkXlZQzT32v+onjoBmZEniUcdiXHngUKAIQs8PlbbLNb6/T6KyIDxcAWhxWekZ
	 mJtSwEFfsDZvXUEyar36FRCEIc7EgyGTX3M13iZ+bIcQAmUT15w+GUVZj5jFZmtMa5nOx
	 M6KoyAKb7iJaWrXoT2U3/kQfsWdfsf6eLRhPzAgmbA2m8PeX5eQcw7yGIVwc/bbyOHhio
	 fjiYghFKVYpkAuwiIMDUqjaGEfqhJccpl2hTdGARtZ5Yy6qECu6yBjqx/ZMBvvTwbtYus
	 KRon+khXc3VyaYZg1v2dBx5DXi5i5rfhtSo1xJ3iIzG6yzjgwskODyvLnoDqdtCxlsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377921;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=SXMDUKU8JoAk/oFBq/P4B0/w2u2L8U9fM46BJ5h8xiU=;
	b=wyIAKnQa/BzRV/V+4I9A6KYGkF6Ne2jF/3g3OHY7JwpA49t73+uHucnwN4rwAsB9fuwq
	 B4mOcC8ISbg1YOIjjXAc/1EYn89Mr7Sv8Q03tLOQptJJ4g5i9ISbJM7/IoggpSBtEmszB
	 2vFH8pjJZXWhaDM50iFNYTpo4axWS9UgxESXYO/vyreLyDevPPTEm9XmG9QUmgSOisMe0
	 KSR4+VZmgHBLqTRpWXF8ha4CyJXWV8v+jh3Xi2Mx7xlkRcl4MYAvkUbjOL4Q15OfMdgkA
	 MMRRk2q1rJQyeYjM803UmFT4WLrDldDbgKDvVc/B8cWYJpW++gKzjY82xifmj86i0kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=gXVKqEIu;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26820606A320;
	Fri, 30 Oct 2026 16:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26820606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=gXVKqEIu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=SXMDUKU8JoAk/oFBq/P4B0/w2u2L8U9fM46BJ5h8xiU=; b=gXVKqEIu5eViDtg7aRBlpU+gWd
	AhpPHvjJH7Cq69v17pgBEPxUC4wD6Hn46nGg2n1krHnaP+HuMB0TIFgQqtov84RHKD+/L9dE0q9TR
	gU2YLTnq3ds0rQgFJ1/jEm5yxZ37gfSV36viKuAyt9y+jCZ+C+Ey3R+x5A81ZVBTik2ZqSH3W7H3G
	q8pVIr9K4Y7R+nNPH4YXDzW16O7MNUXVqQCwB+dQFdKxiP56EgEkq1yUKCCiH+j0IC3KNkJVTdA4b
	sry0LcCdQsZWqNxkaIRoFT77z+IwUwpH0Cxgt1fzv65uWkNhBC7Gs9tKOrj53qupF1EPiOqMNGKw/
	BXUtiYuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xMpWH-003x26-0k;
	Fri, 30 Oct 2026 16:31:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Oct 2026 09:31:44 -0700
Subject: [PATCH RFC 2/2] net/mlx5e: Rate limit the HW stats refresh from
 ndo_get_stats64
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
Message-Id: <20261030-mlx5-cmd-wq-v1-2-1458b2aed637@debian.org>
References: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
In-Reply-To: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=3173; i=leitao@debian.org;
 h=from:subject:message-id; bh=V8a1j1n1zFWm8kITR5H5OSwQjGYGT+ECI1w5aAdV+IM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq5MZyivdZFHmXJG6yY3CujPwA6Np/acktUbI+z
 ejmrhA6EH6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCauTGcgAKCRA1o5Of/Hh3
 bUf/D/9Hjz+rRFvo4iBG47H1R5XyzBKkt6Z5VsEPFjIkkUL9Q5I3tA5o6mrJQamsa8ONlJJJsEP
 nY+BlsPhTVSFEjh8uuBQvu6qLMgMgBdGcp4C68QaOn+cSfu78hj+Imrb6s8ZQNNFnLcnHSVEOn2
 /9XxmW8zbRYwn+oTpM8kl9sICTtfqunHhxM0N/S4jcdbzo024Bzkrmed1Q/U5PLg1cP9Znz+/Nt
 uwVUw+zj9Y8rHPhXdcfzwlJnhw/CBP1KxbDFIs504R9j98QD3TOcxgFzEmoWv8SY7dYIFWi3YfV
 a+eTiOngHw1G4vzcTkt/O4Rg0WDneT/tnwW+pdZ1F8iJyGvHwmaBKA6iGsISzAxBqA8A64mYR2E
 GamC/c82cVUXbl3KId/SNSBm0ClLUmskE936iXxtSsFrebPUGg3csOvr65BDLWV5Uk/1ENt66nu
 Bh+MojZdvOmoJH3Yusb5SBel3Y/4T1Xfr+/q3o01B8WSisF7EmVikbjmKMkxbFHG4PAx9tldDX4
 g11bYYJ9z3JgVxvN49eIU0o+U9XbFxQOuKSV51OTj0OLotEfwgofq6MI/dOJ4M++TkJbPPpuJv9
 f/3nvn9pwT2IUxuqS1QeIwoffXS8c1ifVtzWpFjL2g89CPc/1UpPxuPraceuZCF1cjlfQY03A/c
 gMcX6/0AAMOOS1w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

mlx5e_get_stats() and mlx5e_rep_get_stats() return the counters cached
by the previous refresh and queue update_stats_work to refresh them in
the background. queue_work() only merges requests while the work is
still pending, so with several readers each netdev keeps refreshing,
and every refresh sends one to three firmware commands. A single read
of /proc/net/dev requests a refresh on every netdev, representors
included.

Until commit ed56c5193ad8 ("net/mlx5e: Update NIC HW stats on demand
only") the driver refreshed these counters every 200 msecs. Bring back
that interval as the minimum time between two on-demand refreshes, and
skip the requests that arrive sooner.

Readers already get the values of the previous refresh, so at worst
they are now up to 200 msecs older. The monitor counter event path
queues the work directly and is not rate limited.

In switchdev mode with 8 VFs, one /proc/net/dev reader at about 75 Hz
caused 13.4k firmware commands in 13 seconds, and 1.8k with this
change. With two readers the count drops from 27.3k to 1.6k.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454e3..b66d40cdfdda53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -151,6 +151,7 @@ struct page_pool;
 #define MLX5E_MAX_NUM_CHANNELS         256
 #define MLX5E_TX_CQ_POLL_BUDGET        128
 #define MLX5E_TX_XSK_POLL_BUDGET       64
+#define MLX5E_UPDATE_STATS_INTERVAL    200 /* msecs */
 #define MLX5E_SQ_RECOVER_MIN_INTERVAL  500 /* msecs */
 
 #define mlx5e_state_dereference(priv, p) \
@@ -928,6 +929,7 @@ struct mlx5e_priv {
 	struct work_struct         set_rx_mode_work;
 	struct work_struct         tx_timeout_work;
 	struct work_struct         update_stats_work;
+	unsigned long              update_stats_jiffies;
 	struct work_struct         monitor_counters_work;
 	struct mlx5_nb             monitor_counters_nb;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f32..307505e0a827c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -169,12 +169,21 @@ static void mlx5e_update_stats_work(struct work_struct *work)
 
 void mlx5e_queue_update_stats(struct mlx5e_priv *priv)
 {
+	unsigned long last;
+
 	if (!priv->profile->update_stats)
 		return;
 
 	if (unlikely(test_bit(MLX5E_STATE_DESTROYING, &priv->state)))
 		return;
 
+	/* Stats readers may poll often, limit the rate of FW queries */
+	last = READ_ONCE(priv->update_stats_jiffies);
+	if (time_in_range(jiffies, last,
+			  last + msecs_to_jiffies(MLX5E_UPDATE_STATS_INTERVAL)))
+		return;
+
+	WRITE_ONCE(priv->update_stats_jiffies, jiffies);
 	queue_work(priv->wq, &priv->update_stats_work);
 }
 

-- 
2.53.0-Meta

