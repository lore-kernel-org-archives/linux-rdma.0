Received: from mail-m8122.xmail.ntesmail.com (mail-m8122.xmail.ntesmail.com [156.224.81.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0ED39891E;
	Mon, 29 Jun 2026 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.224.81.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715271; cv=none; b=m3uKbghZr6R0bH4x6FCmezMQlY0FXcXKqglAE49Fj9xbe1pgWA446e+x8VsEwqHDjNFacCY5LynzvQvLihTGeJTwzsok6EfeLsAkg714fcgAfSyql/xeyY6XCKY3hC4ife/nAuJKYzdC72K5+yg+SJEVVqKRSJdp2w6GxHODc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715271; c=relaxed/simple;
	bh=yfs8+bMOUbqTUuh24TuXA2WJutNxxonltXfrlZiI5iE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kJv676usm/TyrC7pR3J1HhzZOaK5zoE2HLH/hOoysKrmZlEFKkVbJvv7HxHoqI80J9Y45fB6CMCIN8xAXihUZDvyJbNEcWdwgROOKfdiKRDB/D9J8eecxd6eVS3esaoxFhj4OLI41AmekM0hMNmPxDu9dh0TFoI0UhF/gaZ2nQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=cg7cOhvE; arc=none smtp.client-ip=156.224.81.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="cg7cOhvE"
Received: from DESKTOP-SUEFNF9.taila7e912.ts.net (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 441fe7671;
	Mon, 29 Jun 2026 14:40:52 +0800 (GMT+08:00)
From: Dawei Feng <dawei.feng@seu.edu.cn>
To: saeedm@nvidia.com
Cc: leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kliteyn@nvidia.com,
	vdogaru@nvidia.com,
	horms@kernel.org,
	kees@kernel.org,
	stable@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	zilin@seu.edu.cn,
	Dawei Feng <dawei.feng@seu.edu.cn>
Subject: [PATCH net] net/mlx5: HWS, fix matcher leak on resize target setup failure
Date: Mon, 29 Jun 2026 14:40:49 +0800
Message-Id: <20260629064049.3852759-1-dawei.feng@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f121bff6d03a2kunm0b532ae5167829
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHh5OVkodSktNTUtDGEwaTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=cg7cOhvEzbulZL53noFNqlYXEefydojZqYXcwUrt4F66QBc1PC66ANOY7Z8S2/ugU1n3OJLs9wlESI9PheqS5YWlnwmNPHhNreMjzu0nbf6z7VrwUpldug3vAVVUfFxIWnzmMDiFHPDGOh4V4/rfYtPjpaHIl6y5xjyaIvEL+bo=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=yVyDbdz8sAP2Avj+M0KEYVA5YSr+NWDHHtNxtisYCrI=;
	h=date:mime-version:subject:message-id:from;

hws_bwc_matcher_move() allocates a replacement matcher before setting it
as the resize target. If mlx5hws_matcher_resize_set_target() fails, the
replacement matcher is not attached anywhere and is leaked.

Fix the leak by destroying the replacement matcher before returning from
the resize-target failure path.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
mlx5 HWS-capable device to test with, no runtime testing was able to be
performed.

Fixes: 2111bb970c78 ("net/mlx5: HWS, added backward-compatible API handling")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index eae02bc74221..3bcf412a08c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -205,6 +205,7 @@ static int hws_bwc_matcher_move(struct mlx5hws_bwc_matcher *bwc_matcher)
 	ret = mlx5hws_matcher_resize_set_target(old_matcher, new_matcher);
 	if (ret) {
 		mlx5hws_err(ctx, "Rehash error: failed setting resize target\n");
+		mlx5hws_matcher_destroy(new_matcher);
 		return ret;
 	}
 
-- 
2.34.1

