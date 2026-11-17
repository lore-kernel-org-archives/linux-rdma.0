Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931273;
	b=ibgEyiCIPJcQ04OpAmYnoD0icuW4IpLJcS0m4lvT0afj2cMKySAgWPzjnI2dD8AvE8l5
	 x7Ynjeb7LG2eJcFJu2/LAGOcGLqg1I6EpX6VOIlrffIN4bFSrxPD5ZhNWwXuRCaGJ08z+
	 PP8PHGkMPKUmbhqpMXI06DGi8KMY8LXc8KeJATLHkki5yfoJOkRTZT0uSRmvU7O+Sl413
	 WCIy6xhjoRWdQYIXWZUflZj+8JPe6ylEMyhzhTJ2rbgZGufoi2I+BNeof9yoxxj7NslZy
	 AbPuRgDURbEM1o91PXxtg4fDSMVQhqAoAUe3/e9pwSTxP0OeGLBxQ9yBI95+UDMR7hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931273;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=wavLIa4siMaZSOGuACzOdEdbmHI3Ld+5BJVE9ILIwb0=;
	b=t8sZo+4wAs9gzqczxZZghuEj6r/grqog6OEhuSKZ1GwLB9NA/rRJ/P6Yf/fLl/kNn7ZL
	 T1LXGT+dwLs6PN2LiLq0VuHNMLwBVDEwCguvLoafoFSdBOsRxN2WKxkuka+hHndUYRaRb
	 FzwIaLyt1ekc3BwM97KTs8kF3axRWcX9atCv5D2kQtYlHU65MvY9LhrDeQtFKTkiLHHv6
	 kApHTULAZSEGmBRbVasOP0CwMBep+6IaseFDDXUJ+2qeeE7VdCgupHRcLSAQAO277FU/H
	 1mSWwJ4Vf41S1smb6udeJQD4pLLom7m75FmpevQHsfE/g2plJm18HJYm8yUpQHm6dGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=HLYyPpa9;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DA1606A32C;
	Tue, 17 Nov 2026 16:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47DA1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=HLYyPpa9
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id B2CE720B7169;
	Tue, 17 Nov 2026 08:01:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2CE720B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794931265;
	bh=wavLIa4siMaZSOGuACzOdEdbmHI3Ld+5BJVE9ILIwb0=;
	h=From:To:Cc:Subject:Date:From;
	b=HLYyPpa9KWH+MxRRHOiaPyCjFL5A6lJLRb4dZiMwVmvwBGZj73Ebg4cMB5vYmROdk
	 lTGBRrbVP1CbR9gV9pJSqGjUxOz8jcUmJSkJYknXcvSm0Jx45CajMCPztxP/maBOxE
	 Zp2HXJl70Dh5lgGqghKq2vyXGXofz0aeqP1WQExg=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org,
	shacharr@microsoft.com
Subject: [PATCH net-next v11 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Tue, 17 Nov 2026 16:00:57 +0000
Message-ID: <cover.1794751992.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v11 of Long Li's four-patch HWC series. I am carrying the series
forward with review fixes and integration work. Original authorship and
sign-offs are retained.

The series supports concurrent requests over the MANA hardware channel and
rebuilds its queues using the queue depth and message sizes required by
the PF. It prepares ownership and teardown, gives each message its own
completion, adds concurrent request tracking, and enables dynamic sizing.

Changes since v10:
- Rebase onto current net-next, including Erni Sri Satya Vennela's
  6964ff21c5d8 ("net: mana: Allocate queue MSI-X vectors on demand").
  Preserve the upstream allocation, affinity and shared-vector behavior.
- Distinguish a local HWC rejection from a command posted and then timed
  out. Propagate that distinction through GDMA, Ethernet and RDMA cleanup
  so a destroy that could not be sent does not release device-owned queue
  memory, RX pages or RDMA pins. Retain relevant EQ/MSI-X references.
- Cover failed creation unwinds, transferred queue ownership and partial
  multi-command DMA regions. Preserve verbs dependencies on rejection and
  avoid repeating acknowledged RSS WQ destroys during a partial retry.
  Keep previously retained CQ callback state until destruction succeeds.
- Wait on a full mixed pool while a healthy occupied slot can still make
  progress, rather than failing merely because another slot was abandoned.
  Keep quarantine, stop/cancellation wakeups and available-slot behavior.
- Preserve the specific private-bootstrap EQ-test failure diagnostic and
  initialize the context drain waitqueue once in PCI/CDX probe.
- Correct the stale WARN and teardown/RCU comments. Add original-driver
  Fixes lineage and dependency-complete backport guidance; do not mark the
  whole feature stack for automatic stable pickup.
- Document nonzero PF-report validation and EPROTO, including fallback,
  and the existing unchecked-doorbell fix. PF-directed geometry and
  directional-size contracts are unchanged.

Independent pre-existing RX, CQ-lifetime and broader lifecycle findings
remain separate. The posted-command timeout/PF-error cleanup policy is
also unchanged. Unacknowledged DMA, pins and references may be deliberately
retained; this revision does not infer quiescence from a reset or delay,
or promise automatic reclamation.

Validation on this exact revision:
- Ten GCC/Clang W=1 MANA Ethernet/RDMA target builds: unmodified base plus
  each of the four intermediate commits, with no compiler diagnostics.
- Thirteen inherited bounded actual-source regression suites and four
  throttle/CQ/EQ lifetime suites.
- Eight new GCC/Clang ASan/UBSan suites exercise cleanup rejection,
  callback/dependency retention, partial DMA creation, retries, healthy
  controls and the unchanged posted-error policy. There are 175 new cases
  and 25 negative controls per compiler.
- Source-cited local review following netdev/Sashiko criteria, including
  the fault-state caller interactions and failed construction unwinds.
- Strict 80-column checks have no source diagnostics. Checkpatch reports
  the retained Co-authored-by metadata warning once on each patch.

These are static/offline checks, not actual bot or hardware approval.
No new full-kernel, runtime or performance qualification is claimed.

Previous revision:
https://lore.kernel.org/all/cover.1794208055.git.weh@linux.microsoft.com/

Base: 6964ff21c5d8b75649211a52dbfd92753e605649

Long Li (4):
  net: mana: prepare HWC ownership for safe reinitialization
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 drivers/infiniband/hw/mana/cq.c               |   17 +-
 drivers/infiniband/hw/mana/main.c             |   91 +-
 drivers/infiniband/hw/mana/mana_ib.h          |    5 +-
 drivers/infiniband/hw/mana/mr.c               |   28 +-
 drivers/infiniband/hw/mana/qp.c               |  106 +-
 drivers/infiniband/hw/mana/wq.c               |    4 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |    6 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  207 +++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   20 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 1021 ++++++++++++++---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   49 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |   58 +-
 include/net/mana/gdma.h                       |   26 +-
 include/net/mana/hw_channel.h                 |   70 +-
 include/net/mana/mana.h                       |    4 +-
 include/net/mana/shm_channel.h                |   10 +-
 16 files changed, 1404 insertions(+), 318 deletions(-)


base-commit: 6964ff21c5d8b75649211a52dbfd92753e605649
-- 
2.43.0

