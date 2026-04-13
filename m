Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9C232F749
	for <linux-rdma@vger.kernel.org>; Mon, 13 Apr 2026 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776081603; cv=none; b=nykgzizEW/SyRVJWqq4XJSZqGGMtbVN4F4UtpITvO0Asmhd4nksbDinrJ3fwAwxh1Zr9bXS9SK6/h2WtUvn85SjIlvvbA5ChKml9rrlDlMGlmZory+knyvB18t4aK8xPqV75s854L/Ov3vkCHRk1VOK0C/jB2csaBoP6n/aOdu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776081603; c=relaxed/simple;
	bh=6fwLwWNLs1EfDGkdX3ygPgU9zxnBYk06z+iVq0IN+O4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RE3VFpqnEYeicND35rNJ+FZGnhj0JKjBfibkcWZXahLtdATeh5cKwaAgFEtSmkMW5ZMaXzEusoSb/B7kLYY2ilPwGNRWOvWblSFbGhRJkfdYJjukZfte5eR2m0yI/uz4TLU9TuDmfuMYVlWso6RrxL1nn4hzUfVU5szeo1351N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NAHT55EH; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAHT55EH"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c741692db4cso1072803a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 13 Apr 2026 05:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776081601; x=1776686401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3u8EWySsHMnJmBCST1Ast9PFMWGZFxzWnCzXib4HbCo=;
        b=NAHT55EHxxUmHG/sJlomRZbP0jXVWEoeLLns7CAvoZO44nWxqhs5W5BX0SY3kRD2H3
         O49mfKq0AWmi+Bi++aHzN43uOhduJvfmphxi9ECZ8kQ82EdVP3Oe2Of2rK+vkYeHHPxE
         hazlMwpVkhOUmSVJlNvFfZEpbetmvBLPKCdpN2GOgbL6sw5jmBE90L/24IGY0h3DoPXi
         kMTfkhbF/pNu6AaYVsFl8ck0H+92Ug1Hg7lAUbWZEEUIzqfEqXpKop9w2G1otQ5ykJii
         FLxP7ZuKWSUwgD/zqLBmRbH3rWYyIe8+oCO/G914GU2/fmQgKNT2X35kqZgPZ9uVD7Ub
         2feQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776081601; x=1776686401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3u8EWySsHMnJmBCST1Ast9PFMWGZFxzWnCzXib4HbCo=;
        b=o7kI4/nnC4plEu2HovYUVoIgDrSDaiKIGJndAQ3mfwfC2StMgbqoG2/5VqxaJg4ASd
         OFatm77W2Og+wWaLGYYCgseje6YkCiKVn61JtVPOzHr2EssR1TM6qbB1Q8rqkE4D+8pV
         tjJtV+rFMVktD+indmLNYe3kQmQXdNFPJ/FwfrEzqT2Dno3Vs9oiEJn6iMNBRPh41+hM
         6sAsBUIPV1azi4yHs0qp0TwN+5QPD6vbq+RlnOUpyniFJJamO2Y/i3cLlF1W1xDJgc3K
         IxGJVL0OYZnRVj1GINCY+wigMj+zjKGwfTvNB80S6CISObld6eDv2m6TodQmseEeViyp
         jQ5w==
X-Forwarded-Encrypted: i=1; AFNElJ/P5bphaKMCDTq+dtITMTdpITvU2xs4Pt4VUU+3CRGk9P7Dk6ictdTnRL6/FUlX8EC9YLpItjbnD+rw@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5eWRUYkSnqTVhGCHHauG/xAccwtZOHSnD1rC8zsAbebP/kWlQ
	MzVC6XBb469LAsPJ0K5CRL6fJOk9v7qP0j5EJaxzkPaw9yjhMUF3EgZv
X-Gm-Gg: AeBDiesVOxqG/hAlDIxN6s/CxeYxgruUXzmtzptrTLa/IXPSlM4BpKfoz9NU/8/L1Pa
	vYxlxmp4f3zMdj/i7RGSDJ+cXlffbHJIjuf4NTS98Jevu9NpTsg4oxTDwH/I2Z0bgGP3quGVJFy
	/6GaoruqsRKMlESjVwwrhxkROPwcB0GoiRMPUTjp0sYf75URKBHB80y4WELCOLpvdRvnkla//YZ
	b1JsnDMrMsclJvkWFapbdRgzvmUsNhVMnJTvfsK9RTDFeiMzJPTVwvfN+UnRBNRbtPoIb822Azi
	QqZAwqoeEyCJ3tVB3yijeyuYgIqVfrfXqQGj1ELnIycdp1ct91EYBFFmfl9jvd+fl4VsrDxr6+k
	Ez5RncpIN64KnTQAUuKC7rgd/LUjMQknKGNRErk6yDiKxx9mU2aUltIdgey2wugyf3VgpyLoidP
	UcQuRKq0UjB16WhJPzg/98OMFNVETbGVw=
X-Received: by 2002:a05:6a20:e212:b0:39f:48fe:830b with SMTP id adf61e73a8af0-39fc95aa2d7mr17020912637.30.1776081601292;
        Mon, 13 Apr 2026 05:00:01 -0700 (PDT)
Received: from lgs.. ([2409:893d:1188:142d:db27:7a46:955d:48f7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7944cd52d0sm764199a12.21.2026.04.13.04.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 05:00:00 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Roland Dreier <roland@purestorage.com>,
	Jack Morgenstein <jackm@dev.mellanox.co.il>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] IB/mlx4: Fix refcount leak in add_port() error path
Date: Mon, 13 Apr 2026 19:59:48 +0800
Message-ID: <20260413115949.2799399-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In add_port(), if kobject_init_and_add() fails, the error path frees p
directly instead of releasing the kobject reference with kobject_put().
This may leave the reference count of the embedded struct kobject
unbalanced, resulting in a refcount leak and potentially leading to a
use-after-free.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using kobject_put(&p->kobj) in the kobject_init_and_add()
failure path.

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - note that the issue was identified by my static analysis tool
  - and confirmed by manual review

 drivers/infiniband/hw/mlx4/sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 88f534cf690e..15b36b9e4bd6 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -642,7 +642,7 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 				   kobject_get(dev->dev_ports_parent[slave]),
 				   "%d", port_num);
 	if (ret)
-		goto err_alloc;
+		goto err_kobj;
 
 	p->pkey_group.name  = "pkey_idx";
 	p->pkey_group.attrs =
@@ -689,6 +689,11 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	kobject_put(dev->dev_ports_parent[slave]);
 	kfree(p);
 	return ret;
+
+err_kobj:
+	kobject_put(&p->kobj);
+	return ret;
+
 }
 
 static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
-- 
2.43.0

