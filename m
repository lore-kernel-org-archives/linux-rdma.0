Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BEE3D47BF;
	Wed,  7 Oct 2026 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377623; cv=none; b=WM3s3C1UrTHldWpUwtODKgfW9QtKLtf7g3p5Hn6sKKUlq8XSJutKDHYocyEZcV9/uKcerW7H2Cpn9YX8GsaiaPxI/sHjMJsKDER91bd4XYjERT8WQALfHi9FtY7MorZp/uWLoZrfhtQs8UU2qURwZJWOqr0XYUBUEdzD5Xn6c2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377623; c=relaxed/simple;
	bh=9cPNyRHGG2WmvFE7FD4D24TAmZAqJuJz5eqk8zSTrv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FeROu8a+0msJF1dxyiq6O4iBimSUtRVAaDWKA33EYcQYovtS1RE4iPykHeL8qdgs2sJ3Hin+7mUPqCh98+Mr4jh8ka1Y+e0h8mpo1ZOva3TGkkuerG085nJ/2Z5+DHWaKylsJuT/Ro6hHJDNjIZov/CTewFyJWQ4+6JEopuNtco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mFyUo4Iv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mFyUo4Iv"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id DC8CE20B7166;
	Wed,  7 Oct 2026 05:52:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC8CE20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791377558;
	bh=pgXXnsxbosFwljyh+v9NmPF4yFb98y3x90Qgy6et6YA=;
	h=From:To:Cc:Subject:Date:From;
	b=mFyUo4IvqOg+G1TYdkFWFRcW2cgrsBhxgO5PLj8sXYeFF82tXzp4/vKeYEf/uRsn8
	 TggdHiK8ylLWtpdLbZrQ00/hmDdsCyG0xPilTMyk9837cph/CmJvcQETH11A7xk0mH
	 VkK5N8qxB4go+I4FnjwCuvoYQstRHBzTZL22O380=
From: Wei Hu <weh@linux.microsoft.com>
To: Long Li <longli@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Shiraz Saleem <shirazsaleem@microsoft.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Kees Cook <kees+treewide@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Manish Awasthi <mawasthi@linux.microsoft.com>,
	Wei Hu <weh@microsoft.com>
Subject: [PATCH net-next v6 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Wed,  7 Oct 2026 12:53:26 +0000
Message-ID: <cover.1790665894.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series picks up Long Li's v5 MANA Hardware Channel (HWC) work,
addresses its review findings, and retains its four-patch feature lineage.
Safety changes required by concurrency and repeated HWC reinitialization
are folded into the patch which owns each behavior rather than posted as a
separate fixes series.

I have taken over follow-up upstreaming from Long. Long remains the author
of every patch, his existing sign-off is preserved, and I added mine for
the changes and submission custody.

Patch 1 prepares HWC ownership for safe reinitialization. It serializes
complete shared-memory transactions, tracks possible PF ownership,
retains mappings after an unacknowledged destroy, fences the HWC EQ before
releasing CQ state, and safely publishes and withdraws the HWC CQ table.

Patch 2 gives each slot independent completion state, withdraws caller
storage before sender return, handles the response-versus-timeout race,
and prevents depth-one slot reuse after a genuine timeout.

Patch 3 adds concurrent requests with bounded admission, serialized SQ
posting, separate sender/response ownership, stale-response quarantine,
coherent timeout updates, private setup publication, and sender draining.

Patch 4 rebuilds the depth-one bootstrap queues at validated depths from 2
through 128. It validates both reports, message limits and doorbells,
keeps the untouched bootstrap channel for depth one or reports above 128,
and restores fresh bootstrap queues after a failed rebuild only when
teardown was acknowledged.

Generic Ethernet/RDMA CQ callback refcounting and generic service-work
versus device-lifecycle serialization are independent pre-existing work
and are intentionally excluded. Malformed-RX handling, duplicate-success
correlation, and broad device-controlled allocation/timeout policy caps
also remain separate follow-ups.

Changes in v6 (v5 -> v6):
 - Keep the four-patch v5 structure while folding review-required HWC
   ownership, teardown, timeout, publication and fallback safety into
   their owning feature patches.
 - Serialize complete ESTABLISH_HWC and DESTROY_HWC shared-memory
   transactions. Record possible PF ownership before MMIO submission and
   clear it only after DESTROY_HWC is acknowledged.
 - Retain PF-visible queues after an indeterminate destroy. Fence the
   dedicated HWC EQ and withdraw its CQ from dispatch without freeing the
   mappings, then retry teardown before assigning fresh queues.
 - Destroy the HWC EQ before CQ and completion state. Release-publish the
   CQ table and wait for IRQ-side RCU readers before freeing it, without
   adding per-completion refcount operations.
 - Withdraw the caller's response buffer before return and quarantine a
   timed-out slot until its late response arrives or teardown cancels it.
 - Return -EBUSY for healthy slot pressure and reserve -ETIMEDOUT for an
   admitted request which receives no response.
 - Publish slots under the inflight lock, protect response state with the
   per-slot lock, and retain sender/response references until both sides
   finish.
 - Synchronize hwc_timeout updates and publish the HWC only after queues,
   admission state, caller contexts and the direct EQ test are ready.
 - Replace the goto-heavy request and channel-creation flows called out in
   review with focused admission, submission, wait, build, validation,
   rebuild and fallback helpers.
 - Treat reported depth as a maximum: rebuild exactly for 2 through 128,
   retain untouched bootstrap queues for 1 or above 128, and require the
   rebuilt report to repeat the selected depth.
 - Enforce directional request/response maxima against both the report
   and allocated buffers. Rebuild only for exact 4096-byte reports while
   permitting bootstrap operation for other nonzero maxima.
 - Validate BAR page geometry and every stored doorbell. Invalidate the
   old HWC doorbell before re-establishment and suppress MMIO while the
   invalid sentinel is present, without adding full validation to each
   data-path doorbell ring.
 - Remove the proposed capability bit because driver-version
   advertisement occurs after HWC establishment and cannot negotiate
   creation-time behavior.
 - Preserve current net-next behavior which always uses the
   hardware-reported dest_vrq_id and dest_vrcq_id.

Changes in v5 (v4 -> v5):
 - Shortened comments and documented the existing error paths in patches
   1 and 2.
 - Rejected apparent success from a response accepted before request
   submission.
 - Guarded CQ unpublication when establishment failed before cq_table
   allocation.
 - Required successful retry teardown before creating fresh bootstrap
   queues after an initial destroy failure.

Changes in v4 (return to net-next after the v3 split):
 - Reworked the feature series into four standalone patches for handover,
   per-slot completion state, concurrency and dynamic depth.
 - Added bounded admission, guarded sender accounting, timeout quarantine,
   queue-depth bounds, message-buffer sizing and rebuild validation.
 - Reset routing IDs for each establish and rejected a missing doorbell.

Changes in v3 (v2 -> net v3, historical fixes-only posting):
 - Split the combined series after maintainer feedback, posting fixes to
   net and deferring concurrency and dynamic depth.
 - Added response-buffer withdrawal and stale-response handling.
 - Removed pcie_flr() teardown fallback and retained resources after an
   unacknowledged destroy.

Changes in v2 (v1 -> v2):
 - Bounds-checked the SGE pointer derived from inline OOB size.
 - Protected active-sender accounting and drained senders during
   teardown and failure exits.
 - Rebased on net-next e354f7d60f14.

v1:
 - Combined CQ-table lifetime, queue sizing, RX validation, teardown,
   concurrent-request and dynamic-depth work in seven patches.

Validation:
 - All four patches pass diff-check and strict checkpatch.
 - Every patch passes targeted GCC 13 and Clang 18 W=1 MANA
   Ethernet/RDMA builds on base c66d93e68728.
 - Sparse and Smatch add no diagnostics over that current-base baseline.
 - Release kernel 7.3.0-rc4-mana-hwc-v6-4p-g7065a269bba5 booted via
   one-time GRUB entries on two Azure MANA VMs.
 - Each VM passed 32-worker control stress, queue resizing from 8 to 4
   and back, MTU/link changes, three standalone PCI remove/rescan cycles,
   and two further cycles while control queries ran concurrently.
 - MANA rebound, peer connectivity recovered, and both RDMA links
   returned ACTIVE after every cycle. No new MANA error, timeout, warning,
   UAF, refcount, RCU, lockdep, KASAN or KCSAN report appeared.
 - Fresh safe-kernel and four-patch 16-stream TCP receive throughput was
   24.338 and 24.337 Gbit/s respectively. Concurrent control stress
   measured 24.339 Gbit/s.
 - Four-stream 64-byte UDP sustained the requested 399.986 Mbit/s on both
   kernels; loss was 0.812% on the fresh safe baseline and 0.041% on the
   four-patch kernel.
 - RDMA devices and links remained active. ib_write_bw reproduced the
   environment baseline status 21 / syndrome 0x1c6.
 - The request, timeout, rebuild, fallback, message-limit and shared-
   memory state machines are unchanged from the previously injected
   depth/message/doorbell/destroy/response fault tests. Fresh runtime
   additionally exercised the new HWC-specific CQ publication path.
 - Both VMs were finally rebooted to the known-good
   7.3.0-rc5-mana-vmtest-g72d3fcf802c4 kernel with the safe saved_entry,
   empty next_entry, active MANA/RDMA and a 24.347 Gbit/s smoke test.

v5:
https://lore.kernel.org/all/20260908035201.402424-1-longli@microsoft.com/
v4:
https://lore.kernel.org/all/20260901200018.3194525-1-longli@microsoft.com/
v3:
https://lore.kernel.org/all/20260803234355.636038-1-longli@microsoft.com/
v2:
https://lore.kernel.org/all/20260721234339.1476932-1-longli@microsoft.com/
v1:
https://lore.kernel.org/all/20260715032942.3945317-1-longli@microsoft.com/

Long Li (4):
  net: mana: prepare HWC ownership for safe reinitialization
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 .../net/ethernet/microsoft/mana/gdma_main.c   | 129 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 928 +++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |  58 +-
 include/net/mana/gdma.h                       |  14 +
 include/net/mana/hw_channel.h                 |  56 +-
 include/net/mana/shm_channel.h                |  10 +-
 6 files changed, 1000 insertions(+), 195 deletions(-)


base-commit: c66d93e68728cfb5f40b40d0f24129d7768faf43
-- 
2.43.0
