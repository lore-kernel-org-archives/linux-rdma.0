Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383130;
	b=2W5waHq9hPBjUYIeCCA0zNNx027ZYRhEWTfITuW0A9GxaaTub2IaRfKN5wcBYEBJh3yb
	 CDuLV836V35WEo/d4YDUIE1kUNA307/z2HlKw1ekR5H2YtwPH36GelJ93vZ+8WYtN7OzT
	 9TkSpKNNaUigIDURTvbASXe0vgFuJbSVKmq8uGwNLN5R/nbC8e4wG8g8XLYf+Jy4cXEaK
	 26Q9I/+thc69QdqDc0gF0hVSuGszBhemceearoaNAFzek9aMCpdrzorLPSX9SWqY/f/jO
	 bIK7yqvBgKCw7p4Ot8KhZyBfElzKGHfdO3UAEb1RHtmZ7icBD6XJyyCmqidVRTu0buA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383130;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JjKytr2/tdOSIX1OKYCfq3N0QO6/0vvrQU+SOUmNoVI=;
	b=v9wQTApzoYsXgMRjO5Gx/mmhsbQCPozgl7IXeniNrZ8NyV4da4j0XIBzrSmo5OqyO2bZ
	 Trke7B0Ksu29VW1UKnMP9CRgydTmz6yGy79xiOsP/no2vWEEQBJBJ8qXdTc+dKH4C/cIM
	 vJ4f76jb5QgeqesIY4mM0jkd5XY2/7pRqZCFlJTiIXdeG2G7LH6qs4itmYm6H2wiyVwjW
	 7AL7+sCpG4VxcuEjJFjlMnhOvTJT7zk/KGneCtfpVg+LbEQBO+k/rfn6ujEbfrVuWAUI+
	 ZZQliaqT/reM2iaYPzzPVX34eRtV/O7QFwOjcqwOU1WDeSUO4GNPb6q7X3sN74dWQJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ZHxorlbT;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8DA606A31E;
	Sun, 22 Nov 2026 21:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D8DA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=ZHxorlbT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383127; bh=X4BR+3z4bCtFQxk/fhJw5fcoAEWXU2M/R6/BtbKsNB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHxorlbTag4jLuaU/ygUDS0MUb8H0kB428jxNSU7w8y3kYimAomyqc1uVw1nPuLY0
	 o53rZD5emb3ImfHlfK2EMJcQqdSQMZ5lrGax4x24OMEEPnP57CsZs6Dv77OJrVMfht
	 IFXtfRFmMkfr6ovXgnImDgKJopc6Ceckhp3kCX6HHM53QEuIAQg3meXW/l0JvmQg6o
	 zBv9IRQwlePH1+7wn1WVAwJ9tEjQo8zWEXhvJ0+MHzn36PDKqwWnWFTX2NCtQtS5UI
	 jUswO9lkwYbpj7ctaW/uHYCsTXmtwkbHn6OS5dgAUHHE/CNJfUayxKomcAWwdJoxT7
	 DkNEZfm7Slsbg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 71AF544C0B08;
	Sun, 22 Nov 2026 22:32:07 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next v3 01/11] bnxt_en: require an exact tunnel id in TC flows
Date: Sun, 22 Nov 2026 22:31:49 +0100
Message-ID: <20261122213200.3207385-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261122213200.3207385-1-acassen@corp.free.fr>
References: <20261122213200.3207385-1-acassen@corp.free.fr>
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

bnxt programs the value of enc_key_id and never reads its mask. Flower is
about to accept partial masks. bnxt would offload them as an exact match
on the masked key. Reject them like the other exact fields.

Found by an AI code review agent while auditing the users of enc_key_id.
Build tested only.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c6b4a14c0e6e..e493c85ecf28 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1081,6 +1081,13 @@ static bool bnxt_tc_can_offload(struct bnxt *bp, struct bnxt_tc_flow *flow)
 		return false;
 	}
 
+	/* Currently tunnel id cannot be partial wildcard */
+	if ((flow->flags & BNXT_TC_FLOW_FLAGS_TUNL_ID) &&
+	    flow->tun_mask.tun_id != key32_to_tunnel_id(cpu_to_be32(U32_MAX))) {
+		netdev_info(bp->dev, "Wildcard match unsupported for tunnel id\n");
+		return false;
+	}
+
 	/* Currently Ethertype must be set */
 	if (!is_exactmatch(&flow->l2_mask.ether_type,
 			   sizeof(flow->l2_mask.ether_type))) {
-- 
2.43.0

