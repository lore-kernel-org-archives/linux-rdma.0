Received: from smtp.smtpout.orange.fr (smtp-65.smtpout.orange.fr [80.12.242.65])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D03FADFA
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017245; cv=none; b=FxtfzgSlXQRqJgnyf9QgjzNp7mCm8EQd1mRrZCmxATX9wzllPw5mIiF/bU8VhNBVIuVI92FtV/i/lwzUIaZliP49D2tiJJH7WTZsVxFbZf9PF/FpZN00Xs2BOHnIPK8tksi3VLQjuiXyqnIaxiXDI6pn9duJjfXcvDpaVyC6WWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017245; c=relaxed/simple;
	bh=XpGwfVzGTr8hfVpHkoISJqYbxLSDQRxHKBbcsKa0Ac4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C/LAtwjiT3vHXECF6M9VjaCRXTKMmKeo3xDc0kHI9ci8pDQpCWxXtAZKNxw6aTHKqc5v1R1V514ZCC7XSMRIJl8K7D51sxQi/K0qOM5XS/X9yoYsEKvih8lVWDr9kxV0lxpZFB7OFSHGNGjMR4iE+CUy7j1tOIHVIMxa08/B9/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=DpSq/w7p; arc=none smtp.client-ip=80.12.242.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="DpSq/w7p"
Received: from device-97.home ([10.65.86.67])
	by smtp.orange.fr with ESMTP
	id jYMJwPZcFrxb3jYMJwue9c; Tue, 14 Jul 2026 10:19:19 +0200
Received: from device-97.home ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id jYMAw5vkXDzLkjYMAw0U3a; Tue, 14 Jul 2026 10:19:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1784017151;
	bh=GMJi+gTFGDUXh/gZorteniOi+++0sQzYcGVvcoNPxrQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=DpSq/w7pH9YcOc3VZZLFDFh3xoK1JRH0w3xjJ7n5f+RCO61LD7abrFq0xJKkieIsf
	 9F+hgS3Pvs2PBdRKHDQbIiavUQQh9mH+SA/0ep10vuL6Qhxurq/zUVgU6OvnODGx+R
	 qwXJnwfPgEW87sIU8cKHabV0R01tB97MThIDjr9qlYHdG2HUAR5EkNxuk0RmcuBano
	 ivGyJlPcmhIRrCZQO0QEgU/q/GuLeF2DWl3VbCwoRqN8sWfJQLILQx2UpjlURZl9Gs
	 TQNv/1KT6hzlqy7ZGx887PyIZfIUadWw/5BQclHJoE3HIljH49mcG2isPFQifKvD2+
	 5jHSDGLn9mkYQ==
X-ME-Helo: device-97.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2026 10:19:11 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/mlx5: Constify struct ib_frmr_pool_ops and dma_buf_attach_ops
Date: Tue, 14 Jul 2026 10:19:06 +0200
Message-ID: <22f2263c04cc94e242cee712e6e6d82b86ac353d.1784017128.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct ib_frmr_pool_ops' and 'struct dma_buf_attach_ops' are not modified
in this driver.

Constifying these structures moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

While at it, change a '1' into a 'true' into the mlx5_ib_dmabuf_attach_ops
structure. The 'allow_peer2peer' field is a bool and other usages of
'struct dma_buf_attach_ops' prefer using true/false.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  77631	  10392	    320	  88343	  15917	drivers/infiniband/hw/mlx5/mr.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  77759	  10264	    320	  88343	  15917	drivers/infiniband/hw/mlx5/mr.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 drivers/infiniband/hw/mlx5/mr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index e6b74955d95d..00e13028762a 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -339,7 +339,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 	return 0;
 }
 
-static struct ib_frmr_pool_ops mlx5r_frmr_pool_ops = {
+static const struct ib_frmr_pool_ops mlx5r_frmr_pool_ops = {
 	.create_frmrs = mlx5r_create_mkeys,
 	.destroy_frmrs = mlx5r_destroy_mkeys,
 	.build_key = mlx5r_build_frmr_key,
@@ -898,8 +898,8 @@ static void mlx5_ib_dmabuf_invalidate_cb(struct dma_buf_attachment *attach)
 	ib_umem_dmabuf_unmap_pages(umem_dmabuf);
 }
 
-static struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
-	.allow_peer2peer = 1,
+static const struct dma_buf_attach_ops mlx5_ib_dmabuf_attach_ops = {
+	.allow_peer2peer = true,
 	.invalidate_mappings = mlx5_ib_dmabuf_invalidate_cb,
 };
 
-- 
2.55.0

