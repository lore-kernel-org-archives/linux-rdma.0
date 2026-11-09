Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229848;
	b=1zxWrJP3ZNX/h0MOhfS6r9ClQYXGAg3qi25o1ylB2u3xfXPom2SpdNGP502BI5AmABYU
	 LwuNCVOsRR3+YoRl49MLSMmCx/8DebqkCsAlXoBHZl9pCWgjJ4dRRKvvh5MgDV574xQJI
	 tAUbp1cg/X5uJv2Z4RKNmqmA/wU6wIN5vL5UE03rbsz55M+v0ZC+PcJv6bOWBdvHYy8WN
	 RzXvfokFiO5T0PWBKsV8/iHJnbV874LeWg4VL+yA7zfmu2giCfM064RpgwD3Jl6EHyf8i
	 gznnibqbtLvNvzXXTJTBhMvrHmlgVwHQ52D/3cByAOoCm2o1oIQg90qkdhCN70gj6Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229848;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HMWVSYbVReaQvn6vsmT0jO2CyxVbMT6voyL5m7FUv58=;
	b=Nuw6AKkPOnzWfSFKsjq3fko0pgm9T1ZfV04JNF+iXQvobI1Pt33NAX12nNHOLAMDAmzY
	 rifCNthI9Vd6zYfFjbd/8/YObkDCWOYzDeduABmqLteI8TS+AAdcCWOV9DCOQEloEwmK7
	 LPaKQY5U//zkospS3rNA3BWFKRYEg6Ga4cKvSbZMWDbbmRq8WJMyEq5kjFuGxP0+tcjf8
	 oK6BeOk7R2iyyUpO/0n6k3qKO5OG8Pfw9cJSDEREid6Z/VmYJ5CSZjeUBWMi5u0fVJGg7
	 rsXbxHIFYi8RfKl8OVxjGI+N9mwxh6o3IPyZs7SM9/65qezqmKd2qK+egZc+KHibqMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=i23YClqA;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4100C606D812;
	Mon,  9 Nov 2026 13:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4100C606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=i23YClqA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229846; bh=r7AVXNRaRSXaGwGg/zYogQuj3T7r4JX2XJQNHMJ7dHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i23YClqAAMhbmyvVgpBszmfD2jDl+3nwzS679N3uPfi+DDE80wNKl1oQWjhnolNuW
	 vO2bHpRcYGUWkY8NaF3DSaOtAXs8+OHFtaTPapIkT3HvcvGVvOQiyWJWhemR1ErD/a
	 BoOWz+ytAQ56/FyTFUp3a96YGz/1tQsGJrmEyZ8N8grxsfmrJ/z3fQfk8tk3i22k7m
	 wRfb5GZg5Sj9N3rG2xgXpbf50AKjfssTzoMMBbLHieWm/7GYMeaY/5CXFZhTwXa7o0
	 GZ9ydbnonjNo4gPvsomAFrG7OhgAOlpFlK2hjpuqD+kDAH7oq2s5eZw+V9WXf/Ih7k
	 +50DIIqZDG0Vg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 411B944C11AE;
	Mon,  9 Nov 2026 14:10:46 +0100 (CET)
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
Subject: [PATCH net-next 02/10] cxgb4: flower: refuse a tunnel key wider than the VNI
Date: Mon,  9 Nov 2026 14:10:28 +0100
Message-ID: <20261109131039.959438-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109131039.959438-1-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
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

cxgb4 holds a 24 bit VNI and truncates the key and the mask of enc_key_id.
An exact key above bit 23 already selects the wrong VNI. Flower is about
to accept partial masks. A mask that only covers bits above 23 would then
clear the VNI mask and encap_vld. The rule would match any traffic its
other keys allow. Refuse a key that no VNI can match.

Found by an AI code review agent while auditing the users of enc_key_id.
Build tested only.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 3307e5042681..d9a509be5c51 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -316,6 +316,17 @@ static int cxgb4_validate_flow_match(struct netlink_ext_ack *extack,
 		return -EOPNOTSUPP;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		if (be32_to_cpu(match.key->keyid) >> ENCAP_VNI_BITWIDTH) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Tunnel key does not fit the 24 bit VNI");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 
-- 
2.43.0

