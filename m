Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051888;
	b=i8rdNjaHSF8LSCV1eYp2JKWritN7ZDT6STrRePu0oQtI+6Ac2Kt217lxyQO2x65z3rTU
	 ss4771jEHcyOXFZOYcpzVsCz0b/7W5p4UrpqHMa0NyXENANnEKl63+YgJIQBotVryTeXz
	 j9lHwigB9uUpDgA08j8DoFxyAMsrmExRvCJjAal7Ex6rIwm1a0ZtNz/vEeQBBclqOVp0E
	 4lEslIxai4DGBiAZ9en29+E02AfQx07/ysuVRVz1C6QZsDJEA9uce+y6xyCNYskdiDmAz
	 07Pmn5ubu60vSeNvayaFHVmYhMO6Jk1SFSwKen5ld3mtd/rhYjyTd0TQrqB/m4uqbhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051888;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=ShD4ogqRNxiX2a2hqpTu+irBW0EUFBYbprtP+G2/Kac=;
	b=iNbbOahnQvzNgsodyM6ssrq9gIjAcLFwr4AdTAR3PG9KFtkOoeeKcLq0m+AGRD/MzOp7
	 /AGr5NwHV5TPPRHLmS3L/r2GVwsWqQ0/Ra5JlViZcKqUvrIV2jqAoQw6CJG81boB1sivE
	 /k+TPM+aPdQbjFZaPnLxobF1XY8sJTChQu2MiIUKb6uCkv0Sj3BnjCoZ7vkymjNg2KXDA
	 0sm+UzaLJL2E53h9SuT499XwNx5UEILHlacdsgOCeSXwI8NzrHuI9A/sWeTmgA079jesj
	 NgjtvGCHdgJz0y/BKeX7GspvehMqB88sHzKF+dX7BZTv4Gg1wmRV1MSqaZnmQFTMuig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=ms2Zt0dN;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F1606A32F;
	Thu, 19 Nov 2026 01:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 941F1606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=ms2Zt0dN
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AJ197GE3585688;
	Wed, 18 Nov 2026 17:31:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=ShD4ogqRNxiX2a2hqpTu+irBW0EUFBYbprtP+
	G2/Kac=; b=ms2Zt0dNoA7neJe6fqhSifGAXVObPGEUTOkJ+DNmGPdLL5TfHIZ+q
	fF6K0Spk1YYf8eMWSHZPTodVMMbkQNja3WpeaTEdglrCMGOhFjxSY+SS8r6fxW/m
	uqZEFAYtEW0ozo+gJalw0o8KUi0FwCs9vKTdjS9EM2N+8ReIirofmf2cnD8LmXQz
	rrnz1qDrFjqc4UTuemC/FgQvovZVHPESx1AnYIqzOunkwIxT6rLE7xL+J4tmF/Mk
	j1zH6vNjUQUhkeoUtZ1m2HFklM1xXO30zuWOrQoheGjsITa6MMoxwaz7MB/jFKJ4
	jZFtS5Sr1lwqbgRAytsmhi91jRgzzzcHg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j0yu5u6kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:14 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:13 +0000
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
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 01/12] psp: get netns from net_device instead of sock
Date: Wed, 18 Nov 2026 17:30:52 -0800
Message-ID: <20261119013103.1092559-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=EqFHPicA c=1 sm=1 tr=0 ts=6afe5162 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VabnemYjAAAA:8 a=aANAhI6xw8lVU80_FSQA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX80ERIUKKJjEo
 6bIFOjs2WLfRntfXu4y2OKWtG8jKZDUClp7gTy4kcxQ4yO5z5trMtzPoCSqBFyyFevGjqcRys3k
 w8dcvUEyIGzUf+PXA/1GB4phF8Pm7i8=
X-Proofpoint-ORIG-GUID: an_9dRbrHF41v_rCMFE-jXN3BN7x9mZ_
X-Proofpoint-GUID: an_9dRbrHF41v_rCMFE-jXN3BN7x9mZ_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX9ilC0jv8shdg
 eGKjAj7hvczCWRPGJW3oTgIivszSu5mgPsopifvSRos2xeZljZ1L1IJoiPMbwYvvXBuVfwJGqq4
 WJE5PSFD37XNohZyzu1FotxRaB0+raYkm3hVWYDcq3fjaeA0kfduja9/P0gLBbQ09/Q8wX2l/pc
 WQSAOpzaWWStT3NlcZGl6yvbME0e7/W5TWw5JJ90MEP5DjeNRpe2qM7TBnV+ggMRKJr9EuIc9jS
 Et5Tx9JT/9xAmuHOBTzPEHBUtMRyrkmWzy5YeupOfY/R0D9ahTCuGGaov/9PorqFE/ym5mnadQk
 8rVLLS2VeVOc2Jpv2pBARX8uDpgDTzj+oUThQxnOZa1Rwyr7D1yVh7qn4B/DD4weda93ymsb3Yc
 chqdDs2cOvgy5V/MZAd5lTPl5KbUacAsGJ+5Ps40bkxsXL6o3479mMOilrqiF4DdyLOEbycMoDF
 0YkG4VCo7tZ0Yj8RCvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

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
index 273b010d2355..e09f6fec948d 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -221,7 +221,7 @@ static void psp_write_headers(struct net *net, struct sk_buff *skb, __be32 spi,
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

