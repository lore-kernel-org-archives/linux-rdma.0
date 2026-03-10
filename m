Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4851D5147
	for <linux-rdma@vger.kernel.org>; Tue, 10 Mar 2026 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154686; cv=none; b=eWnjrBV99SqTBO3hj/i36CJn/UKAeWV6u240zW7JFlNiN1R9+JPMXshtit0y9OiGwlQJIuwoayhfcDGX7PtjODHzaN/CKT+nzxHE8BMhNG87dLlaHXkMd2BbvZ6yzssiL6mQ4oVQS8PTfTQ1CJdj+GB0Amj/0VHsuNBLclOz2cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154686; c=relaxed/simple;
	bh=8fduPlpsWlY5OABBCjn6Z/DgvqLXx0MBVpvCEYHpfuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pAfjLpAzxkOhKn/odmVEeKIz/LHc6/FE35sA/vRs/5RojqaIPvbnf5lPEVQt0+xiZpY99eSVf0+7QNHuXRmhgN3fzKgVcbK94olDf2awvNSaQb+fcQzlnwj2HKikSFXdVxHsOZgDhO6WQacbHDExpgsDQ/7sgxFud1yskiA1/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jN7+MwY6; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jN7+MwY6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pG8i9xriWwSMhHEY0XesIWMcvdEr6/xMZY0geaKsJ+w=;
	b=jN7+MwY6zl3ztIoFDr37JwTAOJSOXW/I3D5Hu9z0bl4O6gJ48UiU1WfV1sjZCHnVxl1RHG
	x+n0iaE8cVZEpLbiSWxot0/WN+UcKY7hR9Y4M+srORCfhtWO0vCGFljBSeexalPn/d5pIB
	V+DXA3Sr2KV70qne2T4DO+F2OBZ1+8g=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/mlx5: Use clamp() in _mlx5r_umr_zap_mkey()
Date: Tue, 10 Mar 2026 15:57:28 +0100
Message-ID: <20260310145727.236094-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=thorsten.blum@linux.dev; h=from:subject; bh=8fduPlpsWlY5OABBCjn6Z/DgvqLXx0MBVpvCEYHpfuU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkbDMP3R+fwT5HeyGAopdmS/tDp4A6jBZaf1GNkD8a92 CYWu1eyo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACYiUMPw34t7WZTWnYVnqgoc WfkSCmb79S433ZK+Qo7F45SAQ0jhEkaGWedbA8ouKO1OSoqZLFm49AufwhqLjW/1dm7kExU5NoW XBwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace min(max()) with clamp(). No functional change.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/infiniband/hw/mlx5/umr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 4e562e0dd9e1..1a6b0ac5c24d 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -1013,7 +1013,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr,
 		 MLX5_IB_UPD_XLT_ATOMIC;
 	max_log_size = get_max_log_entity_size_cap(dev, access_mode);
 	max_page_shift = order_base_2(mr->ibmr.length);
-	max_page_shift = min(max(max_page_shift, page_shift), max_log_size);
+	max_page_shift = clamp(max_page_shift, page_shift, max_log_size);
 	/* Count blocks in units of max_page_shift, we will zap exactly this
 	 * many to make the whole MR non-present.
 	 * Block size must be aligned to MLX5_UMR_FLEX_ALIGNMENT since it may
