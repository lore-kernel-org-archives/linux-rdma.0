Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA84DEC3A;
	Wed,  7 Oct 2026 18:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397784; cv=none; b=IDZv19RCFugdhyM3NMdyxJWyzvIb2hx10GzDVVLtgrH61lwbgDHlGqEKvlLetoMj6naUgQ4bbReP0B9YS/NN5L/MLGpBpVwmxUrJ1A4MG8oFPMrWnXCbTESyKbBxvcOZuMUmt0nPYYiao4PLcCNjjJMLV/cpQK7+os382d4JU4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397784; c=relaxed/simple;
	bh=i9H44DowS6+oasXyh4/SXrZHWueedVWfI+Cxyl6TIXI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=meZnpOiWe8KCv17kLLNqBWfx4N0xipjaJqYZT1cibBm00tM+YqERkz2zJC5/aWKneyo4xUpR7WiJ/4NxXPZrQfqUlq9QwF63sKcGB4ygETf3wwe0xZcV9xBs9L/Zz/ZtlxvQOhgVygJEzUa0Z+Dw1kILU47W21Vj55pStPSBopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=uyz4eUp9; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="uyz4eUp9"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A7906A05A5;
	Wed,  7 Oct 2026 20:29:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1791397776; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=SDkbcKEg56Hg163LutOTCLb1IktY/aVEl/Io7G5PV78=;
	b=uyz4eUp9ohF/ZZk0czJGYV9mwV2vkj6EBQeljHKPvD6HA+Xq8NffbjfykVavvpW7xGvAlS
	prXUHs9fygmzq0JEzpdYTKF9NOIGeyR9DDD7c9aFBqtmXfFCMQwaf81BfqPCrH4IHQXAAX
	5N+NaDGU8xnLCMtzqHSsNkR93PHDrkIBB6kEZ3E9vY/Ry8lmVg8iX9vKzF3UujXI5wi+D7
	hS+J38JK/VeQNUWZ0EHOWAheD9l/pStKfQBAWW4vMEoeM8TBSdbRfKTjXJ7od6FFkK1dbz
	0kt2cqhepQIjIadJe4Fy0vy2pf7VJEhG3ECJUlLtl3FZioIIb+I9MNAygW5+ZQ==
From: Nicolai Buchwitz <nb@tipi-net.de>
Subject: [PATCH net-next 0/3] net: use skb_share_check() in loopback
 selftest hooks
Date: Wed, 07 Oct 2026 20:29:21 +0200
Message-Id: <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM2wrCMBBEf6Xss4Ek4vVXpA9NMrErsko2SqH03
 03r25yZ4cykKAylazdTwZeVX9LA7TqK4yB3GE6NyVt/dNaejAQjqEbxzBXawjgUpK07+32KF4d
 0CJma4F2QedrkN1oPgqlS/1/0Ex6IdXXTsvwAFEg6IIgAAAA=
X-Change-ID: 20261007-nb-net-selftest-shared-net-823dc91ed5bf
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

The loopback selftest hooks can get a shared skb when another handler
is bound to the device. Linearizing a non-linear frame then hits
BUG_ON(skb_shared()) in pskb_expand_head().

Stumbled over this on RPi CM4 (bcmgenet, with jumbo series applied +
WIP selftest patches) with a packet socket open at the same time as
running ethtool -t.

stmmac and mlx5 seem to have the same pattern, xgbe already handles
shared skbs. Patches 2 and 3 are compile tested only.

As the impact is pretty limited and doesn't seem to bother anyone in
the wild, I've chosen net-next, but kept the Fixes tags. That matches
what Paolo suggested during the LPC track.

Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
---
Nicolai Buchwitz (3):
      net: selftests: use skb_share_check() in the loopback receive hook
      net: stmmac: selftests: use skb_share_check() in the loopback receive hook
      net/mlx5e: use skb_share_check() in the loopback selftest hook

 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c  | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 net/core/selftests.c                                   | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)
---
base-commit: 45ad84d2800e4a092fb8d96006a533b2d0ab13f6
change-id: 20261007-nb-net-selftest-shared-net-823dc91ed5bf

Best regards,
--  
Nicolai Buchwitz <nb@tipi-net.de>

