Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711502941A;
	Sun, 26 Jul 2026 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785057244; cv=none; b=j/QGnr3QDsULZxLJpPlzMhI+b/QWzDkWs7MxBSxQCNT05imdZvaC2fMUO8ZQ8PZZg90WUp//46dZL4nuqOaLcxWMwRPfkWk8CYqoKJozhavZXINf+vzbjufJcuM5mpZj38S9oZUl9uRRJalDvlZokUc2WqUm6yxrl05eIGLUwN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785057244; c=relaxed/simple;
	bh=btlhvOM/rfS2G00EP3KzzNnEnPsU7EPYPmP4z84omwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XT98Nsz8UkEq734um2yCtwYGXLIhlFMMOvLCPDqBJrE3ibgZd0Vl9ywcjamSV59ljyX3sF0bdsNLjgH9Go9YLGj+kxvgn2iG/VpyvSFBaRS1rQYY+V1LTRiGGDAkWDkWtdkN2ke5ftV58AAzCsFP1XNuUfeY25CT1BfyRnhi04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgJgU5Cv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgJgU5Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA391F000E9;
	Sun, 26 Jul 2026 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785057243;
	bh=bxYr3zLtB3M1i0e/ecXFpM+SNTevH9MUORswmiBKhE4=;
	h=From:To:Cc:Subject:Date;
	b=RgJgU5Cvlof7LScOkHwZjUfd1tvr6z2wsuHsEV12mC8Gn2yBObZMfpZm/oYORMvct
	 9waqHfa/V/LLPQOfShrYy5AKzTjX+5mG+bBkvYNmY3sY6NbYKgpXliYiFsGZT8dBWu
	 RFTX/pQ5lJzZMgUmy1AyfJZHGS3P76iNeBgzyW/QC1PmJUMQJ+/+n/V64ntPgMWcyw
	 J52q948PZIYYC5Vu1UhLKtZyZwBCGr+EzhGZXXloHeUkAxmJs87LPTR9JAr5xRwJ7d
	 TSwc9mLaeQn6/2cAPGCwSQelg9m+v+GKp6mZ9jVCS2E6GGLXiUZboCibiA38wC8CGk
	 x8xqU8YR+FlKw==
From: Leon Romanovsky <leon@kernel.org>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Daniel Jurgens <danielj@mellanox.com>,
	Doug Ledford <dledford@redhat.com>,
	Parav Pandit <parav@mellanox.com>,
	Eli Cohen <eli@mellanox.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
Date: Sun, 26 Jul 2026 12:13:55 +0300
Message-ID: <20260726-get-param-leaks-kernel-stack-memory-v1-1-d61a4d39662d@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260726-get-param-leaks-kernel-stack-memory-6b8c813fe849
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

get_param() reads a congestion parameter as a u32 but formats it with the
signed "%d" into an 11-byte stack buffer. A value with bit 31 set, such as
0x80000000, renders as "-2147483648\n" whose full length is 12. snprintf()
stores only 11 bytes yet returns 12, so simple_read_from_buffer() treats 12
bytes as valid and reads one byte past lbuf[].

Size the buffer for the widest unsigned decimal, format with "%u" to match
the u32, and use scnprintf() so the length passed to
simple_read_from_buffer() reflects the bytes actually stored.

Fixes: 4a2da0b8c0782 ("IB/mlx5: Add debug control parameters for congestion control")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cong.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index d0edf83a2f20..113e5f5fc6fb 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -399,15 +399,13 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	int offset = param->offset;
 	u32 var = 0;
 	int ret;
-	char lbuf[11];
+	char lbuf[12];
 
 	ret = mlx5_ib_get_cc_params(param->dev, param->port_num, offset, &var);
 	if (ret)
 		return ret;
 
-	ret = snprintf(lbuf, sizeof(lbuf), "%d\n", var);
-	if (ret < 0)
-		return ret;
+	ret = scnprintf(lbuf, sizeof(lbuf), "%u\n", var);
 
 	return simple_read_from_buffer(buf, count, pos, lbuf, ret);
 }

---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260726-get-param-leaks-kernel-stack-memory-6b8c813fe849

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

