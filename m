Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794680871;
	b=t1+Bul7Fl2w5wHo5SdE/omV4sCTeH3DlbpW4dpFn9IktVka5MSkfOcIKKdeirBTM2wcs
	 3crlpoeGTd+BPtPxVEqa7z4czbVJuWbt0mKvL/9DTk4wAUXrmR/N7PzrWiRfwe9a1ik6d
	 eHACaIWZ8VQPn1Bh5zgfrOb4w0FHgZu1kYvhBRVxh0sHLVNw6Mumcfq3qcGLyz0z0gTjv
	 5jZ8pFeQwdTPjBgufSON+5DEpqc7Z8JMZURoZiGAc2POF2rRx3MkVNpMsQB9qL6hs1q1t
	 k5emKySB1jvV/ATmAYNV+O55GeQJCZdaMQwQpHf085l5VTaoGTRy3+68jH9vKZPWwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794680871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=COpZlkF3gjNsbleKennDYj+Fmu6LFoVwH+euJBJfJOY=;
	b=Uazr2BqTl9unQXZc3yV1cUuohrz7KWM9QFU62hUiVnEhiW+xkrACy1jAZxvnIgmX38id
	 vQ+TG/hsK4XgPMFRUja1l00K8MQWhi9PCkh9TJmKUzbZh2Vgvn9xW/lr54pBEYttxOPho
	 XeMpw2nA6rFum0VNJdQY6wPG/YCMhLStEJNd2nT06vUygA29HmSxUAAoUMXmjoOJLhF+j
	 Vc21JwOo6WvhdmK53w2x3dtAyJKudZ91g0dFXRjUUNu8Be+kINuq0u4KLVxWOSSLplxj+
	 EgztOq6FW84vKMeEXCGSybunskux8L9b65kABTBODg5VbOh+c75oKcBkGk+TYY9/3dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=u1ahjrHa;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D377606A897
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 18:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D377606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=u1ahjrHa
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4395d31228so383135066b.1
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794680870; x=1795285670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=COpZlkF3gjNsbleKennDYj+Fmu6LFoVwH+euJBJfJOY=;
        b=u1ahjrHa4S10vwFHPp1YcfCzotsvWJ6wsT46BsGRopHXst2ygrEwQhtTPt0JmMxOwi
         Jp6fzNbsLPDoaSvVc7BTnyuqGCTz30vGlb9gh5w90VrPa4tpIuLkFOCx+mNb7DkDxFaL
         KIaO2j7tH5pb1t3EBb+yHIwuBKfeOxjFPcVVlVR048Xvq0dov7DPDrcWspBWn7LKz3GT
         eCfieLZlG3IQ2tpk/VC9nMEqa/6ijt2+T3n5YZJttlmr6b2bF6YJ1epTfewEBsHVCcWc
         hWRzRdGyfnusjN6nmxxMoOCPM8G96Tj5MvKU7C07RpIksijy4LvH59BR6wHXj+DcLz0h
         NzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794680870; x=1795285670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=COpZlkF3gjNsbleKennDYj+Fmu6LFoVwH+euJBJfJOY=;
        b=YXmrLdB3SqEs68ACDnhUnbqkp9LYHdFrp6wHNPjiM/6OjetHX+J/7O6L5xd9bXU89R
         bU6uV0Yen+xkdP5rRd4/PZIxAek54a6kjIUTefEfLHS84WhCqJecHxTF1TQs2SY0q6UD
         9zAd1QhMjC99rhwN1pXaa2XPkJ8e3275IMEBHxtJepmKfwOdQdAhot2t3lekgRQtT8G2
         3Q1+c2k3hQBJZvxqeppZ/6daZKMdXAPLTJs21+OV6Pf3qpe5gvgFPdtN2UXRX0BKHBhE
         hKaloMP4BB8UmGr7c7bxHazn/Y5VaiV8rJiYq0SPZvxG62SfUPWsKYvsFrDjBVtnQJgi
         NZgg==
X-Forwarded-Encrypted: i=1; AL+hErHfD81EUa6D69LsHQujCH7ZYXsfmdF0sPeRX0fOq7yPAiSaWIrmam8TyELK41WPJYG45C9yknfqSJVq@vger.kernel.org
X-Gm-Message-State: APuU4Z+1eLXE1LU8hw/gomORNgkoPa/lBLl6wGCkDYpTdrPnLVrQAZmG
	+jZtsYu3Skt8rh15vLF2zt0ef1+PyypjAPXvVSDwwmZa3o/q6xeoHpvA76HqQrfFAQ==
X-Gm-Gg: AYBFou22zz1J75rOxS8/cmwh2khAMacIFkpcwiO+JlfW65be99alCNVP8jNt75aOcO/
	tUQ+yRKcJxBie9JWjEqp+fvRK5Yv/W6MLly/ojaWP/i3n/IgtFBoJQbS0g5dEkteEGAXaCzwTkp
	OtbGK4EJ2x0FotrjTsjPsJYfEP4jBvGs6HUET1cn0ebwcVcnT0gGbomplTWTg2favXB6sLMu7+1
	OJ0GBehdx+v/qUPP9E0TjoZDtjBHqbji9TPZmFc6g++zol790wyIisBQiaarHnm0X09b4kBH7oy
	MNbYqolEKqaWyuVXomjzsz4oXgZ6StepzjmRfTnaEqjLnVY+Uyrq8vcBo3Frq2pR52bpjLGeJP6
	rnHZj36WF/xeA+rwo/hc+tV9OQ5gnMXVzsj9yPsEdgzMurDwLEOiliWmlELBFtfUqLFk7q19TWz
	JLQf8q/hFwawtodqoUwjOfZW1nrit6TDRwjmlPOsjQFmg0kansk16pOMHMImLlyXHXJHYRZmwSo
	JnoR0AthUBUSPmHPpc5waldw7BrhC7BpMcRPl1est+umDx5O5frKc8f3SovSDdOHBxuRwi8QM/V
	3MBN9qk91dXp9BbxW5PAOAQjbiBaQEyYI0ehxM0hhixnaYEFfpU1T9PIC4Nxr0cgamM7VnwaqKQ
	xdTl6yG2AVFMGtDySU5pVRbWaZN5r2/Bki1HdtF7t1+nX6UoC35egNMxn1dQ9/3ooVyNzCP8KFk
	wY+9WRNnr4Ll/UT7YDY5zHjroRIQl8QYDa3aQdFvGzgcV02Oge/P/A/uhqJQnQTUrJx2lLb5i39
	uQsi2sBsOh9bdZvratluKuvmATEF1eYyBG45QjCWHm51YudbbrOsKQ4x4F49rwwxdfDEQSbDNNq
	/Bk=
X-Received: by 2002:a17:907:ea93:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c50963bdb9bmr585583166b.44.1794680869556;
        Sat, 14 Nov 2026 10:27:49 -0800 (PST)
Received: from Desktop.fritz.box ([185.181.130.189])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b56df7sm245554366b.47.2026.11.14.10.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 10:27:49 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	richardbgobert@gmail.com,
	willemb@google.com,
	ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	martin.lau@linux.dev,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/2] net: keep the TCP fixed-ID flags on the header they describe
Date: Sat, 14 Nov 2026 19:27:44 +0100
Message-ID: <f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
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

Commit 3271f19bf7b9 ("net: gso: restore ids of outer ip headers
correctly") made SKB_GSO_TCP_FIXEDID describe the outermost IPv4 header
and added SKB_GSO_TCP_FIXEDID_INNER for the inner header of an
encapsulated packet. Every path that adds or removes a header then has to
move the flags, and none does. A TCP stream that GRO merged with fixed
IDs and that is forwarded into an IPIP tunnel, or into an ESP tunnel mode
SA with crypto offload, is segmented with one outer ID for all segments
and with incrementing inner IDs. Decapsulation leaves the state of the
removed outer header on the new outer one, and the inner header of a GRE
or UDP tunnel, which segmentation reads at encap_level 0, gets the state
of the outer header.

Let SKB_GSO_TCP_FIXEDID describe the innermost IPv4 header again, as it
did before that commit, and replace SKB_GSO_TCP_FIXEDID_INNER with
SKB_GSO_TCP_FIXEDID_OUTER for the outer header of an encapsulated
packet. A new outer header then has no flag and gets incrementing IDs,
so encapsulation needs no change, and decapsulation clears the outer
flag in iptunnel_pull_offloads() and bpf_skb_net_shrink(). Convert mlx5
and sfc, the two drivers that use the inner flag.

Fixes: 3271f19bf7b9 ("net: gso: restore ids of outer ip headers correctly")
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 Documentation/networking/segmentation-offloads.rst |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  8 ++------
 drivers/net/ethernet/sfc/ef100_tx.c                | 12 +++---------
 include/linux/netdevice.h                          |  2 +-
 include/linux/skbuff.h                             |  4 +++-
 include/net/ip_tunnels.h                           |  1 +
 net/core/filter.c                                  |  1 +
 net/ipv4/af_inet.c                                 |  8 +++++---
 net/ipv4/tcp_offload.c                             |  6 ++++--
 9 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/segmentation-offloads.rst b/Documentation/networking/segmentation-offloads.rst
index 25a8b7eca847a..0f20bb643145d 100644
--- a/Documentation/networking/segmentation-offloads.rst
+++ b/Documentation/networking/segmentation-offloads.rst
@@ -49,8 +49,8 @@ The default behavior is to increment the IP ID with every segment.  If the
 GSO type SKB_GSO_TCP_FIXEDID is specified then we will not increment the IP
 ID and all segments will use the same IP ID.
 
-For encapsulated packets, SKB_GSO_TCP_FIXEDID refers only to the outer header.
-SKB_GSO_TCP_FIXEDID_INNER can be used to specify the same for the inner header.
+For encapsulated packets, SKB_GSO_TCP_FIXEDID refers only to the inner header.
+SKB_GSO_TCP_FIXEDID_OUTER can be used to specify the same for the outer header.
 Any combination of these two GSO types is allowed.
 
 If a device has NETIF_F_TSO_MANGLEID set then the IP ID can be ignored when
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c9..b804a759710e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1175,12 +1175,8 @@ static void mlx5e_shampo_update_ipv4_tcp_hdr(struct mlx5e_rq *rq, struct iphdr *
 	tcp->check = ~tcp_v4_check(skb->len - tcp_off, ipv4->saddr,
 				   ipv4->daddr, 0);
 	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
-	if (ntohs(ipv4->id) == rq->hw_gro_data->second_ip_id) {
-		bool encap = rq->hw_gro_data->fk.control.flags & FLOW_DIS_ENCAPSULATION;
-
-		skb_shinfo(skb)->gso_type |= encap ? SKB_GSO_TCP_FIXEDID_INNER :
-						     SKB_GSO_TCP_FIXEDID;
-	}
+	if (ntohs(ipv4->id) == rq->hw_gro_data->second_ip_id)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
 
 	skb->csum_start = (unsigned char *)tcp - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 03005757c060d..162cfa54f2d04 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -201,16 +201,10 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 	bool outer_csum;
 	u32 paylen;
 
-	if (encap) {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID_INNER)
-			mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
-			mangleid_outer = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	} else {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
-			mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
+		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
+	if (!encap || (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID_OUTER))
 		mangleid_outer = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	}
 
 	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		vlan_enable = skb_vlan_tag_present(skb);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 435be7880d7e5..7ecf0f9c5f655 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5536,7 +5536,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
 	netdev_features_t feature;
 
-	if (gso_type & (SKB_GSO_TCP_FIXEDID | SKB_GSO_TCP_FIXEDID_INNER))
+	if (gso_type & (SKB_GSO_TCP_FIXEDID | SKB_GSO_TCP_FIXEDID_OUTER))
 		gso_type |= __SKB_GSO_TCP_FIXEDID;
 
 	feature = ((netdev_features_t)gso_type << NETIF_F_GSO_SHIFT) & NETIF_F_GSO_MASK;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6787fcf6ac3e4..6eb913ebc7d53 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -716,9 +716,11 @@ enum {
 
 	/* These indirectly map onto the same netdev feature.
 	 * If NETIF_F_TSO_MANGLEID is set it may mangle both inner and outer IDs.
+	 * SKB_GSO_TCP_FIXEDID stays with the innermost IPv4 header, so there is
+	 * nothing to do on encapsulation. Decapsulation clears the outer flag.
 	 */
 	SKB_GSO_TCP_FIXEDID = 1 << 30,
-	SKB_GSO_TCP_FIXEDID_INNER = 1 << 31,
+	SKB_GSO_TCP_FIXEDID_OUTER = 1 << 31,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 5cccf4c0e6913..a8e1cd7021fcf 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -667,6 +667,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 			return err;
 		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
 					       NETIF_F_GSO_SHIFT);
+		skb_shinfo(skb)->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;
 	}
 
 	skb->encapsulation = 0;
diff --git a/net/core/filter.c b/net/core/filter.c
index 52e6ea6d50455..340b2e64d818e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3867,6 +3867,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 		/* Clear encapsulation flag only when no tunnel GSO flags remain */
 		if (flags & (BPF_F_ADJ_ROOM_DECAP_L4_MASK |
 			     BPF_F_ADJ_ROOM_DECAP_IPXIP_MASK)) {
+			shinfo->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;
 			if (!(shinfo->gso_type & (SKB_GSO_UDP_TUNNEL |
 						  SKB_GSO_UDP_TUNNEL_CSUM |
 						  SKB_GSO_GRE |
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7677b0343abd4..d5769a5fdc314 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1402,10 +1402,12 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	segs = ERR_PTR(-EPROTONOSUPPORT);
 
-	fixedid = !!(skb_shinfo(skb)->gso_type & (SKB_GSO_TCP_FIXEDID << encap));
-
-	if (!skb->encapsulation || encap)
+	if (!skb->encapsulation || encap) {
 		udpfrag = !!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP);
+		fixedid = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID);
+	} else {
+		fixedid = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID_OUTER);
+	}
 
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment)) {
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index b84fcd07c7230..79190044f6fe9 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -459,6 +459,7 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
 {
 	const u16 offset = NAPI_GRO_CB(skb)->network_offsets[skb->encapsulation];
 	const struct iphdr *iph = (struct iphdr *)(skb->data + offset);
+	const u8 fixedid = NAPI_GRO_CB(skb)->ip_fixedid;
 	struct tcphdr *th = tcp_hdr(skb);
 
 	if (unlikely(NAPI_GRO_CB(skb)->is_flist)) {
@@ -473,9 +474,10 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
 	th->check = ~tcp_v4_check(skb->len - thoff, iph->saddr,
 				  iph->daddr, 0);
 
-	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID << 1 != SKB_GSO_TCP_FIXEDID_INNER);
+	/* Bit 0 of ip_fixedid is the outermost header, bit 1 is the inner one. */
 	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4 |
-			(NAPI_GRO_CB(skb)->ip_fixedid * SKB_GSO_TCP_FIXEDID);
+		(((fixedid >> skb->encapsulation) & 1) * SKB_GSO_TCP_FIXEDID) |
+		((fixedid & skb->encapsulation) * SKB_GSO_TCP_FIXEDID_OUTER);
 
 	tcp_gro_complete(skb);
 	return 0;
-- 
2.53.0

