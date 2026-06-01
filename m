Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9B38AC61
	for <linux-rdma@vger.kernel.org>; Mon,  1 Jun 2026 10:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780308068; cv=none; b=gMRoD0RG+kgxDkmB/Jd+jsmXuyZsVlhyy0kb0/dXjYZz0OrfnbJwAx51+fi56M+9rmYE6VbE9korHpTmsQZQhyqjrauRK2+OLrJeb0x2wgMDrVU6qlsTRJY9Ad3YUr3gHt8TIbBfmNp6eXrakQi593RNLfxZIFgERW5pyOiTVTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780308068; c=relaxed/simple;
	bh=30uaRlsCN52zwnJzNQZoTrQlcipKMlHmLsqMXxf4MTo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hiUA6QTK+cQTbAAfbTkfpdHJzZ3aHbHKntvI2phGHK0vGt2p1RLoqs6NtN3+MRSWLHDhl9hgEvIcefvkUhKxQLSHuw9RGLOoP450S8GnFM0x/6br8StxofoR0P2pSkuU8oNq5nPTxgmJRW7nK28cpRREopoDZ/tkdEofG553SN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=opt/hOsL; arc=none smtp.client-ip=111.202.115.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="opt/hOsL"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Mon, 1 Jun 2026 05:58:18 -0400
Message-ID: <20260601095818.2227-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc2.internal.baidu.com (172.31.50.46) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1780307918;
	bh=EeLGS8U1QP4Dq5W0kdd5fRDmzk5u9Mfjz2w+GQA8Qyk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=opt/hOsL+zIQT4Qy0YBICGjXjCuVuYW9is5OiQopACkfLNMnoh6MmdkoUFFtiVJ/V
	 8ogHsuiWeZxTGqEt7/+R8JVvR6zuYwD3j+JVS3VmHkIxLahnrygkvs6ziyoIXzB3i0
	 4n4dPdq3+nooQpwmATZCmJzBuZvSQG4XF/w6tnvTCHoOUOlb9cf/CFM+nH5YMILf3M
	 z8TdQZY77whiyKFv6YgxHT1c3A+za29IuOwDXjFAWOFfwFaBBxD+bxoCKsVKMk/l0B
	 Omapv0DVBKNfgb3YKnIvWnNXDA16CwMGgHVuuYlmd/zA8fO5aFXjfKYlAmTdmp4d0c
	 x9ix98z41gFNQ==

From: Li RongQing <lirongqing@baidu.com>

In mlx5_ib_enable_lb(), dev->lb.enabled was unconditionally set
to true even if mlx5_nic_vport_update_local_lb() failed.

Fix this by only setting dev->lb.enabled on success. On failure,
roll back the reference counters and return the error.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c7ae46e..870f00f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2023,6 +2023,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -2030,6 +2033,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 
 	return err;
+
+err_rollback:
+	if (td)
+		dev->lb.user_td--;
+	if (qp)
+		dev->lb.qps--;
+	mutex_unlock(&dev->lb.mutex);
+	return err;
 }
 
 void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
-- 
2.9.4

