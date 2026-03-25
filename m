Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19933410D0F;
	Wed, 25 Mar 2026 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450299; cv=none; b=lkNgblaPRdC5XNlW4jnxUd5mIRB3DOOPEC7z0mi2O7emdAcrmXwpxH4T3JgezY3I2rOXRaeOlL4AK4+TUMVkBpixmwsizp7Tjl+mJpOOx6cCU7ay0pmn/1tLXRiRDpnaBX0M7a+5d4HjnZ/UBdBQV1znbHJay8nEh/BZWJ0P5XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450299; c=relaxed/simple;
	bh=AoJN3mD+ZYMDEPLixrQql/276UNXHzit/UqYp0ozVgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ix8q2qPYlOvbC69xunAKHJgZSQPIl1KrJCEoF0+PZBXrYrjxFT/YG9Wjs5JTJgrWckkORxADv7HafLmmL5jkhKfwULRKPmL90hr7ktiAceQtVGYj7rhnWkd4YOpIf/vlepfjTKExgI0oIdxYDe7giSZ/Y7Tluk02IXyGzK8nM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiMr9uxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiMr9uxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC1FC2BCF6;
	Wed, 25 Mar 2026 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450298;
	bh=AoJN3mD+ZYMDEPLixrQql/276UNXHzit/UqYp0ozVgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiMr9uxXe0TtC9MR3hGxTwSlV2erZr9US6NFfa1noGufzwAm9tLYPxAeofytpJpOX
	 Cn24/GhMkq/WEBFfYEnT8VotFXc074mlVtS4sTMxJlFHSg63t9F1dTWtd/wpXHciMJ
	 hOYkfp9qf1KvELDE1JQYeTIRV/2fM5LJwver3DunHdHqKB1MewWOKRmaG0F9Ry/Qmy
	 HalyQwtwCHCoTvpgFVI9Tyl334q58dQfzSlt2VkKUYc0uIXtTtSMRplYoq1e7LXqyf
	 XLQC20LYKGv5baMlkbYiq8cgGvPVli2TzUWRaTx+qbnRgUSOiTYFLA+2Spc6xyEbfp
	 /r3P2BjipV9QA==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Danielle Ratson <danieller@nvidia.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 10/12] MAINTAINERS: Add entry for ethtool loopback
Date: Wed, 25 Mar 2026 15:50:17 +0100
Message-ID: <20260325145022.2607545-11-bjorn@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325145022.2607545-1-bjorn@kernel.org>
References: <20260325145022.2607545-1-bjorn@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a MAINTAINERS entry for the ethtool loopback subsystem covering
the core loopback and CMIS loopback netlink implementation, and the
associated selftests.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a09bf30a057d..411c412975ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18389,6 +18389,12 @@ F:	net/ethtool/cabletest.c
 F:	tools/testing/selftests/drivers/net/*/ethtool*
 K:	cable_test
 
+NETWORKING [ETHTOOL LOOPBACK]
+M:	Björn Töpel <bjorn@kernel.org>
+F:	net/ethtool/cmis_loopback.c
+F:	net/ethtool/loopback.c
+F:	tools/testing/selftests/drivers/net/hw/loopback*
+
 NETWORKING [ETHTOOL MAC MERGE]
 M:	Vladimir Oltean <vladimir.oltean@nxp.com>
 F:	net/ethtool/mm.c
-- 
2.53.0

