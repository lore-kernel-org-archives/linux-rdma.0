Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEAE518158;
	Thu, 15 Oct 2026 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065560; cv=none; b=r0z7hbSp3B4Pi2s27QnGBdwikqjRlUi1j3cEknxKvhTY/Yd+UeJd+atMpgrhHn91rc9EePltZwrhBpXsPtiHNsSs1nPo8oiyLXi114Dbjhz30oxEi7bwVHKVFdpabIMfOq9Sn9XXJjBnDYGGbAES8eYqI10WiquQHf4fAGZz5XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065560; c=relaxed/simple;
	bh=rSEOV8VRGcsUnyxvpDxWwUomyuCFT0NGj9X5osfyJkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAqdcFmzc8gJ+hKy3R+LAycozqnHUGHNEnAJLmJNRiuz1lsPdGHBnSELNqWvpbTUxdlALZ3yJKpHoQ2/jfhivySQSx77nIaVWgOfi2+vPNJouhUL+US9HRNYQDX+05Pt9H3IiLSqBSCTZ9WrpunY3tJu2Zy5XHCuhwXAxekhnlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CN3ycaaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CN3ycaaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F031F000C4;
	Thu, 15 Oct 2026 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065559;
	bh=qP8/tIYa0gcosBQ9EKNrYiQBlTnxHfFXnZoV45ZKWsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN3ycaaZcoZHfbVaZTQYcetnYk7Eg6o9EM+setE+y4rs55G85nlEJXrq0bQb7Jh/A
	 nWlw2htyzQ98PvDA5nnrbvyZcYwqilP2PzekVAcyV5JWyldXgxKbyw4m5jn23bQV2e
	 3bEXeCyNLEZq156jT/JSCiKk60Mu6BNUVn8KnEP5BJVQReqj5ghMFm5NVxOgFMXK7U
	 mI95vNP5E8EZfgJOIm9bHeAJw/2EPQB5K+z9W7XBpDiyYvXVNplqPy4Lpfu6UFdIHA
	 2LLF9FWvlsEJmHEK7VaLowkzh6TOSAkHlcLs3TNEKbnsDCtrrQFeDGBPk4kV5BiFmL
	 kb0vTYXE4M7lQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Maor Gottlieb <maorg@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 1/3] RDMA/core: Preserve the selected source GID on failed AH modification
Date: Thu, 15 Oct 2026 14:59:00 +0300
Message-ID: <20261015-ib-core-fixes-v1-1-60f6da3ddec3@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

When an address-handle modification fails, the core replaces its source-GID
reference. The old address then loses the reference which keeps its source
entry alive.

Fixes: 1a1f460ff151 ("RDMA: Hold the sgid_attr inside the struct ib_ah/qp")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index edf62652f9d3..7d52d3036208 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1011,7 +1011,8 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 		ah->device->ops.modify_ah(ah, ah_attr) :
 		-EOPNOTSUPP;
 
-	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
+	if (!ret)
+		ah->sgid_attr = rdma_update_sgid_attr(ah_attr, ah->sgid_attr);
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 	return ret;
 }

-- 
2.55.0

