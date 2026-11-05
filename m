Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917270;
	b=txLqRLG1bqUvz6tGMHWnqYTTYiH50CdM3x890wKM8GFWFVL+bT45dTkvIVhQftsCLOW+
	 LJfq36BNAihFmIOZeQNdkGzSd23JTAk588goeo56QAAbxt7TRlrwNXYh5hNiFVfySa/bH
	 uzMaRCFMinzKwLPA2WJmCblWAXn5tSRAd7HPSBNC8FF0xFgZxS5uCKQpaIYmigTrNtfWm
	 M1o5HS1w7VBjgsXZmH0w68eUz4ouo93u2zRkh8IU32Fw7vpgFmBIiStBQLAntIC3lNBx/
	 vkft4ihezLluuJTv2SWal5X+OcAOVug9tc58jUf6srXJ9/WPq9DE5nFEyfbuzeXvOug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SeK2ptx5a0hAbgEAKy9F6rfb5PgJz2u6yxoaC4Xui3Q=;
	b=zVEz18JuBDOFy1PfeZduZBBCFIdR78KG+2qyWV1LpvOQmNR0hexg1hTCc+jbkUUmYUAp
	 e38yyheLTemJb0C+sjYmJ3f0gVHFDkc4ADHwmlAeGi56w/bDb64Syn3tKP0DTxeq6Rzee
	 ZSzrMXqU+F7Ug7LIvH5IWCi8OrW5Y1YbhCWr643V/KIjOuj6N4gLF2gfbjrcnvftbaEW6
	 rAkrqor26Xoxv/Je4xw88ENrB31zKOEJTqvAqrGAl9LuZpZz1dLUhWehcHOdZpjzI1nNh
	 D0t3I3xy8sW1xT+qnsUjtqUei+uWah1OH/vSOMQLFmrUW7F8uIqV0FCPr0/XOp190OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tXK09pbb;
	arc=none smtp.remote-ip=74.125.229.136
Received: from mail-dl2-f8.google.com (mail-dl2-f8.google.com [74.125.229.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2EF606A339
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A2EF606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tXK09pbb
Received: by mail-dl2-f8.google.com with SMTP id a92af1059eb24-1379d236149so80307c88.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917269; x=1794522069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SeK2ptx5a0hAbgEAKy9F6rfb5PgJz2u6yxoaC4Xui3Q=;
        b=tXK09pbbOwh8AP9jNlpQhqDpUJfAjAae6Ku58Zgm44oOrfeRgdSy3UqYDB78OGEkcU
         +7aiH8UB+U/cTYuBSbGlhDQoEbs9Vjmeyf3p9O/kparVcGyxuc93925WNTKkW6a3BEzO
         kK/Sp3YdmtVRiF09ADY4T1DxgRws8BeCuiAIpg2IYjHqryzRmvfWPHfU/TX0kerBTqqP
         Z9XvevicmbaLbeiorRF3IL8ubRSPGIbqOCg8Q6r+m7CUkeDrHjJ0xWcSXEoZeV3ileAK
         XGTP86A9kpQXIAKr1zaON1csyIQLpcAgryipH13EsnYOQnbNlmrL/xzxbLANwK/Q5qrd
         5YDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917269; x=1794522069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SeK2ptx5a0hAbgEAKy9F6rfb5PgJz2u6yxoaC4Xui3Q=;
        b=P4ymiVr1US3eUGBPI3ufRGkxCchgrfw9RclSvnxB/k4fqpquOpSZ4OcdPSmQ5pc8zA
         w7OJ601FGa5iZ5RfjlAKES1PBuujRXfKzmgnjejzBDW9Zg3qxZwkElXOmfs4r8gl0Y5B
         lZoO0cn8eZltPh/1wgxRPi6d2KbUZGR6JShVjB5q3u5f4abWfbxCCJ54XRMaPzngZa3e
         sAmz5PI2JGa17rZr95Rlh9gBO8wH88AJ/A/dSYbcKjacgKkj/8RlkchB7Mo3Kwf4pNg3
         V8BRh385hsH477AK6TNuhcAQJIBuPUiZv6i/Q7ZzwfMs07W+SEcNJXlx92xPMqpOIvmo
         Y/Ow==
X-Forwarded-Encrypted: i=1; AKwUvByGAzDTJuuarExORlFZrGPO/40awfFJRlaV5fx6ojkxRIrZq6xDmwXDUcIRDQ0r/LBuwykvdnTYolC9@vger.kernel.org
X-Gm-Message-State: APuU4Z9rx8FP6yi+9eXJ94J97QdzspgxpO9/ULoc2MPZ4fcUBal/NmO2
	oHcxVQsNExbgrR+WVgCT0SKOpJiGLX0xZcFPaCinXxhlnYsWiUGdbTFa
X-Gm-Gg: AYBFou31rDZ83bLHJk67JWXhKs3Jwsgf6m3MAHKRQiiZdnmLRAX+V4OVjvBPbUAQfI9
	ZApKkOAiYpLtZJKsYSz1nQECBWL8sZPgokzjFiLPqQekZcO8yoHPCeGXFaBNns7Gv3xkm5kaIdM
	YM6tF9ipomBrgx2/v4boL+jVa2ZhH+qUpgzq3e7/XJg3Kf6vQk63KnULZ6hBY3DZeaVpWF65st4
	zz+GsnDO8c9zgJ9ys1qsZMQH5KMolXR1k9ukCeyuBBuipm1AwZnFtZXWY536xKiJsc8jRrp+WXY
	hqOWKjlNev4hth8xpVDASQtYTKpI+SgidAcjAG8WKgLayM+VCMExCkWKtvReflPFZOkv5sT71r6
	5nOGc7F4VNf9AATlulJSP2FvqsxiXzkEChlfgs7bcj7TPRpZxCacG11h9csop6PFQr1fQEXdatq
	MouOvL1SHTtAm74P15QNIaoEgWQ/ZOS5fnVkmq6Un7tPX4GJ2YHWuqUzOAagFBQPpD4tdx9E6uc
	fuXcPXjGQhb+dqqXwwuERurBkImojtJJE9E9jtaIcjXFgm9HltMGOsbJ23ngk2nhBVWUBrriJAL
	LDgn+FmAMyqTonIULhHIOHM=
X-Received: by 2002:a05:701b:4292:20b0:15a:4155:3d9d with SMTP id a92af1059eb24-1b25d37e36dmr449336c88.31.1793917268955;
        Thu, 05 Nov 2026 14:21:08 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm26931552c88.21.2026.11.05.14.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:08 -0800 (PST)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	edumazet@kernel.org,
	horms@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	michael.chan@broadcom.com,
	pavan.chebbi@broadcom.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	sdf@fomichev.me,
	dimitri.daskalakis1@gmail.com,
	almasrymina@google.com,
	dtatulea@nvidia.com,
	bobbyeshleman@meta.com,
	asml.silence@gmail.com,
	daniel@iogearbox.net,
	razor@blackwall.org,
	leitao@debian.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net-next v3 7/9] net/mlx5e: lift the netmem TX frag size limit
Date: Thu,  5 Nov 2026 14:20:56 -0800
Message-ID: <20261105222058.944293-8-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105222058.944293-1-sdf@fomichev.me>
References: <20261105222058.944293-1-sdf@fomichev.me>
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

TX data segments have a 32-bit byte count, so devmem TX frags don't
need a size limit. Set netmem_tx_max_frag_size to U32_MAX.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..28ba04bd5f4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5967,6 +5967,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
 	netdev->netmem_tx = NETMEM_TX_DMA;
+	netdev->netmem_tx_max_frag_size = U32_MAX;
 
 	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
 	mlx5e_set_xdp_feature(priv);
-- 
2.53.0-Meta

