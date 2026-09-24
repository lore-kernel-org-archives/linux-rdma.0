Received: from outbound.baidu.com (mx13.baidu.com [220.181.3.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 571BE359A70;
	Thu, 24 Sep 2026 06:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790232635; cv=none; b=Q5zIWf99WaQLboqn7iNm9oquGH1stZKv6FyZbVhBwXOH2E+lmyrrkaGY6I+EIl0bDrhA23TEbQCAXUUbvZSe+fRcbQsRoPPPamxL+mc8/VNbFD30SnawwhONB1yRPy5+ujA7+CbtKAjtwN/DDxnC4kTL8ynpNdvt+hVYHj6SPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790232635; c=relaxed/simple;
	bh=fZsYSsVPn7oZCdO20+fq4e15qAV657+bgqozpMl22+E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KHMjJRvAPM7hen4UZB68JI+iPZ578R8+6SMy5v4dl8YHaquH47TI0+FmTNcwQGjgjeRazV6EYpFCrt4a2zObRK+cGtVZaqrg95oXns65hZjaWp8m+lpSdkCiKt4QQb19rkCnnnF0Nz8wIFjPr/aRLmTcaCUzyFyw86IwNbsocTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=YvIHGmVo; arc=none smtp.client-ip=220.181.3.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="YvIHGmVo"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Michael
 Guralnik <michaelgur@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] RDMA/mlx5: Wait for in-flight page faults on implicit MR null_mkey dereg
Date: Thu, 24 Sep 2026 14:50:17 +0800
Message-ID: <20260924065017.2424-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc5.internal.baidu.com (172.31.50.49) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1790232625;
	bh=XRITnGPI2MGQsAQZPBnT65DhCFWUCo8azF16hTjiJ8A=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=YvIHGmVo2ojDL8bfVWpkP0Y3soi0xOW1+BWizpjfi+1+4AmtYoUq17fc4IsScjAQT
	 RsMjHkYmSptdcn8M0fTL8WCi5YcJFp8MBFMwboHciqOHxPjRNhFYHDGWbrouZ1KKqJ
	 GR+xhN/Q8PhJbF6gwNCZyipl8Kt2A5Pc95NX5FqlMX+XK+0zn7rR7+5LUVrVbzvydy
	 9H6ETfQiYmDIdP73660YgRtXK/A0Cr6cUAJxWI6Zva8S8FMJeXMuUofUc6nEMN4itL
	 xcrydGrcndG2W51ikBHRKB9H7TRKEnYVvUhSTnQMUIs72K2VgDs3k+7qNAHDSBaev1
	 aVLnGb8xz/Zng==

From: Li RongQing <lirongqing@baidu.com>

An implicit ODP MR (imr) publishes two mkeys into dev->odp_mkeys: the
main imr->mmkey and imr->null_mmkey (MLX5_MKEY_NULL). Both are stored via
mlx5r_store_odp_mkey(), which initialises their usecount to 1, and
find_odp_mkey() takes a reference on whichever mkey it finds for the
duration of a page fault.

__mlx5_ib_dereg_mr() erases and waits on the *main* mmkey usecount only.
For the null_mmkey, mlx5_ib_free_odp_mr() merely xa_erase()s it from
odp_mkeys and calls mlx5_core_destroy_mkey() -- it never waits for an
in-flight memory-scheme page fault (MLX5_MKEY_NULL) that holds a
reference on null_mmkey. After xa_erase(), find_odp_mkey() stops
returning the null_mmkey, but a fault already past the lookup still
holds a reference and dereferences the imr (via container_of and
pagefault_mr) after __mlx5_ib_dereg_mr() proceeds to kfree(mr).

Mirror the main-mmkey handling: after xa_erase() of null_mmkey, call
mlx5r_deref_wait_odp_mkey() to drop the reference taken at store time
and wait for any in-flight fault to finish before destroying the mkey
and freeing the imr.

mlx5r_deref_wait_odp_mkey() wakes and waits on null_mmkey.wait, so that
waitqueue must be initialised. The main mmkey's waitqueue is initialised
in mlx5_mr_cache_alloc(), but the null_mmkey is created through the raw
mlx5_core_create_mkey() (not the mlx5_ib_create_mkey() wrapper that
initialises the waitqueue) and nothing else sets it up, leaving it
zero-initialised. Initialising it in alloc_implicit_mr_null_mkey() right
after creation avoids a NULL pointer dereference in __wake_up_common()
when the waitqueue head's ->head.next is NULL.

Fixes: 6f2487bfafce ("RDMA/mlx5: Add implicit MR handling to ODP memory scheme")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: add init_waitqueue_head(&imr->null_mmkey.wait);

 drivers/infiniband/hw/mlx5/odp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b861861..766f545 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -595,6 +595,7 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 		goto free_in;
 
 	imr->null_mmkey.type = MLX5_MKEY_NULL;
+	init_waitqueue_head(&imr->null_mmkey.wait);
 
 free_in:
 	kfree(in);
@@ -683,6 +684,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
 		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->null_mmkey.key));
 
+		mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);
+
 		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
 				       mr->null_mmkey.key);
 	}
-- 
2.9.4

