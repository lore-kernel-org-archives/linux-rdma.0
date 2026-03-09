Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285639A05B;
	Mon,  9 Mar 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773054935; cv=none; b=AWbSlEec0OiLHoPjrc0AdUbDCouOMu03f8q2svVpQpVNl6hlqVzOa4GqX45FGKdj8or/gO62Z645wvn27tepBj7x0RM9uBF5rUne98xPRV2p2jaPKK9L4C4RgtkJsme4u6j3Q5xjNuaAbyJsmXNKJ+Fn74cRNgMG49j6W4BXoRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773054935; c=relaxed/simple;
	bh=YZqrFAi+xx1WasdQBcrBtpQgQLl0zbLLz0lMnsGCHt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWX2SAwnERPgqFYkauvcS0WX49dlSOyMUVDgwJXtv2JTs1cGfUjaFxlRt8iWxAP+C8PuAR4jOmeIVeA+yeHQX6GGoJvA6sSB7W80BoLdP0i06lyVShVmGygbJ2+jvN9wNcjIgM6qLteKzWVlTRBNDywZl+262kFEt5J9aDrOqWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCkqRQ/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCkqRQ/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F5EC4CEF7;
	Mon,  9 Mar 2026 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773054935;
	bh=YZqrFAi+xx1WasdQBcrBtpQgQLl0zbLLz0lMnsGCHt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCkqRQ/kDYnasY1FUbbys375EBYRCVztdy70T7qjDndxTBBSy3Z26gZOFIVm+0MrS
	 OphQZjvAtzLYKW+PmwWHOuD0sQjwTZwkdqyLPkZJF88KSZ/4EeOeC/gBGFOdLRtdRP
	 nao9/KeoIZnSDNOPssFj6WwGOA+0VbyHsDLCeXrCbDyXJA6Fn0n1QDNo7Q6A38XyoA
	 HqsV94Pyk15yuYIDwnh6mvA1ejGppYXCZGPrUV3ImVYfFy623kgIW3qowWBW58/Y5a
	 wUpSjDEMnPKCDT6H5BgI7o5nhBUw33K2xT1rGfmeHeXprgQjUjth9w8Yrkav/XFU4S
	 4a/hsEr9qo2Zw==
From: Leon Romanovsky <leon@kernel.org>
To: Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Itay Avraham <itayavr@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>
Subject: [PATCH 3/3] fwctl/mlx5: Invoke fw_validate_cmd LSM hook for fwctl commands
Date: Mon,  9 Mar 2026 13:15:20 +0200
Message-ID: <20260309-fw-lsm-hook-v1-3-4a6422e63725@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309-fw-lsm-hook-v1-0-4a6422e63725@nvidia.com>
References: <20260309-fw-lsm-hook-v1-0-4a6422e63725@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Chiara Meiohas <cmeiohas@nvidia.com>

fwctl is subsystem which exposes a firmware interface directly to
userspace: it allows userspace to send device specific command
buffers to firmware.

Call security_fw_validate_cmd() before dispatching the user-provided
firmware command.

This allows security modules to implement custom policies and
enforce per-command security policy on user-triggered firmware
commands. For example, a BPF LSM program could filter firmware
commands based on their opcode.

Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/fwctl/mlx5/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/fwctl/mlx5/main.c b/drivers/fwctl/mlx5/main.c
index e86ab703c767a..8ed17aaf48f1f 100644
--- a/drivers/fwctl/mlx5/main.c
+++ b/drivers/fwctl/mlx5/main.c
@@ -7,6 +7,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/driver.h>
 #include <uapi/fwctl/mlx5.h>
+#include <linux/security.h>
 
 #define mlx5ctl_err(mcdev, format, ...) \
 	dev_err(&mcdev->fwctl.dev, format, ##__VA_ARGS__)
@@ -324,6 +325,15 @@ static void *mlx5ctl_fw_rpc(struct fwctl_uctx *uctx, enum fwctl_rpc_scope scope,
 	if (!mlx5ctl_validate_rpc(rpc_in, scope))
 		return ERR_PTR(-EBADMSG);
 
+	/* Enforce the user context for the command */
+	MLX5_SET(mbox_in_hdr, rpc_in, uid, mfd->uctx_uid);
+
+	ret = security_fw_validate_cmd(rpc_in, in_len, &mcdev->fwctl.dev,
+				       FW_CMD_CLASS_FWCTL,
+				       FWCTL_DEVICE_TYPE_MLX5);
+	if (ret)
+		return ERR_PTR(ret);
+
 	/*
 	 * mlx5_cmd_do() copies the input message to its own buffer before
 	 * executing it, so we can reuse the allocation for the output.
@@ -336,8 +346,6 @@ static void *mlx5ctl_fw_rpc(struct fwctl_uctx *uctx, enum fwctl_rpc_scope scope,
 			return ERR_PTR(-ENOMEM);
 	}
 
-	/* Enforce the user context for the command */
-	MLX5_SET(mbox_in_hdr, rpc_in, uid, mfd->uctx_uid);
 	ret = mlx5_cmd_do(mcdev->mdev, rpc_in, in_len, rpc_out, *out_len);
 
 	mlx5ctl_dbg(mcdev,

-- 
2.53.0

