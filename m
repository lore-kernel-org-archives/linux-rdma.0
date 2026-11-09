Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229849;
	b=DNEqArzjhz10KSzpELdwhaYCkrAk+1buAIdsSSDSfGEslFYh4qciJcbhBeEOxPxOVqSW
	 Ti/NB7RucVCXRBlUyaMMt9I33TXkuMktqjHtnCgb5YNaFSrDhZyl+PCMcTZ5PvSDhcVz+
	 JIvZ9oS73tS7hT/eDLbFRdmLDXqzazP6Zzfq4HgldTs24kBoB2kuYEX9Bnc4F1/nSOlvw
	 fddGSqPnY8n43yw5KPsMJxTS9cO6wrcvhYwPBcWCdqs7w41R7KFGWDYfJIp+1mImliCEh
	 zSqQKFfsMWjH0nenFMx0EvSV86KyvdAj+CunnYZIDWyTeEqSB1cAAm0fPx1MdryZxrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229849;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xq56ye0cilKoYtkCm9so//HbQcJMShZ8jayP8IVetxw=;
	b=Jbryph3G/V3EPSwt7obnKjkrZCm4JuEvykGuIos/A+sE2GNPs4g53hpa8AQ6/3K0gVBE
	 mRRGx29utityEXRN43/ibkfGNG8Xz/zBy7n5eZ3snkWirwOGAkB8CDo48j3d9gRmM6N70
	 TTE4BlGylkjXyFHhHpvSpf0BXHxxXSuoHvi8lMZ2VNxNshMJq/vywIOLdx6ZT6oizp2km
	 7NfI13pW+IFNQzXHn+eBURUqH1zriyUF/x7y589Zs9hs8f8jFcFzZhC0BTlXPUmaSvmOK
	 LM4rS6cssDsVayNJTqn6zZspt50vB/HYHp4/OXJ7ZcvwCruet6vFNuhNesvOdigMLDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=HfFM9Ud3;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3F5606D818;
	Mon,  9 Nov 2026 13:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F3F5606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=HfFM9Ud3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229847; bh=iGxFXY5s4DXgSHppry+TbbV91qX+iyEjhioIZWhodzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfFM9Ud3/KMWpIajIMs+Aoqd8N+Lm+MPnHTlZUBkInvGOfEvbcC1oLnP4REP8fdcH
	 O7ThAiRa0owvrlkJE5yRd88IkczPPw8qqDnfsAmmBl5J3ppfNysMdu6hrsq3Z9fIqj
	 QVyjW6gfGQp0lVPCf1ff+cTYySAbZ8tJGT/qRRA7iucZvoOFhxvGGcJr9P2iQQsB6N
	 IK5R6K2MVj/ANKeYr3KBWQBCQr9AX2/o5nOOuhWJn0rxsraV0v083eg89F58DURwc5
	 ycyqaoMKsN6iPI8Z08Uul7OsL/ifah4zUIpSica3u2ktBApiokEA9LNGvCy4I63lid
	 LRwoMmjsJPK2A==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id B9DC444C11B9;
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
Subject: [PATCH net-next 03/10] nfp: flower: refuse a tunnel key wider than the VNI
Date: Mon,  9 Nov 2026 14:10:29 +0100
Message-ID: <20261109131039.959438-4-acassen@corp.free.fr>
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

VXLAN and GENEVE rules shift the key and the mask of enc_key_id into a 24
bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
is about to accept partial masks. A mask that only covers bits above 23
would then match any VNI. Refuse a key that no VNI can match. GRE keeps
its 32 bit key.

Found by an AI code review agent while auditing the users of enc_key_id.
Build tested only.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../ethernet/netronome/nfp/flower/offload.c   | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 161190200dbd..e5f6f4f464ad 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -150,6 +150,23 @@ static bool nfp_flower_check_higher_than_l3(struct flow_rule *rule)
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
+	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: tunnel key does not fit the 24 bit VNI");
+	return -EOPNOTSUPP;
+}
+
 static int
 nfp_flower_calc_opt_layer(struct flow_dissector_key_enc_opts *enc_opts,
 			  u32 *key_layer_two, int *key_size, bool ipv6,
@@ -411,6 +428,10 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
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

