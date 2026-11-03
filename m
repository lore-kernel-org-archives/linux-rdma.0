Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793708477;
	b=MzQEaxi1D3+qYXwgArc+TtjNupVSe2WDtq3ju1WW1HRH4c1QSUfBNKKNrO/4b/sfVmD8
	 vn0yAENqY52+AX/UHy2QTqucMtNln5G8hZKdOStO5JhuriB+OhyKV8z7n21mLgZJSUMkA
	 C9R8+Xn7zVFPbQ1i6OzP9Tf/knGwKzMi62IyefkLi2FsC0CTaPFQML918yO4G0M69CrP5
	 XRPfPCgd6Pmtb0CSmKFtZb+ksRs+meOy+S8nKgEK9hPYKwCAObprxrAA5rSyWKvyIe0JT
	 MEg+1hfTh4WtEVeaNP7MxcVu4HmBQ4oeKJJZfJ29I8Xaz+0gX+cgCiVO6fWjSGkDBjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793708477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ftzGpP0ulPi0xGwIl3ZzcJGVoGV7Otzfx0qZQUNaagQ=;
	b=hePriP0cmbZQa5foi98/OQQ8sQj3/+ELeryQvgI55ZPNEAXwic0wsJpug2Y6MwrO2M+3
	 ROaU1hXhd2yuiHsxA4FRTdkfl9pg1aEGAoA0HlG4wr2wev54I6pd6K400oPwNyeOBZSSf
	 zXGw+l3Nr2/oLT5YiHoeZMdUy9Zue/vOiRnQEla2kqTg60AZOi9mofg6CeH5YSVPRVH0o
	 nA9iI0uCZO/zP7e9mqtY0ahZJXxisDHtU6JoD30ZTmt2k2FsakYjE6jMwZUKL5m/HIXdQ
	 Ia/dYjpcvz32eqesAegfHBWHTCXhdU2UGFsJW5jX5wDJHkj0mOVIvvILqMiAIgrNjEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fvh2JQpB;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B339606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B339606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fvh2JQpB
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso45974945e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 04:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793708476; x=1794313276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ftzGpP0ulPi0xGwIl3ZzcJGVoGV7Otzfx0qZQUNaagQ=;
        b=fvh2JQpBOu6cM29Ph7fUxFpEYbdaym81ejC6CL8VJiAP7BOyDllLvM8BGNfB44Hfx9
         Ozi4LlYF8HzffdDY8ExE4TxcuiTSfS+woc4hiVBfCp9+LnI4HjfhgrQ3aIqqaTspn6Oi
         In6aaRZG8QYujzoip+UPV5MJ1pSQ8dAKxjoNgE+G3aFeskF6jnD9WJI0mpMgRvFj/9D/
         ZlXMDuYgtMOVCcKICTfFYDprdp5J9/N8wJ+I9YOMZDJkvzEF/pKjgSy+p5hykfYcMGKI
         8VJQL8q3/BUTBpEeuGK49JPTRbUs6eIOrHEss+F+BtHJX0sCez5Q49zVvnB1fpwkWsnQ
         F4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793708476; x=1794313276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ftzGpP0ulPi0xGwIl3ZzcJGVoGV7Otzfx0qZQUNaagQ=;
        b=A9MxncvQ02fHNz5TYCxzEHXyvV8O/K3z1MNfwhpcODmkHRAATTu0UzDpMbzgRS4mOV
         9GHLxFtdimhbHLDCqGcmfyvLc7xj2W8BVunnXzxQraDzEBsYPoY3FE2A4TtW53wKoIDe
         buiL4+YpZTmYnaMumex+w0Q9lMkGqgB+mwcBWY7S0JPAZpi8GWcUqS+fI7vx50cICZS4
         rvDVKJyv5rOJCqOig6qWMOGlzgo/DByRLkXfrq3NQZzCa99bU15PudHoeKE6xlazxONk
         hiJNffzcPE86B2UsxleA/CDVlPj8eOry+JQn4aT5JgJ+vIX2i9Xo4phnVb8LM5+Gfa6r
         wgbA==
X-Forwarded-Encrypted: i=1; AKwUvBwk1GVPcPkwLim3nMOPAh6D016DD8bn+IysurWWY3RUiRJSMP9AmM9B4K6N3itvNBfCAZJIr3HvFiX6@vger.kernel.org
X-Gm-Message-State: APuU4Z8mpX9sTndpjcfIg6yx7+MCZxgCoyjbx10f5N3J33cuZxkEy1gV
	8yzzSmNtLTPo8R0UMONQslZ5gPhGW7gDYOdz5GBoJjR/J574EOo8zmvH
X-Gm-Gg: AYBFou3uPFTG9b07c0bkoHAJkTupMDodoMCm8RCFtkBjO+gh2jMWCEqRpR+xkDqVO1k
	4FDeunnfiP7bMy5zPE6W+IJRLQEoS/lnzcHaAc+7IJbfWg0GF8gYA/2UBD8raIrFw/nEvhkHM5L
	cswxz+7wjsLqLqdx869HBKzubfpdFGn+ucNQR4ekKRugap0IWKmEQqdKzNS8QwLsSIqmM2GdGvo
	yB7B2pveA+FXYJFbhlA6YPRPy1WQ5IDHOPlj2TZbvOjZxByKaSoObalqhs5bdnC+OrZJqdrmazM
	PFiyfLDHRE+MBrbvd8KIelW7Qyhfpx8M8B1110OobdS9+xthA/bTpbb4v/zvg9lSUvaDVPpASdv
	kKrl4lmHLyr6zvXP7ZDEvlVHz030Ijo7OIMb/gwcsvOkkglAZZZbRItgNu3JsWPwaNAd3eoGsKm
	NscSSzvlFlBil0qU+RTyFgHW9B6izlHAIz8FLtaNieV7GHNm62iSLFBKoHqo/Wl1PXkwBZZtmWW
	fQrKdVZhD3hUC2UgqF609/WAW58AcmFXfL8K88VC1bx3D9vFz+GfLjCkKH/j/IHeq+GNPMzmqEG
	AVc0zzwcXa7hBDm3QASWq520fUrAcNMjqnNBGOqW6PhyEYg7VzFl2pCkRKisvC6LthOo8oz4Y/Q
	BSAMrxAeaUoQWZ9FVYU53LC6wsZlOLJ3mcQO5/QwNJZegrKfRcbXpZkR1HNQ9cC+2TlO+mgqIp2
	jTgNTMHrXsTHjwXOO/11QcZ6I=
X-Received: by 2002:a05:600c:a00a:b0:4a2:190f:cf6a with SMTP id 5b1f17b1804b1-4ac19802310mr295970745e9.35.1793708475722;
        Tue, 03 Nov 2026 04:21:15 -0800 (PST)
Received: from uk-shared-4.. ([62.89.143.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab00ff3dsm105111815e9.14.2026.11.03.04.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:21:14 -0800 (PST)
From: Peter Morrow <pdmorrow@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Simon Horman <horms@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Morrow <pdmorrow@gmail.com>
Subject: [PATCH net-next] net/mlx4: drop the unused is_supported callback
Date: Tue,  3 Nov 2026 12:21:08 +0000
Message-ID: <20261103122109.1798144-1-pdmorrow@gmail.com>
X-Mailer: git-send-email 2.47.3
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

Since commit 557d80138618 ("net/mlx4: always create the eth and ib
auxiliary devices"), both is_supported callbacks return true, so the
checks in add_drivers() and delete_drivers() no longer decide
anything. Drop the callbacks and keep the aux device table as an array
of suffixes.

Tested with this change applied to 6.12.113 on an Azure VM with two
ConnectX-3 VFs: both auxiliary devices are created at boot, and
removing mlx4_ib, mlx4_en and mlx4_core deletes them cleanly.

Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/intf.c | 44 ++++-------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index 31860b4ab..1e136203b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -41,23 +41,7 @@
 static DEFINE_MUTEX(intf_mutex);
 static DEFINE_IDA(mlx4_adev_ida);
 
-static bool is_eth_supported(struct mlx4_dev *dev)
-{
-	return true;
-}
-
-static bool is_ib_supported(struct mlx4_dev *dev)
-{
-	return true;
-}
-
-static const struct mlx4_adev_device {
-	const char *suffix;
-	bool (*is_supported)(struct mlx4_dev *dev);
-} mlx4_adev_devices[] = {
-	{ "eth", is_eth_supported },
-	{ "ib", is_ib_supported },
-};
+static const char *const mlx4_adev_devices[] = { "eth", "ib" };
 
 int mlx4_adev_init(struct mlx4_dev *dev)
 {
@@ -98,8 +82,8 @@ static void adev_release(struct device *dev)
 
 static struct mlx4_adev *add_adev(struct mlx4_dev *dev, int idx)
 {
+	const char *suffix = mlx4_adev_devices[idx];
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	const char *suffix = mlx4_adev_devices[idx].suffix;
 	struct auxiliary_device *adev;
 	struct mlx4_adev *madev;
 	int ret;
@@ -211,7 +195,7 @@ int mlx4_do_bond(struct mlx4_dev *dev, bool enable)
 		priv->adev[i] = add_adev(dev, i);
 		if (IS_ERR(priv->adev[i])) {
 			mlx4_warn(dev, "Device[%d] (%s) failed to load\n", i,
-				  mlx4_adev_devices[i].suffix);
+				  mlx4_adev_devices[i]);
 			priv->adev[i] = NULL;
 			continue;
 		}
@@ -258,21 +242,13 @@ static int add_drivers(struct mlx4_dev *dev)
 	int i, ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(mlx4_adev_devices); i++) {
-		bool is_supported = false;
-
 		if (priv->adev[i])
 			continue;
 
-		if (mlx4_adev_devices[i].is_supported)
-			is_supported = mlx4_adev_devices[i].is_supported(dev);
-
-		if (!is_supported)
-			continue;
-
 		priv->adev[i] = add_adev(dev, i);
 		if (IS_ERR(priv->adev[i])) {
 			mlx4_warn(dev, "Device[%d] (%s) failed to load\n", i,
-				  mlx4_adev_devices[i].suffix);
+				  mlx4_adev_devices[i]);
 			/* We continue to rescan drivers and leave to the caller
 			 * to make decision if to release everything or
 			 * continue. */
@@ -286,23 +262,15 @@ static int add_drivers(struct mlx4_dev *dev)
 static void delete_drivers(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
-	bool delete_all;
 	int i;
 
-	delete_all = !(dev->persist->interface_state & MLX4_INTERFACE_STATE_UP);
+	if (dev->persist->interface_state & MLX4_INTERFACE_STATE_UP)
+		return;
 
 	for (i = ARRAY_SIZE(mlx4_adev_devices) - 1; i >= 0; i--) {
-		bool is_supported = false;
-
 		if (!priv->adev[i])
 			continue;
 
-		if (mlx4_adev_devices[i].is_supported && !delete_all)
-			is_supported = mlx4_adev_devices[i].is_supported(dev);
-
-		if (is_supported)
-			continue;
-
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
-- 
2.47.3

