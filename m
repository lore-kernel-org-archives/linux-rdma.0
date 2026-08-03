Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87BB39BFFA
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 23:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800881; cv=none; b=PXf/rEczbPy6i02HMGQBmUCuTVGNwF5u+3rpzNqvCd0Da9NKV7pwCJMqKaKmAscnKHUvu4i84r1F1zaCJYf8wItLCUYZIGFybQ26tBwOyFWA3h7s2xrzUfhO62Agb7xjzgRoybW3fqnS/2qxDMl1NDv3rQBvLW3T2Ixp0lzXra0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800881; c=relaxed/simple;
	bh=eB+ze/+u7thR9be6FtIVrOzuGSSTupcYFQmfVu3l1d8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gNNOO5P4/Az8kEynXTGOnWTOaZ+4GCTUFe7h+myzoHTDNg88/piN+hOySHp746TP0U7KzfDqRm62HDl2J3YIA9pqWoB1O0UpwahBG4fgko593w5P3b/VkI051GUCfsBsFWqlWIE7M2KYgjuyqEr0FZiCCwRNNU356sOSN0N+DJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQBNEMR/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQBNEMR/"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso446205b3a.1
        for <linux-rdma@vger.kernel.org>; Mon, 03 Aug 2026 16:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785800861; x=1786405661; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZN2PrMjeC/rF7ocz4YocvO7Rr3+RP+K43ZmGxuO2IKg=;
        b=lQBNEMR/GOY7amJFkU9BRmd+CZ5jiQ78lnIQNgZWAJJBemdva3r+mIWyfAIxCumPJq
         ReIs2aL4KDCA9o3ySS3ulkfs4z94rqU/JL1ohKgKxz/ODzB9zNQDXXNqQZYnb2TK54dp
         p15IXsxjoOUMZpnfnIikAPCNaWmFhx+hJlALH7E9sqhqk7mY/AEOhBUMd7FoVS/yfBWL
         X3XeWdAmP0M7+KlcgEuikGMimodd5jrmZ7nmR7h0rtpvh9ge7zbGFxUi9SHV7tr8smrJ
         cBeKqoVDRLX3TImyjWLdSfbzxFLMQYhg2tSm+SJNFKbgclYOmMUl0uscR5PXmdQH3UwJ
         wpxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785800861; x=1786405661;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZN2PrMjeC/rF7ocz4YocvO7Rr3+RP+K43ZmGxuO2IKg=;
        b=IKSCACCPfW61u2u6jtqp3+hKgBXTLes/ovGuyKPyvRZdJgzySuoRCAcmv0M0zVS/wc
         vNiNWilDQYEIrUvXF/8cIB1wXxz8MFkF5oJxnNaMBTBaAC49qeLSfACToMgG9eL5ICQP
         I2cdpBvkFYjD0smBGZnvp95PtUjRPLtV3o9c4knZ99Q/OdjxPBP7TRrP/+w5hVitnOm4
         lzK9iOX9n1T+S+hKRU7q6llOCM3r4FibFhcFwkVQ2Tke7OHgKElRRH5Q0l4tbPWGZUlv
         Q98jkhbtNGgeV22jNd++BHlfxkrOMsJjj20e1Jm3DwRim4aaeXrcv3qP2jDLmfpXysyC
         Uu+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpWDshxLOaXyLRtnNL+sy0ZC7MZigYX5OOEQ3TO5d0CgPfXRclmK0u+dGwNT+gZG5NcD9ZLd6h2LlxZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxxFJ2TrRzU8ReD4qqmJg4T04DMaVDKOVzh99N6qG3bigkXoSOa
	tHAl1LMnYw75e5eVAhidt7yKEoZhf9DmFKNL4+c/Fp5pNaB3phxlsOq/
X-Gm-Gg: AR+sD13GamuQQdmhuaPF4+kwEq31mAyE34l7eXBsBweVoiN0qbNIMvHzSeQDWvHcQ+I
	y8n8bZZjZkCObLlWoNmdhyRngnj14R74dhMCqtTDG4qiOvMRwS53KgGiHd8k+CFh9Jjek1ExkeH
	Ym8C+Tbj4Lv5zVBde5/D5WGjunS0uHCTZuxXyeIPksgL1cB+XSWtTotwGjdGrcTfZQVRxpNsoXp
	zS7dTiGOM5LyreFqiI2ep3ARqu3Hs5O3CHHMm6YHTxV3Xm6AntU7LsGKD+b6Gv0fs1YfktZ9cXb
	RIjgqgSWEB7cONaCXCk/yy9y0A0YzwMEagAGXyW6Yx42hKYZe2t+9LCzvg4cjZtqoKCgsPhJ2ro
	rDhsipQNED7GeY3RQ41HmbN3btTgV199k2ms2gj+OpzdZoDWD15+eRgZvlZk5+5XlhqCIffgGeA
	mZkCYMf23EP3YESW1MNy/NcNY+n1v5gbIwbu1FIlg1yqcmtFw8Uo+Hwlk=
X-Received: by 2002:a05:6a00:a90c:b0:848:2f58:e1e9 with SMTP id d2e1a72fcca58-84f1cbc930dmr1257604b3a.36.1785800860784;
        Mon, 03 Aug 2026 16:47:40 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe7a243sm4263667b3a.24.2026.08.03.16.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 16:47:39 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 03 Aug 2026 16:47:29 -0700
Subject: [PATCH net v3] net/mlx5e: fix BQL reset on SQ re-activation
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com>
X-B4-Tracking: v=1; b=H4sIAJEocWoC/2XMQQ6DIBBA0auQWTsNUBF01Xs0XSCMlaRqC4bYG
 O/ehJVJ1z//7ZAoBkrQsR0i5ZDCMkPHrhUDN9r5SRg8dAwklw3X0uD02hT2nxeamri0ytaNM1A
 xeEcawlaoO8y0wqNiMIa0LvFb+CxK+peyQIFta7nttSZP+jbRai9umYqR5flrT59Egc4P0ihSp
 vHD6TuO4wfg1Jyt3AAAAA==
X-Change-ID: 20260728-mlx5-bql-84e02a5a46c8
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

mlx5e_queue_start() deactivates and re-activates all channels but closes
only the queue being restarted. mlx5e_activate_txqsq() then
unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
of channels that kept their in-flight TX WQEs. The next completion then
over-charges and trips the BUG_ON() in dql_completed():

  kernel BUG at lib/dynamic_queue_limits.c:99!
  RIP: 0010:dql_completed+0x23d/0x280
  Call Trace:
   <IRQ>
   mlx5e_poll_tx_cq+0x668/0xa60
   mlx5e_napi_poll+0x5b/0x7b0
   net_rx_action+0x15a/0x580

Reset BQL only when the SQ has no bytes in flight (sq->cc == sq->pc).

In the case that reset is skipped, the outstanding WQEs will eventually
complete and rebalance the dql. The dql->limit is carried across the
reset.

Fixes: b2588ea40ec9 ("net/mlx5e: Implement queue mgmt ops and single channel swap")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v3:
- Sample sq->cc/sq->pc before setting MLX5E_SQ_STATE_ENABLED, so a
  concurrent mlx5e_poll_tx_cq() cannot un-charge BQL between the check
  and netdev_tx_reset_queue() (Sashiko:
  https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com)
- Link to v2: https://lore.kernel.org/r/20260729-mlx5-bql-v2-1-cdf285e586df@meta.com

Changes in v2:
- remove misleading comment (Tariq)
- Link to v1: https://lore.kernel.org/r/20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7d47a1da8b6b..f0407a850ea8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1939,8 +1939,10 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
 	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
+	/* Reset BQL only when the SQ has no bytes in flight. */
+	if (sq->cc == sq->pc)
+		netdev_tx_reset_queue(sq->txq);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
 	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
 }

---
base-commit: d1000fd7995e51deec872d154e0a40d82f7a539f
change-id: 20260728-mlx5-bql-84e02a5a46c8

Best regards,
-- 
Bobby Eshleman <bobbyeshleman@meta.com>

