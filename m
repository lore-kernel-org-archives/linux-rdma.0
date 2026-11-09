Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229850;
	b=rQmEXbRxK5nx1spfvXDOAm2PbwpVDWMiT3DzPaCRpO6notGbqHFQllfVdy7deNVnRPjI
	 oBivSdFLpwKUD4nUQDhrTm3dnwrUZennj28py2pgbZCx6VXDiVQOBG8S4gXgWkJx1eoUD
	 z1bo7RIWzS6Ew0zYhrB/xjLhmUS+HS+WjyOYNOjrOcaAcVcu8/nXqctS7Ixzyxc38kQl6
	 6rMNt56ZY09GWDDTqHSNRkrgWkO9eD8OZ0PIiWQDTxz2P8ITlsqZYd3x+Gqz4a2GfVmd5
	 kNcU4sGOFZKPnMxIdSVyqcxkl4KwLnoAWVWCTk9Mc2QBpGApkE/RLh69GzijI2Xs4XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229850;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mKoXs6VqVthbWJtOwMd5KBChqjVY0ecFZeruwDYu1BY=;
	b=OVK4AVwJ0lCf/yrXYag6tNoHuY3yuWS0heK51bazI5QoOIK5+yqNCMDcqanZun8VUg70
	 hbRAKBtdkxxS2MITgnGJU0RO72EoCGqMHulZ+Lwk56RuQWGX8lo1UfCRqw/ZEH5kc4srL
	 cAedcrA9dRR/zXiUyDGPA7sPuGKDU5qLsZx8wr11P9VYRA47LOrnoAwpl0gKya7+SdJl+
	 SnOp5DhhSP2zDrOplN9jjM0/iLvKOH5NWbHJy0Stzl47nLf5ZC4acSU5AYEFWrPqpsrV5
	 i0UfKiO/D/EbT1hhV577oePH7DRrvCQOeIV7yhdDekpqSd0e85rRkozt1ODMGbQrYGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=SuY6TqlE;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF372606D833;
	Mon,  9 Nov 2026 13:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF372606D833
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=SuY6TqlE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229848; bh=lbjz/+eNy9kE2MIpGzdcxAaIqpRBRcWZI2x7PMVFMzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuY6TqlEtxKy3ms7RTAlia3lKZqKakZTkgm09n/l/ATBEY1qA7//YPCcV4w1KvVu0
	 a2YXw+OpxL6JLT9Ouy1MgBCBNNCw+K5Ou0dcfDfcKTnjxEYx4g7gHBzoGmTgerUrlm
	 uwahKFgVeL8/jrQt+Ue/rXzalxRrc5SR7/D/uyw5OPMcak+JQ93FCrgqBVNRw6iYO8
	 R/DKZf4S3mcDqIlUTKFDLkfbJ339/hfu5ZCSlrjVHQ3O19ekUoQffvHQJVIYfKd4mK
	 XrpBw3Bw4mzOvDAA1s2lDPDQzK+JI7wre21LW9jcdFIUhVzht8HNese+Yyd2/bgC4w
	 LWN7UmQGRvuYw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id B721644C11C6;
	Mon,  9 Nov 2026 14:10:47 +0100 (CET)
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
Subject: [PATCH net-next 05/10] net/mlx5e: TC, reject a partial tunnel key with tunnel mapping
Date: Mon,  9 Nov 2026 14:10:31 +0100
Message-ID: <20261109131039.959438-6-acassen@corp.free.fr>
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

Tunnel mapping stores the matched tunnel key. The metadata of a packet
missing in hardware after a goto chain or a sample is restored from it.
A partial enc_key_id mask would restore a wrong tunnel id. Flower is about
to accept such masks.

Tunnel options with a partial class or type are already rejected here.
Rules without tunnel mapping keep working.

Found by an AI code review agent while auditing the users of enc_key_id.
Tested on ConnectX-7 with firmware 28.48.1000 in switchdev mode.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 708b7987ea4c..28f09d234835 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2257,6 +2257,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	struct tunnel_match_enc_opts tun_enc_opts;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5_flow_attr *attr = flow->attr;
+	struct flow_match_enc_keyid enc_keyid;
 	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	bool enc_opts_is_dont_care = true;
@@ -2265,6 +2266,16 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	u32 value, mask;
 	int err;
 
+	/* The mapping restores the tunnel id of a packet missing in hardware */
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
+		flow_rule_match_enc_keyid(rule, &enc_keyid);
+		if (enc_keyid.mask->keyid != cpu_to_be32(U32_MAX)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Partial match of tunnel key in chains isn't supported");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	esw = priv->mdev->priv.eswitch;
 	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 	uplink_priv = &uplink_rpriv->uplink_priv;
-- 
2.43.0

