Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAF520C029
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027232; cv=none; b=TvMI/as8XiVv+pV2j34DnhrO3cWVsU643JQJwJFxiincJYRMJ91mf9RhVP4FgNNkz4BlAkn/m28vs9D7QSojXgdWSjZl9NbY0isQwSWeAIfRE1If31cKK9sVHxrQgvMv1oA4iRtkPrCm9ERPVaSjZMGDZBWJPXnokERwc9tklhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027232; c=relaxed/simple;
	bh=U/uHtn4m+NNYAlOZgFLNrJ0c7na8xGiMuGaK2nPn3Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gp5v4eg8G+xKeKCmISsVZwQCUZBbY7UUbs/eKMgNQ0qT1tw0eP0bRU1I3+NCu6XGICiPAufdemmZvxegR2mSmRslofmvW+ys+2SmFRhr/GlaI2Ymt80JBCxCuwbY0R23vIbqgpc+a0unC43uzS/gr87/ppTlt55vqznaTDXvXa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=eAFTnr6M; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="eAFTnr6M"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7c3b75caad1so2909229137.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027230; x=1792632030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ryVASonw0Dj8PaeKjL5g58hdmwHMfooca29xETnUQg=;
        b=eAFTnr6MUv7XRJj1+UK47OJdMNNeVWe5W2tAdwbe+vuFn9T6PRsWdJjcI/sW4sKlje
         fzvWeyfnSUwRGlUoValrTbLiRwPATJpxAtd9sqhuIYIz+zpDOoORGymoVRX8OGbo/r9j
         bVH6alDm1zrFhgTWkwGs5g6lDmooVafn1pBfppwcG9wkpT4ikLDRTW8ph083W5z7y7K3
         uHq0dyMxkt7nwXg8d4+vJEGc+Sq7lWwjwYOgH2+qr6RjMpjOCFXeHh/agtMLYHKXTlYW
         dSKR3D/Wq8+btICU1eSvtcWelRx/J5Ckv4iLYp8foqIH/iEYRMKOlD7UbcsOv8wB4Agm
         DKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027230; x=1792632030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ryVASonw0Dj8PaeKjL5g58hdmwHMfooca29xETnUQg=;
        b=lzgrVqu94x+E2TF2f8WoBKvsw9JygpJgkaOjyfcpy+2k9PFeeVyIgHTxMU9FOJmiLF
         oW3N8bPWYLJTgyGSe6MsorBlHH4URnycc4ZQNa563HPfl329bR5l5QtuUHhpALfu1dh7
         +h3qCKkUn8hxny+yLZvEwr8AR1u5y1mx0wDtUblOva9xLGJeubjSRoriUP4LA7ZjojVM
         90vLQj9h8phOFcSwqdxlVPERUSVWfyFHKRbMYNPGg6WxpoUbF+EW62lYvjEwk9CUIZIA
         niEc6Vdd+Nul709tIj0GYkG1D/4SQnbBWlh8GUHjSJVI3UTusrlzAWnyt7TErbyUHtJm
         13zQ==
X-Gm-Message-State: AFq9FYI+OmhmKZf+tuXqmh2H3FcNLQ7BmbBV+txW7w+TLFCr677JDae6
	tGGZCGYh/W7rpG+jrAfr7EMORH4GzjAQd3NoYxKUloULc6H+formigbeNlokaH5Hvocz
X-Gm-Gg: AYBFou2+hGb1whgRB4RBpgN15XkOEUJZNf5JCS/KjHYmt4mxxL3JJOwFiy0RtMC80IE
	UNxT2lppaFnnpM18WG1nMUyas00RagmgQluD/wIwI+GOr5ccR10rj9ouH3L9Ahm+F5K7JF4LwkH
	8i/MU5O4LbK8xUrG0cMGpMwJ4GgVfreMqcaT3vWxWTsmcQX9gEvXCcsIgNiYnQ7slvkWy8xlEh4
	epQYoMWFVwfuTHiGTWzcEbalDZbSnDYgjmo8qq7wjD3hfoXFtx9HS8OvCpd0ODTdvYBvGFNUTO8
	hDAJLW4HA3/zyDHtW2qb/C5F8Dlkf3cHkDZ9mhIdelowuYM0JOJG1CJsDu1oYwo29Z396WvWJW9
	2LQIyzUd7rgxv9Ol2sD6SE8izW8JwXV/7EMSB0zjBSE6edtehmXsgeipWO98vuWbk7zDbcn2w5K
	3z4I0DyRi4A0qZElR3aELTIpiyTKyB5geC2Lw6Q7jMolvZQb1Hr79JdRUY3OiMLClViS44XzaJ5
	irP8SJ6mss8znbR8bwQaNDWIDTlLz7LZMUbjUYQ5f6+rvQF7IlDzAR9pnSs1SCuavB7UiHpIlIa
	QDn1T3JuIA==
X-Received: by 2002:a05:6102:418c:b0:7c8:3b8c:82b8 with SMTP id ada2fe7eead31-7cb3730ba80mr5451079137.17.1792027229862;
        Wed, 14 Oct 2026 18:20:29 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:28 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 0/6] RDMA/irdma: Add support for ioctl
Date: Thu, 15 Oct 2026 01:19:34 +0000
Message-ID: <20261015011940.4122452-1-dhu@x6u.co>
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
 drivers/infiniband/hw/irdma/verbs.c | 574 +++++++++++++++++++++-------
 include/uapi/rdma/irdma-abi.h       |   5 +
 3 files changed, 444 insertions(+), 147 deletions(-)


base-commit: d2c08575500145dc5cb55075cd9b177626531613
-- 
2.56.0.385.gd3acb90ef8-goog

