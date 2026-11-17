Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794885109;
	b=q7CDcxPVirfoT/1820Br6yjv2N7fERqO/rc5Y8xF0Er9GejVPDGEyBlvRSZJu4G80zRK
	 klrxIHmkffXSqT3+tl5YTjsqKRHmjPLF8Cyc+c21w/lL3W0JxWFY8z46m75VNKDhAUavm
	 odIqFbFXrAgwOTE+zxUUJwPC9IpWgfW7aV7DDDq4qWcKmt+ZaQ1MYMlUTc5WFvZTr75GC
	 qp8OuLIK9aYuGNLWNHlGavjug9GDzbYI51BBf1AsmKVGPFsI4U+ho7MyM0F+wCFc03Wb8
	 lB2lzFdCWIYRrNPNYDkIVC/i/Do92r4wA07vbTjmNBrHpAuOYqtFhpGsC9n4r8aHGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794885109;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3oEyXkT10pdH7P7mR2+WY3w5NVnu5TROP12ldyy9kHs=;
	b=zsoBrkfyHPc4Atgs4KD89F9gV8sZhn84vAqRvGMfdMWeTALU/FdHtitkkDH7HNVJibmu
	 JtsE8gYNe0c6QxekXozNUS4DzIH36dv6GULcWe8uj+XYdlLxLKAc3sriRyg1KqUTYYOum
	 kvyseJNWSPBzRXqntI3CKMYEPFsfkYsW0cdftfFsXHKfaZyzUDEwgupSQ+f10Jmd2rhtf
	 A4ztGFL6+ysKDk3BF/GTAXf8ua3JZ+9UknL+88LG1nwCzX0MsZtNs1tpzYz31aQRqoF4l
	 DIdaYAeYDaj4saASiE2FDM9fKw3WpQVW7d6XmOtDHrzivKEb7wDZzk2T6WpG+FZKfOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CkinACuk;
	arc=none smtp.remote-ip=209.85.219.51
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0800606A887
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 03:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0800606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CkinACuk
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-92105225913so134496d6.1
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 19:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794885108; x=1795489908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3oEyXkT10pdH7P7mR2+WY3w5NVnu5TROP12ldyy9kHs=;
        b=CkinACuksaJtTkDpqUFv9vcV5g/yL9gClGFP+pQzi4I/aiNiVxkM9zLrBjZE1SQqOo
         UVWbNftox6mz9HF5fRLW9piEVzz4vsDeS+rXIJFb/4FbtH3pz8FE8gvmNP0j5Ue6Whko
         L1C3UQSOZocMl4+eRqgH74dFAhssAqTbkQug7ttn8nTZEg2qYfxGv8FWfYeFZBXtw8cc
         AX+GBM2IVXZdNGNG6wWdMOFpsdy+LGeWo+iK1AJsOqoKvNqLVLKldPzeamFXM7RfXvMs
         QcHnrFDy/PkPA0bzH2Gy1JNPeu21B7Fe62Q7U3vQkEmdxdlgm/leMac0pF7hlviS1nYL
         Ea+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794885108; x=1795489908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3oEyXkT10pdH7P7mR2+WY3w5NVnu5TROP12ldyy9kHs=;
        b=kmE5UM5IkYCGruuzv91UlSKwaklSyzqzFc2p5RdvyLgJWymUG63lplJJoWOzepLX9j
         Y0nmBOKRDcaYise7u3ohp0vzqzC7gD/IpsWpafqmZznIFXwg1G29WiapVf+qpeeg/bDK
         56kMOvOhdLenCIauE2HDEsv8hu5dcj5VEOFwmERu/1xP6M1SpEl1gkAfiLb6+4hF22/H
         8lE3wKn3U2OskN1aBgXqj+16mYD3mSmGoAtfAed2yWUKBNW4S+t8Y08Xl2pMpBIHIQmE
         Y1OYlQwEjHG/58DhTUwntc6ZQyKHwupka9luUlozFOt35k11umTZoJeX+iXCMmOpESKu
         MiPg==
X-Forwarded-Encrypted: i=1; AL+hErERhevwme06bEEMMkGZz9F9UrZJyxrzcVR6D4cqcLiF4U0LTa4/khWYH/04bp9g5u+QDPqT3PCYXD2J@vger.kernel.org
X-Gm-Message-State: APuU4Z/iX34Aw7gS6q8DOeQ7rN0vuFATkhQiw/uSRtmZ/b9AgTnbQMiO
	RU/1s0Gsl6DPL1CVGT42QYJtsVwr7OTj2dGWfsbLQyXiA4dGNfEK8wpB
X-Gm-Gg: AZFdTZcRRurXjvVFfRAafXbGNHUIYqQZ3Vk5XnniSEHjda/qTMQCZfFH+2c+OTDrcgz
	50XpYioVyjGn655oG+BvDa1tVTdW0dkL1j/YvB16pyrt/+ugxc7ZtMfva8MzuXgp+Bs8wOddl7c
	ULdrCIstMyTY2jGykUujvH7kSL6PZIpw5mMZGinyNusKFrVF8lAuJGGqQ0tc68If4l9Fw8WZMIq
	CTd7L1oN3szj4LyDSTTpwalnbqef5sitGwCjXmwdBu2daqZ8SRnzM3BsMmr+5rFAxrK54SE+54b
	xeYsez5oCKIscQdBfxdhA0uyxKcKRf5r1Dph3FfnhGWJIVkg5hMxqnDzsblxEt3sWdk6aUweqew
	yLsLXwX3iBditjrVQ6xe2s+5425zVg2h1dez0uxGqEgaYeINWneWgWVEITqAstBcBbcGA92g1RL
	eIsj7NG/GZCKunEeUQyE7RlRuyndv9SWQ040DkCmY5d+8N9OU5NfE4YQP1b7vdU01owOwJDHfpS
	1jTI5Z/YSQL7qJaZCvxfu0KROoTKKBJU+qHQQmIVDkx49Na+P+VdzWOxgymiEBr0FScNwv0MhH7
	svi/d470qFjwfuDVYdzXZ8ykYOfM6bVA61gfrUmAJ/zEuwV8QZX2HOGnln2No5M07CAlPkGevLU
	=
X-Received: by 2002:a05:6214:dac:b0:920:f523:a79d with SMTP id 6a1803df08f44-920fcaedb93mr24717456d6.12.1794885107860;
        Mon, 16 Nov 2026 19:11:47 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d5f3e4sm101713436d6.16.2026.11.16.19.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 19:11:47 -0800 (PST)
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
	Parav Pandit <parav@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net] net/mlx5: SF, remove probed SF devices when arming vhca events fails
Date: Mon, 16 Nov 2026 22:11:41 -0500
Message-ID: <20261117031141.1720619-1-lcy8047@gmail.com>
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

mlx5_sf_dev_table_create() queues work that probes the SFs which are
already active, and then arms the vhca state events. If arming fails,
the arm_err path stops and flushes that work and frees the table, but
the SF devices that the work already added stay on the auxiliary bus
and in table->devices. dev->priv.sf_dev_table is set to NULL, so
mlx5_sf_dev_table_destroy() returns early later and nothing removes
them, while they keep pointing at the parent mlx5_core_dev.

Remove them with mlx5_sf_dev_destroy_all() after the work is flushed,
as mlx5_sf_dev_table_destroy() does. Move the helper up so that it is
defined before the new caller.

Fixes: 4f57332d6a55 ("net/mlx5: SF: Fix probing active SFs during driver probe phase")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus MLX5_CORE, MLX5_CORE_EN,
MLX5_ESWITCH, MLX5_SF and W=1.

 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index e75cbf333898..44f6292ad59e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -328,6 +328,17 @@ int mlx5_sf_dev_notifier_init(struct mlx5_core_dev *dev)
 	return mlx5_vhca_event_notifier_register(dev, &dev->priv.sf_dev_nb);
 }
 
+static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
+{
+	struct mlx5_sf_dev *sf_dev;
+	unsigned long index;
+
+	xa_for_each(&table->devices, index, sf_dev) {
+		xa_erase(&table->devices, index);
+		mlx5_sf_dev_remove_aux(table->dev, sf_dev);
+	}
+}
+
 void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_dev_table *table;
@@ -360,6 +371,7 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 arm_err:
 	mlx5_sf_dev_destroy_active_works(table);
 	mlx5_vhca_event_work_queues_flush(dev);
+	mlx5_sf_dev_destroy_all(table);
 add_active_err:
 	kfree(table);
 	dev->priv.sf_dev_table = NULL;
@@ -367,17 +379,6 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 	mlx5_core_err(dev, "SF DEV table create err = %d\n", err);
 }
 
-static void mlx5_sf_dev_destroy_all(struct mlx5_sf_dev_table *table)
-{
-	struct mlx5_sf_dev *sf_dev;
-	unsigned long index;
-
-	xa_for_each(&table->devices, index, sf_dev) {
-		xa_erase(&table->devices, index);
-		mlx5_sf_dev_remove_aux(table->dev, sf_dev);
-	}
-}
-
 void mlx5_sf_dev_notifier_cleanup(struct mlx5_core_dev *dev)
 {
 	if (mlx5_core_is_sf(dev))

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

