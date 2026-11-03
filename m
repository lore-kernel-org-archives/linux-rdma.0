Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698941;
	b=r6hOMG8+BrFGpSzN+ynn15fN0hXuu9+NQmscUOtagBNl2J5Vs1vBO8a6g7rd5JyUf1Bj
	 mFLz4yeIr8RhFNxw2OiNbqE0Gc2B+eoz/tuvsnLZxAPLMdsA9kufKqYZlX1Xjkd+4UoyV
	 lgqn4OBqeI7lmZKW+PsQNWTf3++KqFvSiaF8jsr7XlA9umUWA0wIbHwQ1aO2Zkq4Gb1L4
	 +GHG2D6BsbB6QZySmF8bvSbF8b75io8wwBmmP93EwsrIrSJ0T6LvUlJiPnrgpjod+lhuD
	 RcXtFIx53L+E9tsPsV1W+GlkY98ikGMpX27Slt8RAfjo/q3ykA5HFQngilLERsRvwIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=D+1gcuGMS1DK0u0pkTQ4Ad8IzuVyaURYwHHz5nlXvQs=;
	b=AsMOtScPbZODaM2ZS9Mde0920G1BZaalTB2+37TtThQ+h2v0QiI9Ff1oT0BQ/GfuYHMp
	 baWa3LCVv/2CY23attiCoSfkHgIQwUnB/eTXOwpWnhI6RE1njj5/TR1LKhuA3yKLk+h/y
	 05p+pTFw5ynaFLRpcVhTPLHC/EuNx/XyYTp/DjpIyq+JSAxxBINy09QHvgyyqD02Wl98b
	 qx/HvdRwL8s12MlQouB9wbKuq31YGmid/YAGcf5R1CmVD4LaxG5Npf6XmAZLH8IYDFwL/
	 QVwdElmDHvn1JfJmdciE8U0hAO3oQg9FzCHRivYS+A46yHbxICswB2UFLhjlmTm4xVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KqgbRdoR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01995606D809;
	Tue,  3 Nov 2026 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KqgbRdoR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327ED1F00A18;
	Tue,  3 Nov 2026 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698940;
	bh=D+1gcuGMS1DK0u0pkTQ4Ad8IzuVyaURYwHHz5nlXvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqgbRdoRauyZvwKMcCNOajmhpF5ubwxZmHG4kgzvqS5/YvsunwZ4PUxFvJfXJlF5B
	 jLRjkLH/ter0Zclu7R9PRcDnxLAuvj/E1KvdQE42TSc3/+e0fhao1PDFHUEhhGU37n
	 4oDHXbiyDVZRm77nj++xm0JROH0ByTov8Rh2cT+4twis8ch3btjsfaKwr3s+W8m/Zu
	 KMrHEQ7q9CM7hbgP8YSiRk6Y47kRTXZ/3TWp7XKBKPZiKltc49RboAQ7I/jNGdCGki
	 /Nha8bqUvNszZzyMvJ7cr1Tde0wIlpIpapOLEIls548+46GS8tqJglsyfMbGyww+0f
	 SMULnR67iOZMw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc 1/4] RDMA: Rely on the generic Patchwork instance
Date: Tue,  3 Nov 2026 11:41:57 +0200
Message-ID: <20261103-rdma-branches-v1-1-763c07cc14aa@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
References: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Drivers do not maintain separate patch states in Patchwork, so there is
no need to specify the generic Patchwork instance for every entry. Rely
on the generic instance instead.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..ececae180352 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1049,7 +1049,6 @@ R:	Gal Pressman <gal.pressman@linux.dev>
 R:	Yossi Leybovich <sleybo@amazon.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-Q:	https://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/hw/efa/
 F:	include/uapi/rdma/efa-abi.h
 
@@ -14193,7 +14192,6 @@ L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	http://www.openfabrics.org
 W:	www.open-iscsi.org
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/ulp/iser/
 
 ISCSI EXTENSIONS FOR RDMA (ISER) TARGET
@@ -17357,7 +17355,6 @@ M:	Yishai Hadas <yishaih@nvidia.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	https://www.nvidia.com/networking/
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/hw/mlx4/
 F:	include/linux/mlx4/
 F:	include/uapi/rdma/mlx4-abi.h
@@ -17381,7 +17378,6 @@ M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	https://www.nvidia.com/networking/
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/hw/mlx5/
 F:	include/linux/mlx5/
 F:	include/uapi/rdma/mlx5-abi.h
@@ -25165,7 +25161,6 @@ SCSI RDMA PROTOCOL (SRP) INITIATOR
 M:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/ulp/srp/
 F:	include/scsi/srp.h
 
@@ -25174,7 +25169,6 @@ M:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-rdma@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
-Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/ulp/srpt/
 
 SCSI SG DRIVER

-- 
2.56.0

