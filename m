Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3390C5FDA7
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681084; cv=none; b=SXpeHXl3m8f2Ettiwl+nNWINH0c/bQKc9JS7XoUEfNAqaEZ4/P3NBZmFRGH9JQGhVSoOGQWuIzo19jSPbqo8wk+gzE/VY/EvC7B4VOxLgZD2S/O4a52PmioIDtLRXwA/ncFaM+X32BnkNMzuT1C8olerkcoBpMbRh436Xy8JhhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681084; c=relaxed/simple;
	bh=DkU1fYd1IIAxte9Pnb9eqIS8jl7Hi3XVnVU8rEsYprY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZUlOYRKNEn+d6jO1w9kqBubCB0K41x62nx67cfU3/giP/oj62Wn8tyB68fM6/XsyXh6ksL9y9huITH5nela6XZO6FdRPg6EaQsu6MsX1FzHOxVqaIdKzCKma/KlEJ2mt2C7WrXPdeufVnLLx6GuJ9mfOdrALW5EKeo7CcCrJs9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=B1n7OmPb; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="B1n7OmPb"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8ae8541a2f0so7371577b3.3
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 18:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1791681081; x=1792285881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kGp/tVc5H0YMoXXk+u9E+QsSAwD4WEME1DUtDG16Q34=;
        b=B1n7OmPbjLcj/1cszyMZax+yEKlgyFbiSxODFLp01EKrZJ0Y6CJB03Gh8R0NmbbeVa
         NMrpgEyd9gArIwisYtIOE8rQK+FF6pBOJDscpICJc9RnftNhJXUkI/6cHViUXT/2j2GQ
         JrhZomiVOnaew7chhdJ3HyooEG2jfb7X0AS6Bp7jQWrtf6MN2iRzciCLy7B/KpJ21IBk
         ZzIOhltdXY05eqyNcabY2e9BnBlQLILguuTxP345yKcRftRNjRPZt1layLdyTNOC4PBR
         /67Cmb5dm/LnP0cRXVpzbYcRT4aOyP83/60I+jbjoBCBsnT1Oi0lYAKCZMKcD1qH8LT8
         YaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791681081; x=1792285881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kGp/tVc5H0YMoXXk+u9E+QsSAwD4WEME1DUtDG16Q34=;
        b=T6OpND+9AurC3Bpak5qhEeeizBDHWuKAcp+qWcA2I5ryelmJW3MeF5RvNzZXZ1o9qX
         iBy4rvMCH2tuczJu49bEkubjEQMCBzM3kz3d6CQNugRe6snI5AowuK8irOTFkavKoRoL
         K9iZ4wrEN+ftQ9nnggQV74++vZbVgV3gVnwRHUvQ2A+jDAbBZs1L1OSZ+Lr2QtnJoDx+
         t37L94lNNmQnV3Y6u8W6IZfaJawnhElFpUgOv6ioU99+uom1x0uxVf5shoKmuGKP723v
         EZXBrORT/FJlL2YAE8ChnmGMbKSj3kmL9qpiufpJmjIgqWpPkfCZVmSJgwmvqBMsGW7v
         ooCA==
X-Gm-Message-State: AFq9FYID3JoXOl62+1R/biCOLievGyAxATsAG2MempJNbetwtGFH7ykt
	fMr0ZHu2/z1Kt9Dq9tLS1Zl7vCK1RckGsbTGZ1+onLTAy+GGJW4CHEHmVNpiwTLXy6md
X-Gm-Gg: AYBFou0evgEOw+2ly4W16rssbrlzylhtWVNrZ8iiuksnEIRbsSkNvmVRZRGULAlwfU+
	bArLSn+OfRlWR0iBQmEgypgYRxCVqCiwz6lt2HycBtFjncbCjBZnTNnp1Q2Kn/GjxXGdVT7nNN/
	9Mo80jBk87kV9x7CbbFf1ClV+hhtW5EDw36c6cUX5BxXyeUcXT0pWxJj7ZnADWFzTr0dkYV98s+
	Z47MyO7GxYNdKzlsb6Jsmj22bfd820sJz9W4yNzMq7RrD7s7DuGaTRah82Z9UZCRMI/PZHuTUX0
	9EwntI9aaLJ3h8DCE6uHA4uXeSI9jOOsUwCK8B2xxx3JtcOQF/uDgmDbo+Xj230jxBi1VivXJWz
	w6n3P1oMRp203YHeqZ6NaPlS/aMwnXRMWt4QGKBk3DrVwS3+Kvys/ivkuCTQ/sDikmQ7oMc6wCh
	JElqD1UNFEAdtyVv/lVlOQ6jv8RNnsSMk/lsaKFclf0Y1xV+nL3/L7Pbm3ROtMApgg0d35Pw8ZR
	F7XMV17P6TQgwIh5rbmsxphqPHCxg2yXv6Mzm7T1dDl4TOSD+2/4AH4HXV2LjbQqXZiCpVdlNo8
	jRVPwydFcA==
X-Received: by 2002:a05:690c:95:b0:8a8:6fac:1525 with SMTP id 00721157ae682-8b07edb158dmr24589047b3.46.1791681080997;
        Sat, 10 Oct 2026 18:11:20 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b07f263bc8sm21311817b3.45.2026.10.10.18.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 18:11:20 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next 0/5] RDMA/irdma: Add support for ioctl
Date: Sun, 11 Oct 2026 01:10:17 +0000
Message-ID: <20261011011022.1445352-1-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
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
4. Adds support for driver-specific shadow area UMEM attributes during CQ
   creation with CQ resize capability.
5. Preserves backward compatibility with legacy 2-step write() path
   registrations when UMEM attributes are not provided.

User space rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1766

Testing:
Verified with rc_pingpong, srq_pingpong, and dmabuf_pingpong over irdma
devices in Confidential VM environments.

David Hu (5):
  RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
  RDMA/irdma: Register irdma UVERBS ioctl namespace
  RDMA/irdma: Support UMEM attribute for QP creation
  RDMA/irdma: Support UMEM attribute for CQ creation
  RDMA/irdma: Support UMEM attribute for SRQ creation

 drivers/infiniband/hw/irdma/utils.c |  12 +-
 drivers/infiniband/hw/irdma/verbs.c | 347 ++++++++++++++++++++++++----
 include/uapi/rdma/irdma-abi.h       |   5 +
 3 files changed, 314 insertions(+), 50 deletions(-)


base-commit: d2c08575500145dc5cb55075cd9b177626531613
-- 
2.56.0.385.gd3acb90ef8-goog

