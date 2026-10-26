Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.168
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793008465;
	b=5FpayJVnShWjz4/IwOs42GIAn/+qZyw7ijUGl056hHs7J64hVmc/Jt1D6r3za4f7DRZz
	 34XJg8ivIKJEzBbonbBejNyfNGCkMCdyn+c7gjpAOacM7uPRTaO84O7HC5A1p2Tj7FZ0N
	 ixqZmEJbSwzmgzYQkCHm8LNCu58XxVNc+QRMatjJMLt0Q77lvQ3HiemgSJzW1TcZq2qNA
	 AW2r0QpyuHCWvDU/o7Zk6Ywsdw/cxKS/PHGgkybztOzElVWVWqLDFtoSDD5N2qT8nQJso
	 FoO2MVQ0wmGheHPJaTbL+A29PbCI4keIWmxo7FkXHSC/CLKE+0ypbotFzQQgWHDNxjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793008465;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+CdnSQYOGYAynrzkG/QTB342cWFFcGggZ0YCcMYw7pY=;
	b=0k5Uv6xnAUU5JRxrWlNx9elAHtIChYmuvW4UY36See8v+242at2J3qkzzCkjMKCuI70s
	 CpsF2tv5+UJPWAIlAqLuw3D5cw51t8PYMe8nUxp5smxBbKHqCCUxjYbUlI79yJ/fjpk0t
	 FL2tReMuGm0DRe9yTf87F74CS6IOKzmMzel9wXOs4HlU/3ExbyaoONWzBhye6yfKYcuUj
	 ubG0ck3rq29bINdBlwy4mTfzxjKSC5Lbdcfc15oMlKiJI2VFHPmJS3xzrE+EO4A+O+gx5
	 Pam/9x23XDSlUG2HO5lsCjVnTT5CI8C9OzcstovnaQUtXXnZvKPB0Q66ZjZMtnq98LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Wb/iLEPb";
	arc=none smtp.remote-ip=95.215.58.168
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076C0606A321
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 076C0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Wb/iLEPb
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FYVvf+389IS8ZL6LsNXMb88YYC2tzhligrXA3E/+ZL0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793008463; v=1; x=1793613263;
 b=Wb/iLEPbv3K7GHUiIqw889QbfCrcH2mC+AUhsEyrBPQAXu95Lzcr2MAktRyZituMje0+6/8R
 p5VHLxnQH4i5V5S+cImVJk9HlxygorSQuP7NNJqRtxLD7Z+sPm9aEjcNPl/pZoJtGjaCu0VUjsC
 ak1GPMc6QB4m2zgg8RAsguq8=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9e2f4d0ab2390074;
	Mon, 26 Oct 2026 09:54:22 +0000
X-Mizu-Trace-ID: 9e2f4d0ab2390074
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	borisp@nvidia.com,
	witu@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net v1] net/mlx5e: kTLS, Fix missing error unwind when enabling RX offload
Date: Mon, 26 Oct 2026 18:53:46 +0900
Message-ID: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
ICOSQ"), the async ICOSQ is only created when an XDP program is attached
or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
the channels so that they get the queue, but it ignores the return value
of mlx5e_safe_reopen_channels().

If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
enabled. The next offloaded RX connection then dereferences the NULL
c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
not help, as the flag is already set and the reopen is skipped.

Propagate the error, clear the flag and destroy the accel TCP flow
tables again, so that the feature stays disabled and the next attempt
retries the reopen.

Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
Found by code inspection while backporting commit abed42f9cd80 to a
downstream kernel. I do not have a crypto-enabled ConnectX NIC, so the
failure has not been reproduced and the fix is only compile-tested.

The crash itself is the one described in the changelog of abed42f9cd80
("async ICOSQ allocation is not triggered, causing a NULL pointer
crash"). This patch only covers the case where the reopen that should
create the queue fails. ktls.c is also the only caller that ignores the
return value of mlx5e_safe_reopen_channels(); the callers in health.c
and reporter_tx.c check it.

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 337201f128958..3cc1213c2f682 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -139,7 +139,11 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 		err = mlx5e_accel_fs_tcp_create(priv->fs);
 		if (!err && !priv->ktls_rx_was_enabled) {
 			priv->ktls_rx_was_enabled = true;
-			mlx5e_safe_reopen_channels(priv);
+			err = mlx5e_safe_reopen_channels(priv);
+			if (err) {
+				priv->ktls_rx_was_enabled = false;
+				mlx5e_accel_fs_tcp_destroy(priv->fs);
+			}
 		}
 	} else {
 		mlx5e_accel_fs_tcp_destroy(priv->fs);
-- 
2.43.0

