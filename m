Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD284E0B6E;
	Wed,  7 Oct 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397788; cv=none; b=kEGSkB0gaGaQn+iMpnAko4lT+dAMS6VWWBgvDao6vXh9ImXJ2bDAnaPBtYcpR944Z3Jb6tJWcRzbfNII+aQqejFCq1gkmduaFtKX+WBhdh5O+GuopPegpYMEtbvlnpjvKPWOyM7kKTUd11n+IWeudwYwmIIdYJ+dJ553fFVPNgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397788; c=relaxed/simple;
	bh=zSw4MvkKTAyxu2Chr4JiaTHB9/UhfdQZiXE9PiL5x9Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aB8ALA7jhVSHoL+lwvXxTdWC3cPWvYUZ2oVct4ZwZ4S/QBistfZYzvD8nsrz580ufaHn/l2J1ZHElrvJLujlFzSPkeHfEcGp6cfLQDU9FLP6fd7by/HxPN4npqTiRNH24RsVMV179QeFKV9tD/ZXBjdOtGPbdWqgMbdJRT3teGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=LwzuGWoN; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="LwzuGWoN"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2101EA154E;
	Wed,  7 Oct 2026 20:29:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1791397783; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=+vwzImBllyc3KkMfgkhrOwCBUwVrLqdZ+ruuZlAUn4g=;
	b=LwzuGWoNsgTkxuu+VoKQ2EDZKSS4AXl1JK/uAQ7DmkdAgXNErOy9H2t1+mSO6fqWGwzesb
	hlfHio3Lolq8R69IG/jBZEAF8jgRHBktf1HHA31KxMti4X+vyc+3arr2OmYKrfRB3/iM5I
	Gh+Y1j3gRBrbWuaPf64nqp5XInEiYy/7eK0sUVkNkIJPz9MLspsQCj2sDOm4V0CLUV732N
	YiyLxnvWcLLlN67YRiHSbRyReJnAH5fZESJcandycRY63SKtPl1C9r2ECzvU6WVJ3aDf9g
	f0t6PoCh+T4CHtcBTmHU+vsBHpsLeCIdk30ZuSqAV/7XnH6UXI96+nY0BMIh6g==
From: Nicolai Buchwitz <nb@tipi-net.de>
Date: Wed, 07 Oct 2026 20:29:24 +0200
Subject: [PATCH net-next 3/3] net/mlx5e: use skb_share_check() in the
 loopback selftest hook
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de>
References: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
In-Reply-To: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Oleksij Rempel <o.rempel@pengutronix.de>, 
 Maxime Chevallier <maxime.chevallier@bootlin.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Jose Abreu <Jose.Abreu@synopsys.com>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Leon Romanovsky <leon@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
 Alexei Lazar <alazar@nvidia.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org, 
 Nicolai Buchwitz <nb@tipi-net.de>
X-Mailer: b4 0.16.0
X-Last-TLS-Session-Version: TLSv1.3

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_linearize() on a non-linear frame then hits
BUG_ON(skb_shared()).

Call skb_share_check() before linearizing the skb.

Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 1dcdb86690bb..8eb9a9469549 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -166,6 +166,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
 	struct udphdr *udph;
 	struct iphdr *iph;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
 	if (skb_linearize(skb))
 		goto out;
 

-- 
2.53.0

