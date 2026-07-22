Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E33793D2
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746741; cv=none; b=WZOQFoW7W27DfhfOUptjcZ1uks8w39tjoYQW5psbVU5PXPlazyahP6HWaTMO14BvPLv+S/YMn0o81O0IaJjgRX4JaZ77AHR9D2zIGf2TZ/d5iMVk4qqruLqlSqoFPB9U7etw1p0hZtnqVoZ93CTsDaqYdKcr0vkQOcY+J2ukLU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746741; c=relaxed/simple;
	bh=1EblrzgLJcRDCn1v3FJEGmGB3FLGsptGxFAPO04kyTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ulv6BKkC5VwM8ySmpnvlGGL02gKy7VK8FEDm26AXpZv8kRFh7bCn0KflWL83EWny9WtthJi/IJ5rM0/jDPU3ryOPo1hOchVj0xiOh3QDFtUhi27NNPSyVHt4KstWjeQv3bt4UlbogAle+9pzlA7DWs0DnvoTwcpBGOD3AZ3EBfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=nWLDJetw; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="nWLDJetw"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso22358395e9.2
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746738; x=1785351538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Roft6Ikjq+qhKFFk0rGulNK01SEMvk3YKlHglgEZK0o=;
        b=nWLDJetwc4PT71WlB0yppd3cgwnFSO0G0ShMgQYptDibs4g5PUbfw4QkMVnrzpVrFe
         XARBIX3yPEa5YAKxzcZFFN8z/GTCctWC7+n7YMDbOb7qKBBB55EQvbhTJtqf04rNvF/2
         YkBcG5dyj1XtNdE5BLiGL1DfoNLM6B8ahYPscNf2YqIucoXVtiOELpo/dpnAN4DMr1e+
         THEbX1fO/Sd03SBw92H0xzku4j4qiC+O7eq2fcDfZKF0J9WIrwsZPpX2pQlcLTWSlmJ3
         d7XJn+/WvfIZ6SSGjxZM1G0E02lLfGGBUFXZAFaQ/zjpnCvLyvFjekwQIbXuwm0wZXnU
         sZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746738; x=1785351538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Roft6Ikjq+qhKFFk0rGulNK01SEMvk3YKlHglgEZK0o=;
        b=tZ6Q504b8H2cbmBJ0mtDAisjw9n4Qx/5boHHn0s2IKVdtdLbJcvi7Sj3pXXlwzleNa
         1U4BU3Ptt+H9mOTzgjWYywn0DmiVTn1i6coOmnwhAXFjlh75Hlce5wiK4UkQTQZUca3o
         356huaRYhqG8R7u8k62dk5iDkjYB6d0+Xorg3pPoX0Mo/LLQgojt4Yx703WIr1kIMF2g
         09zQ2ztUzUoOascd5LXCk5EOFgRZQ4tXg+CWJ/WaA9bf6QcErg9LvL60Fc1xMhvaPYPH
         8KVzgzEqgKoU3ccU/zZNq4iQLjMc86Po4dD2swqbXVM9YWuY6PrwxwofDFz0473DLKY2
         FPUg==
X-Forwarded-Encrypted: i=1; AHgh+RqTz+gTun0fqUSX+LcIbng5HJ2z0WcWMOS8aiqCtA0t5OKtGdnOat8xyzQstyzxQ19HyXUAG/3gCQIC@vger.kernel.org
X-Gm-Message-State: AOJu0YwZfjbTNt4OPlDJUVqnm+pLwa7urHnAiZIT11+pRgrkWg4pbVa+
	hAgVUpgRCaokTMhdaBOGZciGmlJpfjp1/bvS/Sc5N5aG4pIBpMo5p/27GAtMqawSmg==
X-Gm-Gg: AR+sD106vc+qTz8kSGPuxwO0wEOwpzcMVOTL9JUGCDYHGTih1WxxTDiIJEHfJ1s0Fpx
	SfPN9ORGJcxKU40Dji7NfceSFWoD4eT0EgTIylVtRfZrIzrEnoK7V2twy0HDuuqMM1K0EjRFYyU
	AWyWdcZn0chUqpY2Eo19eD6kNpOyBon9Ve/1wEekwuqf3KXLF0ANA84OkkADmAeVeP6fi6Ak8tU
	5LIBTQ05EkCW2aorIGW/s1zJuX9PBJ05WOsCZd11s9CK/4xlARtRa1JEFZ7DLUTIJ7IDg1qFcnb
	3/dsJqUvWKrcT+pB5uxk1pUK1vaCDkNGAbFnKrA4T9x8j0KOOzbzvgFpKQNZEMyceVeoDs/xLDq
	mgpKYQicTwWQCKyo3PKafeKv1cjP65/4oQb2E8zGyQrP7d3eWVZlqLgR48C5wUc+qtIHCxgeXpx
	3Drg4MqrOx817IJLz71hO9NrooCza3ixn/YK1liEL5QfkIl4c=
X-Received: by 2002:a05:600c:1c16:b0:495:5022:71b9 with SMTP id 5b1f17b1804b1-495502272f2mr281514875e9.33.1784746738206;
        Wed, 22 Jul 2026 11:58:58 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:58:57 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v4 0/9] block,md,nvme: correct handling of unsupported P2PDMA transfers
Date: Wed, 22 Jul 2026 20:58:32 +0200
Message-ID: <20260722185841.449934-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md treats an unsupported P2PDMA transfer to a member as success, and
nvme-rdma retries one forever.  Whether peer memory can be DMA-mapped
depends on the PCIe topology between the two devices, and since v6.17
the failure completes as BLK_STS_INVAL: retryable for multipath and
deliberately ignored by md for member failures, so mirrors silently
diverge.

v1-v3 restored BLK_STS_TARGET for these failures and tagged P2PDMA
bios in md.  Logan Gunthorpe proposed a dedicated BLK_STS_P2PDMA
instead, so no consumer needs to know whether an I/O was P2P, and
wrote the core patches; v4 is built on them.  Patches 1, 5, 7 and 8
are his and keep his authorship (7 and 8 with completion-handler
additions).

  1  block: add BLK_STS_P2PDMA (stable, v6.17)
  2  md: keep REQ_NOMERGE on P2PDMA bios
  3  md/raid1: serialize non-write-behind writes on CollisionCheck
     rdevs (pre-existing bug patch 4 would widen; stable)
  4  md/raid1: no write-behind for P2PDMA bios
  5  md/raid1,raid10: factor out raid1_write_error() helper
  6  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error()
     retry clones
  7  md/raid1,raid10: skip futile retries on P2PDMA mapping
     failures
  8  md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
  9  nvme-rdma: return BLK_STS_P2PDMA (stable, v7.1; needs patch 1)

Routing: patch 1 block, 2-8 md, 9 nvme; 7-9 use the status patch 1
adds.  Patch 1 alone already fixes the divergence (md stops ignoring
the failure) and the multipath retry storm; the later patches only
refine the fallout, so the series bisects safely.  The md patches
fix a v7.2-rc1 regression (02666132403a) and carry no stable tags.

Tested with the QEMU raid1/raid10 error matrix and a ConnectX-4 Lx.
After patch 1, block-layer error injection accepts status=P2PDMA, so
the md completion paths can be exercised on any member with no P2P
hardware.  The patches were developed with AI assistance (see the
Assisted-by trailers); all code was human-reviewed and tested.

Against v7.2-rc4 (Logan's base).

Changes in v4:
 - new BLK_STS_P2PDMA (Logan) replaces restoring BLK_STS_TARGET; the
   R1BIO_P2PDMA/R10BIO_P2PDMA state bits are gone and the md changes
   shrink to completion-time status tests
 - blk_dma_map_iter_start() gets the explicit
   PCI_P2PDMA_MAP_NOT_SUPPORTED case (Logan's patch; v3 kept
   default: only)
 - write completions record the whole failed range as bad blocks
   instead of narrow_write_error()'s per-block retries; v3's coarse
   retry is gone -- the new status is deterministic, nothing to
   re-attempt
 - read path: bi_status is evaluated before bio_put()

Link: https://lore.kernel.org/linux-raid/20260718162547.448892-1-mykola@meshstor.io/ [v1]
Link: https://lore.kernel.org/linux-raid/20260719105327.864949-1-mykola@meshstor.io/ [v2]
Link: https://lore.kernel.org/linux-raid/20260721174502.111503-1-mykola@meshstor.io/ [v3]
Link: https://lore.kernel.org/linux-raid/9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com/ [Logan's proposal]

Logan Gunthorpe (4):
  block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
  md/raid1,raid10: factor out raid1_write_error() helper
  md/raid1,raid10: skip futile retries on P2PDMA mapping failures
  md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA

Mykola Marzhan (5):
  md: ensure REQ_NOMERGE is set on P2PDMA bios
  md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
  md/raid1: don't use write-behind for P2PDMA bios
  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
  nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers

 block/blk-core.c          |  3 +++
 block/blk-mq-dma.c        |  3 ++-
 drivers/md/md.c           | 10 ++++++--
 drivers/md/md.h           | 15 ++++++++++++
 drivers/md/raid1-10.c     | 16 +++++++++++++
 drivers/md/raid1.c        | 48 +++++++++++++++++++++++----------------
 drivers/md/raid10.c       | 26 ++++++++++++---------
 drivers/nvme/host/rdma.c  | 38 ++++++++++++++++++-------------
 include/linux/blk_types.h | 10 ++++++++
 9 files changed, 120 insertions(+), 49 deletions(-)


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.52.0

