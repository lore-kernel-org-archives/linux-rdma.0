Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 7439C332EBC;
	Sun, 20 Sep 2026 09:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789895194; cv=none; b=hmJ5BHqg94Avnsxzuy5ICGD6ndQeflrlGeP4gGt91rj9nZeDW3jkgtx1w3bDKqjn3zpT2hROzggnF/MG9oBXd8gDfw8hRd5VL4QMJ3XlKtolKyPa9sGkf2VhOLZWqmNNU4zE3BnLlMsovvG8a+SVPB/PByjGqNyaGkdfCVJZle8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789895194; c=relaxed/simple;
	bh=Q501yF6oXZfww3ruyMnZ+SD0H5KTlRlj/fO/zbnsFHM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sBymwpCZGh9XYySPl99QSkxrnBssFpSTVMgjKBXCREZ4qUz+nwOC8oFN2lkEx+4j6ZK1+yHRRCDHtQVkpEuegfliFo/+Os8VaRjfqxOD5dQnlurhkatsuZYsol1flt/gpOsS2LykuxdSBAP2RNmRiTdKDark8ZcbZY/990eKTBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=KniiiL6b; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="KniiiL6b"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Michael
 Guralnik <michaelgur@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Wait for in-flight page faults on implicit MR null_mkey dereg
Date: Sun, 20 Sep 2026 17:06:13 +0800
Message-ID: <20260920090613.2186-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789895184;
	bh=hSyapZAjz9fAEbqd9BOJNhbfML49/C3Q+WmLAmmPnCg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=KniiiL6b8EVigfVLzTugUNW3oPIrXohlTJ4lkJwEpD5UbkrjUNtyTfNd4cgQbR+am
	 Bnvsugqm1I8heMo0LdK3J5GNQvs+JHhJmCn/Uov1LMO2cye18cuHCDORGy2YNcpeAz
	 dj8HwxANuRz71STM2+TWTP3WLM11p7aZ6LyQx3MqL+fHjK4CauoLyCR09pD3ver2m7
	 asmz+1Vsxd6qyzWo6iFoszYOKGcFrPodYBKXTjmGZsyN8vaVrLhhe1mk+Ry6fuJOOW
	 FpzDzpIYDFZEr7Ou+zRuUyB0iM1Ksxe7qPQzYHB0dTPSenYQc5rouI57G2RYv6kub1
	 phGDR8gI1HTcQ==

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

Fixes: 6f2487bfafce ("RDMA/mlx5: Add implicit MR handling to ODP memory scheme")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b861861..f27ca77 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -683,6 +683,8 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
 		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->null_mmkey.key));
 
+		mlx5r_deref_wait_odp_mkey(&mr->null_mmkey);
+
 		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev,
 				       mr->null_mmkey.key);
 	}
-- 
2.9.4

