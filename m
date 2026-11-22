Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383131;
	b=qTzkQwf5jq3KEwQmZsf2xcgh4D9PJEVdLwR25OHqCPXoCXDqVVFiuRmnqIt1MfbQ5vcO
	 WKBj4IAetQAHDYA+0EwLmQJ285VV4FFmPdHpJwDcAfMI2AbvpuJszpmbgnyODtcXuhAMN
	 9C6foS0uiszOK/e8TD6O/JHrb0FCuIAYOdzD0W21JmI5XEW2n+G18fJ9uK5HVmwSP9pcB
	 kUPMgaudUKlIx5W8QGIj9vnqo47+vq9MANBFIR1D8ggAPlBUZaatyms8bzoAwBMFsdS5p
	 ysMJ1qsGxyMIo4q1Sr3vog1n8FN5pEPlbKlgGNKpPSL4u3mEasjVarXCyfm1JMpB+lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383131;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xqQWfWKatMYIK2o9eLxPURKMr0Gqkug9p556vmmLLro=;
	b=WfWcVGuPl28/Q41pKtgesBty83MuY4HfkNJEZrfbloSGBnyONCrXDABqO/aZ+OL9Alra
	 GpchjGrH+S0Ov5bH//xpCU09uxxxszGyNjp9GL3Mo999sXPqsLXemlN1L78igOoDglZ6X
	 9bYWBTGnq9S1ceG9CfRi2lx/1hYyO0glbCzRHzu30EAwOZwF4gBTwpo6J6pTt4jqNHF6P
	 WjWGJO5fmMF7/KJYG9h8tr6vKvrQXDTewrlS3EBcMpHcoEdKD82aOaDhcw6qj9G8C1PYQ
	 135YGOgPPZLxb9DmqBYtbfqw25QiUNS1WaYvaoG5TnYQnpOaAVw5V2eag2sgtgJ9FxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=lWwcf02L;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4144606A33B;
	Sun, 22 Nov 2026 21:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4144606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=lWwcf02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383129; bh=qPmG8P+hFAtTUxkbaEcSp1PyPgXZo0DXS68/FvOLOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWwcf02LVJV9TAAQ/YKkO7Hop5lLjsm3vAVzs+WyY8xF6dF+HVAO7kDxVM1TN+Lz/
	 i7CVJudE6+9ueESKZDn6NYwz8jAfuesrOG4H6KlWQdWUQqOOcIXrN0sV40ltUZWXiM
	 h2G02m/bbrzgP8bAqvekWl3VLEerl4+WrsDu1ECxxo2TO2no/h9LsCVQexNoszob9R
	 HvJudc0br1+Ng192Sn4CACCP5lhe2JLren/f3u11+Ac68e/gCAnamSkGAzcBYxWsfW
	 ZZTwvPh5P66O+q0Ic031tC4eBMZypzVaTCHwdStnNohGVA5hPfAzzMtM35xUz7p+fV
	 0a/z2rQNtE/Ow==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id E8E4344C0B40;
	Sun, 22 Nov 2026 22:32:08 +0100 (CET)
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
Subject: [PATCH net-next v3 04/11] net/mlx5e: TC, refuse a tunnel key wider than the VNI
Date: Sun, 22 Nov 2026 22:31:52 +0100
Message-ID: <20261122213200.3207385-5-acassen@corp.free.fr>
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

VXLAN and GENEVE flows truncate the key and the mask of enc_key_id to a 24
bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
is about to accept partial masks. A mask that only covers bits above 23
would then match any VNI. Refuse a key that no VNI can match. GRE keeps
its 32 bit key.

Found by an AI code review agent while auditing the users of enc_key_id.
Confirmed by code inspection. The wrong match was not triggered. Tested
on ConnectX-7 with firmware 28.48.1000 in switchdev mode on VXLAN, GENEVE
and gretap devices.

Fixes: bbd00f7e2349 ("net/mlx5e: Add TC tunnel release action for SRIOV offloads")
Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows offload")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h       | 3 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c    | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c | 8 ++++++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 6873c1201803..d7c778bbb2ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -13,6 +13,9 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+/* VXLAN and GENEVE match registers hold a 24 bit VNI */
+#define MLX5E_TC_TUN_N_VNI BIT(24)
+
 enum {
 	MLX5E_TC_TUNNEL_TYPE_UNKNOWN,
 	MLX5E_TC_TUNNEL_TYPE_VXLAN,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index bf969212cc77..ee04fcdca6ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -141,6 +141,14 @@ static int mlx5e_tc_tun_parse_geneve_vni(struct mlx5e_priv *priv,
 	if (!enc_keyid.mask->keyid)
 		return 0;
 
+	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Tunnel key does not fit the 24 bit VNI");
+		netdev_warn(priv->netdev,
+			    "Tunnel key does not fit the 24 bit VNI\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, ft_field_support.outer_geneve_vni)) {
 		NL_SET_ERR_MSG_MOD(extack, "Matching on GENEVE VNI is not supported");
 		netdev_warn(priv->netdev, "Matching on GENEVE VNI is not supported\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 467fbe43b89e..33911e72d20d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -173,6 +173,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	if (!enc_keyid.mask->keyid)
 		return 0;
 
+	if (be32_to_cpu(enc_keyid.key->keyid) >= MLX5E_TC_TUN_N_VNI) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Tunnel key does not fit the 24 bit VNI");
+		netdev_warn(priv->netdev,
+			    "Tunnel key does not fit the 24 bit VNI\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
 		int err;
 
-- 
2.43.0

