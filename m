Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383134;
	b=Qdm4kI77bYzG2N7B2Hs495Tnp/RkFCHvjzXVb6PNL0Dll7ROo2hIn15JS0+tBiJF9ARz
	 eNVhmlw2t/81pdxo0TbreyQ0E6EMyGiMgkGXurYBIGFZEq3KPOs8ijmRGElMC7NErZxzc
	 GpIWHqCIs9exMjssTR8pPw9X77gdn+l1iyI9gH7ftAV+vNFtm0XMrTN3swozK1jNPA/sU
	 9rxN3AL8OHvD2KaUaNlPYqdAGvviMVf/pcW77SUGxr+KLt1+pTHcA2az7PRcHT1ZWitvs
	 loZsJMT8wPh25lEIgZdgjQ1ANet1xRJhcyQxCafoRJX25O+ZCOShlopwKangNBitBnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383134;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lQQL+w7jSXxL7DuCEWJgXOVlyIiO08sZXsfYcN/oPBc=;
	b=cydqfJ6JyprOah3xYog/fpk5PkBZZ1kzmwGgjEI0rYuJF9hkUhUmBILDldUoizIeieJ3
	 /alqVHTkjH5F6fweHEYfJf7s/8Tc9hZlhkUqgQvfwOiYBbimIX8W6H7tY1OfYNRRkqrv0
	 aI1+HEeKubIwOg6xE3n8IFYSjD6rlrrmm/1vVgGQdLxXanCBth0Vjb70BFsxx3ri4RdH4
	 VFl1uxxQRJEdlhboYArNjtJz+qg6VFmA3X6V0IzeBde/lPoyTImvOkf4+zg7/Iu855QGB
	 WmDJzbOV91RRiXLsdlrXp1CT5kIGMS01Ood1lLumfHfSgzsDl2Mko+xaiM8mH0/QKVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="PNY/WmiJ";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C560A2612;
	Sun, 22 Nov 2026 21:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE9C560A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=PNY/WmiJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383131; bh=kHRSW5x32V/1AcgY5KsUJ58hTF+YN8QMY2Q/TVZ/4XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNY/WmiJnuXwFMVGSBqasSMOPnymrPStY7frJLzk6sYT+k89kiQPMuTK2RsBuxPJ3
	 V9DlQusGygRBiYIK6EKPEq7WodxwwJf14vtkQU9pzeK/lJkKkbChtAdqOgteOJmzpA
	 Tg1kSvNHnC8FtaO0EChq9z8JWka8S2PkhoRPDjx3e6u28tBEN9ZWn8UbwG4K2L1TO/
	 Q8k8UtKrt2tp6K6uV0RL69Qkxd+cTLLsUsdUyqxdsLhZwcApYR8YvSyvbw1BI5geps
	 f2FlcD2LyN1gFEZPOiBsCdrZXXG4p8/ouXl3L3J2Xrl21RJZxw11a//qm4tbOOwM3R
	 J1fnxje4BpOjQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 68B1844C0B5A;
	Sun, 22 Nov 2026 22:32:11 +0100 (CET)
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
	oss-drivers@corigine.com,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v3 09/11] net/mlx5e: TC, reject tunnel keys without a tunnel device
Date: Sun, 22 Nov 2026 22:31:57 +0100
Message-ID: <20261122213200.3207385-10-acassen@corp.free.fr>
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

The list of supported keys accepts the tunnel ones but only tunnel devices
parse them. On any other device these keys are silently dropped from the
match. Following rule is offloaded as a match on all IPv4 traffic:

  tc filter add dev eth0 ingress protocol ip flower skip_sw \
      enc_key_id 5 action drop

Commit 075973c7d7bb ("net/mlx5e: Rely on filter_dev instead of dissector
keys for tunnels") stopped parsing these keys on other devices. Reject
them there, for NIC and eswitch flows.

Triggered during code development while preparing a generalized version of
earlier GTP-U work [1]. Reproduced on ConnectX-7 with firmware 28.48.1000
without kernel changes in NIC mode and on the uplink representor in
switchdev mode. With this patch the rule is refused in both modes and rules
on VXLAN and gretap devices stay offloaded. Not tested against kernel
selftests because none offloads tunnel keys on a physical port.

Fixes: 075973c7d7bb ("net/mlx5e: Rely on filter_dev instead of dissector keys for tunnels")
Link: https://github.com/acassen/research/tree/main/UPF-flow-steering [1]
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2326fb21da66..eab4d5417ce2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2786,6 +2786,17 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
 		if (err)
 			return err;
+	} else if (dissector->used_keys &
+		   (BIT_ULL(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_PORTS) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_IP) |
+		    BIT_ULL(FLOW_DISSECTOR_KEY_ENC_OPTS))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Tunnel keys are only supported on tunnel devices");
+		return -EOPNOTSUPP;
 	}
 
 	err = mlx5e_flower_parse_meta(filter_dev, f);
-- 
2.43.0

