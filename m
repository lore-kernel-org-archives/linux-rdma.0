Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795285626;
	b=CiB3N24JsJCHAbYW1XkjIWMJk1u3xv9yQU0pOVIS+KfTX+hAZG8u3el8zaemlQDikfBH
	 e7y3Uy5/CCyg9chSvh98sGKU1CjKd1NNseVdOJZ4PspyhAtbNkItAtGjx1x/Djk9YbnWr
	 IaUCZPDdAabsZ58iFev/pVvpPxuRyDqENYh6YsMC2oTpYtdtCpcN16JkLBCS1fU0Uydsw
	 vEqvTjUhS/ldDWNw1nIzHWKsWwWqlxYrp5UleS5JBR5GWjnMtbLYYdcLQPQRDl7Wktw2D
	 zXwMt79RKoKg3SrQ3T8dtUPF5JPpc6Q3NiqyoiR11srT3KRJGLVmwdMobW8qH468LFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795285626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afBLPxnTKw6hTyvfGk2Nqd/UU7dMRfr50ALLZwezHG0=;
	b=GjUoXn8B+z3tp7hJvaafhMOUeU8VwXcOPXQqnfRqCOk1yXUxBuRL+9fO7J9VXDjecvmj
	 ynCV2BLRX3pATFd417IWNeuHj/KeoVehAouOkaTC1d6nhWPkA51YcD3yAo2jmML1zhTRf
	 68SDE3MA/tmN0An1tc0gecykhPwdGBF0ra4CHET2IkEWjerLhjNl9sahpKaxA1sqAFWD+
	 qbC6Iqx0/XL7nZ+AcesOAr2ya68W0iIM03t4hdt7zEQCrswj7NGHftwyVhW29h+VXvFYY
	 d4GpY2LaP6GkafnvRXNxcwlQz5E1MjPrLi/ebfQo1L7zUCqwyCciRJkfpXvRqQoLVWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ymhOVYJ7;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431BA606A68B
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 18:27:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 431BA606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ymhOVYJ7
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50933bdf4bso467200466b.1
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 10:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795285624; x=1795890424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=afBLPxnTKw6hTyvfGk2Nqd/UU7dMRfr50ALLZwezHG0=;
        b=ymhOVYJ7lbl7HJ3JLhRlbmf86bxreq5jLc0uVVUC12jaZDbK0htKePOa4O6GdDv/Gh
         EYrrCGGmFVQIBSFXhHGTDdvG7r+b9sxdzvXG7xj3BTL1hfLjRi3giRQ8AfzpXL5zpW2M
         NKzejMu6HatE7lRpCVRA4Lw3z88EGG+OCrQON5rC2uFX+tQpJVCsyOcsXju8IcZ0edfQ
         9DDGfYT7iuRiAB4yt1g1BDBAUvRjo/uDugg7ImsIBingD1QnbX9EdIc5KWVDOSJ+n3de
         C6iVgLSUsfXa3o+mPaBI1HSQ9Q3oa1auvbq9/O6yXogTjChPHo5l3Zx4J6CSbdphJgfG
         RYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795285624; x=1795890424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=afBLPxnTKw6hTyvfGk2Nqd/UU7dMRfr50ALLZwezHG0=;
        b=1GJXDqGi59TQRFfoWCvJTTmdGiBnqsi6rJpp/IeVcwjJ802z81AGGEAA5tmWPucVUa
         gYRymh1RDLI3EAXzkGzmTnM3AnaJg/jrt+JHTHe/C7UlgvngijS881qgcpOrBwwDt0Xk
         y6vHyA3hgt0zVBYBjU3jHDdFRimEBEalhtk9MUroffwID+e/YS/B3si2diHd8HETVuyr
         fbod9/jn0nGd5eqnYBX28LJZHl1n6yTipUcwqpttNbThqSjttaECDKXNwH/9IwP1KvqQ
         3akniUiOT83bO6OjQx4D04CBmATuF3gaf0KhmgqkEcNjtS4ve3Qa5veQhVyaQwHliqUF
         vUEQ==
X-Forwarded-Encrypted: i=1; AL+hErE1T1cBZIhejR+mG6A15xTvbQJc2gy2UzRIIpGMEnBB+dXsz0LvLSOwDe5EzwNhO5NkQV6hdUHsiEVY@vger.kernel.org
X-Gm-Message-State: APuU4Z/vbDWmRcrs2y/qkGopce6h+dZvTe/U+CFCY6QsE/rwbsHN0Avw
	ZpsHlO31aUWlU2yaojkVC+Tk7SOByRB77Z0uoMdofJ6ayDwPsG/izkxlf4N02WTqvw==
X-Gm-Gg: AZFdTZedvPW2+D5nuPBKvwbwFkeM8VTCp2rd1hb9N1ljcZ1/L60KgytMIHNr86TLqVt
	aB6ANG5g+FCU3im3ih6bEqVe5EY2DjJvlKRK4XGwpSXtKS7gkQl9TkfKMEWfdPtoItzOdK3YMBM
	Wb+eV6vKI4yVXmIcSGMVHJ0ztE0N7MYfntBxGiO5vQrTPi7OziJZ2FEi2l87Qvlah4wW78Yjy0a
	lOwUe4AkLc1C/Gw97AYXSPnP6yuECR4msyJvnu3vOmt48EZwNQeJR4uCijpCWeVdYamjlD59t4P
	fNDkdbl4x4x3XSzGFq2HCPnqA4tVf6H151XL6lq0c2IuGKUjErgdb4pIlxUKhEZmUOumtwf3rAS
	rvrJwXxdo72qkXanT8cjWJtoQ8tCCgh+wkmDeu2tXDnjX1V2rbmNbQrdwK5R8AjdKDQadLqjQS8
	1EO2CMWkVRkR9A8sbcBji0FlV5pMMFrqKOQ726kLZw8LCNuXPrW7NHFqfYnJ/p+rdf2MCa0iTsD
	Fln2UzdFsrZ8xTKAR++WuxZKZzkZFWOfeXQUg88xhZ3pU13gRVe0I+H+F4ZZZIP5cHS40Dg7yDc
	tO6y2wm1EZne4fytuq7OYRHLsObUO82bPT8m55xqtpBpEj3Y0NP5M/nr0jgVreVDd2pn+cr94fr
	ebEigXoyG6j/7t2Z2mzd5w0uix3V3XN22cAJKs4yeflepnV+7g1L3hK6qvycPK11gFTvhAELVVc
	gal+kmsZNQIYuXoIteMcC4V9uTHJEtNdVKHGLFcSs/4BuzTKRZm4fE2oU+rmhJtoJXk/YdIer3x
	mFzc70Dkl4FOfaB7F0+1dw3sLMTpXwJxveFoW3fhCdXTdAZno649EBO2pcjF/QPkSTNgAQRJAOv
	NxMvyT+b/oyRkOplFiSzO1fFGZyZdXlWyS6kVoNG9COCE4QCMUwG1BLQABIcOKKZX9JUA6A26fY
	b
X-Received: by 2002:a17:907:728d:b0:c29:4b57:503e with SMTP id a640c23a62f3a-c513a3a5327mr644785066b.1.1795285624426;
        Sat, 21 Nov 2026 10:27:04 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470dfa000000000000000a27.dip0.t-ipconnect.de. [2003:f2:470d:fa00::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513b001172sm224519166b.79.2026.11.21.10.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 10:27:03 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	willemb@google.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	steffen.klassert@secunet.com,
	herbert@gondor.apana.org.au,
	richardbgobert@gmail.com,
	ecree.xilinx@gmail.com,
	andy.moreton@amd.com,
	alex.austin@amd.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	izaiahsun@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	ipsec@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3 1/2] net: keep the TCP fixed-ID flags on the header they describe
Date: Sat, 21 Nov 2026 19:26:59 +0100
Message-ID: <7c74b2076dc7dee1d481d39a135e0946d5e04145.1795284858.git.julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795284858.git.julius@bairaktaris.de>
References: <cover.1795284858.git.julius@bairaktaris.de>
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
and with incrementing inner IDs. A tunnel that decapsulates such a packet
in iptunnel_pull_offloads() leaves the state of the removed outer header
on the new outer one, and the inner header of a GRE or UDP tunnel, which
segmentation reads at encap_level 0, gets the state of the outer header.

Let SKB_GSO_TCP_FIXEDID describe the innermost IPv4 header again, as it
did before that commit, and replace SKB_GSO_TCP_FIXEDID_INNER with
SKB_GSO_TCP_FIXEDID_OUTER for the outermost header of an encapsulated
packet. Where a header is added in front of a GSO packet, in
iptunnel_handle_offloads() and in the BPF LWT encapsulation, clear the
outer flag, so that the new header gets incrementing IDs as it does on a
packet that was not encapsulated before. Clear it as well where
iptunnel_pull_offloads() and bpf_skb_net_shrink() remove the outer
header. ESP transport and BEET mode with crypto offload set
skb->encapsulation but keep the IPv4 header and its ID, so xfrm_output()
copies the inner flag to the outer one for them. Convert mlx5 and sfc,
the two drivers that use the inner flag.

Two flags cannot describe a header between the outermost and the
innermost one of a packet with three IPv4 headers: software segmentation
uses SKB_GSO_TCP_FIXEDID for it, as it used SKB_GSO_TCP_FIXEDID_INNER
before.

Fixes: 3271f19bf7b9 ("net: gso: restore ids of outer ip headers correctly")
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v3:
- Clear SKB_GSO_TCP_FIXEDID_OUTER in iptunnel_handle_offloads() and in
  the BPF LWT encapsulation, where a header goes in front of an
  encapsulated packet (Sashiko).
- Copy the inner flag to the outer one in xfrm_output() for ESP transport
  and BEET mode with crypto offload (Sashiko).
- Name the paths that change the outer flag and the middle-header limit
  in skbuff.h, segmentation-offloads.rst and the message; list the outer
  flag in the bpf_skb_adjust_room() decap flags of the uAPI header
  (Sashiko).
- Wrap lines at 80 columns (NIPA).
v2: https://lore.kernel.org/netdev/f7d096c63c6a0b7a23a4dcea9a3de0915a48ac56.1794139176.git.julius@bairaktaris.de/

 .../networking/segmentation-offloads.rst         |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  |  8 ++------
 drivers/net/ethernet/sfc/ef100_tx.c              | 12 +++---------
 include/linux/netdevice.h                        |  2 +-
 include/linux/skbuff.h                           | 12 +++++++++++-
 include/net/ip_tunnels.h                         |  1 +
 include/uapi/linux/bpf.h                         | 16 +++++++++-------
 net/core/filter.c                                |  1 +
 net/core/lwt_bpf.c                               |  2 ++
 net/ipv4/af_inet.c                               |  9 ++++++---
 net/ipv4/ip_tunnel_core.c                        |  2 ++
 net/ipv4/tcp_offload.c                           |  7 +++++--
 net/xfrm/xfrm_output.c                           | 10 ++++++++++
 tools/include/uapi/linux/bpf.h                   | 16 +++++++++-------
 14 files changed, 67 insertions(+), 39 deletions(-)

diff --git a/Documentation/networking/segmentation-offloads.rst b/Documentation/networking/segmentation-offloads.rst
index 25a8b7eca847..45c1703d68b8 100644
--- a/Documentation/networking/segmentation-offloads.rst
+++ b/Documentation/networking/segmentation-offloads.rst
@@ -49,9 +49,11 @@ The default behavior is to increment the IP ID with every segment.  If the
 GSO type SKB_GSO_TCP_FIXEDID is specified then we will not increment the IP
 ID and all segments will use the same IP ID.
 
-For encapsulated packets, SKB_GSO_TCP_FIXEDID refers only to the outer header.
-SKB_GSO_TCP_FIXEDID_INNER can be used to specify the same for the inner header.
-Any combination of these two GSO types is allowed.
+For encapsulated packets, SKB_GSO_TCP_FIXEDID describes the innermost header
+and SKB_GSO_TCP_FIXEDID_OUTER the outermost header. Any combination of these
+two GSO types is allowed. A header added in front of a packet gets incrementing
+IDs. A header between the outermost and the innermost one has no flag of its
+own; software segmentation uses SKB_GSO_TCP_FIXEDID for it.
 
 If a device has NETIF_F_TSO_MANGLEID set then the IP ID can be ignored when
 performing TSO and we will either increment the IP ID for all frames, or leave
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1586cb2404c0..e47b1232130c 100644
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
index 03005757c060..162cfa54f2d0 100644
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
index 435be7880d7e..7ecf0f9c5f65 100644
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
index cf6a8e64b403..0613252e7302 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -717,9 +717,19 @@ enum {
 
 	/* These indirectly map onto the same netdev feature.
 	 * If NETIF_F_TSO_MANGLEID is set it may mangle both inner and outer IDs.
+	 * SKB_GSO_TCP_FIXEDID describes the innermost IPv4 header and
+	 * SKB_GSO_TCP_FIXEDID_OUTER the outermost one. Adding a header in
+	 * iptunnel_handle_offloads() or with BPF LWT clears the outer flag, and
+	 * so does removing one in iptunnel_pull_offloads() or in
+	 * bpf_skb_adjust_room() with a BPF_F_ADJ_ROOM_DECAP_L4_* or
+	 * BPF_F_ADJ_ROOM_DECAP_IPXIP* flag. xfrm_output() sets it from the
+	 * inner flag for ESP transport and BEET mode offload, which keep the
+	 * header.
+	 * Software segmentation uses SKB_GSO_TCP_FIXEDID for any header in
+	 * between.
 	 */
 	SKB_GSO_TCP_FIXEDID = 1 << 30,
-	SKB_GSO_TCP_FIXEDID_INNER = 1 << 31,
+	SKB_GSO_TCP_FIXEDID_OUTER = 1 << 31,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 5cccf4c0e691..a8e1cd7021fc 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -667,6 +667,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 			return err;
 		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
 					       NETIF_F_GSO_SHIFT);
+		skb_shinfo(skb)->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;
 	}
 
 	skb->encapsulation = 0;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8d7228834305..e5aae5320af9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3097,20 +3097,22 @@ union bpf_attr {
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_L4_GRE**:
  *		  Clear GRE tunnel GSO flags (SKB_GSO_GRE and SKB_GSO_GRE_CSUM)
- *		  when decapsulating a GRE tunnel.
+ *		  and SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a GRE tunnel.
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_L4_UDP**:
  *		  Clear UDP tunnel GSO flags (SKB_GSO_UDP_TUNNEL and
- *		  SKB_GSO_UDP_TUNNEL_CSUM) when decapsulating a UDP tunnel.
+ *		  SKB_GSO_UDP_TUNNEL_CSUM) and SKB_GSO_TCP_FIXEDID_OUTER when
+ *		  decapsulating a UDP tunnel.
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_IPXIP4**:
- *		  Clear IPIP/SIT tunnel GSO flag (SKB_GSO_IPXIP4) when decapsulating
- *		  a tunnel with an outer IPv4 header (IPv4-in-IPv4 or IPv6-in-IPv4).
+ *		  Clear IPIP/SIT tunnel GSO flag (SKB_GSO_IPXIP4) and
+ *		  SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a tunnel with an
+ *		  outer IPv4 header (IPv4-in-IPv4 or IPv6-in-IPv4).
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_IPXIP6**:
- *		  Clear IPv6 encapsulation tunnel GSO flag (SKB_GSO_IPXIP6) when
- *		  decapsulating a tunnel with an outer IPv6 header (IPv6-in-IPv6
- *		  or IPv4-in-IPv6).
+ *		  Clear IPv6 encapsulation tunnel GSO flag (SKB_GSO_IPXIP6) and
+ *		  SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a tunnel with an
+ *		  outer IPv6 header (IPv6-in-IPv6 or IPv4-in-IPv6).
  *
  *		When using the decapsulation flags above, the skb->encapsulation
  *		flag is automatically cleared if all tunnel-specific GSO flags
diff --git a/net/core/filter.c b/net/core/filter.c
index 946b07a17fce..ad73ff0f0581 100644
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
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 72c86ff2a847..e120272a12e3 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -585,6 +585,8 @@ static int handle_gso_type(struct sk_buff *skb, unsigned int gso_type,
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	gso_type |= SKB_GSO_DODGY;
+	/* The outer flag described the header below the new one. */
+	shinfo->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;
 	shinfo->gso_type |= gso_type;
 	skb_decrease_gso_size(shinfo, encap_len);
 	shinfo->gso_segs = 0;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8822bae439f8..45fa88e8f40f 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1404,10 +1404,13 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	segs = ERR_PTR(-EPROTONOSUPPORT);
 
-	fixedid = !!(skb_shinfo(skb)->gso_type & (SKB_GSO_TCP_FIXEDID << encap));
-
-	if (!skb->encapsulation || encap)
+	if (!skb->encapsulation || encap) {
 		udpfrag = !!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP);
+		fixedid = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID);
+	} else {
+		fixedid = !!(skb_shinfo(skb)->gso_type &
+			     SKB_GSO_TCP_FIXEDID_OUTER);
+	}
 
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment)) {
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 6c2855adff28..dbf6bbf25114 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -193,6 +193,8 @@ int iptunnel_handle_offloads(struct sk_buff *skb,
 		err = skb_header_unclone(skb, GFP_ATOMIC);
 		if (unlikely(err))
 			return err;
+		/* The outer flag described the header below the new one. */
+		skb_shinfo(skb)->gso_type &= ~SKB_GSO_TCP_FIXEDID_OUTER;
 		skb_shinfo(skb)->gso_type |= gso_type_mask;
 		return 0;
 	}
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index b84fcd07c723..da0d8ba70c0c 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -459,6 +459,8 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
 {
 	const u16 offset = NAPI_GRO_CB(skb)->network_offsets[skb->encapsulation];
 	const struct iphdr *iph = (struct iphdr *)(skb->data + offset);
+	const u8 fixedid = NAPI_GRO_CB(skb)->ip_fixedid;
+	const u8 encap = skb->encapsulation;
 	struct tcphdr *th = tcp_hdr(skb);
 
 	if (unlikely(NAPI_GRO_CB(skb)->is_flist)) {
@@ -473,9 +475,10 @@ INDIRECT_CALLABLE_SCOPE int tcp4_gro_complete(struct sk_buff *skb, int thoff)
 	th->check = ~tcp_v4_check(skb->len - thoff, iph->saddr,
 				  iph->daddr, 0);
 
-	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID << 1 != SKB_GSO_TCP_FIXEDID_INNER);
+	/* Bit 0 of ip_fixedid is the outermost header, bit 1 the inner one. */
 	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4 |
-			(NAPI_GRO_CB(skb)->ip_fixedid * SKB_GSO_TCP_FIXEDID);
+		(((fixedid >> encap) & 1) * SKB_GSO_TCP_FIXEDID) |
+		((fixedid & encap) * SKB_GSO_TCP_FIXEDID_OUTER);
 
 	tcp_gro_complete(skb);
 	return 0;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index f1f612cd7b43..927e1535c47d 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -805,6 +805,16 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		xfrm_state_hold(x);
 
 		xfrm_get_inner_ipproto(skb, x);
+		/*
+		 * Transport and BEET mode keep the IPv4 header and its ID, so
+		 * the header that SKB_GSO_TCP_FIXEDID describes is the outer
+		 * one as well.
+		 */
+		if (!skb->encapsulation &&
+		    (x->props.mode == XFRM_MODE_TRANSPORT ||
+		     x->props.mode == XFRM_MODE_BEET) &&
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID))
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID_OUTER;
 		skb->encapsulation = 1;
 
 		if (skb_is_gso(skb)) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8d7228834305..e5aae5320af9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3097,20 +3097,22 @@ union bpf_attr {
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_L4_GRE**:
  *		  Clear GRE tunnel GSO flags (SKB_GSO_GRE and SKB_GSO_GRE_CSUM)
- *		  when decapsulating a GRE tunnel.
+ *		  and SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a GRE tunnel.
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_L4_UDP**:
  *		  Clear UDP tunnel GSO flags (SKB_GSO_UDP_TUNNEL and
- *		  SKB_GSO_UDP_TUNNEL_CSUM) when decapsulating a UDP tunnel.
+ *		  SKB_GSO_UDP_TUNNEL_CSUM) and SKB_GSO_TCP_FIXEDID_OUTER when
+ *		  decapsulating a UDP tunnel.
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_IPXIP4**:
- *		  Clear IPIP/SIT tunnel GSO flag (SKB_GSO_IPXIP4) when decapsulating
- *		  a tunnel with an outer IPv4 header (IPv4-in-IPv4 or IPv6-in-IPv4).
+ *		  Clear IPIP/SIT tunnel GSO flag (SKB_GSO_IPXIP4) and
+ *		  SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a tunnel with an
+ *		  outer IPv4 header (IPv4-in-IPv4 or IPv6-in-IPv4).
  *
  *		* **BPF_F_ADJ_ROOM_DECAP_IPXIP6**:
- *		  Clear IPv6 encapsulation tunnel GSO flag (SKB_GSO_IPXIP6) when
- *		  decapsulating a tunnel with an outer IPv6 header (IPv6-in-IPv6
- *		  or IPv4-in-IPv6).
+ *		  Clear IPv6 encapsulation tunnel GSO flag (SKB_GSO_IPXIP6) and
+ *		  SKB_GSO_TCP_FIXEDID_OUTER when decapsulating a tunnel with an
+ *		  outer IPv6 header (IPv6-in-IPv6 or IPv4-in-IPv6).
  *
  *		When using the decapsulation flags above, the skb->encapsulation
  *		flag is automatically cleared if all tunnel-specific GSO flags
-- 
2.53.0

