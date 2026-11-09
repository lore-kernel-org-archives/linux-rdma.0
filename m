Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239121;
	b=1M1oML6pB9YUzYAEeXm7Dhlc1Qrlum04shGhwO+w4u2UvQz4N57nYOMpcVdsAfdQOV6I
	 sjFyskkj++STo5/E4tFfyil1cm8dloTTQolARluf7bSmxbdVFiBthpPJV056wCVTNRy+F
	 aFVbtFVNFM9e5bR92Nvwdz9t80BmYJBUJLAjpmV12XUDSe7upppDnuXW9QwOe2kzxjof0
	 AMcCM0nhrSu/CYcnWdMsH5ueQoXKS50Z+JmBFCQfX/0SdM7PqJkw64GAkc6wjAI4e+jBd
	 KvMm5H3vSIDZ1rLL9Qh/2/1siwBf5q+DmVdu69SFDi8kx1ss2goyrkG6SDN0uxNtG+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239121;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=pbAX5+86YsSWRAJ9Rdk5jM3to2XAOPxy7BWdPqEtg24=;
	b=WaC749+PkJXIAmL/A5OmX8/DvKtYiGvyt0XoTkJ1dZhdiSjmBZh6Anhtf+MN42Jf36wS
	 1ryhEbjM0kJwg0/YTtdfp7kobFYBEQlrNQ0Tc5PuYYT8bXTfWxenXO3luNYhYRtiRvDsM
	 OyAV3bYcEjhncViS1l0SHNX5JJ+TWfES727E4B6Yzc/wfvNOf9CCFd56NOgQx8kTfvZGU
	 WllPe1aU0MdrClLgFSKymSOwI7HJi9qALnw5Z/8gsB4B6HN/Xu6YmmDCHsQYUF/CR+uBE
	 EW7VRj88LabPRhEtPAzDjiGhWWEtZvZgfZV4NDeZGYuf+umKhVVEhUqXmsTOvP3AbWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=ILB1aHmF;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C02A606EEAA;
	Mon,  9 Nov 2026 15:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C02A606EEAA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=ILB1aHmF
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 65FF820B7168;
	Mon,  9 Nov 2026 07:45:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 65FF820B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794239117;
	bh=pbAX5+86YsSWRAJ9Rdk5jM3to2XAOPxy7BWdPqEtg24=;
	h=From:To:Cc:Subject:Date:From;
	b=ILB1aHmFc3oRM3IidQOxV5zsnFODk7JrgWZqnt9oF/ccowEfUv/RT+ujya2OBHaYN
	 xW3e2AH3RDR3pgpojc7sQU5RX4vh+Li3R9VZB+1GYsvFGVdosryiOBSkAehpVab95o
	 BYLfuZn5ozxJpR7CS6bkUzpfWYkuog04yV4jaeqU=
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
	edumazet@kernel.org
Subject: [PATCH net-next v10 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Mon,  9 Nov 2026 15:44:59 +0000
Message-ID: <cover.1794208055.git.weh@linux.microsoft.com>
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

This is v10 of Long Li's four-patch HWC series, rebased for the reopened
net-next tree. I am carrying the series forward with review fixes and
integration work. Original authorship and sign-offs are retained.

The series supports concurrent requests over the MANA hardware channel and
rebuilds its queues using the queue depth and message sizes required by
the PF. It prepares ownership and teardown, gives each message its own
completion, adds concurrent request tracking, and enables dynamic sizing.

v9 was deferred while net-next was closed. This revision resolves its
conflicts with the upstream throttled-EQE support; it is not an unchanged
RESEND. No new actionable v9 review finding was located during the
reposting check.

Changes since v9:
- Rebase onto current net-next, including the throttled-EQE support from
  684603842b78 ("net: mana: Add support to process throttled EQEs").
- In patch 1, use one acquire-loaded CQ-table snapshot in the new throttle
  reader, matching the existing normal-EQE reader and HWC table-withdrawal
  lifetime contract.
- In patch 1, fence the HWC EQ before destroying its CQ, but keep the EQ
  allocation alive until the CQ has detached its upstream child entry.
  Preserve the upstream generic CQ detach/RCU implementation and allowance
  for empty HWC CQ polls.
- Refresh patch 4's context while preserving the upstream doorbell
  client_offset argument and address adjustment.
- Patches 2 and 3 retain their v9 changes. PF-directed queue geometry,
  healthy-admission waiting and timeout/cancellation policy are unchanged.

Validation on this exact revision:
- GCC and Clang W=1 MANA Ethernet/RDMA target builds for the unmodified
  base and each of the four intermediate commits.
- Strict netdev checkpatch with an 80-column limit and whitespace checks.
- Bounded actual-source userspace regression tests for request ownership,
  admission, retention, teardown, initialization, rebuild and TX budgets.
- New GCC/Clang ASan/UBSan tests of the throttle reader and CQ/EQ cleanup
  on patches 1 and 4, including partial setup, prior fencing, table
  withdrawal and negative controls for the integration changes.
- Source review of ownership, IRQ/RCU readers and failure paths.

These are static/offline checks. No new full-kernel, hardware, runtime
or performance qualification is claimed for this rebase.

Previous revision:
https://lore.kernel.org/all/cover.1792679388.git.weh@linux.microsoft.com/

Deferral while net-next was closed:
https://lore.kernel.org/all/20261022082333.5a259426@kernel.org/

Base: fa5196392691051963726787944db872420dfa75

Long Li (4):
  net: mana: prepare HWC ownership for safe reinitialization
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 drivers/infiniband/hw/mana/main.c             |   19 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |    5 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  162 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   15 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 1022 ++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |   58 +-
 include/net/mana/gdma.h                       |   17 +
 include/net/mana/hw_channel.h                 |   70 +-
 include/net/mana/shm_channel.h                |   10 +-
 9 files changed, 1157 insertions(+), 221 deletions(-)


base-commit: fa5196392691051963726787944db872420dfa75
-- 
2.43.0

