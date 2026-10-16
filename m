Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B23EBF11
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182567; cv=none; b=BEOr+Ch7lB4FnVa99WVFNwADkPt3ajwwwPmVDglaelSSBWKM2xFGdIYHCZd7UXEhEms+IZmsdq+b61HXjpF2WEaoSykgCj+c5MguF3YP52QAEI9l1FNp7b3wLOos7c2LJGfBVh2bT6KDZdgjhPlpGwxhfToref2oPNsFVVsYNGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182567; c=relaxed/simple;
	bh=K/eiPh6wdByAcPG4TnUSQON8b7aKE6ICed5QBrHg5Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VcAAtSQ+FCmW94kI18PEm1g39XN5ZA+SqynkFuc3RyejLH6fDEYEdctGef6GXEW1k9rINKfaDx54Rgusr4BtprTyRXEHN0Wzvlj2Q+OymLxPhWn+ob9J5uFsUB352oMsejZ3yfU+/e70Y/XWhXy0eDNyZmvZNk0gMDJCMGuAl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=Su//ULe9; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="Su//ULe9"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5e3e525cf4bso245835e0c.1
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182564; x=1792787364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nxphn8qi8chEITJAq0WxifpclpFq8ct8M84yutQx3UY=;
        b=Su//ULe9FM3nbKuUjRrVH6jCG6Zl3AtKQnib4G3JF6NGoszkJMuW/s+ambaz8bs+WI
         AnRCnYUi8E2s1v52nx8QtjomnGjkcTb9OkYcb0VHmvBgMJto7yItofvOnuHwZqC6DNyy
         ebIaL1oKpy25pzTciFPuegIHZx4IqIKq9asmmK4BTYivKlPXH/EpkNiheT+xKb2va2Ca
         3IPwRrXfXez4MR4BUkOUu3NXkGqggzVY51YjOZhkf1UVWF0AWpEhatGVf/ujqQ9AlRQQ
         1DVmIVUN9/Co4G9qIkUJqHb1E+pQbbdLD7r7D0Xb3ByVn4saaitlULbzlbH6XvqDfzEx
         xNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182564; x=1792787364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nxphn8qi8chEITJAq0WxifpclpFq8ct8M84yutQx3UY=;
        b=Nixy3xI7Y21f+LZ9k2T4Dmfiu2IY8vvdpBJH30wUPPDdpbNvwfRjBwKEl1z2W0Un0K
         3EuYIezllGJ/Y2EnbErMguGckdsKQLvjJ4hdCsGPf6daMFYbgH/z83b3qhvUb+XzarHB
         2tqGZFpWSQIQIcXcE+n6cITtWBMZzfoufuKEgwTICMptcMb56i5izpAbo/GsDHhhYqYW
         1cZEvOb2e+L9EoV6fNZwO68PIAeiPwaws/L6GRJ8kIJBiv3T9cJXP/Jk0GcZe1gCaSW8
         sKAmP6wlmJLE2x3QRGs/tCYDIgCQAN7sN9601BANML2ttAUKlOXKSd3yzfa8WfVR6ySu
         36lw==
X-Gm-Message-State: AFq9FYINP6I0gesZI3aKf+0D/wTInNs51U2/lr7SRLCqrOVaFud0ffdw
	z5SZh772H6jn5z/z2/DQ7iPoUFWUC7+tJnSVbq6rLueAonQcre25dYr1OyxsnQUCEtnyax70agg
	YADX2lA==
X-Gm-Gg: AYBFou0lETt64tCz092NNkCZCK8M4aS/1Jl9s0n+mxb3zU+ZkGcI6tQ5SJLyOwg2Dm3
	CwH4jH+NqojRCnV2lZLliHmAlayH9vzpCnrgH09vAyL70LWwhVs81vNMlUhwVTRmyvM0L+aQ99A
	FX5rasf9MWEN7tqQ2FYuvSPgIY3TTQsGX673Tf+3DZkeG90nc9E2vtTxIBlmtTgmM5ujs1OrRml
	EDoJxavZ+2aTbseIk2u74kRiq7NPHN71tBmaLhGDvH+QP8uIwcbNK2fX3oY6jS5w7hCG8+Yvfo7
	dLDRyRljAV2tjj1tKWcZC0Gt7pZTizscUHmIpdAQVTO7GDcts1ekE6DBbEtuxhoaazYf00s1R+x
	jHy3LoCdhbdKh59/9WzWtGPO7BqyZRiwAchywjVWszvDMFSPinhbd0CHHv3IfXFtKsR4slL+/3U
	ISqj+v5M2Jaa8RZDYIpWf3IeF2BVRO2aepfygA2CESVQmkRPZ0QFbxs0h1rlw7YW3Vqy4BKpubT
	Nm+y2RNLsKqP7tuSNwlpUhd4iNQEgnE3ZPG04fQZB1ib0Vtl4HAS1bwfj1zQLxONEVYChFF1ms1
	91ueeKk8Rw==
X-Received: by 2002:a05:6122:c1c4:b0:5c9:8b3b:deb5 with SMTP id 71dfb90a1353d-5eaa9ecb28amr507582e0c.0.1792182564282;
        Fri, 16 Oct 2026 13:29:24 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:23 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v3 0/6] RDMA/irdma: Add support for ioctl
Date: Fri, 16 Oct 2026 20:29:03 +0000
Message-ID: <20261016202909.1289496-1-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

Hello,

This patch series introduces support for uverbs ioctl queue creation
(QP, CQ, and SRQ) in the irdma driver. This series makes progress towards
modernizing irdma. This enables 1-step queue creation from pinned UMEMs
and shared dma-buf heaps (system_cc_shared), providing RDMA support for
Confidential Computing (CoCo) guest environments where memory encryption
otherwise prevents standard host-VA-based queues from operating.

Historically, irdma relied on legacy write() commands for queue setup.
This series modernizes irdma's queue creation path by adopting the ioctl
infrastructure:

1. Plumbs uverbs_attr_bundle into the irdma QP and SRQ creation routines.
2. Registers irdma's UVERBS ioctl namespace definition for QP, CQ, and SRQ.
3. Implements 1-step queue buffer creation for QP, CQ, and SRQ using
   UVERBS_ATTR_CREATE_*_BUF_UMEM attributes and ib_umem_get_attr(),
   configuring hardware Page Buffer Lists (PBLs) directly from pinned umems.
4. Split CQ creation setup logic by umode and kmode into separate
   routines to be consistent with other queue creation logic.
5. Adds support for driver-specific shadow area UMEM attributes during CQ
   creation with CQ resize capability.
6. Preserves backward compatibility with legacy 2-step write() path
   registrations when UMEM attributes are not provided.

User space rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1766

Testing:
Verified with rc_pingpong, srq_pingpong, and dmabuf_pingpong over irdma
devices in Confidential VM environments.

Changes in v3:
- Improve patch 4/6 to split umode cq creation to a new callback
  .create_user_cq() (irdma_create_user_cq) (Leon)
- Clean up duplicate bounds and NULL checks in cq creation path (Leon)
- Link to v2: https://lore.kernel.org/all/20261015011940.4122452-1-dhu@x6u.co/

Changes in v2:
- Add patch 4/6 to split out setup logic from irdma_create_cq() into
  umode and kmode helpers (Leon).
- Rewrap commit messages to ~75 characters (Leon).
- Fix a pble/umem resource leak in irdma_resize_cq() (Sashiko).
- Link to v1: https://lore.kernel.org/all/20261011011022.1445352-1-dhu@x6u.co/

David Hu (6):
  RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
  RDMA/irdma: Register irdma UVERBS ioctl namespace
  RDMA/irdma: Support UMEM attribute for QP creation
  RDMA/irdma: Split CQ setup to umode and kmode
  RDMA/irdma: Support UMEM attribute for CQ creation
  RDMA/irdma: Support UMEM attribute for SRQ creation

 drivers/infiniband/hw/irdma/utils.c |  12 +-
 drivers/infiniband/hw/irdma/verbs.c | 756 ++++++++++++++++++++--------
 include/uapi/rdma/irdma-abi.h       |   5 +
 3 files changed, 568 insertions(+), 205 deletions(-)


base-commit: 978361dd2ccff357d4fe6aac6ce057d1bfae8312
-- 
2.56.0.176.g3575e65682-goog
