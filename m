Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 825EB368D51
	for <linux-rdma@vger.kernel.org>; Mon, 14 Sep 2026 12:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387992; cv=none; b=JSNO/m0DqVfzsYczOC3d3Y46uOs0urzF9wUlAzlYI5uFozAtyhe8ci71RYeFdToP8GL1oc38wJGoxZkuTo3D5XNBaKCY2D0/ZJ3cVoCr/OkQ8j2CzhmOXSTERGA1iFxQwdExcnNco3KMltHMcwhfhM0TUEvSJrgm1qB9qFKIXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387992; c=relaxed/simple;
	bh=Y8ZvQ0N71lShvCW6RI5Bnkj1c3UzVfIXH7wcqCgGmds=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G0COJrfXl5TTFHjhd7rSFz23enHyulMBVcaGa0w3Gqio3BdWUCQyvEfWeLzNtcPHYTJJD0IP9WrO5cQZ2p66N8f/87xzypxaeEswkwxh5n3nNWv/KTj4g24N1hrWO79IK/LX0QCFQ5gA8XCpULx//+1pdeAJgMTVRDERAmmILdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=GY7AngAT; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="GY7AngAT"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Print err code when create_qp fails
Date: Mon, 14 Sep 2026 20:12:53 +0800
Message-ID: <20260914121253.2193-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc9.internal.baidu.com (172.31.3.19) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789387981;
	bh=yV1bSr2uTEzx2rrnon64QKwvVfgCUjEw1GlkPvxl9dU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=GY7AngAT9fytZbUhwJ/Wz9Nk2Ixq21orWN+mErjDhRVKCQFpkecBD+AypKfVg1VTv
	 57Ba1DZnuyhRtWDBm12CQ3bzE4JBNqiMFSdOu7XMQ2tfHhzZ4TmKkrEt7lGF2QdVEC
	 HLd+33+E/obMtikH95HtshWfQ45KmwW2oUI1Nz+tuRSLrLOQqaFPlhELY7jk/oy5tL
	 DB1s3fxJbzxlbrrh4cgWJecQ/Wc+QfvRcvHhGPpSV/a8M5me3WgJKHIDafA+hRrpeg
	 W8dEOaNKO0XQNUIhVzLa3R0o957Gz1+wcF8i6N0bkfqIHGlAIRDssRNktNYpBXLPww
	 6/xyOYuaBaKcw==

From: Li RongQing <lirongqing@baidu.com>

Add the actual error code to the "Create QP type %d failed" log
line in create_qp(), so failures can be diagnosed from dmesg
alone without guessing the underlying error.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0d4f8b1..2f05817 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3186,7 +3186,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 out:
 	if (err) {
-		mlx5_ib_err(dev, "Create QP type %d failed\n", qp->type);
+		mlx5_ib_err(dev, "Create QP type %d failed, err = %d\n", qp->type, err);
 		return err;
 	}
 
-- 
2.9.4

