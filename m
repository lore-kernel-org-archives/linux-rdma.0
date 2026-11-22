Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383131;
	b=tltlW8Zx/jCKc0KTXkkZMuXczZfKVOicMcbC+R2ZnwgeiIuTsDju9T7aKaupnadKZrQX
	 hDnc2uz/6gw+s7ldxOeXyC2m/MLms8hryuf4vK8H4ifda4XnIvM2ckxU18M8bRZAkjlSk
	 NOkLx2Zl6Si9FB1esDM94u6raW+6eGRjMTIn6eYc85Be16U3bMw3WVCS+zitH3+9cdRk7
	 j9M0KWTGoo3ejtNlPffz8jDqlqAqHsGI9cWpspk+Qb0nCoNlT5HzOvUrzN835ttkWuEH4
	 8xgVLB81GVOwPSj90C63j6fWyaE9V0Q/PzSzOxLh6F1TdOfdQlM1N6pYnW268p42yjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383131;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wO1WQOXacXkBpK57nLOV+oxy3y/IXe/mURdsCtq3BIo=;
	b=C78imSUxFgmI+dmCItcTENp+5w0ZaeoKTq1Pu1eG6UGlUKRpAKK2OeLBP1/7bqD8RocN
	 gzGyeNt/zDribTAezYN8vhw898jOQLK0qiHEG3vWWG3VqpMQ7YADONUZr+5qAAk75Iyhx
	 xMHgEcL2DxlYFQfPg8vJvIIMdAHA42PEmM7bpM+4XDApu+KFbhfZdQNX2EaUY7QTFKvwF
	 RgW8aupYkGR1g/P9VIp2Q40tRRa2pdK9hJ0ldIGVOlsFTZEgF0CQgv/Gs36IsK4ceHb10
	 Oua4coBpjyTt8RcVnkYFIgTm8N2VuLeczMKRi3B9jGeaCaBF675cXek52MSx9UhPViA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=B4kvXhrQ;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75414606A32D;
	Sun, 22 Nov 2026 21:32:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75414606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=B4kvXhrQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383128; bh=bO9QQRqz12+HYcEU6xIwAl7/+IlRcZmrK9er/mim46I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4kvXhrQA8MgkIe3HhtMIhDJZ428tPHZ8S7xBfY7PGml9e8F6AXyvzKlQIGmNjK5F
	 BPXiVXzHBIButPQbZ7N0DLYLPF2pVxIEc9a8YAtncS6LfOPEb02QTEeH0X++oP5cYA
	 poCmwpJlPgQjU3sjGawRR3QwJiN3GCbWoN0mYv3OzaBgnhmjUOS/x/rPwTvoLN2nHt
	 bEGOW95pB3b/dhzMd7AbDyznMBiXVmhvFVK970UAJzCike4Ui25lPydZ4p8sM59TTH
	 TIptMPMy8RjVUsdbBvKorreM6749YS+WRSBer7NB7zT0TC+M2jrlxSIgoV1eH3W9UZ
	 TdvQPM/0/zCXA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 7037944C0B3E;
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
Subject: [PATCH net-next v3 03/11] nfp: flower: refuse a tunnel key wider than the VNI
Date: Sun, 22 Nov 2026 22:31:51 +0100
Message-ID: <20261122213200.3207385-4-acassen@corp.free.fr>
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

