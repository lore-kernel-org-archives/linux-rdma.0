Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416761;
	b=VgFsa4AohVCW3DtQ3Sf0ZAOsf6uIT4Gkz6zyb3EFc5BMtTRreOmYU/XQ0j01JI4Bu+Ro
	 UGe7wnwSVjZuiSnlCY/V+JMSBDbOrZqnRzC3XjhjEvoFyhj4q/XeUCf73N3/hqm6zi6n0
	 E22/d463JOWkQETi8PYN8khTxETIICpeuoDQBa1vkqdcyeRHN8ypUAXQYkdDQb7A5CggX
	 EDiJzdEmrORAfirpyjrYIIQLttC5E02eLsMku4dxhmYrk6KVeO+R/3VsDGT2LcEUrhNDe
	 M4VWVeTfhY0Fp/LUVLGkjRNhqYu1O5vNntcSRxK7Sf5SjxPNLk6EXxEzZCfSlrxXLvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416761;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1xnopvEZEzie/o3uHTj2YcSIP2GSDNMyJkurGYUsKGE=;
	b=ndN8B/MqgVEqgJ4zqyAQXjpsphirgjbevQLW9O6r+ejwKD9QxQWmOomAvGPyx4aYBq51
	 HlNel1jipHawGZjl6xovENHJ9PxU3cnZby/Dy5hHp9jawrrqRFz1pLo2EycnKbHClat0s
	 LVPjy0wRSnswyJH58uuYCFGgeG3ltYbLKF2to5JcAxTN24TKn9EtDHZBsrK5+l7n9p5DD
	 UHFox2hZrdKZCDkdLS5vvgPCk/GdSV9K00kg0IHpl4J8ZZOUoYJCroZtCIbKxXgwjJtWX
	 298BmVj9Byy94CzGtaixmXYAY0MZw0CxOxeosSomT36inLp33vsVQFXB+wcAKdPK23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDlMrfCf;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D2B606A324
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 17:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03D2B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDlMrfCf
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0d09df973so2626401a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 09:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794416760; x=1795021560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1xnopvEZEzie/o3uHTj2YcSIP2GSDNMyJkurGYUsKGE=;
        b=IDlMrfCfRk83+CpCsqlKTjDEpt3pi9YKutfnlitSxFWtfM5phb8ZMlfdCkySAd4WM1
         9qUT7XAObzPLg4/AnRzyX5OAHt2GUn2GisZoema+ye/g6yQfQMOsnYowP4GB2s02TAtO
         QVHYdV5WoLvL6+4knGCNqCAX8jxFUWPZNs1dsvBXCfUJWvr+scsGIopfaBbE/xmlSsVp
         yMVYZyGbfm0x2JZxbo2+pAfW8jCJJCti6cmHLuv/DShxLHrig5SCx9CAXSLmfPH4s6hI
         qHTXRq0ZFzC2AZh3hILFR356W7d+SYLoN8FJpdEjiELqRC+TOoWc/DFSomuGzVUjgAtq
         s6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416760; x=1795021560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1xnopvEZEzie/o3uHTj2YcSIP2GSDNMyJkurGYUsKGE=;
        b=dDK3OrtXQ8MKkGvyGsYwOeFBMerPELCXoGBtbMrWO51BQM5ynwq7Xz4YGtBe0ecXal
         d3awGWxIrLM1cGkkhj7+2pHUsB5NjhWv0LvQE2C87Y03cOF8NsO+H/7COvXUGTu+WRPr
         1MVH1aHGRJ/JbRWtdUeNzkdub6wWivrNXcJIiZGT8RhO5n/+HElhh5MZMSA/um+oEAPj
         73zz7AfYx/RGX/YkEEN7anUDSRqGvg1DwZfwTPJgy4HAUxI0aPDYBaopD/UW/MRttwVz
         7aGvGV+2DNa1Ot+ys3IjF3r6IdVfW1iWS6oScVlMe9Uqum9fBWwkqKupKv5Z3yPuJtpW
         39jw==
X-Forwarded-Encrypted: i=1; AL+hErHpIy3GUVtxZQEwWcHFiLSdLU4IybjJ8MQhp21ucvFrnaNUN5xsYja3i0tbKzAKSPp8szEB+Ow9CKm/@vger.kernel.org
X-Gm-Message-State: APuU4Z/1pKYEKr6APrQ6G6bDeEj1N+SqxGIBp5bfpTJV8ig9tcpDqiKo
	Z8vMToMVryQImnksYcLrC44kccJWPEvQ5lAmgHsLksjWZJNnaMWvpAwX
X-Gm-Gg: AYBFou3mg0aHb7j/r5omFVwiiFwzwP9oJeaNSwQHO0i2RhvTBiqykV6Z6EakC2aPvbX
	g2u2rfMZi3rPYucZ/xLQ647JQ7aryK0zwrQYyI6sMmZrnOG8EJNd68lFEm4hLGIfbJmOzey5VZb
	DdO65iwasvxAdSfuEjwbcH8S8PV3OcI8am0sHFtKTtzcvBwsN0uhzP6SnLIsZblYW9YZPSYakj8
	ji2kb5YxXz0yHGo2Jy57d3RmGW91Wlx5p+tTrebcPBQaNg0oB0gmh/01pQiePRpsChKxgrvKPmB
	9T0rcglBF/+xG6ogyTRFhLW6E64KVQRWS4n4sxgtToQlhisaq1dTY6f8dcZShzYab4yE9i8ngLc
	fySPFAzP1xkVHhHxagcNu8AAZVmp/hckNvkzWJ7MIFcNuhlLBSTPIjqqlIaoYdW7Rgp+RJdY56F
	ybVHzPPc80YelKjKQt+LnbSdYmZL4uzBGU5sNQSw3yo/jYmuK9TGOWTsgvZr/J7yO3MXaWIpGyr
	v9BVJLegHnOsJ6XTLNAm/eW/3o6YKuqBhHlw4oOZ1u6jDIbyQFiQMUP4Hg9JKB6tWQAxOusrNZP
	Rv5ZlgbQwpIZZobc/CYaacLLV78/uBtOjoxcqfKWMnG7uCZnG3YxFXIB
X-Received: by 2002:a17:90b:440d:b0:3b0:c7ab:4644 with SMTP id 98e67ed59e1d1-3b182e6ed78mr3037677a91.14.1794416760110;
        Wed, 11 Nov 2026 09:06:00 -0800 (PST)
Received: from localhost ([2a03:2880:7ff:72::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d5eb471sm1864724a12.2.2026.11.11.09.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:05:59 -0800 (PST)
From: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
Subject: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
Date: Wed, 11 Nov 2026 09:05:58 -0800
Message-ID: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
X-Mailer: git-send-email 2.52.0
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

From: Dimitri Daskalakis <daskald@meta.com>

Since commit 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split
settings"), mlx5 no longer reports tcp-data-split from
mlx5e_ethtool_get_ringparam() and the reply carries only the stored
config. With the default config (auto) the attribute is omitted, so the
device looks like it does not support tcp-data-split, even while HW-GRO
is on and SHAMPO is splitting headers.

On mlx5, header-data split is performed by SHAMPO, which is used only
when HW-GRO is enabled. The driver already keeps HW-GRO on while
tcp-data-split is enabled, but nothing enforces the other direction.
A user can disable tcp-data-split and then enable rx-gro-hw, leaving
the device splitting while the config says it is off.

To make the feature handling consistent, report tcp-data-split as on
when SHAMPO is active and off otherwise. Only allow disabling
tcp-data-split while HW-GRO is off, and keep HW-GRO off in
mlx5e_fix_features() when tcp-data-split is already disabled.

Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
---
Changes in v4:
- Nimrod and sashiko pointed out that not reporting DISABLED for
  tcp-data-split makes the feature look unsupported. This conflicted
  with my attempt to block users from setting DISABLED, locally sashiko
  found several scenarios where ring changes would get blocked.
  Instead I took a different approach, if a user sets hw-gro on ->
  tcp-data-split on -> hw-gro off mlx forces hw-gro on. I mirrored this
  in the opposite direction, i.e force hw-gro off if a user sets
  tcp-data-split off -> hw-gro on.
- Clarify extack messages so users know the sequence of commands to run
  to enable/disable tcp-data-split.
- Directly going between tcp-data-split on <-> off is intentionally
  unsupported. Going from off -> on would require forcing HW-GRO on,
  which would require careful validation with features (XDP, XSK) that
  cannot support HW-GRO.
- Link to v3: https://lore.kernel.org/netdev/20261009025137.2631215-1-dimitri.daskalakis1@gmail.com/
Changes in v3:
- Drop redundant hw_features check in mlx5e_ethtool_get_ringparam(). Packet
  merge type can only be MLX5E_PACKET_MERGE_SHAMPO when HW GRO is active.
- Address Bjorn's feedback, and drop premature netdev_update_features() call
  in mlx5e_ethtool_set_tcp_data_split()
- Link to v2: https://lore.kernel.org/all/20261006225925.568263-1-dimitri.daskalakis1@gmail.com/
Changes in v2:
- Leave kernel_param->tcp_data_split as ETHTOOL_TCP_DATA_SPLIT_UNKNOWN if the
  device does not support HW GRO
- Prevent users from disabling tcp-data-split
- Link to v1: https://lore.kernel.org/all/20260923230521.1267511-1-dimitri.daskalakis1@gmail.com/

hds.py with GRO off

 # Interface: eth0, driver: mlx5_core
 TAP version 13
 1..13
 ok 1 hds.get_hds
 ok 2 hds.get_hds_thresh
 ok 3 hds.set_hds_disable
 ok 4 hds.set_hds_enable # SKIP disabling of HDS not supported by the device
 ok 5 hds.set_hds_thresh_random # SKIP hds-thresh-max is too small
 ok 6 hds.set_hds_thresh_zero
 ok 7 hds.set_hds_thresh_max
 ok 8 hds.set_hds_thresh_gt
 ok 9 hds.set_xdp
 ok 10 hds.enabled_set_xdp # SKIP enabling of HDS not supported by the device
 ok 11 hds.ioctl
 ok 12 hds.ioctl_set_xdp
 ok 13 hds.ioctl_enabled_set_xdp # SKIP enabling of HDS not supported by the device
 # Totals: pass:9 fail:0 xfail:0 xpass:0 skip:4 error:0

hds.py with GRO on

 # Interface: eth0, driver: mlx5_core
 TAP version 13
 1..13
 ok 1 hds.get_hds
 ok 2 hds.get_hds_thresh
 ok 3 hds.set_hds_disable # SKIP disabling of HDS not supported by the device
 ok 4 hds.set_hds_enable
 ok 5 hds.set_hds_thresh_random # SKIP hds-thresh-max is too small
 ok 6 hds.set_hds_thresh_zero
 ok 7 hds.set_hds_thresh_max
 ok 8 hds.set_hds_thresh_gt
 # Exception| Traceback (most recent call last):
 ...
 # Exception| CMD: ip link set dev eth0 xdp obj /tmp/ksft-net-drv/net/lib/xdp_dummy.bpf.o sec xdp
 # Exception|   EXIT: 2
 # Exception|   STDERR: RTNETLINK answers: Invalid argument
 # Exception|
 not ok 9 hds.set_xdp
 ok 10 hds.enabled_set_xdp
 ok 11 hds.ioctl
 # Exception| Traceback (most recent call last):
 ...
 # Exception| CMD: ip link set dev eth0 xdp obj /tmp/ksft-net-drv/net/lib/xdp_dummy.bpf.o sec xdp
 # Exception|   EXIT: 2
 # Exception|   STDERR: RTNETLINK answers: Invalid argument
 # Exception|
 not ok 12 hds.ioctl_set_xdp
 ok 13 hds.ioctl_enabled_set_xdp
 # Totals: pass:9 fail:2 xfail:0 xpass:0 skip:2 error:0
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 21 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 1f534051cdfe..8e7c748caf2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -388,6 +388,13 @@ static void mlx5e_get_ringparam(struct net_device *dev,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
 	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
+
+	if (dev->hw_features & NETIF_F_GRO_HW)
+		kernel_param->tcp_data_split =
+			priv->channels.params.packet_merge.type ==
+			MLX5E_PACKET_MERGE_SHAMPO ?
+			ETHTOOL_TCP_DATA_SPLIT_ENABLED :
+			ETHTOOL_TCP_DATA_SPLIT_DISABLED;
 }
 
 static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
@@ -399,7 +406,14 @@ static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
 	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_ENABLED &&
 	    !(dev->features & NETIF_F_GRO_HW)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "TCP-data-split is not supported when GRO HW is disabled");
+				   "TCP-data-split can not be enabled without HW-GRO, set it to 'auto' and enable HW-GRO first");
+		return false;
+	}
+
+	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
+	    dev->features & NETIF_F_GRO_HW) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TCP-data-split can not be disabled while HW-GRO is on, set it to 'auto' and disable HW-GRO first");
 		return false;
 	}
 
@@ -474,9 +488,8 @@ static int mlx5e_set_ringparam(struct net_device *dev,
 	if (err)
 		return err;
 
-	/* Might need to disable HW-GRO if it was kept on due to hds. */
-	if (kernel_param->tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
-	    dev->cfg->hds_config == ETHTOOL_TCP_DATA_SPLIT_ENABLED)
+	/* Might need to adjust HW-GRO if it was kept on/off due to hds. */
+	if (dev->cfg->hds_config != kernel_param->tcp_data_split)
 		netdev_update_features(priv->netdev);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..e2f657b36824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4627,6 +4627,13 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features |= NETIF_F_GRO_HW;
 	}
 
+	/* HW GRO cannot be enabled if header-data split is disabled. */
+	if (cfg && cfg->hds_config == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
+	    features & NETIF_F_GRO_HW) {
+		netdev_warn(netdev, "Disabling HW-GRO, TCP header-data split is disabled\n");
+		features &= ~NETIF_F_GRO_HW;
+	}
+
 	if (mlx5e_is_uplink_rep(priv)) {
 		features = mlx5e_fix_uplink_rep_features(netdev, features);
 		netdev->netns_immutable = true;
-- 
2.52.0

