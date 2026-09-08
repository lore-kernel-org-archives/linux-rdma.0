Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECB931E844;
	Tue,  8 Sep 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788839566; cv=none; b=L7SZup1BGPchv39JzyXeSobGx/BsLyBLMPKtk3KtP3IDL7dKU18Z7NdUUmv1EsM61ajafe+p+0b2X2sY03o4f57scQ4XXIOCf9Fb9B7wEhoQ7hxNKGWxrOOKhRqVUyq0myB9GN+prZS9VWG/UWicUzxWo6nwNPNvbFyfdo5tEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788839566; c=relaxed/simple;
	bh=O58mdDD7buJukthNzlnnZFaRkMHiNGqA0ijF5raLU/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S7gDPReWQiZYM379TMug79MTOmgZ/4fOb82yuK7rnLh3CR78SeDw81Y2xZkiYFpPtjkQFTiSJnG6APwPgDvZ8n1S54HHC4mYNdiKJy3bGHpay4+5FgApBTq0/yVyYovM4mMg3ErFnziDhpv7wrCWux5aZYdYeQ1iq4Ye5JtfXkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 87CF720B710C; Mon,  7 Sep 2026 20:52:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 87CF720B710C
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Long Li <longli@kernel.org>,
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
	stephen@networkplumber.org,
	shirazsaleem@microsoft.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Mon,  7 Sep 2026 20:51:54 -0700
Message-ID: <20260908035201.402424-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series enables concurrent MANA Hardware Channel (HWC) requests and
rebuilds the depth-one bootstrap queues at the device-reported maximum,
capped at 128. The first two patches provide handover and per-slot
ownership state; the last two add concurrency and dynamic depth.

Version history follows the original combined submission through its
split: v3 was a fixes-only net posting, while v4 and v5 here are the
standalone net-next feature series. The separate net v4-v8 iterations
are not revisions of this four-patch series and are not prerequisites.
Patch numbers in each entry refer to that version.

Changes in v5 (v4 -> v5):
 - Patches 1-2: shorten comments and describe the existing error-path
   changes, including teardown polling and query-only zero-timeout
   filtering. No executable changes from v4 in these patches.
 - Patch 3: reject apparent success from a response accepted before the
   request was submitted, preserving an existing cancellation error.
 - Patch 4: guard CQ unpublishing when establishment failed before
   allocating cq_table.
 - Patch 4: after an initial destroy failure, require successful retry
   teardown before creating fresh bootstrap queues. Do not test the old
   queues with uncertain mappings.
 - Clarify publication and locking scope, dimension acceptance, and the
   missing-doorbell guard's limits. Shorten all commit messages.

Changes in v4 (return to net-next after the v3 split):
 - Rework the feature series into four standalone patches: handover
   tracking, per-slot completion state, concurrent requests and dynamic
   queue depth. No dependency on the separate net fixes.
 - Patch 1: record submission in mana_smc_setup_hwc() itself, including
   failure after handover, rather than using max_num_cqs as the gate.
 - Patch 2: separate per-slot ownership from concurrency; make error
   signed, handle a response racing timeout, and ignore zero timeout-
   query replies while leaving asynchronous updates unchanged.
 - Patch 3: use bounded semaphore admission, guarded sender accounting,
   and per-request timeout quarantine rather than a channel-wide latch.
   Retain quarantine for zero-timeout cleanup.
 - Patch 4: cap depth at 128, round message buffers to a power of two,
   and require bootstrap message sizes before growing the queues.
   Retain the full 24-bit depth in u32 and check allocation bounds.
 - Patch 4: reset dimensions/routing IDs for each establish; check for a
   missing doorbell after the handshake; validate rebuilt dimensions.
   Retry teardown before bootstrap recovery after failed re-establishment.
 - Base the four-patch series on net-next 1bb784eb6e38.

Changes in v3 (v2 -> net v3, historical fixes-only posting):
 - Split the combined series after maintainer feedback. Post six fixes
   to net and defer the concurrent-request and dynamic-depth features.
 - Add a separate stale-response patch with per-slot ownership,
   buffer withdrawal, a channel timeout latch and zero-event filtering.
 - Remove the pcie_flr()-based teardown fallback; retain HWC resources
   when teardown cannot be confirmed.
 - Patch 2: publish queue dimensions before creating the CQ so the RX
   path has its stride and slot bound.
 - Rebase on net af39eb111ce6 and clarify messages/comments.
 These describe the historical net submission, not additional fixes
 carried by the current net-next series.

Changes in v2 (v1 -> v2):
 - Patch 4: bounds-check the SGE pointer derived from inline OOB size
   before dereferencing it.
 - Patch 6: protect active-sender accounting with hwc_lock and drain via
   wait_event_lock_irq(), so the last wakeup cannot access freed gc.
 - Patch 6: force-complete and drain senders before teardown/FLR handling,
   including its failure exits.
 - Rebase on net-next e354f7d60f14 and keep code within 80 columns.

v1 (initial submission):
 - Seven patches combined CQ-table lifetime, RQ/SQ sizing, completion-
   buffer teardown, RX validation and HWC teardown fixes with concurrent
   requests and dynamic queue depth.
 - Base: net-next f6f3b36c15ed.

The v4 admission and quarantine policies are unchanged: FIFO admission has
its own timeout and may trigger recovery on contention; zero-timeout
cleanup still retains slots for outstanding requests. Existing IRQ/DMA
teardown and service-lifetime issues remain outside this revision.

The series remains based on net-next commit 1bb784eb6e38. It does not
require the abandoned net v8 series.

Tested on Azure: each commit's MANA Ethernet/RDMA build; three PCI cycles;
queue-count, MTU and link changes; and bidirectional 16-stream, 60-second
TCP traffic. Synthetic timeout and bootstrap-fallback recovery were also
exercised. RDMA coverage was enumeration, not verbs traffic.

v4:
https://lore.kernel.org/all/20260901200018.3194525-1-longli@microsoft.com/
v3 (historical net split):
https://lore.kernel.org/all/20260803234355.636038-1-longli@microsoft.com/
v2:
https://lore.kernel.org/all/20260721234339.1476932-1-longli@microsoft.com/
v1:
https://lore.kernel.org/all/20260715032942.3945317-1-longli@microsoft.com/

Long Li (4):
  net: mana: track when the HWC has been handed to the PF
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 .../net/ethernet/microsoft/mana/gdma_main.c   |  52 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 535 ++++++++++++++++--
 .../net/ethernet/microsoft/mana/shm_channel.c |   8 +-
 include/net/mana/gdma.h                       |  13 +
 include/net/mana/hw_channel.h                 |  46 +-
 include/net/mana/shm_channel.h                |   2 +-
 6 files changed, 593 insertions(+), 63 deletions(-)


base-commit: 1bb784eb6e38fd73143f021608e4ef3095d0c0d7
-- 
2.43.0
