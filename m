Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514591;
	b=gZWqgUNeqEpAGX7fwNsZGRl8P//dK7HdHNomvLXgng4Fn/ZAqf457R+1VG2Wxfmf7oJ4
	 6aq09IrrE4IknYYADJmtbSCztVZ8gyex5rFtRXu17wnf3MLZ/3oJM+L1wWgg5p32l8xXF
	 MGVBXTj8dbsNph1Y5kECS9BGVxG+i3SGXhN3QGXPoBPKzoyclE7si/M0Y7v4e/kL1zsXP
	 jXHQu8f7vLJuUjaWeELDIdHmvLX6O/kMGG/d71yfs6EINQUBd38h8sIjoyHHz9xXK3J09
	 hoaRczNdNh8T1DBnDcZkOcW/c8kxKfg183k5W5d90I1l+hdgRl71+scMrKC1YAuH4ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CdlYPARhuT5EgLufL/ZQ6dU/20tseBOVd7fjLCxWlSo=;
	b=Oe8v3Iw00c+4ylQUPNWhWC3UXQ5vFP0iv/0y4fNVvpsstP+O0PY58CF7jsK4zg4CP/Ke
	 W91oY7OkqE89nmiXSULrVILM0Esa6w6zlwwflNroOHlhshNpKmJUV49vbD7SD3qWjRIvI
	 mjx3UWNJufYbpr3JEuYsKpjC/UvHDyhX9LfHwa8xIksRHo9kMvurNTU9yBkAXCvcOjSe4
	 Cq+zxxMNzxvMKshC3g2E4ZWkrDgCpul4Ru+6Po3WgfaXQwPyu/p8YDaXpql0/3zYg/kF0
	 tjQ9qbolmjIXogKTWkilr1SfKkoZflfZoA3J5Nu8LcrM9ZfyjXep+Kg93N3Kf1yKKnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=p10U2UEo;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650C860A2604
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 16:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 650C860A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=p10U2UEo
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so24056975e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 09:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792514589; x=1793119389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CdlYPARhuT5EgLufL/ZQ6dU/20tseBOVd7fjLCxWlSo=;
        b=p10U2UEopDR0Q/Yj8jDVPbCso9MIg9ixUZiZzxfdCSAisf/I/blQW1TgxbbPL0VOLq
         R47u8hZFr5snKKUmwksv1uvElX2vsoAik6jLR7tNX4qWTm2rdPCadETL+3ufuFnxbegj
         yR1FRzFy9sluZ7gA3+va6d5yxbXdBI6KZzNjBJd/VX2fq5JBcX3UpoxT8lwSJ9zjrm9Y
         L/7FR4TnzkWqTYuT2jP8fQXlxU3cXhfOYJBWds/snZB/WfjMjc3NxEFbzOHzFYuu+7u4
         kutmn7XgWl/H8tDTNAu0m7FEkhfi8jNE+xaYIRUJvMXpojOwP2iaTkBS8BabWkM3/3sk
         2MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792514589; x=1793119389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CdlYPARhuT5EgLufL/ZQ6dU/20tseBOVd7fjLCxWlSo=;
        b=HmcpMv13xj+d+ZrJJN+2/sFSSSXKZ1Hdxoe4dJcQzGflCFPIJbtQLFSxP4Mduc3G+J
         QG236zMCjz1DzxMkl4IaU6AgKfNOd7v8QHPmvr97U3jGNpNQG/29CMUevoKe1+70Nkpp
         bAm4PkTLBAWPgaShwqZssQBcfom8jce3zAUaFiu2g4YGuWSD5TmZJAyS+sRfMplvQmQw
         /gDzmdkqHSRm+L7MX3RF85zZtOYGcC1JzB+Zbcpm2fLCU/lPww3wKLJZm6WRcthG04A7
         Ivbb1uHvSvr9ipBQdlRvrmNGacwgvBUi/LHUO+CxTagkqmUZiSm44h4JAofFXjwPW2pK
         1MLg==
X-Forwarded-Encrypted: i=1; AKwUvByTMmvtNgCW5JKESVrID0xdV3aX/+jHBGlD7rDi9xli9PGCv+YOV+oftTx+TC1Wk6GsI8NeUGOP5Xix@vger.kernel.org
X-Gm-Message-State: AFq9FYL0W9ybWsGeDT88AODpVc0op2almGyfr4L4snV3B1SbmKawil0P
	7Gek1105blsRmc6EjuCx5uHimA0FzFMj3OAMRqgFvz6QByYnGq1CuUQ4
X-Gm-Gg: AYBFou3ZPHf9gsrBfe33cxj7FUUcrz3DgDsPxj+AryOdF8Mv2c/GVpJ8vFWwdE2Iauu
	UYT6mZvlshQ2VIMTBbt0bVVEK+UZFDyfWGDTh3sDVvH3NH7Xz5g+hupuQVV1aE7LC31i+PdTVLT
	RxZBXzYRw/Cu9CpwAZzpPTjGP45eg/ZpP+0rwkz63NvrvWGYIFRnBmT/KYwnKkdk+TJW0c+etxQ
	OxU89dfwtGD7o7M+xua/z5xswVtqU84ClQpYXkAS/0jkCswtA3qdtLzJfVZfF3ZNN4r7y5ifuVA
	Ntitst9gHJPfaavZD86dQclfqTOvQQgvFkTrT+G87FzKH6j4mekqt9LvhzP6mK2qfp8oNoFanwc
	swO0+UQKSo4eoSS4fxfAQBHWoG5wh0BbM6BYzOSWtMxGCDEU/zme4qqKwz4qGOu/LU2bSsuJlHj
	P87gTIWEihBG9i+uIU/TQN+kDDw/3itAxhll3g8vMdKs9LThq1c4n92blLrzBH6fuXhGiI3lvgQ
	ET+G649sUc0R5rONWZFiFwYxNkAkO2dLZcYzMnVaaJIDCgZIzMO5VB+Nl9mVhVdoPv5S0oWrE5J
	1jj1aThKY1FswVxNjYNg5zVpLggEFqjBKDqJW52+9DCWPXMg2UiDGEBzsBX+eXYAyGuPgF9i
X-Received: by 2002:a05:600c:46cf:b0:4a1:f8cb:7d70 with SMTP id 5b1f17b1804b1-4a1f8cb7ecemr44109325e9.24.1792514588519;
        Tue, 20 Oct 2026 09:43:08 -0700 (PDT)
Received: from p15v.lan ([217.169.3.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb864dacsm8742505e9.12.2026.10.20.09.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:43:08 -0700 (PDT)
From: Peter Morrow <pdmorrow@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	regressions@lists.linux.dev,
	Peter Morrow <pdmorrow@gmail.com>
Subject: [PATCH net] net/mlx4: always create the eth and ib auxiliary devices
Date: Tue, 20 Oct 2026 17:42:39 +0100
Message-ID: <20261020164239.3808903-1-pdmorrow@gmail.com>
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

Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
an IB port or a device that advertises IBoE. Before it, each mlx4
interface was offered every device and decided in its own add callback.
mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
for raw packet QPs only.

ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
packet QPs, then cannot open them:

  net_mlx4: cannot access device, is mlx4_ib loaded?

Restore the old behaviour by creating both auxiliary devices for every
device and letting mlx4_en and mlx4_ib decide in probe, as their add
callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
ports, and mlx4_en_probe() binds a device without Ethernet ports but
creates no netdevs, as mlx4_en_add() did.

Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
eth and an ib auxiliary device, and DPDK attaches both VFs and passes
traffic through them.

Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
Suggested-by: Leon Romanovsky <leon@kernel.org>
Assisted-by: LLM
Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/intf.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index 82e467c..31860b4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -43,23 +43,12 @@ static DEFINE_IDA(mlx4_adev_ida);
 
 static bool is_eth_supported(struct mlx4_dev *dev)
 {
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
-			return true;
-
-	return false;
+	return true;
 }
 
 static bool is_ib_supported(struct mlx4_dev *dev)
 {
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
-			return true;
-
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
-		return true;
-
-	return false;
+	return true;
 }
 
 static const struct mlx4_adev_device {
-- 
2.47.3

