Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0A33F410A
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785358095; cv=none; b=nsfh9oT05Johl8TId6vIBiZwGQl52WCMFOxevv68U69PHy8AZkXtxg/8YhzLuhkDgshD0s7QwPmtld6tVAjT6sisLVLjhRS7re1hW+PHFOZ1623HgETI2KPBtVT1jmDM2I10rg6GQvPHd89xrHkSClEWCCemwrg/IrNkMVMUNNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785358095; c=relaxed/simple;
	bh=ghSvs3bjeMbD0ElSdqAngWYaaXDI5xXr0l+jvLObKnM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CNcLYgU320k8wdnS/lCFzyxalESuu2GaJTmylXqGrqMzjb3JesxwSeEYiclj0mDQhd3sI8LfXG+hMiuhVPaD9WZ+d61QhxXY9bPorjhroxd/Ufq6Pz587v1CbRPUEWInErCi3V0SvHmDooB3Keo1cHyP48GcQuVgIrNWQm0675M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzGIp2gy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzGIp2gy"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso9985935e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 13:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785358090; x=1785962890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7C7vldz7GsXVEVDYDLw9dX12wc2USI49J3820vhn8yQ=;
        b=VzGIp2gyJbxIIjBfOavXImng7MoqsgVwnTvUJdxIjOVXk36N0l/Ip7bOwOL3q3ws3d
         XAsPqyCCl7z5HyNPIz3YBwqSqPED+w3glrSu8NK9Uzr5c7W7HAlk0mqgyGSDqvVMJKDW
         j4tj+ysV9YSRzuKGEMuE0wlWhrRe5G9QzMk7dRszCh7peGSY+R4Uj3DpzbObvzYMupc1
         5SY+CnXQTg5epjrdfpyleRtS9PzipojY+FuPVJFBURTdEGpqP0EN7rxYvXHUCqyrzlhC
         zzGHYC3SADdrbP0ttghvqitQ8AAazv1NLe0IYkwCcWciEwQ7L8/MLx0fLJsJDq6EFCh2
         vhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785358090; x=1785962890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7C7vldz7GsXVEVDYDLw9dX12wc2USI49J3820vhn8yQ=;
        b=lIMNl5uqSnnDSV0r3DusP+kU3AK+Imi0X2RgThua9mmAJxiH6mlwvfdHgLCIqrjy8E
         yZIanfPvbq/65sqEv6HXZaUAdmeOmU3eE/15eCiZ5C8u9ZwzZev7BJ3m4eJ+0KIN7iBY
         QfxwQGpwSdQWqu1uFYelSI7IsVrSC2W0YMvPV8orwHt5sDs5ti5W6ykczNFkb3rvaLvO
         eRkDVunzH513Yc6SfuLny/0ul2IU9rC2EIA4EHstEitszF6v2Pk/CUMDp/uOtTTdsWaM
         Wz3OPQtz2d9xmXGXWyYMFwkAIYQ9oyroKKkXq8dQb7jhLLIOqlbNoFFV1A2GUaMM4qkW
         ERBA==
X-Forwarded-Encrypted: i=1; AHgh+RpenGjonCcBwnB/mIUzdG1S2cCs8VVJxHz++NOQ0FzA//bnCPo8uTu7ZCsjDUDnNt4zcIUF29dt/06o@vger.kernel.org
X-Gm-Message-State: AOJu0YzYsFt96phIUSHzB7IYqLXPbN4bJSV7jZm2qDSw1RdRXGTSeJWE
	yixS5KIxYX0ZIu+GD/9/KZQTRyhj/tkcbzmNBm3eajmF9n331Ex3twtNQpSBfFG7
X-Gm-Gg: AR+sD10fD7QLESdojqf+rELqP7OXtkaq984uTD5mq7Rdhv47HRIX8lFlkukX56ejph4
	GQ8ncERPYJaq5fEC4uBMvJL3ueUwHjg2i7hUFXafoMlSlpCiRlmLBsqWgVQPloRwPvULZdKDNzP
	lG+YtWmJheBJvKaxlTaB9ubrMcvnlNpAI7bqn9oNRlUUNYeiPyO3jOfMQVJqBaUuGYVBTieGawR
	fs+5HmSdH2S9rSxcn5DOiGHwiM1ZMmM4AjEqIfucIIoYTLNVU5ENMZ4fHc5kkqJyqfT1PEQACWZ
	HisgecFYuuPH8eGUmo0OQ4TadgFmFVRiePYifKWbCSAxpkhdfnYZpnlEjX3L+zJZmOLRtkX5jG3
	Px6MKd7AQjsAbR9eHo/BRGNR4dP5B2pqEnnJ4c3dq5xv3wzuFjYSObEmARwHtbxCOHuCx1FGYUN
	PnjR/aRWvAdC7OIXQAF9Icft6tUepIt81lc0w/3VRahVJzkgc+f/1buRD1Ay9oxF5BEtwVcd2/P
	nrSun8NdXY0RG14AWjAVgurEKQm1n5QJcA=
X-Received: by 2002:a05:600c:c8d:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-49800ea20e7mr16645e9.25.1785358090071;
        Wed, 29 Jul 2026 13:48:10 -0700 (PDT)
Received: from syslab05.cs.virginia.edu ([128.143.69.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6e179sm93779065e9.9.2026.07.29.13.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 13:48:09 -0700 (PDT)
From: Tianyu Zuo <cosmosocket@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Khalid Manaa <khalidm@nvidia.com>,
	Ben Ben-Ishay <benishay@nvidia.com>
Cc: dtatulea@nvidia.com,
	horms@kernel.org,
	Tianyu Zuo <cosmosocket@gmail.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net/mlx5e: SHAMPO, Fix IP length overflow on large HW GRO sessions
Date: Wed, 29 Jul 2026 16:47:45 -0400
Message-Id: <20260729204745.166584-1-cosmosocket@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5e_hw_gro_skb_has_enough_space() bounds a HW GRO session by the
payload held in the skb fragments only. The L3/L4 headers that
header-data split placed in the linear area are not accounted for, and
the limit is inclusive of GRO_LEGACY_MAX_SIZE.

On a 4K page system a session can therefore grow to 16 full page
fragments (65536 bytes) plus the 40 bytes of IPv4/TCP headers in the
linear part, giving skb->len = 65576.

mlx5e_shampo_update_hdr() writes the IP length itself:

	__be16 newlen = htons(skb->len - nhoff);
	csum_replace2(&ipv4->check, ipv4->tot_len, newlen);
	ipv4->tot_len = newlen;

With nhoff == 0 this stores tot_len = 40 and updates the header checksum
to match, so the corruption is self-consistent. The GRO stack does not
repair it: the header is written before napi_gro_receive(), and
inet_gro_complete() only runs for skbs that the GRO engine holds on its
gro_list. HW GRO sessions are typically flushed on TCP_FLAG_PSH, which
makes tcp_gro_receive() set NAPI_GRO_CB(skb)->flush, so dev_gro_receive()
hands the skb over via GRO_NORMAL and the gro_complete() callbacks are
never invoked. The length check in inet_gro_receive() cannot catch it
either, since tot_len and skb_gro_len() are compared modulo 64K.

ip_rcv_core() then trims the 64KB skb down to the wrapped tot_len,
silently dropping the payload. The IPv6 path wraps identically in
ipv6hdr->payload_len.

Triggering this requires the payload of the aggregated session to reach
GRO_LEGACY_MAX_SIZE with every fragment fully populated, since
page_size * nr_frags otherwise overestimates the data actually present
and the session is flushed earlier. In practice this needs an MSS that
is a multiple of the page size (for example 8192 on a 4K page host with
jumbo frames) together with a page aligned start of the session.

Account for skb_headlen() and make both checks strictly less than
GRO_LEGACY_MAX_SIZE so that skb->len can never exceed 65535.

The check is strictly more conservative than before, so the implicit
bound on the fragment count is preserved: page_size * nr_frags +
data_bcnt <= 65535 gives nr_frags + data_bcnt / page_size <=
65536 / page_size - 1, and a single CQE adds at most
data_bcnt / page_size + 1 fragments, for a total of at most
65536 / page_size (16 on 4K pages), well below MAX_SKB_FRAGS.

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Signed-off-by: Tianyu Zuo <cosmosocket@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6fbc0441c4b8..2e9676305439 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2222,9 +2222,10 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 
 	if (page_size >= GRO_LEGACY_MAX_SIZE)
-		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+		return skb->len + data_bcnt < GRO_LEGACY_MAX_SIZE;
 	else
-		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+		return skb_headlen(skb) + page_size * nr_frags + data_bcnt <
+			GRO_LEGACY_MAX_SIZE;
 }
 
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)

base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4
-- 
2.34.1

