Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77BA372B5A;
	Wed,  7 Oct 2026 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397785; cv=none; b=mW0vZkl6xwu8ua7OEPBQUmGURM9wKrknsKMvuHflB7nFh2T58u1UgHsOKkZa3AZK3xXCx17fg/9NNofFo4XWuR5HOSIjmLKZEiOMo7dInpg9AKVpbvPeoRyf5PM0LBDJFwQWYCyv06Ud6PKvEnxaVKjdeO+6Gy1uwN31+sAj+1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397785; c=relaxed/simple;
	bh=nh5laS0QoZtRzH96terkjgV4w1ijpibG98NPpiYebxg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qaANHE4Hb+/OPaZGkKe2n3KMg6tRb213RKYcQi8ptqOGf+DErl56L9PEDJTDVOgLueva1rNJhVYg7w03T6cVmpwsC0BO3nw5xc8sOpErrfbeO6g54/2/706xj36obbR5FdNY63Fc4/YikpvKEYa8rYsEY0ztVAZFOciksPz59nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=doV851Cb; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="doV851Cb"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E4EC5A154D;
	Wed,  7 Oct 2026 20:29:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1791397780; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Mpp+rwnsNyKfxHdHUlAB8nvSuXAVIMHmY8/y4443xPI=;
	b=doV851CbkIgU/9FY1AehSM+L+Mv7bINiYDMomw8Ltq8sN+80RWajOMQTojDScGN6Ny+Qmf
	AXcMJyoO6dHh6hvsN5IjvVZ/SnXrC2K73CfwigpQhfK4UE2GZXhv9nQplOogwP5b4aAofz
	Iun6OocKTMBuQQUfYlFVrqYyZg8Jzw6QnRxvZ5VWWRXdOs8jqr7YS3t84ICnNffECh6pEz
	T0qPZNy7nMlB8aU8KbFOZ878kIitGZQ1zutkiqG9mB+MJ551XnkGQcyZYnbscVYgXGIDnQ
	0iLhyPJtEBBhmuGr9pdsaoMmkG7k+d930mP2N2IheFIydxjJfQtKuw5exh11dw==
From: Nicolai Buchwitz <nb@tipi-net.de>
Date: Wed, 07 Oct 2026 20:29:23 +0200
Subject: [PATCH net-next 2/3] net: stmmac: selftests: use skb_share_check()
 in the loopback receive hook
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de>
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
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 6097f312fce4..c910675a9d9b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -244,7 +244,7 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 

-- 
2.53.0

