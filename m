Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978772;
	b=ucfriCqJZ28Oy+vVD/nPsgKqL9v6s4aK41d7/Q/W5BKhMbGr+Pqx/v/smW3s7u5IdniF
	 01PDokarbhvXEn9cxJEwec6NMT/IAN+FMQUksW86XrsMUVHHbY9PJyxkWZ+3GBHm1X+jb
	 EpY9gCegX/35oC4sd5BTzq2edCCqscqKef/KMKBHpOg0Sd9ICbLQCmgI5zGkTtmpQ9I/U
	 I26D2rthJRwWrW0CYv7hHqKFuRDk8ShCObGJvNEPcwJ46hQro39XlnHKQCZqr5mE7KKRy
	 YH/KWma/lD4QoWCM7NmbujxTIVftBK+RMhZUsNJPs3j7DamV4oMHkV0cJoWhiCGmeAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9I/hVi6WR1uXMNLiaaICSMrOG3A3Cvvh+eTe+Y8iRDE=;
	b=ROQpMWv7WOAcMckBNznG4nBS1i0axQ4CrvaHnDPW79E6JLxh6A2EtggP+jw7+O3Q+d1k
	 hNIvd2gAHOOW0x8D6ELiZKDKvghyMbyRFO8NuqbOETNA+A6Oq+sZkf11dHFOtS74CehMZ
	 Z6W1SSs+yPCKWwVVrMNZuWGJDSsxURt4pfIOoIGh1j48NZyS20Yuh7ZSNiApzegOJmnbo
	 aakjan1tzBZETsH4BSXlg4+R/giwuREXQBNj56ISz0n45ZNJA7JvH9dRKSk9/SC0u5rqR
	 +YvFL5qTSrtLQoy6D8JylCvu6oGvr/7jLtplOjzE9yHyhmhpzWdLfP8kf/amh+dDJpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ciYKEnL6;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5DF606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 05:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE5DF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ciYKEnL6
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-945e6d9ceeaso57260685a.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 21:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794978770; x=1795583570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9I/hVi6WR1uXMNLiaaICSMrOG3A3Cvvh+eTe+Y8iRDE=;
        b=ciYKEnL6tN9Cbe2SrzIAdyXmOVkWx5M2NSiY4dZnY12moQKFQUR8iU/6wgFRkSjd3v
         JQ5VbASNb+PFxxdbJ5S69gN2OjKr17CnQ3SlsNgqN1FfMX72q7o79JmRrefAWAL7NP0/
         xr960MjUqeO8dGSd9rbpWUZCmtaZh3prBsDFnHVPtWONMpWE0alVByPapHyi8oRg5AiK
         hobouqYTUKa3JlPjW1G3QVw+cvBoKTJRdZb7AJ85WYgHhqdNHcIXOo1NyLMbC9sKcfWF
         SC+bcg9Lp8z/w486uv2uH8efmGWbJROBSOy4trYcNoXgjA6ge6eiHO/gLgExg9AIvbOf
         q/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794978770; x=1795583570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9I/hVi6WR1uXMNLiaaICSMrOG3A3Cvvh+eTe+Y8iRDE=;
        b=DqZg0WgvVqPnHx3nlHxBxXSOyvqIGRqAJy3TyTgbJzOnTiPNjIisc8ezJEUTg/C3EH
         6jKMuqfLtBPNPR0zzGP1BNuF9TgFcHSLRU2TRdZRUI4VuUPhZTR8Trd/UNTo7t1KOPgE
         sACVZAQpz8/RIduOrJsnZgvP7hGZWamWc/p74TxoLGqFJb7pRbmor8tM9hTQDWzRtQyo
         xfOy/XgMuoqFZ1UCmT8iUopzVa3PH7w9xVXGIlczyH1Wq43USd8oxbI3ne1GHQqYbXaG
         308BvjDsFaQmBVrBfD/b52uq0CT9N+559xOAkAuepH6euUirGbfAXN+zAATPu1KxjdeK
         M+ww==
X-Forwarded-Encrypted: i=1; AL+hErGH+h278vCyPHBUzVT+h9p7SgmPpU4FV1BxhS2ys7AK790GYHv6BukHnpZcwdEYuEkqk7k4gvBK/vEq@vger.kernel.org
X-Gm-Message-State: APuU4Z+hAsbuzHjVThRwFs4WWknk/1wkOMHaD2P20UWW7Z/23YYb0Caq
	cdBha0Wn0o+H+oyoj4RSwHY1lj+PEMtKScGU6XncB6Il3hIYitxWd/7A
X-Gm-Gg: AYBFou0LruLlHE7X9wsmSBJJFRZ04NI9vR6I2O5K8wqKA7qsPn0x/JEmzElPmprkCqT
	fzrotCYAQM/pcrw968gLlaSyUfFl4zrV/QFZ8sLogmrhSZA4MBzKNUPTX6h8PpAZcEB6QVwD5v3
	iqGzoEqtQTmrTgnDLemCqYtSjaR1Nw0dAOm9E0PUQZtIPsCmd6xwNl0QeNKLcGmnP5e/pLvfrci
	Duue0lnRk3SprZbtcmkhdUxOPAWpgYP4m12wvPYj9+7/EIZyct1ka7WWQNGrqBmxGKX00NKwPTk
	75MYb7uENEkXZhsOtztjxiVhFuh42CTddPe2joI86NvQA6T9Me8Frudo45cG3OJ42DfgRkebY/g
	geSjZ4jWanuOEwuCGBNdHldhO9aQVipbAkryNJMGHxtdBzH1KOoTD8sSumH4/mBk36OMvlE9dyp
	S4aNdO8ubNyAqPVJPJmVTt0wuKr2fjjVNWOTYRNSG/MU4l79TMAv5PJJKTI/BZa1950ddAbidra
	NP13g9DZathh4Njcupedts+9O7oCybHY4VQ9lk6SBWNbq057+/sD6Qkl2BDh9IkCB8oVntI99Fa
	9CmJ96xUqrtXNYGb5SF7akJxTRklNJRwd1sYL9hS6lu2NX2oxBpvWBM41RfVfza6dND5W3ecgiU
	=
X-Received: by 2002:a05:620a:2718:b0:949:7781:6a31 with SMTP id af79cd13be357-9499962736dmr286507385a.76.1794978770597;
        Tue, 17 Nov 2026 21:12:50 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7b8444sm95547485a.31.2026.11.17.21.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 21:12:50 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net] net/mlx5e: IPsec, Fix RX mapped ID leak when adding a rule fails
Date: Wed, 18 Nov 2026 00:12:47 -0500
Message-ID: <20261118051247.3885308-1-lcy8047@gmail.com>
X-Mailer: git-send-email 2.43.0
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

In switchdev mode, rx_add_rule() calls
mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
frees the modify header but leaves the ID in the XArray, and
mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
packet offload SA leaks one of the 2047 IDs. Once they are used up, no
new inbound SA can be offloaded until the IPsec context is cleaned up.

Remove the mapping where the modify header is freed, as
mlx5e_accel_ipsec_fs_del_rule() does. The modify header is set only after
a new ID was allocated, so the copy that mlx5e_accel_ipsec_fs_modify()
passes in never loses the ID of the original SA. Outside switchdev mode
rx_mapped_id is 0 and the call does nothing.

Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in switchdev mode")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus MLX5_CORE_EN, MLX5_ESWITCH,
MLX5_EN_IPSEC and W=1.

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5c69e89b13a7..ef858374ae11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2161,8 +2161,10 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (flow_act.pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
 err_pkt_reformat:
-	if (flow_act.modify_hdr)
+	if (flow_act.modify_hdr) {
 		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+		mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
+	}
 err_mod_header:
 	kvfree(spec);
 err_alloc:

base-commit: 2a324a58a084c5cfd7e5a2f55e0786bee170a4a5
-- 
2.43.0

