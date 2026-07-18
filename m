Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860283CE084
	for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391973; cv=none; b=AORXuX2yDyd2EsCL1H/B32FUVbIdPualLqN4a4m2d9rB85sIKfFPIioonMaMizBxrp5MNxsnarhVi0jr8beeK1X1OlnKXHJk6VuVBcX7XKMGoMmvXGz/8m8z91wQG7yo6Y7KRvgHLhpoJoQsewCzAIVFTo19JMwrTwkejDpcPWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391973; c=relaxed/simple;
	bh=/wrEo4YWigAqPnRzsjCDNVJKg3ikbinhpF6/RVSf8iM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VvqCVHvE+E23dkrQ9nOV8+Gd9svGAH5j/Aob0rFlIiNHKdapvJiqFn7uPy/sr5yo5HBR8vWHfPor6CHsj2AtcLeSgCyYqBRcsa4OU+qFSCKW9xU2N9OKAjhvaTNl2wHKbDDIFxna0e6P32wS1QNP42WYgONE/u5DvGbnKlV3vZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=mGTUeygg; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="mGTUeygg"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso12397395e9.3
        for <linux-rdma@vger.kernel.org>; Sat, 18 Jul 2026 09:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391969; x=1784996769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a8Jq9eO0xjd27F980TmF9dGRWY9vCqzHlM8dGdXc/lA=;
        b=mGTUeyggv5/y0eHX+bPKQaNu6ZSa6dHiNPfWlR/J3T+WMhsNjNTCTTHc398W0AoZJ0
         DwOoAMgb41qsR2DuUJF6sdXvZBuKJEGuOwzDqJbYgQs4pc+4KI3dhS92k+KkscTGb+hn
         IJ6/rcJq4Q6CYysZ/hZgT/tT4dJFVi0piVOB6cijlIGYxJthpPUUgV5RCK92etiBQ2Db
         tuTU8R/SnA/ol545IFk2+keCehvw56H8Zf91jltT63Y8c1dofUsmgDr2yscYeJ/PcaYF
         slI4RGVWc/q1B5CAp7zCKricaCu91nc2MDLDGDigrDLTQXcNZtxS0kSOQ1krt696JDu7
         wf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391969; x=1784996769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a8Jq9eO0xjd27F980TmF9dGRWY9vCqzHlM8dGdXc/lA=;
        b=rmG7TypIoSn7leKIUi3D7l04taTuAISe/Zo0296fnRSGnWThBH42GTkyp9mJAeC+Dl
         6S22J8ikwEPctkop6boFxJdf2fWjgnUfcaAe8NL9LKDck7lr9gKpCPHfvLNy+F1TJrjd
         IWerV7ALIx7kijNjxwr7faqJGDZ+l5ry4Mu2O6Oc+CoagvEDGi1D4f2Wr7W3U7a6yquE
         ihEfR/WDqWDFYGLBr6WryrCE+C8e22oX/EWOMOKyqQtUTelO9hYTMR8l93i1U8ghaCUz
         xpRXhLKEkf4NFNUvpd9aLNnRjcKeVBmkpbbCSTW2bohQQSv7USd3P0yuU4Dtj0yEYJnD
         8X4Q==
X-Forwarded-Encrypted: i=1; AHgh+RrHTNKROPnBxPKrOUpcp5iCSdFp7+M2yrZKJqqw/NPRHsPK9ZwZS3BaWG46ngTgpJLc3DYB/ieuN7V3@vger.kernel.org
X-Gm-Message-State: AOJu0YyqfzlUAdjdzoFuvoJZ7xGuxamo1N7G5JpFn2W5geviACXIrvui
	0uVuzutAAStxhrWGoG9gws14LDFDDio5Nk/gA5wjuM4QgNlDZ1jWcnL6ZZmaAKJHhQ==
X-Gm-Gg: AfdE7ckY6f1wyo/753rUXaivSdbvVGGZw8j7JzFWrnYHB5YDocn9SLTH+LEYyeWkiwG
	ZxAbLwQVoqA8iLtt7NaOec4gdE8I65zBXfd3LBij3lzW/POKl1i2vUC/9hO2vQKYXGAaQRukXC5
	/v65w2AQrkXL2CovMTiDwVq+jyL9VRjwZ2FSor/8apsMsXYTyHOMCHsiuNvo6E+uPRtdRZv1ZOg
	ujeZFBdWISzkdCA8pGn9YeUQ3+jW4NWIF3h8wBkK4UBVqlYCnx1aJtWQiT98Z50zENc5PfBDUQC
	Xglo7yRDieLfgUwhdjai0uBVupL6VHgBhYI/jcOYgmI+ERPUgUi9Ay3C3xArTuuSlz0CegeDBWs
	t322rM4UahYVNTTJGSRqD27y5NTCPTKrCnPtIcQBYekG7Npi8uiC2J7xu51RfqslS3Gijyv4x
X-Received: by 2002:a05:600c:21da:b0:495:3e08:ad24 with SMTP id 5b1f17b1804b1-4954a51b524mr56949825e9.33.1784391968873;
        Sat, 18 Jul 2026 09:26:08 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:08 -0700 (PDT)
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
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: [PATCH 0/6] block,md,nvme: correct handling of unsupported P2PDMA transfers
Date: Sat, 18 Jul 2026 16:25:41 +0000
Message-ID: <20260718162547.448892-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driving peer-to-peer I/O (NVMe CMB source) through md arrays and
nvme-rdma legs on asymmetric PCIe topologies -- where the peer device
reaches some members/paths but not others -- turns up two failures on
v7.2-rc, both rooted in how an unsupported-P2PDMA mapping failure is
reported. On md: silent data loss -- an unreachable-leg P2PDMA write
counts as written, mirrors silently diverge, and where no member is
reachable the write reports success with zero copies on stable
storage; reads picked to an unreachable leg fail with EIO and are
never retried on the mirror that holds the data. On nvme-rdma: the
transport swallows the DMA layer's mapping errno into a path error,
which under the default multipath configuration livelocks the I/O (a
stacked md mirror hangs) and with nvme_core.multipath=N surfaces as
retryable BLK_STS_TRANSPORT.

The root cause is a block-layer status-code regression, not an md or
nvme bug. Commit 91fb2b6052f7 ("nvme-pci: convert to using
dma_map_sgtable()") deliberately mapped unsupported P2PDMA transfers
to BLK_STS_TARGET ("... return BLK_STS_TARGET so the request isn't
retried"). Commit 858299dc6160 ("block: add scatterlist-less DMA
mapping helpers") silently changed that to BLK_STS_INVAL, and since
commit 7ce3c1dd78fc ("nvme-pci: convert the data mapping to
blk_rq_dma_map") in v6.17 the failure surfaces to direct NVMe
consumers as EINVAL instead of the documented -EREMOTEIO, with
blk_path_error() now classifying it as retryable. md/raid1,raid10
ignore BLK_STS_INVAL leg failures per commit f7b24c7b41f2
("md/raid1,raid10: don't fail devices for invalid IO errors"), where
it means a request-shaped error that fails identically on every
member -- hence the silent divergence. The md leg of the regression
became reachable when md started advertising BLK_FEAT_PCI_P2PDMA in
v7.2-rc1 (commit 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA
from member devices to RAID device")).

Patch 1 restores BLK_STS_TARGET at the source. md then handles an
unreachable leg like any other per-device error: badblocks on the
affected member, the master bio succeeds while an In_sync leg holds
the data, and reads are redirected to the other mirror.

Patches 2-4 fix independent md-side P2PDMA bugs of the same vintage:
md_submit_bio() strips REQ_NOMERGE (the only request-level protection
against merging P2PDMA segments across pgmaps); raid1 write-behind
CPU-copies device BAR memory via bio_copy_data(); and
narrow_write_error()'s retry clones reset bi_opf, dropping the
REQ_NOMERGE protection exactly on the error-retry path.

Patch 5 stops the restored device-error machinery from misfiring
where its medium-error assumptions don't hold. A mapping failure is a
property of the peer/member pairing: retrying the same peer pages
against the same member cannot succeed, and there is nothing on the
medium to repair. Without it, narrow_write_error() serializes dozens
of guaranteed-to-fail chunk retries per failed write; on reads each
unreachable-leg pick costs a full freeze_array() quiesce plus a tick
of the read-error budget -- measured below, a mixed host/P2P read
workload on an asymmetric topology kicks the perfectly healthy far
leg after ~20 failed picks, in under a second; and on FailFast
members a single unroutable I/O evicts a healthy mirror outright.
Because BLK_STS_TARGET is also produced for transient device
conditions md cannot distinguish from bi_status alone, writes probe
the whole range once instead of predicting futility: a real mapping
failure is recorded in one call, a cleared transient recovers with
nothing recorded. Patches 1 and 5 belong in the same release: with
patch 1 alone, restoring the error surfaces the retry storms and
read-path evictions above on 7.2's newly reachable md path.

Patch 6 closes the same hole in the rdma transport. nvme-rdma maps
the data scatterlist with ib_dma_map_sg(), which returns 0 on a
peer-unreachable failure, discarding the -EREMOTEIO that
dma_map_sgtable() documents for exactly this case; the driver reports
it as a path error. Because the multipath head node advertises
BLK_FEAT_PCI_P2PDMA (commit fb0eeeed91f3 ("nvme-multipath: enable PCI
P2PDMA for multipath devices"), v7.2-rc1) and the mapping failure is
deterministic, nvme_failover_req() requeues the bios with a fresh
retry budget every cycle and the I/O never completes -- a hot requeue
livelock that hangs a stacked md mirror instead of failing over; with
nvme_core.multipath=N it burns nvme_max_retries requeues and
completes as retryable BLK_STS_TRANSPORT. Patch 6 maps with
ib_dma_map_sgtable_attrs() to preserve the errno and returns
BLK_STS_TARGET, matching nvme-pci so patch 5's handling covers rdma
legs too, and starts the request only after the map succeeds so
nvme_mpath_start_request() accounting cannot leak on the direct
blk-mq completion. nvme-rdma stays on the scatterlist DMA API: its
fast-reg MR path (ib_map_mr_sg()) consumes scatterlists, so a
blk_rq_dma_map conversion is separate modernization, out of scope for
a fix.

Behavior on v7.2-rc2, QEMU rig (one CMB provider, two NVMe members,
q35 PCIe topologies), 90 8KiB peer-memory reads under concurrent
host reads for the read rows:

  topology     op          v7.2-rc2                patched (1-5)
  symmetric    write+read  ok                      ok
  asymmetric   write       "ok", silent diverge    ok + badblocks on
                                                   far leg (1 probe)
  asymmetric   read        41/90 EIO, no mirror    90/90 ok, no
               under load  retry, no eviction      eviction
  unreachable  write       "ok", NO data copied    EIO + badblocks
  unreachable  read        EIO                     EIO, no members
                                                   kicked

Also verified on the same rig: a transient injected TARGET recovers
through the single probe with nothing recorded; P2P MEDIUM keeps the
chunked path; host-page TARGET/INVAL handling is unchanged; FailFast
survives mapping failures but still evicts on genuine errors;
write-mostly legs are written directly (no write-behind CPU copy); a
degraded array whose only leg is unreachable gets plain EIO -- no
budget charge, no eviction; an exhausted badblocks table fails the
member as described below. The write/read/injection rows repeat
identically on raid10.

Validation of patch 6: the mechanism -- ib_dma_map_sg() returning 0
where ib_dma_map_sgtable_attrs() preserves -EREMOTEIO -- was
confirmed on a real mlx5 HCA with a map-only probe. The
start-after-map reorder ran over an rxe nvmet-rdma loopback under fio
with crc32c verification; multipath inflight and nr_active accounting
drain to zero, matching the pre-reorder kernel. rxe cannot produce
-EREMOTEIO, so the failure paths were driven by injecting that exact
mechanism at the map call site: unpatched, one 4KiB write livelocked
(132 failover requeues in 8s, a stacked raid1 hung; multipath=N:
retryable BLK_STS_TRANSPORT); patched, it failed immediately as
BLK_STS_TARGET with zero requeues, and the stacked raid1 badblocked
the leg without evicting it.

Known trade-offs of routing through the stock md write machinery:
an unroutable P2P write records badblocks and sets WriteErrorSeen
and WantReplacement, so later writes overlapping those ranges skip
the member -- host writes do not clear the entries and repair skips
known-bad ranges -- leaving them single-copy until re-add or
replacement recovery (host memory, so it succeeds) rewrites and
clears them; a member whose badblocks table is exhausted or disabled
is failed on the first unroutable P2P write, as with any write error
md cannot record. FailFast members are exempted from md_error() for
mapping failures only (nothing reached the wire, so the error says
nothing about device health); genuine I/O errors keep their
immediate-eviction semantics. raid10 additionally fails a
replacement device outright on a P2P write mapping failure (its
stock replacement-write policy), and an IO_BLOCKED slot excludes
that slot's replacement from the read retry -- both pre-existing
raid10 behaviors with a new trigger. On reads, read_balance() keeps
no memory of unreachability, so each far-leg pick still costs one
failed submission before the redirect; a sticky per-rdev
reachability hint would be md-next follow-up material, as would a
distinct block status naming the mapping failure exactly.

Routing: patch 1 is block-tree material and fixes a v6.17-rc1 status
regression (hence its Cc: stable); patches 2-5 are md and address
exposure that only became reachable with v7.2-rc1; patch 6 is
nvme-rdma and also carries Cc: stable -- the transport misreport
predates the head-node change (Fixes: 23528aa3320a, v7.1) and is
reachable on v7.1 with multipath=N. Patch 6 sources the errno from
dma_map_sgtable() in rdma.c and does not depend on patch 1, which
fixes the separate blk_rq_dma_map path. Patches 1 (block) and 6 (nvme) are
independently applicable bug fixes: each fixes a user-visible defect
on its own and neither depends on the md patches, while 2-5 are
md-side hardening built on patch 1 -- a maintainer can take 1 and 6
even if the md discussion runs longer. Single-cycle routing through
the relevant trees with acks works for us: patch 1 block, 2-5 md,
6 nvme.

Per Documentation/process/coding-assistants.rst: the patches were
developed with AI assistance (see the Assisted-by trailers); all code
was human-reviewed and tested as described above.

Series is against v7.2-rc2.

Mykola Marzhan (6):
  blk-mq-dma: restore BLK_STS_TARGET for unsupported P2P transfers
  md: ensure REQ_NOMERGE is set on P2PDMA bios
  md/raid1: don't use write-behind for P2PDMA bios
  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
  md/raid1,raid10: skip futile retries on P2PDMA mapping failures
  nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers

 block/blk-mq-dma.c       | 10 ++++++-
 drivers/md/md.c          | 14 ++++++++--
 drivers/md/md.h          | 31 +++++++++++++++++++++
 drivers/md/raid1.c       | 56 +++++++++++++++++++++++++++++++------
 drivers/md/raid10.c      | 60 ++++++++++++++++++++++++++++++++++------
 drivers/nvme/host/rdma.c | 26 +++++++++++------
 6 files changed, 168 insertions(+), 29 deletions(-)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
--
2.43.0

