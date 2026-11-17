Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907771;
	b=PEUF0M7U5D58aFqwTXXZ6xdI3vA1bfJaDzNijS5gLlelYntBEx5zOWAFXJ8Q7gjokn1B
	 6J3Dlscq4+2goGCynPzQ+Qy9qi9nr8DTvjoOqyHmtPXYW6xWZbDRcWrLVWLGIJHJSpmnN
	 8lXlgeQk+/edS6DTxuQgthtujKweRaHXf4NqOR4HrhuhMH4Tk42f2eaUuTn1vJzKMyGfU
	 CoFpd/aadp5jUPAuIv4pVi7HsP3hWTJmzaWTStLFagYXQiEsFs1bOY/wcE4PnKmuDuOYU
	 85g4XrUd7iKHWbas0PvwkJLBlV7n7vko+pfziL5EdKzpHSSZ1qOuQhZyWxpYivmwFHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907771;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wO1WQOXacXkBpK57nLOV+oxy3y/IXe/mURdsCtq3BIo=;
	b=g1J7OgqU6fBpowZ6UIaaLWnSJREQxyOrl0VRBo1HP2ZweaO9nM6AEaz0lyL3qGRjCkxr
	 rd4x+7rlp9J3+ETA8EYhEiz3+/dV/zcxkWVv9NWPFZ956ZZZCe4Kn7r0kgw3bGR7tkUGV
	 PnlohMokqhtUlpFbGeBuyT1TRvfk3JqlJ4dSBP2qnqBfoNkYdwtc8q62Crpa9SofjSyg3
	 lp9cTcyYJVkZR1xsDOed+OCogZkThz03inOzjV3kJ8ohiy2HY1bh3qSdW6ytaVW7nmk1Z
	 1K0i3+LlaGX8Y/bcjExfAxnZHcg/KBdcGOeXjsCQm3KS+JRMUoTc6iK7HEsYyOArw3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=JYZYwo3H;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F1606A33F;
	Tue, 17 Nov 2026 09:29:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F2F1606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=JYZYwo3H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907763; bh=bO9QQRqz12+HYcEU6xIwAl7/+IlRcZmrK9er/mim46I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYZYwo3HxqfUVfvNzLMAYyiv1pF3LM15QsmJ9eQ+KPhB15MW54G8YAo+3n45vq1wW
	 M4N3SIxdSccvCgo9S5UWzY50UO5kP0/rUKwV8X/DRvgUEP44qWy8flVi8U3O5qSnfw
	 kFXZlGj0UaD978csqp/77Lpo0fL1P8EuXVLDqqma5k/50+y9r3yAbgpRJLXJ5fjnjG
	 CI9FvGn8Nq1+HbMG+p2CC1W5qieAMSS6KuBQyNAcBSaMcv16IzpbSds8yOTEzhlMYL
	 o5PRAkOT6M9xap3Q57g/EdV9OGc/l9N+7uzepT77CiUINXutywwh32O/EZz23H2c8f
	 Rhr/UjeuOZd7g==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 123F744C0B58;
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
Subject: [PATCH net-next v2 03/10] nfp: flower: refuse a tunnel key wider than the VNI
Date: Tue, 17 Nov 2026 10:29:06 +0100
Message-ID: <20261117092915.255194-4-acassen@corp.free.fr>
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

VXLAN and GENEVE rules shift the key and the mask of enc_key_id into a 24
bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
is about to accept partial masks. A mask that only covers bits above 23
would then match any VNI. Refuse a key that no VNI can match. GRE keeps
its 32 bit key.

Found by an AI code review agent while auditing the users of enc_key_id.
Confirmed by code inspection. The wrong match was not triggered. Build
tested only.

Fixes: 611aec101ab7 ("nfp: compile flower vxlan tunnel metadata match fields")
Fixes: bedeca15afd8 ("nfp: flower: compile Geneve match fields")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 161190200dbd..a560cdef8d23 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -150,6 +150,24 @@ static bool nfp_flower_check_higher_than_l3(struct flow_rule *rule)
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
 
+static int
+nfp_flower_check_tun_vni(struct flow_rule *rule,
+			 struct netlink_ext_ack *extack)
+{
+	struct flow_match_enc_keyid enc_keyid;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
+		return 0;
+
+	flow_rule_match_enc_keyid(rule, &enc_keyid);
+	if (be32_to_cpu(enc_keyid.key->keyid) < VXLAN_N_VID)
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "unsupported offload: tunnel key does not fit the 24 bit VNI");
+	return -EOPNOTSUPP;
+}
+
 static int
 nfp_flower_calc_opt_layer(struct flow_dissector_key_enc_opts *enc_opts,
 			  u32 *key_layer_two, int *key_size, bool ipv6,
@@ -411,6 +429,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: ingress netdev does not match the expected tunnel type");
 				return -EOPNOTSUPP;
 			}
+
+			err = nfp_flower_check_tun_vni(rule, extack);
+			if (err)
+				return err;
 		}
 	}
 
-- 
2.43.0

