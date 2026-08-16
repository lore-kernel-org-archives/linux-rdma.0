Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0EA2DAFDE
	for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 04:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786855527; cv=none; b=K3NCzT3lIqLBI/0dP8gkXm68vUltZjWsJXOpppODN5kPPZxatkjlTty2/RSnj5xIST/ZJXCcszcOzRDva7VGtp76g2L8LGQKxVUDVOplPHM5uyg4ToCL6ISxWG8UBbs2TApt9aGAbLWGDMOtBUk/yAA2AHIWVd7N3NXdZn7Hs1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786855527; c=relaxed/simple;
	bh=VPZwRSomxevHO7ok/WVEp7eMxLHx3jbGcDllWYjpIk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r5BV5kIogAmcxTE3Sb21gEztoDNy5KXsSInOUE7B4zV9fC2J6NeZWNjh/SE8OHh2j8yC54zoi49YSvd+9S44dYYVz2MZWKb7VXUYkY090Ey6oG8QEVXhfhOSbYTL4d6KlctPBDFNGaL9iE8EdJm+/5OgbMcHPOH8dLJAXmWiJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qRSqVadc; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qRSqVadc"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52d8679c149so14765621cf.2
        for <linux-rdma@vger.kernel.org>; Sat, 15 Aug 2026 21:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786855525; x=1787460325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aXQqM4Uz+B7ErOlECxSpCZ++Y8mo3D64bY4QdYcgNwo=;
        b=qRSqVadcpAn7biNDanCxu8O7iykcNgRAO46rIZbwxWbcqrfJi1z8kuY6jf8fVar0Z/
         KnIGj4FQ4P7SNjpQyZ0XbVMhhFW0mGzYBxWTeh3fUNjhRulGYflWZZ3Dqm3FkCB7Po8W
         i27/poacJt16rvPraNr7ytlrZNtJHVilbk88ln1RlWSVJjeqxdAVxaowgmPJDZT9tk8g
         6QwdeKcEGTl74Jod0yHiWcHjnfhXfJY1uxxpJKrtrI+sticqhZgGGdpUMmaxVzsSd9Y9
         xofZMHB0+NTx/HapRBbOHXQpaaQyG00r7UVLNLKcR5KWqvOL/4RJsJeM7pUbU2Ad6WzZ
         WUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786855525; x=1787460325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aXQqM4Uz+B7ErOlECxSpCZ++Y8mo3D64bY4QdYcgNwo=;
        b=pcfzlWrJD8Xs2W4ONS2aBIyPl7Pb3NfVW1shi2los70vu+tSNIKe6SA9vnh2WyQHKT
         ifOOZZC5WJFr7wfoAQqbqdHBch3a9I9OqYfUSIZ/encQ0RtClr7iNkOZ8sxqvoA7JTN3
         +bk/UDoPS/mDj93jBVH5gF0ouHevRlBkl0+t0D8IXzPiEJ1/9cut0YITYUdMXTEmzqEk
         xmJr3ZQNI8jT5gxm4Rm+3lTmlbnd4atzoVBJWGNeQbNTjDiIWKC+de5uDB7fubmJJoF0
         u9bbruxVwF+E5cliZDcbisiZL8OjEfoRJqsuRnWm0pDel2pswIJlVJY3/wIhEmcci3MK
         VcDw==
X-Gm-Message-State: AOJu0Yx/pX4tYv5Enpu6L670gAX/T7TQuqMknipWEsBnz8ZhZ6PXSxVI
	MC2a9Z1MToz1MyaTfuKyRoBHP8TLAi93rbq3mC2wZ4YjuVRMilpG2U3i
X-Gm-Gg: AR+sD12SiTPXFeW9YyENCk7eBIa5sBKs25cMfVdYeqkgU0+07Qwehy7o2B66RqZXPJz
	UBvcPbNtLB+anR75RStKKXnvgI2AIsJF19vP48vZRktE0y7ahr25SRISYLhyC7l8Y/JC9WOUnJ/
	DJyNm8I8u8gKR4jLX0IRRvpjnPXACEx5k5MYVKckchzrJcW96Okzzp/PD4rATfrDXNQ00yUtpe7
	VPAOtOFME4XuBvcAPL4tCcgwipOhcq5pDO7zqRsXgS98bsBcBw5UhlfDv+xcnZN/4QeGc3ZVvg8
	CdlWHxGEo8CCXgxjQJEytIFrXPTrEi8dckMKWiQt4oXvYDoA+ZwaJ+XEiuxBt3rDCa0Ts6bwBRa
	LYgCfAPcG24c6EhgfjMUgWNNZsGa6dPgSRayB18imF2QqHAiNB7jQ4qjnWqa04Evj0VV3ejwxYO
	4gXKoA3gDha++B4Vp6fNUHbEMOPFOQtRa//3MuBJTbg/ljo5jjpYPRUcKd8bXvRR7311wdU/Xvc
	swSFkYxeEVGqzA2hg==
X-Received: by 2002:a05:620a:a293:b0:934:970a:beb2 with SMTP id af79cd13be357-936d22ce4d1mr1589429185a.26.1786855524958;
        Sat, 15 Aug 2026 21:45:24 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936ce1ea6cfsm687105385a.27.2026.08.15.21.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 21:45:24 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: yishaih@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH] IB/mlx4: Fix use-after-free on pkey sysfs registration failure
Date: Sun, 16 Aug 2026 00:45:10 -0400
Message-ID: <20260816044510.3848996-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

register_pkey_tree() ignores errors from register_one_pkey_tree() and
continues registering the remaining slaves. The per-slave error path has
already released the pkey parent kobjects, but their pointers remain
stored in the device. A later device cleanup therefore passes the stale
pointers to kobject_put(), causing a use-after-free.

Clear the parent pointers after releasing a failed slave tree and skip
unregistered trees during device cleanup. This preserves the existing
best-effort registration behavior while preventing a second cleanup of
the failed tree.

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 drivers/infiniband/hw/mlx4/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index e688ad66a895..5438224bf325 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -751,11 +751,13 @@ static int register_one_pkey_tree(struct mlx4_ib_dev *dev, int slave)
 		kobject_put(p);
 	}
 	kobject_put(dev->dev_ports_parent[slave]);
+	dev->dev_ports_parent[slave] = NULL;
 
 err_ports:
 	kobject_put(dev->pkeys.device_parent[slave]);
 	/* extra put for the device_parent create_and_add */
 	kobject_put(dev->pkeys.device_parent[slave]);
+	dev->pkeys.device_parent[slave] = NULL;
 
 fail_dev:
 	kobject_put(dev->iov_parent);
@@ -785,6 +787,8 @@ static void unregister_pkey_tree(struct mlx4_ib_dev *device)
 		return;
 
 	for (slave = device->dev->persist->num_vfs; slave >= 0; --slave) {
+		if (!device->pkeys.device_parent[slave])
+			continue;
 		list_for_each_entry_safe(p, t,
 					 &device->pkeys.pkey_port_list[slave],
 					 entry) {
-- 
2.43.0

