Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id CB189331A6E;
	Sat, 13 Jun 2026 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781365067; cv=none; b=IQLCD5o6XSVxmZ7x/+tK+Gg7Z5Qla9I9Kcu+4icSTQKj9RXqm7TWenzUYTvOj+9FoITbcjbBcdPR4JsE9uCVqZEPmc7gOuHHPyn7LVVRcSsCF1Cg8iGCxzlw0NTaE2wdg+OvheN/UFVd3/DPUdyBDPHXtJ4CiSbhQEUuHLiqLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781365067; c=relaxed/simple;
	bh=hB4utEcg5DjrWCXgLLzL3q7GXevMHduXCwAN7h7N4oU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KtJLc1tFjVzIqOB9SZr5G4nf/hxCUSPiPpe18kWIwcq48GcLBTJD4qVZ52nIIaPhZ2nAPzN4Fgjq4d7G8AKtdeKIEsFvVTPZKksGWQnrYvxFsNoI3xizoDppAGIg/DFCFiazsLN+HD6PDfdq4/2TqiXJiHUVxpqPUxNmN+racyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=MbooNwmE; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="MbooNwmE"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] net/mlx5: Free steering tag data on release
Date: Sat, 13 Jun 2026 23:37:25 +0800
Message-ID: <20260613153725.1874-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1781365053;
	bh=IixFVhPxXR+ixIEBOuwRXxrJCVJP5M7SH9DCvrv4WrA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=MbooNwmEUjyEi4E/o1HYiSCntd+oe/60efzWdnvC+uqhK03w1G8DPqZWnStE3ELbg
	 LSBSQQOIZWx2iaGLNAhPsN8d3MYB6GS9ooYQlH3QbCTSlY8cF7UCOLz0kXfdwXqM+B
	 Tga43t3CvsVqkr/+duadII7mcuf0Kxl3QlYBK9xw7puhFC+cFM2i293+kYRHhZh82/
	 i/PPSuHqYmiMIQgZ3wKDYukijIVf3UYoSi1HtDPxP84EZtYFy04eLYmZgoQbglJlU6
	 67+hqGIUg6HJp/OF4DYhCIC5Bmq1EtG8oPKqj905ebq7dKo83hdUAQLigCGYftO5kN
	 mNMXcj/g1wV/w==

From: Li RongQing <lirongqing@baidu.com>

mlx5_st_alloc_index() allocates an mlx5_st_idx_data object for
each new steering tag table index and stores it in the xarray.
When the last user releases the index, mlx5_st_dealloc_index()
removes the entry from the xarray but did not free the backing
object, leaking memory.

Free idx_data after erasing the xarray entry once the refcount
reaches zero.

Fixes: 888a7776f4fb0 ("net/mlx5: Add support for device steering tag")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
index 997be91..7cedc34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/st.c
@@ -175,6 +175,7 @@ int mlx5_st_dealloc_index(struct mlx5_core_dev *dev, u16 st_index)
 
 	if (refcount_dec_and_test(&idx_data->usecount)) {
 		xa_erase(&st->idx_xa, st_index);
+		kfree(idx_data);
 		/* We leave PCI config space as was before, no mkey will refer to it */
 	}
 
-- 
2.9.4

