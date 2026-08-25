Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF3A377EC6
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 04:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787631693; cv=none; b=bXyZkAO/D3Zowp55A64G/hc3u0YcTJ3wQIK94ZI5s9V7u+YSWprc3+3h8ksIp56EoE0IBRFnI2UuFFr4wm4TZJZ/9/mrFVTT9c3Q1XNoslcv0MLJoktYk1feRzxKq1XOeB4s4Ix3KYra1qKoBdOBoTTF5bJ5vgN3/Yg1hDhh23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787631693; c=relaxed/simple;
	bh=ousdoYsSHSTI/BL4lJxIaBBhJ4S3nVi+5VioExM2LKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ia8NQ9DiYC4aiwRWSeSm0V6QVoaWl4oOROTNID2HMJUOHlJk9Ddca+jQKJAAINMZsnHMq1yGQoWm9nWZckwS/nsPOD7QbpVLsxDafHhCIZV6zHsHo4adEqsvCktx7+nFoB3V50jZPpmCRK/Ol5lH2ZB7d5GXnU7ti2dHj7Bcd1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0qk+Aee; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0qk+Aee"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so3862217a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 21:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787631691; x=1788236491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SmWPDK4pkOZYliuzfvf81MlMLroLGmdSkmMJ8AtgAgs=;
        b=A0qk+AeepAX7hIPDQpannGbkDQDY0q7g2awS7galM1+PDUpEZ28xlVw2zRG/6DqKag
         0aNtrz/UupyrQ4ZJ1cGTcGU6XcWoBESwtQJAcOksGCQNWR8GnT7P9REVBeNVK8el67xd
         Ce7+Ff99MxaxJ/VzSz7jdYOTWeC+1VwqD6WC5bZ/u0GVGbiHFKBmiDekyyym3Yfsxz1Z
         3nVwK+9brEqY3ZrbAF/uz3gbpexHAVsjYtGgN60G03PVBf9vN77rlo2qcEhn6kw7kAkk
         sy3hd6LolBMtyy2BhM+IAbQUkr+WadEAbEj7s3/gQln3w6LrWwdgdXhZMEpQr8KTf6FO
         S8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787631691; x=1788236491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SmWPDK4pkOZYliuzfvf81MlMLroLGmdSkmMJ8AtgAgs=;
        b=UPfUiIT2DVOph0cZIE9T1uXMr5A0IVJWgtzXN7bzWerPQxy+cFrR9oSd7tZm4er0e1
         o7I4hOjtThAbS36OrN1myTZF/gv9Xwt/gaIr8IXWk4Gv/GP10fdTh9cVdd00jmtWNLmG
         QLpivpsYJLGu5FRm3hmR+9X8MXuy+PGu/ZDwgDNvF4y6tESX6hd6P1kSGu0fVQsxexAa
         lA/Z+P9StPaFtF2O7WI8WgsBJwQSI2i+AckY5MjTtQIQKuR9i3MONTbi0HKix2Vc357h
         jvaYrJFNEVOPC/NMojUXBlPUixAAcUqV9iLOgwcptG8qa+pYGq7tb/wPYUYe/tMuDeHu
         Dvug==
X-Gm-Message-State: AFuF++kqY+NjC2hpq+25uv33p77N90zbssy3hebxddIMKqeujiJ2Ixl+
	j2V6SWL6Vd54vvfHASzwwbMgW5HU6WP4ESb+EumQCcn4UWr8TiBlQdXsoEr5V87CUurGRw==
X-Gm-Gg: AR+sD110LN507qFbSpOMCHohL0PWFQnnKo+Ned/Z1x+02gqHU/EOuKBCTTcTBwqNRLT
	wd+3R99B1k+Bx7JIcJJtIqqMwB1l4bCYfwy7b4MuhoWw1b1KPnjpNXsFRJbQa5EUPZI7kI0pBMl
	acWoerejchVy5Ukl7JdPYHTNQRKPMO8fVZIUkgMm10/PIwkJ6VmRWZYgQUfws+jp/37z3uIi4ZG
	ukuR59VlntXfbITtjkudw0VPKg0Sm8tASrWWkh0qDm5qxDUjEVm7b9jvndNvPobGUwDj64VXBVJ
	5+V3PG8DRU5L9VNvdzOhotlrUCQUiyviFp4Ohuy0HU0BDrI50GfOoVV2XnKX4VIudEpf7QoXxxf
	QfDD7XfzCMyGRJrvR3OtP9d8E0r5c1Du9nTIwU89a0ypJ4TTuQe6xC86/ObljfiO3JMWC2yNTtm
	DS3PAbV24m0iATeV5sh9uus9Abp24o+XKZhyEIeNb2zhFEhUVs/yk41RXj+SIQUITKhBf+JyerK
	cFmmMktbkVA
X-Received: by 2002:a17:90b:524c:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-396462b6015mr8011659a91.1.1787631691519;
        Mon, 24 Aug 2026 21:21:31 -0700 (PDT)
Received: from CSU-PC-08777.cmcti.vn ([202.134.16.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b8000bsm2095613a91.9.2026.08.24.21.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:21:31 -0700 (PDT)
From: Nguyen Van Tien <nguyenvantiennani@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: dennis.dalessandro@cornelisnetworks.com,
	jgg@nvidia.com,
	leonro@nvidia.com,
	Nguyen Van Tien <nguyenvantiennani@gmail.com>
Subject: [PATCH] RDMA/rdmavt: Fix potential use-after-free in rvt_mmap()
Date: Tue, 25 Aug 2026 11:20:58 +0700
Message-ID: <20260825042058.561-1-nguyenvantiennani@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rvt_mmap() drops the pending lock and only takes the VMA reference in
rvt_vma_open() after remap_vmalloc_range() returns. A concurrent owner
teardown can free ip->obj and ip between list_del_init() and the later
kref_get(), leaving rvt_mmap() operating on freed memory.

Apply the same fix pattern as the RXE provider (CVE-2026-64582): take
the reference with kref_get_unless_zero() while pending_lock is held,
release the lock only after the reference is secured, and on remap
failure clear the VMA state and put the reference.

Signed-off-by: Nguyen Van Tien <nguyenvantiennani@gmail.com>
---
 drivers/infiniband/sw/rdmavt/mmap.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 473f464f3..318e8877b 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -100,15 +100,30 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		if (size > ip->size)
 			break;
 
+		/*
+		 * Increment refcount and check whether it is being freed atm
+		 * while holding the lock to prevent UAF, matching the RXE
+		 * provider fix.
+		 */
+		if (!kref_get_unless_zero(&ip->ref)) {
+			spin_unlock_irq(&rdi->pending_lock);
+			ret = -ENXIO;
+			goto done;
+		}
+
 		list_del_init(&ip->pending_mmaps);
 		spin_unlock_irq(&rdi->pending_lock);
 
-		ret = remap_vmalloc_range(vma, ip->obj, 0);
-		if (ret)
-			goto done;
 		vma->vm_ops = &rvt_vm_ops;
 		vma->vm_private_data = ip;
-		rvt_vma_open(vma);
+
+		ret = remap_vmalloc_range(vma, ip->obj, 0);
+		if (ret) {
+			vma->vm_private_data = NULL;
+			vma->vm_ops = NULL;
+			kref_put(&ip->ref, rvt_release_mmap_info);
+			goto done;
+		}
 		goto done;
 	}
 	spin_unlock_irq(&rdi->pending_lock);
-- 
2.53.0

