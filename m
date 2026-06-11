Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DD43ACA59;
	Thu, 11 Jun 2026 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173225; cv=none; b=KsRxw3Gos6INSIUE614Jw57XAyDgSDs2UNGaCO/ujx6m18eUyk+UvsbpXD1hYOQvGX8/oG+ecX2qfEUpstq/bQZYVB6t/q+Tcaqh28HvtwrmmFc/wr8c3tQUuHox9Q8hurxfrYQXJUsfCUsZCYVNR8tqYwa4hwrswExcHjXGdq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173225; c=relaxed/simple;
	bh=y3kLA33PttoE2QI9WpAW54AFSaPo/pP5HxjOrXkkk0c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JePK95tIINSxkxMIJox0vcHwIm6JX4nTw/iIeLWUVTUh7hYPbwiuVRsBnrrqXeb2zA1a4F6GRGLAKCg4ROhxFZL2Leub20LHFqXx2SUgsHOPSN8HHIfXzVURwIfAqf1d3afUdLDoNdeES1rPSpAbF+1E6nOZboMPVbObU9WBrmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byQvhEIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byQvhEIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB0A1F00893;
	Thu, 11 Jun 2026 10:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781173224;
	bh=WEczN7YZwH64qexuOg4omZgI5gyxEytI9ScPLUeOGDI=;
	h=From:To:Cc:Subject:Date;
	b=byQvhEIsrLwo76EEepegvidUp3xGMmhIl2ENtnK7L3rU1KPufo0TXErCq8PMrM8+C
	 1SYO0YdiIjaYaX2MNyxmTcCMv9GNq1HihvtmeqKKrVkRsTIVpgNA1dUgHjpeQ87n0i
	 kDHWMEIgwM1O6UetmclSbJqqsL8z2t1jFVQBbs7YFtQe2IZfiCtShZiARyhiV5QhhR
	 8Ox4eHa/3AtLwOqFKFMpGrEU9n+qMQJUZR+g8W9vr69IWGZjB2kgZZAxhx8jVYVcfA
	 TxHZIavbdadUzkstFCi4Xxoc9xO8sLuGcMPFNTZgWwXlStUcXZfcTg9uZHva1csHeH
	 XI8E+dGnEMZRg==
From: Leon Romanovsky <leon@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: =?utf-8?q?=5BPATCH_rdma-next=5D_RDMA/mlx5=3A_Release_the_HW=E2?= =?utf-8?q?=80=91provided_UAR_index_rather_than_the_SW_one?=
Date: Thu, 11 Jun 2026 13:20:15 +0300
Message-ID: <20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260611-fix-uar-release-8f74932eb527
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: quoted-printable

From: Leon Romanovsky <leonro@nvidia.com>=0D
=0D
Free the UAR index returned by the hardware.=0D
=0D
Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")=0D
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0D
---=0D
 drivers/infiniband/hw/mlx5/main.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c=0D
index a558ac5bb219..0f5c61db1d06 100644=0D
--- a/drivers/infiniband/hw/mlx5/main.c=0D
+++ b/drivers/infiniband/hw/mlx5/main.c=0D
@@ -2674,7 +2674,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx=
5_ib_mmap_cmd cmd,=0D
 	if (!dyn_uar)=0D
 		return err;=0D
 =0D
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);=0D
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);=0D
 =0D
 free_bfreg:=0D
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);=0D
=0D
---=0D
base-commit: 54bf38b27afc08a0eb6b732f9c14eb8a4bcb66b5=0D
change-id: 20260611-fix-uar-release-8f74932eb527=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D
