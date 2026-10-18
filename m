Received: from mail-wr2-f8.google.com (mail-wr2-f8.google.com [74.125.225.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D9E33939C
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792335016; cv=none; b=Xa7mhO9IdhUyam82OUsbV/kriPUTelkTM1O7MMOkQZ5LDtMaULsmd7/dI1Yy7qzxyepEiXXBlHxF+O1L0dJBhG4qIjthJiFePd6JtrHEDq1cXYGToJhZCHzKcDh/FtK3l8rVDzrAB9EB13RvSGPOvHzfwTnKRybNMtkomiMSeak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792335016; c=relaxed/simple;
	bh=6yHE6qnIZGNtF1BcbMyPdKNzgBe3P3tTSjHV99FAJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZqX4vS/pBwXtpZ0craYvSfIx771OipQB22oWPpGlnksfRTt8MVmi8MrREwTZrYqaCjKCc9GGHFLBPwh1bpsYX46i5oeZvDp3LUKdEUZiLd139u1KisduFz90l+HmtM5zbaUtsNzX38lGidQxpVkzQfJ+BNC6OxyUdOyN5rkZhgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TRohAXav; arc=none smtp.client-ip=74.125.225.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TRohAXav"
Received: by mail-wr2-f8.google.com with SMTP id ffacd0b85a97d-48df4afd489so561304f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792335012; x=1792939812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/eYVYY73yC/D0v/KcDNwhtZQIc+QCqPcBhpHmMy9LfI=;
        b=TRohAXavpTd4RILfZfOOAng2sbXqGXk+fLQ9JDD41VnBbXRYS0RsQgwHkXOJn+4328
         gDsRJNDv7aZbxocx2F7H5XWip6X5Nmv4X08QaOhJKCplg1a+1vjHZzxqJzWbP4wuixzT
         sxoI1h4Y4rRc0WOKsHJ0xku40igxFTrI4/8obSQgKtnW6rMV3bp2KQTWhwYJNedy9qE7
         PTXVg47ppghRU7bxdapvxjPz0LjVmv0jC9lbOKuhNZcT7K1Ck8B6lLD7cTnbAuTgIZ0p
         5BNgtBahc4LTBcjI/JHOK4GXILDSkQLzKAQxZ59P5bI3qBvNkp4SHEL/UVWbiNERRanI
         fL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792335012; x=1792939812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/eYVYY73yC/D0v/KcDNwhtZQIc+QCqPcBhpHmMy9LfI=;
        b=14n3PUx+saOJ+LR45GENxGedmw/2kyuTDZzmVY1mdpM3qs8HqV5KchrWf5GcdLfPZi
         +CkpoY0mCd3ehCdcwNqQ38kJ3pkcFOdA5aLTcF5Yb0eNryKSDnqqFXauaznIA0f+j24E
         I3sTckOKCAs8cnxVd1j1wJQu+Wc9Op0M3nHyPajc20Ahc2zwteP55ry/QMDrgJrWxXAz
         obFOoLt+657RMTUCjKWLGwhsYWMTa68YTRrCAVRUVq2IGs82dFMCBtIkEQlbH3xO9Np0
         p0WQdZ6I4kyGvBvjP37Y8lO8pibfRxCl8OLTeH9HyoJhyn18ymtR+XfU0f/qB+dYiDGb
         it2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwoRWDQ2hCh4uLrNvDE9/Xs/Hjmx8OZXH5+CcI9he8VUgSAUv8hKRclsAnJdW70f0/iCCzopT7zZ1r5@vger.kernel.org
X-Gm-Message-State: AFq9FYJL1Sr3my+keqZwXeMTUFipmnc5Pck4lbUQeq0IH/AIE7rQaGwy
	GYqsefnEYk23Sn8U5+Amca+Dw02w1r47TIWebn4Yr+gauV+Pvm3MpVF1
X-Gm-Gg: AYBFou3MkX5eNsOghVPGc30YRaApakD5VrOpmo4Tb8or5fYOVaRTWLTtS+9SUGF71PV
	gdfrTmMk3Hg48iX1QHMQMV36yyB4Y9+rnH1gsghZOlMSkf9CnZwmeTz4fW4y6csqA8Dc7p0zNGw
	7YoLNIe45Ky/gbz7E/GjTo5HgmHpUKXtgmi339j7q3wlPJFUsBjZznwD/PenTde5hNUBECEakDS
	Fd7olAzJACjXDwzNFZVJQa5GInZTGXrDUi8rBIrVW+mnnG5IMVMsjq9KjHXTGNQUI0PtbYjxIRq
	Hj1eKcqJ5IvQlY5BDvPjYZQZ2GOObAYsGwr0PL/AqHQjIw7DEb58Ja6DlnDd5vy2ezLpu5eZN9L
	w6jpjnQruZIu9F2NU/V/iuyb2MvcLZeAM7H6sao6i13XEbZ1kvRxVC9gPOKUV2J0sIEvrUQ8Q6T
	aIokKFm8Cijer+5ZW+OcBsLW7hQc930qzuSNZrmlxJ4FfIpfuKa5krgNH3fCucx8o7JVIfzvW/k
	mgkNEKfA5f4aA==
X-Received: by 2002:a05:6000:200e:b0:48e:e9e:129 with SMTP id ffacd0b85a97d-48e0e9e0142mr4734499f8f.29.1792335011724;
        Sun, 18 Oct 2026 07:50:11 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd47104csm19281899f8f.8.2026.10.18.07.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:50:09 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler
Date: Sun, 18 Oct 2026 17:49:07 +0300
Message-ID: <20261018144907.20123-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
is passed directly to _get_flow_table() without an upper bound check.
This can lead to out-of-bounds array accesses on dev->flow_db priority
tables.

Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
_get_flow_table(), matching the existing validation in raw_fs_rule_add()
and mlx5_ib_create_flow().

Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found by smatch:
- drivers/infiniband/hw/mlx5/fs.c:2013 _get_flow_table() error: buffer overflow 'dev->flow_db->fdb' 16 <= u16max user_rl='0-u16max'

 drivers/infiniband/hw/mlx5/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index e63fdb4bc3e3..bc2c15c7172b 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3014,6 +3014,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	if (err)
 		return err;
 
+	if (priority > MLX5_IB_FLOW_LAST_PRIO)
+		return -EINVAL;
+
 	obj = kzalloc_obj(*obj);
 	if (!obj)
 		return -ENOMEM;
-- 
2.53.0

