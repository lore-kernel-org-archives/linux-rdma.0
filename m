Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381F0346AC4;
	Fri, 12 Jun 2026 20:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781295376; cv=none; b=knraji0sKAivvRg4lrsWlikTZriuW7P0i038Q62ZkymaSZt6y0WFseh0Ps2wuhf1/i7BZwUGBIeVzvfAImOK855IJ+SDPAFJSqHY87Ko1DljaUFXvY59qFfQ5HqqMUgHAG1patb+9/OSjjuwhUskhPGV2zWeSptM9WR4OEJxYN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781295376; c=relaxed/simple;
	bh=HEVvnUHz+ElwnNN03w8VODJ4A0gPtm8Ueqtx+ckSyj4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U2uYx4eQRq+wO7kzBRbcKyBYP/9zfiI7zftwGO8lXFyTz2aOG6LVEE0UREzrmH3VTXHDMon9QXI4cWYCKH5h1KeI6bOwyOWUCKFKByzmQQQSGm3K9+GBa/9F0ncxwNqJq7x4CkL7d0HbZoparvKjbo9r6v7iRbEvMm3anb/qkRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxeVAoLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxeVAoLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9131F000E9;
	Fri, 12 Jun 2026 20:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781295374;
	bh=D8VYR55FPfcLqtvHNW5sRMi7TqOpjWGafJVkcnlztgY=;
	h=From:To:Cc:Subject:Date;
	b=UxeVAoLKjXr4G19OLuvR+PdGjg1i81M9t1M8OciMtcEL/QPHLujw+mgarj8Bp4QNm
	 WQLRtKybNQrBy/KLLv/hx3gXjiobjZRrwtPD7/Ave9uAOYRhsP730ZiMHwLGuT/RNZ
	 7B0XGawbu/oIYvMq1aDbyfpc1B1sOm7EieE/VzB56VY8sv4HAD8Vf/60YPpMsKMpF4
	 RHJEmfRi3kG5SloAe9LEK5v4d0iFyKXEVu9msmsLoyJJ54TzXUplIPN+KWq0NQcEIQ
	 io6PIfPkhSS5WLcBQqmQnMZCiP8Oukd5tR/hkPgUBm9FtNcvwbcjOILfpr+pDOxh8B
	 DHlKljhRUDu4A==
From: Arnd Bergmann <arnd@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mlx5: avoid frame overflow warning
Date: Fri, 12 Jun 2026 22:15:59 +0200
Message-Id: <20260612201611.4127750-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Building mlx5 on s390 shows a rather high stack usage that can exceed
the warning limit when that is set to a lower but still reasonable value:

drivers/infiniband/hw/mlx5/wr.c:1051:5: error: stack frame size (1328) exceeds limit (1280) in 'mlx5_ib_post_send' [-Werror,-Wframe-larger-than]

The problem here is 'struct ib_reg_wr' on the stack of
handle_reg_mr_integrity(), which gets inlined into mlx5_ib_post_send()
along with a number of smaller functions.

Keeping the inner function out of line like gcc does avoids the
warning and reduces the total stack usage in other functions called
from mlx5_ib_post_send(), though handle_reg_mr_integrity() itself
still has the same problem as before.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Dynamically allocating ib_reg_wr would be another option, actually
reducing the stack usage but adding a little bit of complexity
from error handling.
---
 drivers/infiniband/hw/mlx5/wr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 9947feb7fb8a..fca9e1d9d5e9 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -840,13 +840,15 @@ static int handle_psv(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return err;
 }
 
-static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
-				   struct mlx5_ib_qp *qp,
-				   const struct ib_send_wr *wr,
-				   struct mlx5_wqe_ctrl_seg **ctrl, void **seg,
-				   int *size, void **cur_edge,
-				   unsigned int *idx, int nreq, u8 fence,
-				   u8 next_fence)
+static noinline_for_stack int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
+						      struct mlx5_ib_qp *qp,
+						      const struct ib_send_wr *wr,
+						      struct mlx5_wqe_ctrl_seg **ctrl,
+						      void **seg,
+						      int *size, void **cur_edge,
+						      unsigned int *idx, int nreq,
+						      u8 fence,
+						      u8 next_fence)
 {
 	struct mlx5_ib_mr *mr;
 	struct mlx5_ib_mr *pi_mr;
-- 
2.39.5

