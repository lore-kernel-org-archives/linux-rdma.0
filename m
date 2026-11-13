Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794542609;
	b=i2tS03p7hB0lwWv+PV6AN5C5WzU6vSPQc0LEsZ5mKlNFz9JP40KNKY+Jka245XPpiXcI
	 yc517M7umC8SUd0IpM0iHoXbpY8vLyEVWdteIstFJpfH2UAHzOBXQ0YGP0Pj6jfZxgilQ
	 3b8vnfHcVpSMYxDjO5SbZW6i1PKOUlQshaSlXpE8ffrVP6FDcHQPHtUN5FLHftLjEzktK
	 D2KRfwpeHBVdmP1/YqOqe8qV6zdTA6ls4PrrzGra+f2N6yEFLUl3G82kelpw+FiVRwQeh
	 CLfg7XuB2/A1D1qhKrxObhX8+i8NXE5Zrms4uvalJL6U9Ab66zzVo/T5YItl/DUNSGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794542609;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=h3VfCHvLvqBO4sImZGoV5l6BeIrK2r9kHf+KVVKvjY8=;
	b=ek+FFBIAXPKFGbdHoBDNB+CRHtqq81PmUNutPw13n3s0AGGz6+ILhZGo+btxFc98p47A
	 6J5vAZn4ik+IiCt9jG1lxiuX30gbFRJqA+0epHMDa0Cmg482DfXm0iWMX9Ym64sNTIyGX
	 XvcV+VJaYhAXZrtMTNPGSqH/EIj/ytPlECvFl6J+hZeHzSY4ucihGIJP82r9P5YJDcPUk
	 8Q4ZyN5CBLdHXlPXbrdXUm9J4v+mVZuj/lBvG9pR6u1ZY11NyOXE3acGWA4umyHxooPq3
	 2EzovkEi4qk8PRBl3Y2Ms6WEXdpz91SN0Gvu4h80YVSO1v+Rl4NuxMeyYDjMmSItg6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vHwZtRru;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6045D606A327
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 04:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6045D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vHwZtRru
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91e98301805so9859446d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 20:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794542607; x=1795147407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h3VfCHvLvqBO4sImZGoV5l6BeIrK2r9kHf+KVVKvjY8=;
        b=vHwZtRruk+RPcP4KnyJvGie743X+cb87JYRyMRIztxJcSvzuMGOg2/QY+mafApaTKY
         WZGKPjjzdXPJ6L8lamwekoV/8UeypJJtGuzE3HKrUSNgpZEYOPqL+zhOxQuo3ihjpIvF
         CDgcnEf4pWI1kXbDbUkwLfbFB14yAGtXx2LYcHTK2HtcnYvkBI8fqev/iKw+F8noMYTx
         oOWuym4pWtANXjlM37wyRJ98J3uuRRJ0/eCqrKgDEXt5tPgMgpYyi6Pw0nRkrgNN4DQb
         v2FVbTAEgF/RLYmTxDAsUV72yuxQbZj7Xen9gafXdKTXG1J7HG7OziCMfo6M6s0fbKHq
         y82g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794542607; x=1795147407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h3VfCHvLvqBO4sImZGoV5l6BeIrK2r9kHf+KVVKvjY8=;
        b=ieVzuYBzp4HNoN+9F+lA3GZkyyHGYBLwqTxbbJSYnEWjuxTr8k9yeF7/m2IQWq3nuF
         ywV88RM7NWcd+hYkh9vkdctdurkv2M5qUGpCmjpVs5/q2xbiBa7IJwiI1Xsc11u3XeWv
         bzY+KhwMQ8GzA8WvaPKNWqK/lCiUjSc/XCij0TkwYr5oEfMp51jSfjrh8ZKhUEhLXk8f
         hiqbOi27D/vZ2PI05VuWoAzE/sONOk5TKW/7dHS3BIRjdLl6QFEoX5yobxtJxRlDMNK2
         F5Y1iuGL9dnb4DY65Rykwxl1yQ2Gj//u4E4zeTEEpkFRHP2hZOaNxkNlKemKxKkdNZAU
         5n4Q==
X-Forwarded-Encrypted: i=1; AL+hErHJRneNfWWJpuLa3wOh4mTGv2lTSh+rnSMRFRL5VSIJa9jqpnqkXS9p+1J7Gvb9Zquao4V3gzxaQn7Y@vger.kernel.org
X-Gm-Message-State: APuU4Z/ys0lJrewSUlmJmd6bn4bEbIk2g12QcKL9E1ZeHueCWuf+8JHc
	YoWQtHwJGwHxs2Ch6hd6U7roHyoyXEIUkY/C212fJQfhMb6FCSj+eJMj
X-Gm-Gg: AYBFou0bExXWF6rSq3lMOX4hixj8sXGdfuaVHfnuv/Jw5T7T2E9HeTc2elI+dayfEbe
	+uVZr8GjmU2rkKJtxU7Ob8MwdGlJGyooPSrmYBFO11AZfL+T6lJnwzMnXSEqVV67JMaih2+iyPa
	Y19yTJ3WyAMnlKku+UuQIwz5BGfyizsxYamXjSyzQuWwwvlY6I8ulm9Bb/8JDByX6KkbLSxMCep
	2vr4dwjsjM2zKpayP9ZyLNHCcflMXz6J7u7NcoLd7xuKBy/ljAK0+k4SPQTYPmLZas1GOD4Nwwa
	LW108LXT//Q+dMlF9VJZnp626t61hRaSCBP0rin6SbBPXt3wGO6rtx3GbfeXueJaqL+xiRPadNo
	s5La5jn8qTHSTOVR+TtatmuuT7P6PiOmcZgX/QsqNsdWWyDMEi6WC/S0Xr1yb7Ig/bfXFAIwYKI
	XC31mIgGOaGI4n1f5bckAqkReTO8FOUlJ/dE5Cijfr6avFoqTRpZOfelQ+mPZBTBs0apN6E+ChZ
	Vcw2clOc8zS6C+1kYfuDLfnaoaTQKrdaR6fbj3UCPEjpg5Bjai36bo8hrzSbWVZTcEBUo6orIB5
	kNQhgKqDP8VwObt2RaIAEWfPKVrQ9knYDGheVtoL4jdYw/NBVeh203f5gN6P5j+u1OV/6nipj0B
	503cfqmqiPc8fUMX/D3vF
X-Received: by 2002:a05:6214:850d:10b0:91c:60e8:a8ab with SMTP id 6a1803df08f44-91f241f6b64mr16509716d6.37.1794542607209;
        Thu, 12 Nov 2026 20:03:27 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db49c5sm11193506d6.41.2026.11.12.20.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:03:26 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net] net/mlx5e: Hold sync_lock while resetting VXLAN ports
Date: Thu, 12 Nov 2026 23:03:23 -0500
Message-ID: <20261113040323.2090829-1-lcy8047@gmail.com>
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

mlx5_vxlan_reset_to_default() walks vxlan->htable without sync_lock
and calls mlx5_vxlan_del_port() for each user port. mlx5e_nic_disable()
and mlx5e_uplink_rep_disable() call it after rtnl_unlock(), so the
udp_tunnel_nic work can run mlx5e_vxlan_unset_port() at the same time.
If that removes and frees the entry saved as the next one in
hash_for_each_safe(), the walk then reads freed memory.

Hold sync_lock over the whole walk, and add __mlx5_vxlan_del_port() for
callers that already hold it.

Fixes: c5eb51adf06b ("net/mlx5e: Fix VXLAN synchronization after function reload")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus MLX5_CORE_EN and W=1.

 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index c2292cab4592..b953bbc4925c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -121,25 +121,29 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 	return 0;
 }
 
-int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
+static int __mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
-	int ret = 0;
 
-	mutex_lock(&vxlan->sync_lock);
+	lockdep_assert_held(&vxlan->sync_lock);
 
 	vxlanp = vxlan_lookup_port(vxlan, port);
-	if (WARN_ON(!vxlanp)) {
-		ret = -ENOENT;
-		goto out_unlock;
-	}
+	if (WARN_ON(!vxlanp))
+		return -ENOENT;
 
 	hash_del_rcu(&vxlanp->hlist);
 	synchronize_rcu();
 	mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
 	kfree(vxlanp);
+	return 0;
+}
+
+int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
+{
+	int ret;
 
-out_unlock:
+	mutex_lock(&vxlan->sync_lock);
+	ret = __mlx5_vxlan_del_port(vxlan, port);
 	mutex_unlock(&vxlan->sync_lock);
 	return ret;
 }
@@ -185,12 +189,14 @@ void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan)
 	if (!mlx5_vxlan_allowed(vxlan))
 		return;
 
+	mutex_lock(&vxlan->sync_lock);
 	hash_for_each_safe(vxlan->htable, bkt, tmp, vxlanp, hlist) {
 		/* Don't delete default UDP port added by the HW.
 		 * Remove only user configured ports
 		 */
 		if (vxlanp->udp_port == IANA_VXLAN_UDP_PORT)
 			continue;
-		mlx5_vxlan_del_port(vxlan, vxlanp->udp_port);
+		__mlx5_vxlan_del_port(vxlan, vxlanp->udp_port);
 	}
+	mutex_unlock(&vxlan->sync_lock);
 }

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

