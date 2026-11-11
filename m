Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358599;
	b=amoYlw7vMRFwduw12u0ek+pDkP007vjyj0SDWeQQFS+92l3S1sD0EtkXpo5SSwutkecz
	 uh4/sA1tb8mu0nxu83hWfwH1krdPEG0Va2+SOcep8E9AJ/qzVBCCkMF9WcZw7wKgtaomB
	 M5FGtRUSP7/GJkoPz7OEZqaOzJps0+sJhQ6vMjy+b97jeRamOZ0rvJtEkfCpdcGGrF/mw
	 MXL4V7NrUmbvrm0X4jnlRzRTn5c4vwi/Bsbk9qoOAauyvbL0lnAxjVCxPLSs9ALR/II1a
	 bGtVB6XbzQH0yyrmOuFBad8hP9vqaV1qHn7QfOTsCkkH/XpCjSG/FcYH5dD0YNs1RFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358599;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=xUuBOsnHZbdftguUIrx+GZlZ9ffkFOF2RrRoWzhspRs=;
	b=IQVQb5uEdmgjCb2on51pZduRapWisd5S4WxlT/Op0sk3eUcl+qnLa2D6Uw682ojoegRy
	 QKzTxO+NQpEsb6w0uSzrnyJjTYDZTDWCrKsakzw6V0T5yZL8biF2OnKAQPmgJ6w9tb+uE
	 fbIArpb2VoQq49mF+cfAG6RaDrdY3cxBmxRaBJfyWGgTincVzxTVU2ZeguShxNqDMeact
	 nZAcMCpiNBiRDo7wNUCVfCvluKKEUqz6dqddLa6wPEgZEBwcXF8YERg/Pig3TQI6lAcz9
	 jCIbmIkhuwF2dyNvK79yYd0FLKqkwRX3l2+dbgsaO683eNiIWCa7Qo80ZwDo+tFxavg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="nh+d98f/";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0502C606A320;
	Wed, 11 Nov 2026 00:56:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0502C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=nh+d98f/
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WLZ0556322;
	Tue, 10 Nov 2026 16:56:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=xUuBOsnHZbdftguUIrx+GZlZ9ffkFOF2RrRoW
	zhspRs=; b=nh+d98f/lhjcHAZDbUq0RWJeTBQ+RVpEogfYO7Slpxv405I+x2bVm
	QVjlwiYn1/JzTjzfplKhgPnfpM/cZFVVq5AjyW9w7I8lGzh2VAV3LRtI0m9+buIJ
	JMve0Bcqb71S0FdpEKeju4jOmPC+hTh+ZgZEjcagNyvIABq7+yO6fRO6Rn/h480T
	qc9NJgOzMxNio9G1O56XeIOK8PJ9sZhTz4sf/kYy8kacDB3hT2qfrVrCerzjZZE7
	OoSGCW+EqDYWodQCNkH5XrvRv0a89BLHEJaMjESC6y0nkHjk61Whvv0OaqOSkiGv
	McaoptnojOTNoe53xRj3U2faIaxyDA4Yw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hv72pkmxh-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:12 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:02 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <bpf@vger.kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
	<jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "Martin
 KaFai Lau" <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v1 01/15] psp: get netns from net_device instead of sock
Date: Tue, 10 Nov 2026 16:55:19 -0800
Message-ID: <20261111005533.6436-2-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX3K/IOI+lB1Mm
 5nuitRRzroAnUPGpJhxVqKALsnapDU8AWXPnFbOsLqNeThBW1TRmnyxm+10K9OYtaAgCUdOiZNQ
 aiD0PUyOScH5J6O+jdi4RuuOrx6gqF8f5UYjpCWNtnTSU3nJkYGrL9e+nDfNACdnvClqCBDEFC5
 wxbTz4bphVv1drbFobQBulrmIw6OuW3SXtsM/MS4R8BOkMzay7NMmUE+QXVVhlV9lgUZ5RaVpTS
 VyQJvrsmDIRLxz8BNm3q7DZ73qBpDyRRkmvh8gGlL7lEmr/BArWw+xSMA4dCLpEekkDXgEpuPY0
 o0Q8DQPJEWqm/c8xfJuD/gBK0XgecuIetuX9M+u6oDhZ1HcFVjT4Z4wTaK9QaRInFt3D+yYEI7l
 IxEdettS2rmFmO1bqAMKGa5JLorS+OOC+0wgrAzOHszwefGPqswk0ZwgBAzWHeG2RnmTWyTcUQ5
 FTgIBC8n8y4GyyxemQg==
X-Proofpoint-GUID: ya0k9nu_ev0erhnkUtg3wfL-QuYjjgRj
X-Authority-Analysis: v=2.4 cv=TtlzFzXh c=1 sm=1 tr=0 ts=6af3bd2c cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_78whYxrdx1mplLwxq1U:22 a=VabnemYjAAAA:8 a=v0rOKv7RD8y9Oui3zVYA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: ya0k9nu_ev0erhnkUtg3wfL-QuYjjgRj
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX3c8egGnIMFgL
 P593oaRoh31hN3ZFT9QYUik8cky9dXxOlvok7zXX1Jowkc9rjQrgkZbgBYOYdWyexm0qYlbyP6O
 QtTvy5kv5Qdx01B9RYa33QnGqoXsF2c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

every psp skb is related to a socket today, but that will no longer
be true once a psp association can be attached to the skb by other
means, such as tc flower rules added later in the series.

get the netns from the transmitting device instead.

for the outer source port range, psp_write_headers() now explicitly uses
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
2.53.0-Meta

