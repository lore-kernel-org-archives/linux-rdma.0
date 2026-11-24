Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558749;
	b=oR2A65dokSgtlwmKL+ozASzNFMQDhyfnMtI6lK2mkJt3w8D3mFu38y7oBTC+00dAqOgP
	 roqJwcqRRgT1lcvu8sDtCZKUyiBxX4kP8i7LShtKXZXuXnoU8pExYbaxsmSOn25gyG1xQ
	 Nmukn8hgJq5klQbLj87a0vcQOCz8r8TKxI2ygyYYEFHHpfuJrGesYL6PfWl1ZlyCs99dF
	 ocfP50Zx+5HI7qYJ+fhOuqZoL+OXnzaOvDk07X9BAybp2xDQ2nJ3EHghjSfO2TVvNatSt
	 JFm2ByWrw5CsNQRVashR3gO7DRfTX1xYV5jpdUi85GZ9eeztAi9qUg9NCVolUVTNqmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558749;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=GULN2dVOHCAKq9Ay+gMdVwn1+udeGMUc3bXu0W2JsPo=;
	b=MpctaNCVY/9wILKUSQwUNnkrkOkxbwUt4WWI4IyXEuabuwJ3fepYgvO+HFzGFoDS1ls7
	 7lgwea/0K+BY3MEkp6DM9mMbvFByj+Ych9lIFhvPzWZ2e21/1cHOlAEFokX3oJxpAJR4b
	 I1sQ/8YbIt+gQG1axPUtIeqkBIsY+t8ColQlrfX3519UU1ZjQkzEnAEv8p1wUSh2Xnw2l
	 XsDA/pb70fvnMOWOna3seJ1bBfBvuPntQOV56ZCc8CKblZ2hQagen+KCJDSETwW4BtTZ/
	 S7OknTxJVkLC+97kCe++DACIwVsf5tB+b2Oqo5etN4hxTHWZyE2kf+cColqSFKfIQiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PX7oFca1;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3DC606A321;
	Tue, 24 Nov 2026 22:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C3DC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PX7oFca1
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB8Mv3754385;
	Tue, 24 Nov 2026 14:18:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=GULN2dVOHCAKq9Ay+gMdVwn1+udeGMUc3bXu0
	W2JsPo=; b=PX7oFca1CXA4J+oXkYdPRyx7Ew9/ypVq7F7H2CcB7aOTEXdr51Y6r
	PpXZ4JPaGckG6AK+pSbxWt/E0KnPcQIuKISMOZl9r5+Ulsz+CcWivSCIzKY34Tp/
	S8RPm7ciPm7vvFaJEcPq22dXYu2l4LpCzYiNV+PPfaNbAlyWOFKL33gsnZxnljwK
	RldvcQ7YBAjpC6uKFG6RnmX4TN0SVNebX+MFbngIVnl9UTBs59nIg8JIF0B/QJKn
	/+urdnd8dCZXN1a7b5b7fudjQvhdwHoCBcndu52CHgUTA+1GMVQH1rwyi+7UO86c
	loCZiPsOlKwj6U4t7Pfzi7imQBWs3k3MQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j5bsuv277-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:14 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::1b) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:13 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Tariq Toukan
	<tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, <bpf@vger.kernel.org>,
        =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=
	<ast@fiberby.net>,
        Qingfang Deng <qingfang.deng@linux.dev>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan
	<shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthieu
 Baerts <matttbe@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
        Hangbin Liu
	<hangbin.liu@linux.dev>
Subject: [PATCH net-next v3 01/12] psp: get netns from net_device instead of sock
Date: Tue, 24 Nov 2026 14:17:47 -0800
Message-ID: <20261124221758.3230929-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: WRZM9c8cSRbss6ROLFrtYgdlWfmmwvXx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX1VzzdDypbrMl
 BFO6R18A2wLBOt32IalLd+k+xqBF0ZUn1iIcFIHNRuFgl5GCI8EROmjSk+K0OIybTd9gnSsQrA/
 Z+JAOi6BArSMy363n7zZ/ibuS8KIBtFkSIEwH+xkHaQYq4YRY6NJH86In2b2m2uLxFyfW1d7WZy
 BLOYdGjWaeYiDuN88+Y4FZh8EaI6qh6GiqlQPAM26KEP/VQCs/ufp59aoQI03N5UobNvRKIe0UM
 wASfRBGCtmKcGPfwRN5LI/3UumSPkf+lYL0oONneYo2KZdWZJ+GK8plBTYIEq8jmNAHbe1XXFWv
 wOzaTlDdyYDghoxLcXzvzb9rskv56M2dKswCPwCpxZrdJBm+1jxpYcyzrztO8G3h6CZgWL9X+eJ
 IzW6kuyio7ky02xDJ73UBw1yA1vhZp8yRtuxlLgj26H8NPedoakWRCtv01sgAUgoS4g64ddesR4
 MxgWLHe0YlO2GN8agKA==
X-Authority-Analysis: v=2.4 cv=Efld0/mC c=1 sm=1 tr=0 ts=6b060d26 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VabnemYjAAAA:8 a=aANAhI6xw8lVU80_FSQA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX9TVoJorBZ9wa
 XK8A5XifmJQ0eCHBNWyICy6wIDoRn0KNk5ah6qxZQkeUUu8uxL3tE7VSnmAAvsyRi63X8GKGxvL
 Piz6OMXTMUlABmeEdIcn72HEOA1Y63o=
X-Proofpoint-ORIG-GUID: WRZM9c8cSRbss6ROLFrtYgdlWfmmwvXx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

Every PSP skb is related to a socket today, but that will no longer be
true once a PSP association can be attached to the skb by other means,
such as the tc psp action added later in the series.

Get the netns from the transmitting device instead.

For the outer source port range, psp_write_headers() now explicitly uses
sock_net(sk) in the socket case specifically, to maintain the existing
behavior.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c | 2 +-
 drivers/net/netdevsim/psp.c                                 | 2 +-
 net/psp/psp_main.c                                          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
index 348fd7a96261..8b474f75dd61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c
@@ -165,7 +165,7 @@ bool mlx5e_psp_handle_tx_skb(struct net_device *netdev,
 			     struct mlx5e_accel_tx_psp_state *psp_st)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct net *net = sock_net(skb->sk);
+	struct net *net = dev_net(netdev);
 
 	if (!mlx5e_psp_set_state(priv, skb, psp_st))
 		return true;
diff --git a/drivers/net/netdevsim/psp.c b/drivers/net/netdevsim/psp.c
index b7452c49b581..0701f38aee6d 100644
--- a/drivers/net/netdevsim/psp.c
+++ b/drivers/net/netdevsim/psp.c
@@ -36,7 +36,7 @@ nsim_do_psp(struct sk_buff *skb, struct netdevsim *ns,
 		goto out_unlock;
 	}
 
-	net = sock_net(skb->sk);
+	net = dev_net(ns->netdev);
 	if (!psp_dev_encapsulate(net, skb, pas->tx.spi, pas->version, 0)) {
 		rc = SKB_DROP_REASON_PSP_OUTPUT;
 		goto out_unlock;
diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index 789315dae237..964749a865b1 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -246,7 +246,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
 		/* These operations are cheap, no need to cache the result
 		 * in another socket field.
 		 */
-		inet_get_local_port_range(net, &min, &max);
+		inet_get_local_port_range(sock_net(sk), &min, &max);
 		/* Since this is being sent on the wire obfuscate hash a bit
 		 * to minimize possibility that any useful information to an
 		 * attacker is leaked. Only upper 16 bits are relevant in the
-- 
2.53.1-Meta

