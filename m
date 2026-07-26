Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7735DA65;
	Sun, 26 Jul 2026 09:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785057743; cv=none; b=j+OgO+TmA0iqy88IQCChiyKjUd78PjgyFcW9LhE7MX1xAts6k7+ttRir+1LnaalouFTpUfP7XERL52MxBgHK3tetviggxvfK/cvWX983VDDz2pGuqIlpvIejvpKAlO+u8Fw4933m9LHkAV1pii6t5T7nrFLsiV5i3TgByTvWM5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785057743; c=relaxed/simple;
	bh=K/tBOjWNRZyV0nOUw94LpsDJgpMdcLczKY8nhe/FZNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tJwd6OEgA3kvcYwGsw/ktFPsq4OK0uIMvyiAghTQT2IJLTr+5IIrTVNQrKFKp1tSSaZteZYzb1GFxZ6+z9av98UGUQCBwhwHSdhF6XD7nCuGyX9HAD5VQZuA8VKTv856DFDpm5APYlBdL7/erLvg9l8mcznBJM099lOlzpvpg44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4L2NfUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4L2NfUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22BB1F000E9;
	Sun, 26 Jul 2026 09:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785057741;
	bh=fX8f5QktYpzBGQsZR2bGTO5y86DpII2cIX8ko9wcH+U=;
	h=From:To:Cc:Subject:Date;
	b=Q4L2NfUV9nKAT2Q5tfCptJ64PaTv+x/o9uG9TPGxYpaWrGCt3GThFZk+v526ggmJV
	 tt2IaMb+fnBCJ2mF2xw32xZ4cmpZB67cm9ucCNL32NKcHeCSI09lXEfRy/Nw0nb19d
	 GSaf4q+viHN2g9k5Vq4KcfiQtUs0qiEQIT+mKajGBTgeyz+WTwviEEAR9BtCzdT1Db
	 chr4Rx5i+UvAPQKMlJ3fv1DGGESrTrqXiFVb1nbiFhUG6Ue9zf5OmI/D4p59xgTS8t
	 s03id+T7Wk0cQyYC/a5pKnUVOqGC7sLYOv1DwO+QWFbNOgQFgrkVMEGHiOZlKNlMOq
	 +//7JkCnc7Pcw==
From: Leon Romanovsky <leon@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Send cong param changes to the resolved port mdev
Date: Sun, 26 Jul 2026 12:22:11 +0300
Message-ID: <20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260726-mlx5-ib-set-cc-params-applies-conges-a64520996573
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
through dev->mdev. On an affiliated secondary RoCE port those pointers
refer to different devices, so a write to the secondary port's cc_params
debugfs file either altered the master port or failed with a master-side
command error, while the read path already used the resolved mdev and
returned the unchanged secondary value.

Issue the command to the resolved mdev, the same device whose capabilities
were checked when its debugfs directory was created. It is already
referenced by the get/put pair, so its lifetime is safe.

Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index d0edf83a2f20..d1b625a52fa6 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -361,7 +361,7 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_exec_in(dev->mdev, modify_cong_params, in);
+	err = mlx5_cmd_exec_in(mdev, modify_cong_params, in);
 	kvfree(in);
 alloc_err:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);

---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260726-mlx5-ib-set-cc-params-applies-conges-a64520996573

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

