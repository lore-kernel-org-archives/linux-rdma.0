Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148022;
	b=lJ0gUyWoKupQiFj1eOqGtQN7CkFkeM4LgFD14VX+LgPj+L3tuZ0vK08GNiDLttSl27xi
	 kID/j950x0TEZEJh6Lc+OQfqYU7SOGfffduuog/qQieud6F6CDREDXmUak9LonNW+JcD5
	 B+vHgmhhuWMVJ3ktuZoPWXfvG4FJRkxAgnisYLmjNCpq4iHxGOxRp7d1Viq16WveO5XUR
	 nDVXy9MnSGGM19tJRj6RJbrn2zA02S3MSHPidBnpJ9atore+140R3e9DLp1tjoptgMdmq
	 X5vVDODKljbdyeFM99hRzakP3MsinE3mGhR1iCQ2+usabkviP5IF034Sy0XcwdK9S7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148022;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=9tN1OwIMXmBkH/myQNFipJUCm4A0jK3APAgstzTCTi4=;
	b=lxoyFPd/1KBqY5rGLaqjOvPViweMDy6jH0CRTl2Ec/2SGA3kozbGhNTVZzOYFI8fR+XU
	 WH2lyp+jW9ELDfg1Dj0QEfLd5byd2FFAvC0jdtZCtFoo6lwCyypEfs+NK0mvGQ0WMXAY7
	 pHQp/esdyJbB7o18pzEmHu58R8PCBYFXyhHjd8kKOHZ2fkAIblnJZmuZS3qFi0lBhKq0b
	 Y1bGDFKfuBm1vSNWSfH08Ngu+HisBVwZnq+XibP7E3lCihKwvcVDNBp9V1l1lEWzwfAHO
	 up1tCCanIdhtbS/liZArgX/8W1MjYj7W5CbrLt5K8/8pd8JNvOjGFgCu2Fm66jyosIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=igtEiTa6;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B948B606D820;
	Sun,  8 Nov 2026 14:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B948B606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=igtEiTa6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=9tN1OwIMXmBkH/myQNFipJUCm4A0jK3APAgstzTCTi4=; b=igtEiTa6FtLkUp3bPsUreKu70K
	7trYSSjsTvpvf7vMBA4f1CFz7tYK+wRdLSCv5j2UWR++hvbXzNkxPMPHSrCr8hfmVXN3qCOOjQ3Sk
	F2yoageZ00kLilMigYMZ2OCXOLzJGEH+g4pNz6uNIThbhJwZKtuA7j4aoeW73X4NZ7dEiUWnxaxw0
	nG2V1/OztfcE9MonQl3sA5785J9KQxSTXR/2/9QhyR3x5Wp4J6XRJxKd3fBkdxUUWeu5e+9PeG4wu
	GDC/EFL4XywGNj25n9lFlbfNgOH2RbB/naIzE65WVqPT0uYcKxoiUnmeNLKoxMmzQ90och+oXHkHP
	3+Ar0TzQ==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rI-00000008IcJ-0Q81;
	Sun, 08 Nov 2026 15:27:00 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sabrina Dubroca <sd@queasysnail.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Boris Pismenny <borisp@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH ipsec v2 5/7] net/mlx5e: Use the packet sequence number for the IPsec IV
Date: Sun,  8 Nov 2026 14:26:50 +0000
Message-ID: <20261108142652.1330952-6-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
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
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

mlx5e_ipsec_set_iv_esn() may decrement xo->seq.hi for a GSO skb based
on the SA's current output counter. The metadata already contains the
high word for the first packet, so this can produce the wrong IV.

For a three-segment GSO skb starting at (H, 0), oseq is 2 and
oseq - gso_segs wraps to 0xffffffff. The helper then uses (H-1, 0)
for the IV instead of (H, 0). This can create a situation where GCM
reuses a nonce.

Remove the high-word adjustment. mlx5e_ipsec_set_iv_esn() then becomes
identical to mlx5e_ipsec_set_iv(), so delete it. Since there is no
longer an alternate IV implementation to select, remove the per-SA
callback and call the common helper directly for outbound crypto
offload.

Fixes: cb01008390bb ("net/mlx5: IPSec, Add support for ESN")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
Changes in v2:
- Simplifications in the code (removal of mlx5e_ipsec_set_esn_ops and
  set_iv_op function pointer), thanks to Tariq Toukan.

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 18 -----------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 --
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 31 +++----------------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  4 ---
 4 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index db260e3..de2e740 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -651,22 +651,6 @@ static void mlx5e_ipsec_modify_state(struct work_struct *_work)
 	mlx5_accel_esp_modify_xfrm(sa_entry, attrs);
 }
 
-static void mlx5e_ipsec_set_esn_ops(struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct xfrm_state *x = sa_entry->x;
-
-	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO ||
-	    x->xso.dir != XFRM_DEV_OFFLOAD_OUT)
-		return;
-
-	if (x->props.flags & XFRM_STATE_ESN) {
-		sa_entry->set_iv_op = mlx5e_ipsec_set_iv_esn;
-		return;
-	}
-
-	sa_entry->set_iv_op = mlx5e_ipsec_set_iv;
-}
-
 static void mlx5e_ipsec_handle_netdev_event(struct work_struct *_work)
 {
 	struct mlx5e_ipsec_work *work =
@@ -859,8 +843,6 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	if (err)
 		goto err_add_rule;
 
-	mlx5e_ipsec_set_esn_ops(sa_entry);
-
 	if (sa_entry->dwork)
 		queue_delayed_work(ipsec->wq, &sa_entry->dwork->dwork,
 				   MLX5_IPSEC_RESCHED);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index abcbd38..172fce9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -278,8 +278,6 @@ struct mlx5e_ipsec_sa_entry {
 	struct net_device *dev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5_accel_esp_xfrm_attrs attrs;
-	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
-			  struct xfrm_offload *xo);
 	u32 ipsec_obj_id;
 	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 6056106..4a9c334 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -150,30 +150,7 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 
 }
 
-void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
-			    struct xfrm_offload *xo)
-{
-	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
-	__u32 oseq = replay_esn->oseq;
-	int iv_offset;
-	__be64 seqno;
-	u32 seq_hi;
-
-	if (unlikely(skb_is_gso(skb) && oseq < MLX5E_IPSEC_ESN_SCOPE_MID &&
-		     MLX5E_IPSEC_ESN_SCOPE_MID < (oseq - skb_shinfo(skb)->gso_segs))) {
-		seq_hi = xo->seq.hi - 1;
-	} else {
-		seq_hi = xo->seq.hi;
-	}
-
-	/* Place the SN in the IV field */
-	seqno = cpu_to_be64(xo->seq.low + ((u64)seq_hi << 32));
-	iv_offset = skb_transport_offset(skb) + sizeof(struct ip_esp_hdr);
-	skb_store_bits(skb, iv_offset, &seqno, 8);
-}
-
-void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
-			struct xfrm_offload *xo)
+static void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_offload *xo)
 {
 	int iv_offset;
 	__be64 seqno;
@@ -264,7 +241,6 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct xfrm_state *x;
 	struct sec_path *sp;
 
@@ -293,8 +269,9 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 			goto drop;
 		}
 
-	sa_entry = (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
-	sa_entry->set_iv_op(skb, x, xo);
+	if (x->xso.type == XFRM_DEV_OFFLOAD_CRYPTO &&
+	    x->xso.dir == XFRM_DEV_OFFLOAD_OUT)
+		mlx5e_ipsec_set_iv(skb, xo);
 	mlx5e_ipsec_set_state(priv, skb, x, xo, ipsec_st);
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 45b0d19..9a7e032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -53,10 +53,6 @@ struct mlx5e_accel_tx_ipsec_state {
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 
-void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
-			    struct xfrm_offload *xo);
-void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
-			struct xfrm_offload *xo);
 bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 			       struct sk_buff *skb,
 			       struct mlx5e_accel_tx_ipsec_state *ipsec_st);
-- 
2.47.3

