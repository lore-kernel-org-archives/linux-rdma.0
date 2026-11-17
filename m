Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907780;
	b=ef7wV5jRQf3tUxqltyibsCwpPRFo4h8w7/VFnceY1dE7te06V5DH6yD5iUzINQ4Vhu5d
	 EmZiq+gvBOQY2tDjwX+l0t1nEqdAvRMxqh3bu5Rj/zC3Zd6y/Xvl/x5OiGmds9oS2HdHT
	 UhTw0APm/19DdNeCrG8EWxA8suaPDd51zwRjJ4O1B0dGyq9JIaknuiWVr3EHq/fJHbdzt
	 /XQ8C+RZ0QlaLcPfLEoTqwBKotQwV153DSM66LmJBiheNdOwHVGz/4DR70VhLoQ4wQ5Ov
	 65TuJ1mZYZqjdL5tqhEdXl0YhbYvKcEm3+O2z6L2Kbu7bJSPcSUhemJ4JgR1xzg8rUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907780;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xqQWfWKatMYIK2o9eLxPURKMr0Gqkug9p556vmmLLro=;
	b=3UgUqx0h3TaRMy3c5ET3QCeC+kkhSNbZlvEa620VAb2bwRtpz42DWSU6UdoGjpLIrYYO
	 TCYYZsM7k43sKjg5fE3ozbTiQj6/3/WnfZhvTszLHYAiXlUNZCUJQW4b5YQqS2WMcqHg2
	 lJamQ6x9qItS0QvlI/D/YbW+G7vsaUubKcGQCAKmL1LDLhsmZ/i8XKUCrSRb+11Lqlwjy
	 25Vc+kO8oOWkoaEy8bQlClrBFsPvDsy65mz82InevTIe00iK0MbNhm6WI+bTuPltfG5A7
	 Mib/iQQCX30VrHxat0lPwe5E4XqOJpsDmxKVyoTPFGJS6OXYZJzvYp5swP/eFf59qxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Sj+fDnbN;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C460A2623;
	Tue, 17 Nov 2026 09:29:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 653C460A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=Sj+fDnbN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907764; bh=qPmG8P+hFAtTUxkbaEcSp1PyPgXZo0DXS68/FvOLOG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sj+fDnbNzmtSvk5xqSC3Y8E9IhXqSNQk6YlG3JZSdyb5InDNl19tyx/SqnCjWcCno
	 PvQ0YdWlio/UH+c78gRkKf5HTpMBjiuaO1IiMofsrs5dYp/dEoeHnSAIpEEKE94Jnd
	 y0XZdKH+uGHgXJSDboluV4yL87IuEE2uz1O5dosrnEaWAO3riQH96jpTCyi/IXtg4w
	 xv8x90TN/ycoAFOdGNaI0NZmIT97xHWBXxJW7Fy8EPzHUgzo6LxssneAnqphEM35zw
	 jgK67lwL7GSmQ0Fd7/4/E8iy2TAesTZyd1cX/va0PCelb36f7B3iKxL7xWgICora5S
	 jOx1OJGdSxXLQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 8CADB44C0B5A;
	Tue, 17 Nov 2026 10:29:23 +0100 (CET)
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
Subject: [PATCH net-next v2 04/10] net/mlx5e: TC, refuse a tunnel key wider than the VNI
Date: Tue, 17 Nov 2026 10:29:07 +0100
Message-ID: <20261117092915.255194-5-acassen@corp.free.fr>
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

