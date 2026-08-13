Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C630E399CF5;
	Thu, 13 Aug 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786642996; cv=none; b=dAz7zVMgz27RlztdXTH5G0347MyCS9nAO1BjTgDWAyh/vUgA+B9i6jd7TCTglonWnilLtp57IgGyUYmY9QPaof/9auVPZDoJQooT+lRHXq+DJXLx7tq/LpPoTo48hY5SbzyM6tRW1TyHXB3ZEcld3DTqGaasizDARs8ZoaRazEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786642996; c=relaxed/simple;
	bh=dsTNUTZVn7HGDPkUqmZ8lxZ2q4/FmqraJUZVIZBNF3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nn5nx1bPkRCcz/c16BKHa5uLbu31ieSfinwt3FzeAGn/wJtGdXn9xwMEpFhGCfg6gFudMlpBWeXhCkG6i0dYWR9RqFyIu8ueAgaWrZiN4Mej70pVtURRs3+d/We3acY2IoqqX/mmMOJLgSLVRdPzo9Qw2sOh4olCsF0eRsiEtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 64E3B20B7168; Thu, 13 Aug 2026 10:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 64E3B20B7168
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v7 0/7] net: mana: HW channel reliability and hardening fixes
Date: Thu, 13 Aug 2026 10:42:32 -0700
Message-ID: <20260813174243.3044348-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a set of reliability and safety bugs in the MANA HW
communication channel (HWC) and hardens the paths that consume
device-supplied values.  The HWC bootstrap and RX data come from the PF,
which is untrusted from a confidential-VM guest, so several of these are
also hardening fixes against a malicious or buggy host.

Patch 1 reference-counts the CQs looked up from the EQ interrupt handler so
a completion cannot race a concurrent CQ destroy.  Patches 2-3 fix an
RQ/SQ size swap and a use-after-free of the HWC comp_buf during teardown.
Patch 4 validates the lengths and indices taken from device DMA in the HWC
RX path.  Patch 5 makes HWC teardown safe when a device stops responding.
Patch 6 stops a stale/late HWC response from completing the wrong command
after a timeout.  Patch 7 keeps max_num_cqs immutable once cq_table is
allocated, so a later device event cannot inflate the bound past the
allocation.

The series has been build- and sparse-tested (C=2), and checkpatch is
clean on every patch.

Changes since v6:
- Patch 1: reworked from the lock-based scheme to lockless reference
  counting per review feedback.  Dropped gc->cq_table_lock entirely;
  lookups now take a reference under RCU (refcount_inc_not_zero) and the
  CQ is freed with kfree_rcu(), publish/unpublish are lockless.  Reordered
  mana_ib_destroy_cq() to detach the software callback before destroying
  the hardware CQ, closing a CQ-id recycle window.  Retitled accordingly
  ("reference-count CQs looked up from the EQ handler").
- Patch 4: bound the RX slot index by msg_buf->num_reqs (the __counted_by
  array bound) rather than the queue depth, and rate-limit the
  device-triggered RX error messages.
- Patch 5: the leak-on-teardown-failure branch now deregisters the HWC EQ
  IRQ and unpublishes the CQ before returning, so no late EQE can reach the
  leaked buffers.  Corrected the setup_active kerneldoc comment.
- Patch 6: dropped the terminal "timed out" latch, which could stop
  teardown commands from ever being posted to a slow device; the core
  stale-response fix (per-slot lock/refcount/responded flag) and the
  wait-queue admission change are retained, and the timeout still shortens
  later waits so teardown is posted.
- Patch 7: reject an out-of-range CQ id with a rate-limited error and
  -EPROTO instead of WARN_ON(), since both operands are device-controlled
  and WARN_ON() could panic a panic_on_warn guest.
- Patches 2, 3: commit-message wording only; no code change.

The v6 posting is at:
https://lore.kernel.org/netdev/20260811023823.2391255-1-longli@microsoft.com/

Long Li (7):
  net: mana: reference-count CQs looked up from the EQ handler
  net: mana: fix HWC RQ/SQ buffer size swap
  net: mana: free HWC comp_buf after destroying the EQ
  net: mana: validate hardware-supplied values in the HWC RX path
  net: mana: fix HWC teardown safety with setup_active flag and destroy
    ordering
  net: mana: fix stale HWC response after command timeout
  net: mana: keep max_num_cqs immutable once cq_table is allocated

 drivers/infiniband/hw/mana/cq.c               |  41 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 111 ++++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 402 ++++++++++++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c |   8 +-
 include/net/mana/gdma.h                       |  29 +-
 include/net/mana/hw_channel.h                 |  34 +-
 6 files changed, 515 insertions(+), 110 deletions(-)


base-commit: f1b3416ceaf7ca4cb5cbd986ee8fe3ffaeda2d48
-- 
2.43.0

