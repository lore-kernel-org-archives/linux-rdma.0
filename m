Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC15E347536;
	Sun,  4 Oct 2026 12:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791115994; cv=none; b=i5+zvPebX6hD6XTJOcfl2EUqIT7Uy9R8zHo158PmelS1flIHXK0s6FmDYOPfX6PxRgPwTdIUYkMc4aOE0p4sUGGY5dUO+eNv+3JTbv8Y0CfzQh6hsJ5Rs9ZfikF7UAxqcScVEY7WOfiMW0SBOQHLohzwo79RoIXEAnaEqSV1n88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791115994; c=relaxed/simple;
	bh=clC3Ra4ilIlBmI1xpPqz3JnH4QU67loNKQHDk0ueN5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kBtkdL7K+eFa8eJdfPSd22jW2Ve86VBnz8e4cEBGjnzCcPWrX71spmHE3PjpKD6hF6N0GYq2jqmTdZNGwu/8SRHYN/4ADTkd+eLkBAjfzGoU9crfL5EwldGVkDg4yl1+NtqoWie++pzMHTf5fgzsK05h7ZAYyeNRMM+yetLoO2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EHZanvJO; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EHZanvJO"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4fec2680c;
	Sun, 4 Oct 2026 20:13:07 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH net] net/mlx4: shut down catas recovery timer during teardown
Date: Sun,  4 Oct 2026 20:12:59 +0800
Message-Id: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa106d50a1903a1kunm4cfc896833c1b9
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTUMfVkpLH0IaQkhLGUhPQlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=EHZanvJOzWoQk6w8US9ZuI7g86oeQL7zqCK2Op3GwUWc3puP3D9+/ClvxIOuG63XFXbNRrzmPjcfPgVWpkPxKhICQSkRBEAA4ojZdGnLGUfX/dj1qtcIVLtgiV0fpOwuUpk46H3T/Yoo2/ELpRlqLUM7xEKXrMJQ4+MRQaqdL1o=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=OUEMRtWmjylDs/HhQsxvQBKuzZdXHJDRqFQOscXEJig=;
	h=date:mime-version:subject:message-id:from;

The catas error timer can rearm itself while the device is being
stopped. If poll_catas() is running when timer_delete_sync() drops the
timer-base lock, it can call mod_timer() after the deletion. The delete
can then return with the timer queued again, allowing a subsequent callback
to access teardown-owned MMIO state after it has been unmapped.

On PFs, poll_catas() accesses catas_err.map; on VFs, it accesses the
mapped communication channel. Use timer_shutdown_sync() to prevent the
callback from rearming the timer once teardown starts.

mlx4_start_catas_poll() calls timer_setup() when device registration is
restarted after reload or port reconfiguration, so the timer is
reinitialized before it is used again.

The change was validated by source review and a target-object build.
Runtime validation on mlx4 hardware was not available.

Fixes: ee49bd9397cd ("mlx4_core: Reset device when internal error is detected")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/net/ethernet/mellanox/mlx4/catas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
index edcc6f662..62574b790 100644
--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -305,7 +305,7 @@ void mlx4_stop_catas_poll(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 
-	timer_delete_sync(&priv->catas_err.timer);
+	timer_shutdown_sync(&priv->catas_err.timer);
 
 	if (priv->catas_err.map) {
 		iounmap(priv->catas_err.map);
-- 
2.34.1
