Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525132;
	b=ve7kjrRrN9r0oaBcs1S+TZwQJvOKjtVt5kkhnt0aE+GeY1MpUO0XmbeJoiqW56yHy5PF
	 dv4TS/o2wRQbWH+n8EgSLmz8xxaBiDZLSllji6woPt4r8PSQGSxvWmzn3GMlrOL6eByjg
	 80h7QZcTpEeCgIX3Gccca3TGUdfKAK1NQKOYoWcuT6lr1SdJ2zXuxQSf646w7sxSCgyC2
	 E3/VC6JeiKp5E8rtrImverLuDVrPltapyy247THglRemxohuc9MoosDAQEaYbTVpY5l6P
	 rcJ6w5w8XLZpLWSgioY/DxCDMUI4g66varqKQV1KJiW1xoLR7k3nzRj5++FTTxJteZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=VfreT4aYeforevoExl2EptNbW6w6oHvb/8bZyqHKctU=;
	b=qjuUemuIKKYhcQ7Cf+AH5vv1le/YHlkGeh1yAUxCUL37u49dExNdFMWrOQKAR0SWToON
	 DDvtQqpfi68IwXS2D/GJeHxKmIV5iK/SAs4ECRi+a/53v9ugP/G/zZq5lDLYhPJ0agaUY
	 BqJU49jloc5WApRQUomOq6U+uWvjHWb6A0MTuEUbpLv4YgFjXC/vLxnmZrLWmvGXfjRGV
	 JoXWXH4qdzNCVcjB9v2t/Fz7kwxWtG4R9Z5H20h5dFq0A2rqsd0mHY4SwxwAPJZ4SnLQd
	 +Edq+I+8i8u0otzWFnhVPR//NQ4wk/heqAIfJXdTVqqdggA5+3ChbqEMIfRhMe9/WkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnA5mV35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E31606A32E;
	Tue, 24 Nov 2026 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnA5mV35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC801F000C0;
	Tue, 24 Nov 2026 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525131;
	bh=VfreT4aYeforevoExl2EptNbW6w6oHvb/8bZyqHKctU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnA5mV35OGOnDwlNaeOJhwBO8tmmTDyJ0yqXoEbPNwLHE9NHsVQdMnAETB0Wcjy+X
	 CO1TWZcSfnYlj0/gZsThV1HNEoBb8AVJi+yQbtWO8rtxlta7jnBCJPOTgVTpz8OHxs
	 NNob8DE02RXzZ5FQf4TsBMW9lzjaNuMA/DUiKpMDwH01cxkQRlq8/YCw8GmeoVmZlU
	 jXvE0F11/Wl7bljrgsCZhfmvTxVHfM5elusnhXSWcSUHN7uZ45XFcQjyPXtYqxODlZ
	 gsaowWlUrJdh4j8uuT/z9hc/SnlZKvY99iwTjGDewRqkoyAQ0EuSVt8S8JtiyKw7m0
	 62XWA0g9n21uw==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Stuart Clark <stuclar@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-team@meta.com,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/15] eth: fbnic: Support XDP redirect
Date: Tue, 24 Nov 2026 13:56:44 +0100
Message-ID: <20261124125654.183091-9-bjorn@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124112707.118678-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, fbnic treats XDP_REDIRECT as an invalid action and drops
the packet, so AF_XDP, devmap and cpumap do not work on it.

Support the verdict.

A failed redirect drops the packet, as XDP_DROP does. Each RX queue
flushes its redirects once per poll, after refilling its rings, so
that a target that gives buffers back, such as an XDP-only memory
provider, sees the buffers that the queue freed. Any native XDP
program on fbnic can then redirect to devmap, cpumap and AF_XDP
sockets in copy mode.

The NAPI vector, not a variable of the RX loop, notes that a flush is
due, as one more live variable in that loop costs native XDP_DROP six
instructions per packet.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c |  3 ++-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c   | 12 ++++++++++++
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h   |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 52244219d166..9f0d8c070d1c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -822,7 +822,8 @@ struct net_device *fbnic_netdev_alloc(struct fbnic_dev *fbd)
 	netdev->hw_enc_features |= netdev->features;
 	netdev->features |= NETIF_F_NTUPLE;
 
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_RX_SG;
+	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			       NETDEV_XDP_ACT_RX_SG;
 
 	netdev->min_mtu = IPV6_MIN_MTU;
 	netdev->max_mtu = FBNIC_MAX_JUMBO_FRAME_SIZE - ETH_HLEN;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 07d4b2e92362..2c8276d23a15 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -22,6 +22,7 @@ enum {
 	FBNIC_XDP_PASS = 0,
 	FBNIC_XDP_CONSUME,
 	FBNIC_XDP_TX,
+	FBNIC_XDP_REDIRECT,
 	FBNIC_XDP_LEN_ERR,
 };
 
@@ -1211,6 +1212,10 @@ static struct sk_buff *fbnic_run_xdp(struct fbnic_napi_vector *nv,
 		return fbnic_build_skb(nv, pkt);
 	case XDP_TX:
 		return ERR_PTR(fbnic_pkt_tx(nv, pkt));
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(nv->napi.dev, &pkt->buff, xdp_prog))
+			break;
+		return ERR_PTR(-FBNIC_XDP_REDIRECT);
 	default:
 		bpf_warn_invalid_xdp_action(nv->napi.dev, xdp_prog, act);
 		fallthrough;
@@ -1334,6 +1339,8 @@ static int fbnic_clean_rcq(struct fbnic_napi_vector *nv,
 				napi_gro_receive(&nv->napi, skb);
 			} else if (skb == ERR_PTR(-FBNIC_XDP_TX)) {
 				pkt_tail = nv->qt[0].sub1.tail;
+			} else if (skb == ERR_PTR(-FBNIC_XDP_REDIRECT)) {
+				nv->xdp_flush = true;
 			} else if (PTR_ERR(skb) == -FBNIC_XDP_CONSUME) {
 				fbnic_put_pkt_buff(qt, pkt, 1);
 			} else {
@@ -1387,6 +1394,11 @@ static int fbnic_clean_rcq(struct fbnic_napi_vector *nv,
 		fbnic_clean_bdq(&qt->sub1, head1, budget);
 	fbnic_fill_bdq(&qt->sub1);
 
+	if (nv->xdp_flush) {
+		nv->xdp_flush = false;
+		xdp_do_flush();
+	}
+
 	/* Record the current head/tail of the queue */
 	if (rcq->head != head) {
 		rcq->head = head;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index 6ee3cce3d942..7bc0c25ac50b 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -173,6 +173,7 @@ struct fbnic_napi_vector {
 	u16 v_idx;
 	u8 txt_count;
 	u8 rxt_count;
+	bool xdp_flush;		/* An XDP redirect awaits xdp_do_flush() */
 
 	struct fbnic_q_triad qt[];
 };
-- 
2.56.1

