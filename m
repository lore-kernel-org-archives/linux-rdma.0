Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383133;
	b=FsCteJj5CD1u+Blqz5pN14vuqVQ7JxRCyyfc1W6d8hq3NYxCs6UqSGbpQ/ODQzRr9E2+
	 QRuJ1WmvQ/R++SR4AE4bKYVao4sseISX+5iXinrmrzUQ+nQOjA6LxB/YgQZhOPpEjGSbZ
	 7R3L5V3CxDeig7lbRVQcWuzz9O9BJYph8A+D0q2tl9dzEjCzn8LedHPH929Z7x9oGxeY2
	 gNQJzHqoNncq3SPdYa4n+ZGAvWz9daofGIa/QF/7CWELZTts8QLMihZv/fc2qt0Fiuuhz
	 JSI0jjxWJoEBNV/l/bEMQ3KyJynXRoQaEFSQjgSDE/XM+FXoz/jghT36rgDrK7VELdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383133;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lVrc4oHsxDCDJa3Hp3qUem7EegpD7+yTpsfWRSyZgHs=;
	b=iCZu4743r/9WXrZvFkAhfx4Z87e9e3gsG38bHN6+lISQ0jp9dYlmis8SSN0QJdNnjIG6
	 N/gkmIrzi8VbA91G6Rz6zQTsiyq3dibzgygfntc1kU92KH6x0WcPXItAG8bAhNFILHfWF
	 Aqkd62WNS0J2cfSzSwStnuautl7V7v88Mwg7XgJq8SDTKvMq/uS44VYy2y2cLUja15eU5
	 9te8E6aR86UwVQe+D4LCXQjhcYDt7D55pCo6dx6pZLYgc6YKuSXoiGoJ/DBOTAb134smm
	 CZabr0lkLpmPHgG5Qepu/wEKZKkT4iyY96mHVBagkUdcM+AlVp833pIwW59kxIP/kxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=QCSOslgu;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C7B606A6B2;
	Sun, 22 Nov 2026 21:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C7B606A6B2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=QCSOslgu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383130; bh=K4Llhg1hmaw8g5dzoUBJThs+VMah2kSFZeuFKLz69pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCSOslguzicAu4cFP1kFFIskrj4pttEBgU5q+DVVgDRgMEt1CQ7KUW6/Orp0QOmb7
	 ntgEGuLK2E9fdrawUPggb2beoR7JPR3DDIvHeUkSKvUdiXSBjJegVRfx8XOEfQPRYE
	 DOvs7o+Tjt8mARSRJu0OOJUogM6tPrOQIagEjOV82J13Y6tvnNj3mt+2GuYFK8qGJR
	 poyOukZUY0hkn7Jc60eVbupebG7bhl1XHcUc3H4a0Dxn2y6CpZMNi1/3L04H+qdSsX
	 yg9heu7qYq+KlIdmtIE0HM9GxxbFx6ykWGpDvJFXnk7wtpD/+ib9H6o/gGwXKxyW+w
	 nR5gRCKs7ONwg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id E758844C0B4E;
	Sun, 22 Nov 2026 22:32:09 +0100 (CET)
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
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>
Subject: [PATCH net-next v3 06/11] net/sched: cls_flower: add enc_key_id mask
Date: Sun, 22 Nov 2026 22:31:54 +0100
Message-ID: <20261122213200.3207385-7-acassen@corp.free.fr>
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
mlx5. On cxgb4 a mask without a VNI bit would also drop the tunnel match,
and the cxgb4 patch refuses it.

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

