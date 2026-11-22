Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383130;
	b=qyz4rAowPMaPUnXCNTDDRDJVTMksOfvS7RttVITT6aadiX1sz7IPqjXpZdg2llYYYsD3
	 0AjaX4M2+FpZnfhzPTGVkLv5RAZDAR+O6UpUiv73gPn8VyPdTeEvIiTWXyYXde5C0hJkL
	 WLWx6Ntth0MeRXG52eH6GLJwK1qLjzag5DQ3vBMtHtyenLFpcctU9Px9vr60rTa3A4zpe
	 sPJI5+D1kY/zWy+hZ0TS8zgGZxNu6s7ja1Oqd+oLx7X1oWWryi/F5Cl2QIKSDsmJm2xql
	 wb/CrfZMMOHXmBZg9ZDzbPMzfTtk3Nhbb4lnEL2RIQKIZeRqumxhV6eX00Vat1MHSfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383130;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0YuOaL22hEDgJH7NIValc7d/1O8aVAHq0GRIbg0dMpo=;
	b=SysyVB7gSBMFKVjfoq28Ocl5TlXx5Mn0SCW3BtkQ6Z9qixPgeuWyBu2OE2LnIhpUEGS/
	 jlAr1ArT60A6IljLNQkHdPVGzBaAwq5cSbPThEBMJMSDoq8JpDv1/uNlLmaVyEZf6I1gS
	 x+ZmtPTXtSNx3r7eSt6lKPH0m9/LB9DaIpeaM/kgbz9VOoq2JGu7JF8K/vuPr4BPDDw++
	 YcjEgQkaZz1yAHMcVEGv8hpkS5O78U5X3n2lBJpIq5oITsCReQY1LWauPAG4MYqvSTY+F
	 PF1K6622GEYncfU1SHYkL7c3kmhUO7zhgtme1vj9OX/dpjIBZg0xDx97Dv0ItghZNPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=RBXtInZC;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7038606A32C;
	Sun, 22 Nov 2026 21:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7038606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=RBXtInZC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383128; bh=UlaJEuXtE7a6/WFj37TmFZ+q/4fm4mTOOJlUXKCu5Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBXtInZCQDXzvPVpLAiYH82kS56iM0VXCexyaSBcfEZJ/d0d2Fd5QMxN9NYIkJueb
	 tnZQnItHAPsxACfauj1pqZZ/KDTcptFHrcIVy13+PgZgj2kWoNclWel5kyyus60W4d
	 G8fgkYz7HM/QutuJpW/i6WkTNYfcY2ZeYNAXJzmQeniPfsw+A/HfAojZEatIHOa1k7
	 1zQnHM9d7cDBZ5z/Hxd7LpYbqVPjWOj1Lhz501EvAyABj5zP5sh9VxMe89+ajwM6qD
	 7e+3g81z/lrd87mM4jXYPRE6WxxJl69nVA02KrTjJWIy4UrjTP+2farxJKjvZq9CPe
	 ukGUsf7mgQutQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id EBAA444C0B31;
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
Subject: [PATCH net-next v3 02/11] cxgb4: flower: refuse a tunnel key wider than the VNI
Date: Sun, 22 Nov 2026 22:31:50 +0100
Message-ID: <20261122213200.3207385-3-acassen@corp.free.fr>
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

cxgb4 holds a 24 bit VNI and truncates the key and the mask of enc_key_id.
An exact key above bit 23 already selects the wrong VNI. Flower is about
to accept partial masks. A mask that only covers bits above 23 would then
clear the VNI mask and encap_vld. The rule would match any traffic its
other keys allow. Refuse a key that no VNI can match and a mask that
leaves no VNI bit.

Found by an AI code review agent while auditing the users of enc_key_id.
Confirmed by code inspection. The wrong match was not triggered. Build
tested only.

Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")
Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 3307e5042681..467f055e318c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -316,6 +316,21 @@ static int cxgb4_validate_flow_match(struct netlink_ext_ack *extack,
 		return -EOPNOTSUPP;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		struct flow_match_enc_keyid match;
+		u32 key, mask;
+
+		flow_rule_match_enc_keyid(rule, &match);
+		key = be32_to_cpu(match.key->keyid);
+		mask = be32_to_cpu(match.mask->keyid);
+		if (key >> ENCAP_VNI_BITWIDTH ||
+		    !(mask & GENMASK(ENCAP_VNI_BITWIDTH - 1, 0))) {
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

