Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229850;
	b=vGodC8FzNu3oGB5n3XtQm2LKvEC0vUcifLxhERVV1/kLJgf4ZEc3HQEBvD9kpv1yAq6Y
	 43QX0pnk9lYvlGRLhiozcVfavLwOR4wG+uJWaBC7KJJGucG/Ao/gjtmRZBElnwKjT1y12
	 J0Sk5Ux5VSQ/vhAD/CxwnP1O8TS8SJq9B36wSlHkt+f1R5Rh8QVDczLuRLWVlwhXVXiSe
	 TFvaKTzDTzBVewq/D4IMIZembmlRl9RXmVUw/fhi5ea3EPVRt7zE7IZmA9WpTaexEUScr
	 L2JH8y+Q/T9liVI7s11/tVk03ECIo76wg9ZNniE5ZRo/pTu1ygInlkL4HlrUpruKihQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229850;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iqFiRT83QmZISlmWEdJqLfZrAjHt8KFvUpnVMhb9+C0=;
	b=P9OEH1tlMVQZeIBIos3NafZnXNcknTBuxm7/gB78CrRcTJO9D+aV8jlbCqydxYiPpIVl
	 M7UEaPkJWpKnAv94QNWCRuk5Q0fND/9l5g3RAzybNaO2CGl8qZKXg2X8MpvX7TUczDBmb
	 BcsXswPF1Ec/jutXn1GlPhKRMFa8IdkkKT7ntCNAk8ga/lskP5DKEWM4jzGwOleYh/Ie4
	 FXp5kxEoKqr61q69SfSZ0KwcQ3/C6qR6xevriC7V77dzGoUQO1+7BRvhWFlkY7pR+fRJy
	 LlwGDRpRPhCkb5I1wmEn/EW5LFPN44Zqxx0oIClgRSDkq+wtkEfkjJDrFcydzWu2joA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=CRHJZNOU;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48B5606D834;
	Mon,  9 Nov 2026 13:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E48B5606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=CRHJZNOU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229848; bh=Db4ooscFNMd6Sx00ziJUqW+Qe9cjVpd/j8N9fbAoU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRHJZNOUx9+/5iq4KxxROQ54SW1CSJYfkyWdhl2vGKHU0tQgP7YqWBosh7IMvT2DR
	 79nv+3fQlUXrrF/odf9+9NZ+Pp5XidBdzyMkXQv+CRMTCif/5YC4Ioe8VrOFWGPHO/
	 C2122KFfE49rpQ1dwDab2PmadWNJ9HqTFO7LSXq8yJMX+0Wjm57DGzTH9MQspTKhlS
	 l64RdAzbUbGKvwfeeQSMBqyQ+YBFgmjT8gVSKDYxH5f5/ZeKBO98LIebFO1OUOOrxO
	 POqYYB/Gk/4LjIn8+GIEJ95wgAxvNwNuK71Sue5OieRYHAXX4etwD1cvfsPzORk8S3
	 T0yr4SqhbgNyg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 3680244C11CC;
	Mon,  9 Nov 2026 14:10:48 +0100 (CET)
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
Subject: [PATCH net-next 06/10] net/sched: cls_flower: add enc_key_id mask
Date: Mon,  9 Nov 2026 14:10:32 +0100
Message-ID: <20261109131039.959438-7-acassen@corp.free.fr>
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

Flower only matches enc_key_id exactly. A block of tunnel keys takes one
filter per key. Add an optional mask. Without one the match stays exact.

  tc filter add dev <dev> ingress protocol ip flower \
      enc_key_id 0x100/0xf00 action ...

cxgb4, mlx5 and nfp program the mask. sfc does when its firmware supports
it. hns3 and ice reject a partial one. The previous patches make bnxt and
mlx5 tunnel mapping reject it too. i40e and iavf never program the value
of enc_key_id, with or without this patch.

Hardware holding a 24 bit VNI truncates the mask too. This is correct when
the key fits the VNI. The previous patches enforce this on cxgb4, nfp and
mlx5.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 Documentation/netlink/specs/tc.yaml | 4 ++++
 include/uapi/linux/pkt_cls.h        | 2 ++
 net/sched/cls_flower.c              | 5 +++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index b6ccc645b0e3..a20fa42e6715 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2908,6 +2908,10 @@ attribute-sets:
         byte-order: big-endian
         enum: flower-key-ctrl-flags
         enum-as-flags: true
+      -
+        name: key-enc-key-id-mask
+        type: u32
+        byte-order: big-endian
   -
     name: flower-key-enc-opts-attrs
     name-prefix: tca-flower-key-enc-opts-
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 28d94b11d1aa..fcaf06c6892d 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -560,6 +560,8 @@ enum {
 	TCA_FLOWER_KEY_ENC_FLAGS,	/* be32 */
 	TCA_FLOWER_KEY_ENC_FLAGS_MASK,	/* be32 */
 
+	TCA_FLOWER_KEY_ENC_KEY_ID_MASK,	/* be32 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 23eba4a00a94..dd248a335402 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -661,6 +661,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_VLAN_PRIO]	= { .type = NLA_U8 },
 	[TCA_FLOWER_KEY_VLAN_ETH_TYPE]	= { .type = NLA_U16 },
 	[TCA_FLOWER_KEY_ENC_KEY_ID]	= { .type = NLA_U32 },
+	[TCA_FLOWER_KEY_ENC_KEY_ID_MASK] = { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_ENC_IPV4_SRC]	= { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_ENC_IPV4_SRC_MASK] = { .type = NLA_U32 },
 	[TCA_FLOWER_KEY_ENC_IPV4_DST]	= { .type = NLA_U32 },
@@ -2110,7 +2111,7 @@ static int fl_set_key(struct net *net, struct nlattr *tca_opts,
 	}
 
 	fl_set_key_val(tb, &key->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID,
-		       &mask->enc_key_id.keyid, TCA_FLOWER_UNSPEC,
+		       &mask->enc_key_id.keyid, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
 		       sizeof(key->enc_key_id.keyid));
 
 	fl_set_key_val(tb, &key->enc_tp.src, TCA_FLOWER_KEY_ENC_UDP_SRC_PORT,
@@ -3680,7 +3681,7 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (fl_dump_key_val(skb, &key->enc_key_id, TCA_FLOWER_KEY_ENC_KEY_ID,
-			    &mask->enc_key_id, TCA_FLOWER_UNSPEC,
+			    &mask->enc_key_id, TCA_FLOWER_KEY_ENC_KEY_ID_MASK,
 			    sizeof(key->enc_key_id)) ||
 	    fl_dump_key_val(skb, &key->enc_tp.src,
 			    TCA_FLOWER_KEY_ENC_UDP_SRC_PORT,
-- 
2.43.0

