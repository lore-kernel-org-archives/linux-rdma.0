Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907773;
	b=kIKJ4Eug9FRVrW5ndcBy1kT38GSuBEirzNrWG4eHPltkI3HEaByEH/To23fO6OLCPCvz
	 9W7xQMJSMJw+UKN3srHbL08t4fv8FnJ2jA23vDu2Zbd5py66aLOzZcEOypAjj4Sofhoh5
	 iV9pYiY1FL2MPv7dyFicHKvf+dN+PK4dSSStFZaT4BAJ77atf9ojtcRIjGTxIEWSJKn9g
	 N3R6f1hExk3PUmuA6q04eOXKRrRjdWIyAJlbvZl6izF4pNuR+xrLZRquzrXvejlAReVzX
	 sMRF/qvpGm3cdPwVfn37xsAVaqRsdOW/MHvYhHY753xVXIiUkiNu3K6O+pw9fl7bgHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907773;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QpXJymSL48oHV5Gty6tREKnyHspYs4HJDm5tg/o9etQ=;
	b=ZFcEG0O6QGMZ5Ro+XtVO+80PsR9+vF+VvhDEaueU54V8j1ZobiK2QpKnzmce9wzWtXRb
	 NYrBId3cU9Bb2v2hC2JrbMcN5FxDOwE3hfSgNG6LYv+rRWwlI89uSLFPPgv9UR0XbbNYs
	 G6WAbULjLysOSt/1BMBY8p2ny7KuZpTP2k2ROKdydNwSB+/3sgwN1pJUODPsaYz27p5/g
	 83QA8BnVxY3bgYw1rKtmQ/2t9O+vbVdYSsthaKJoSDuSU9+zv03Cqwrg7Va5MoSTlk14J
	 pSrW4SvxDdP6Eu1NmOLfh/GZpi68kV4XRqSe4f1/h77iP0pXwzOnbv7VhiGlmqJIdhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=S6tJ7RAP;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7E6606A881;
	Tue, 17 Nov 2026 09:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C7E6606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=S6tJ7RAP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907764; bh=9RTIFcQyd9tjIJwC9OkGdscO68l46ebZ0ckUIssCKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6tJ7RAPxI8ado+/AmhQFw7mrZtMUwUc6wfgusfu4JHJLm7yfIsyHy6hXmzgywEiw
	 83OKWzHVxLs/6IZ3dIM6/AAEgXicQBFHlhQEicWYIrsZqycEKdXBW2KGU4avMefixf
	 OquD/Wc2/dCBSreilPmRC3c0egM/4LV7o6EjoQNxJh6p6CseuQMQIootOz5byzJK9z
	 4lgL4ZCPnfwVET+cKDjSQqLDJqZi2sr6OAqWeMsInLjoyIx/n3boHSrloHBMSH1N6j
	 HjcM8mz5T97ODPcq3yu3U6pCr4JBWYeM+5rTI3iqqpocXsAEMl+SiZ3cJBcn4FNWvp
	 1DZXz7v5Obf7Q==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 112B044C0B5C;
	Tue, 17 Nov 2026 10:29:24 +0100 (CET)
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
Subject: [PATCH net-next v2 05/10] net/mlx5e: TC, reject a partial tunnel key with tunnel mapping
Date: Tue, 17 Nov 2026 10:29:08 +0100
Message-ID: <20261117092915.255194-6-acassen@corp.free.fr>
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
index 1d35c97aea0b..ba3aef3c8063 100644
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

