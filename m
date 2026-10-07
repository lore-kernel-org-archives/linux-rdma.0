Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ABA376BF2
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791416681; cv=none; b=qdfgvh3pXx6dXYHa/BtUnz4lp9wyfsKuDtPW9shulXfKxLQXQxFm5mIz4SDPNnugtxLuFmLa/W0Fq3yqvGkdU2DMgeCZTLDa7aN+01lcd/KJSoAYccnlkDE47IiplOW3dmJ3iWEd30OQF6ErucfSFUCzt1J6hYwpRFPNILd4M4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791416681; c=relaxed/simple;
	bh=YARXCShK/9vVXfiD1gwkK6sm53zPdGGWb0rudFpHQbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jWME/a/1RjRqmg4b2aA0qaf5/2Lt7K+4mlJvosc2vLKAf7TmB6N0EtqTXUxf+CMgyQtiv9rNPhkTwKHwzx9G5DOLfdkHnEAU3oHRgadNvJNPFyfnK906WE6AXK8s0aJ3hAsJy0u3SuMqmk7T4nxZyKPxJ4Uobq5ix1eJUALCoM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EOIspdG0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOIspdG0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a17f65ab8bso8667235e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 16:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791416678; x=1792021478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KVyDlZ+Tk8cP0JL9kHRLRfhLRbrCqUU0BJbBP7MDZts=;
        b=EOIspdG0YMYc6fC8A7mEqcqUIfuLRLfSr36KWWWAOthJszpcPRAvx820SRXYi9pzKa
         Ndgoj9Ibr15wWDazal2Nz8qrMsXaGgXvBGG2BNVH1LZSGzqmRdpOTGBnBD6LgMPXX9br
         qfUgwEYjsBNd0byzGnypwOeLtpSLHhgv6nddgk4+6sfyfwHmme4QV+Tqm4OXOs9/P6Mn
         Z+JXd8WzlIv6OFilHhhv5iWo/KAvM8bEWZXI0VAyA7DlCpbLHzRPrkYmShrcZAdGdUAS
         1NceryOYI0aRZNWjgpIYKBKcBIZNtShV465vbxqNievzviOnoXpACSTBFHFc3/d4CrMc
         hKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791416678; x=1792021478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KVyDlZ+Tk8cP0JL9kHRLRfhLRbrCqUU0BJbBP7MDZts=;
        b=fBUMu5otgR8XflhDcaXC8TbvbrtJ3SwEt8LaKpHnsOVpsiniHDnYJxj0h/ejDroD2h
         4f2l1UUOH53VHjMVc7HhfI9PSoIkGsuGXGV3cQs73OSwBRxXu8dJWlOwlmQa4FrowwxB
         CvpPK61sw4IGJ2SP+QaWEOY9s6BA/hRWyMEzybsr02066RaxRpuDAhriwl2dZUGhvvAX
         i7bhApNUKZYrhPi4bS+sRLklipqDcgy/rSefcFwJRZP8V6sJiJIzaA24LnOGaI4DWF07
         n9lQ2GLiDIZSYr8eA8LCettjcAsEwiOlV2E9quPFT3sGTxf2R/IxA1rV+z8/ZqLEMKJ2
         dLOQ==
X-Forwarded-Encrypted: i=1; AKwUvByjDcioqVr804C9A8UPVV45HHuSTKsuVNADcGgT2z22dmRQBE+vo+dx96NrtIOgiYw6LTlKzoXgYtwG@vger.kernel.org
X-Gm-Message-State: AFuF++lm1E8yhkOtg5cKXN8riBXoidLqRSLvoFoJG3P0T0CMDlFsUSrj
	yt0hzdiPejlZrcPn8eYFszqFLQGCwuKAPJDhzWtjqDC90hjzl2eMszu4
X-Gm-Gg: AYBFou3cSKeTgUMlPWFhjZQam0j6Rj1X8QKShiDWQ6DCvrzQxavWOE9XFNGv58X98hR
	wLVWwSYfGDsBYfVqCAON8/z1cnl/tG9fOYm0CaAnETIxuoIVvtQj3ES4JWapSjzsm86nIrdwHTU
	13kXpsN+txE2DVlsjAVaU2kVgcfajAMcvAqwyySlX7aJ+Hn9ryK9XXS+otkClQSV/4l1IJ+3c/U
	iDXYs3ZxR1T/rKILTV486m2MAUUwWHGcgMwyvoevTE51/1lPD3s46CwY8VDPP+4VyHFqrJM747Q
	T+KFz+0RmjECV1jgAa11VqSRtevUgjgF/l5sV0wCL52lv5Lz1krhASt1u3vmEiLo/3ULFxXuZgn
	XgLuKf2TkW8M3UT/6G0OvxXF5KzvRZBaHDfUXFwWXmLFWIElFELI5brIo7laGmxh/mVTeo0uaWN
	QA/EZQYOIb3DZp1e9olGDejqAgxBxvSvnoUE/qjFMl5wvUTaGvDnYyZkLlTwOivt5o0srgmlVjc
	DhSPjZ6Mh1HlWQdcPYwR+kz+Q2zblVS20l+OBug6h+edIYe/OEUamDRgMQ6BtMfYhZZo+FRGrkv
	2tHrK45krQU/LBE=
X-Received: by 2002:a05:600c:3152:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-4a180650fc6mr61558085e9.35.1791416677952;
        Wed, 07 Oct 2026 16:44:37 -0700 (PDT)
Received: from SD.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f4480a4sm76816995e9.0.2026.10.07.16.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 16:44:37 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@mellanox.com>,
	Saeed Mahameed <saeedm@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Subject: [PATCH rdma] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Thu,  8 Oct 2026 00:42:11 +0100
Message-ID: <20261007234216.2765-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Page-fault EQ work can remain queued after the notifier is disabled.
Destroying the EQ before cancelling that work can let the worker access
freed EQ memory.

Cancel the deferred work before destroying the EQ.

Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b8618610737a..1f28c30095dc 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1885,8 +1885,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	if (!eq->core)
 		return 0;
 	mlx5_eq_disable(dev->mdev, eq->core, &eq->irq_nb);
-	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	cancel_work_sync(&eq->work);
+	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	destroy_workqueue(eq->wq);
 	mempool_destroy(eq->pool);
 
-- 
2.43.0

