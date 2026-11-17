Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907771;
	b=waVlJU39afxBirl4qQ7xWlhvSU6MhzTYs6pwF6E8m2mZaYvUa3b6Rnniyes5FLnBD8RI
	 eZCuHLsZAH0GhqATTww6cO7xLkGR9PDZ347bShGO18VE8RMBtSqqF1LZis65xqX+N8EQ1
	 R+RfNtEUa03e/kKfiFywG+6FnIH/vpNa022/0QGbmpR2pcaDrf3Yw5d6GQRvw4mx75YwH
	 txBWK2KS/cocqKO0bwG/aXiRrFkHDfIv3nL2L+qs7UOsz/XojQdW/cBKNnDbHP2R5dN12
	 iXrfOaYK560CvYbEpSfJAyOtG8HIDqKq9d1ryodZ/1pK9HzAnH/Pu7h+rxBaDtKJVJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907771;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PApOUXK1WkiduHeBDkmMB8mnWq/IyNG+wx88YRljsTI=;
	b=WScBSefsY8JI5k/5NT2iQezxmdrqCuvO24z7qmCB1qTI5IZ7/pv+gzx2AQ2FVq32x/dt
	 jpeNVlVNxpJ+cZ/3ajUQ7vLHWrIcAgErLUtOXD8k7cMKDedEaUMB5NcvONlemv4yfqLOY
	 5tk8zITcXDT0OWc2p+Qc+12Cs1oikbWeydlWP6w079KINZ6pC4MmW5UbLBj4q4yubyk1b
	 CQy9Qt4kDhVwfsJWBRXVDcK+rZqTKoU0QchlkNIGwuw+k8VLoHvmtaXsmOcjIvB52IviU
	 EgK8ZOlITpAoSWUDQ5BVL5lOsJCJkTREuKmOyNdzPhnXb0j0ajVjNm+Zj4OGQA4cyzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=bwMrHAB6;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21075606A33D;
	Tue, 17 Nov 2026 09:29:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21075606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=bwMrHAB6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907763; bh=RoGIP+lb4T/ncLxF3QQFj5FahL2EbJ0Uys3hYC006P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwMrHAB6/NvVZ5WaK2izNARtr9AzamdMlfhevMBnykCJHfSZJi85i2Z4/qIjH5/lX
	 Hr83voeaY9ayK6Jyfy6CFlDfwxuUU8zqIOnLmA11UYatb8PF85k/phSl+6mMqJ9Q4V
	 wP1vL4NPhBIfqJ0vRa5oA/mZz25Nax9BnR7aLcSUQCXXDJDaKkVv1JbadYfH+GgGqz
	 icQ/YobSx1yVJCnNjhQ7TWHfGx/ENZxjVRWF0Us325zzDD24qbhwRE83Am+uAk98WG
	 pBVhac0N440nlGCvgKMk+pLjG4ujC6tv9iAxHySDVEmnGiN71cEaZN4MPBMZyTCnGt
	 7AQR88hQvDfUA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 8908244C0B4E;
	Tue, 17 Nov 2026 10:29:22 +0100 (CET)
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
Subject: [PATCH net-next v2 02/10] cxgb4: flower: refuse a tunnel key wider than the VNI
Date: Tue, 17 Nov 2026 10:29:05 +0100
Message-ID: <20261117092915.255194-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092915.255194-1-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
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

