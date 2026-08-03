Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196B333F385;
	Mon,  3 Aug 2026 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800661; cv=none; b=KK7XVtsfby/p3tBJpv8cUmP9XxZkxh/nRVVoZRJd4QN2lgXq7kqeQU++LkpYuYekPd+zLRiYQrrDeYw+zEHNP8sczbN11PO774A+DbZ5CQsZV6P/Fm+PObqKlYqx+1Ed+wLc5F1N9au7bHJxVivCkWvLtZTgQUy+y8WVAJHh8PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800661; c=relaxed/simple;
	bh=m+wlDPn2LisdKsE2afpwiUccvd1hJDTn7fephGbh6vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M2hkVeMj2Krt5Eh1WG1UPP8Z+XM7MuJ/aWwvc7CQI+9eVZ9hKNmTvqc8KqwuDR20COMTpIJ3SQO1Anz5g+VIqS1mWppkYMV8d5uGy84a2G6l+Npg/WHqNwcqAOQDb4hCGvV0rP+C7N4mOQG0zXDpGwzNnmDduQBO1xNDbUxEGz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id 2314220B7167; Mon,  3 Aug 2026 16:44:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2314220B7167
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
Subject: [PATCH net v3 0/6] net: mana: HW channel reliability and hardening fixes
Date: Mon,  3 Aug 2026 16:43:38 -0700
Message-ID: <20260803234355.636038-1-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes a set of latent bugs and robustness gaps in the MANA
Hardware Channel (HWC), the control path the driver uses to talk to the
device.  The issues range from a use-after-free of completion queues
during teardown to buffer mis-sizing, unsafe teardown ordering, missing
validation of device-supplied RX metadata, and stale-response handling
after a command timeout.

Patch overview:

  1  RCU-protect gc->cq_table lookups against concurrent CQ destroy
     The EQ interrupt handler dereferences CQ pointers from gc->cq_table
     while teardown can free them.  Put the table under RCU and wait a
     grace period before freeing, closing the use-after-free.

  2  fix HWC RQ/SQ buffer size swap
     init_queues() sized the RQ with max_req_msg_size and the SQ with
     max_resp_msg_size -- backwards.  A large response could overflow the
     RQ buffer and the RX slot-index divide used the wrong stride.  Also
     store the queue dimensions before creating the CQ so the RX handler
     never sees an uninitialised divisor.

  3  free HWC comp_buf after destroying the EQ
     Reorder teardown so the CQ/EQ are torn down (readers quiesced)
     before comp_buf is freed, preventing a late EQ-handler access to
     freed memory.

  4  validate hardware-supplied values in the HWC RX path
     Bounds-check the SGE, verify the recovered slot index and SGE
     address, and validate response length and msg_id before use, so
     malformed or hostile DMA metadata cannot cause wrong-slot completion
     or out-of-bounds access.

  5  fix HWC teardown safety with setup_active flag and destroy ordering
     Track setup activation explicitly, tear the CQ down before the
     TXQ/RXQ, and on an unrecoverable teardown failure leak the HWC
     resources rather than free memory the device may still DMA into.

  6  fix stale HWC response after command timeout
     Replace the inflight-slot semaphore with a bitmap + waitqueue and
     per-slot refcount/lock; latch the channel on timeout so no new slots
     are handed out, drop duplicate/late responses, and ignore a zero
     firmware-supplied timeout.

Follow-up feature work (net-next, sent separately)
--------------------------------------------------
The original series also contained two patches that are improvements, not
fixes:

  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

Per the netdev tree rules, fixes go to 'net' and features/improvements go
to 'net-next', and the two must not be combined in a single submission.
Those two patches build on the locking and teardown groundwork in this
series, so they will be posted as a separate net-next series only after
these fixes have propagated from net into net-next through the usual
periodic merge.

Changes since v2
----------------
 - Per maintainer feedback, split the original combined series: the six
   fixes here target 'net'; the two feature patches now go to 'net-next'
   and are sent separately (see above).  Rebased the fixes onto net.
 - Dropped the pcie_flr()-based reset fallback from the teardown path.
   pcie_flr() resets device config without the save/restore that
   pci_reset_function() provides, and cannot be used as a drop-in here.
   On an unrecoverable teardown failure the driver now leaks the HWC
   resources instead of touching memory the device may still DMA into.
 - patch 2: store the HWC queue dimensions before creating the CQ so the
   RX completion handler can never observe a zero max_resp_msg_size
   divisor or a stale num_inflight_msg bound.
 - Assorted commit-message and comment clarifications.

Long Li (6):
  net: mana: RCU-protect gc->cq_table lookups against concurrent CQ
    destroy
  net: mana: fix HWC RQ/SQ buffer size swap
  net: mana: free HWC comp_buf after destroying the EQ
  net: mana: validate hardware-supplied values in the HWC RX path
  net: mana: fix HWC teardown safety with setup_active flag and destroy
    ordering
  net: mana: fix stale HWC response after command timeout

 drivers/infiniband/hw/mana/cq.c               |  46 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  25 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 402 +++++++++++++++---
 drivers/net/ethernet/microsoft/mana/mana_en.c |  22 +-
 include/net/mana/gdma.h                       |  29 +-
 include/net/mana/hw_channel.h                 |  35 +-
 6 files changed, 475 insertions(+), 84 deletions(-)


base-commit: af39eb111ce6b5eba9c08513b62c4868eb7e7fd5
-- 
2.43.0

