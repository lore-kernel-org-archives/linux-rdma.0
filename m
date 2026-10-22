Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792681391;
	b=txLZxpxXMUI6O+IqFnntjtuFuKuQB8nQB37Jxc4zShXVgT9V0EQ+1DYZdiH1ypVzQRUR
	 syRgab6Q3qkNsAh+KilxEt7hJWqs0ckZv9mXTSoUk/gmbm1Jmf6fyVFx9X0xNtVEVSmVS
	 S+eUDWgO+d9p+wARGVJlPWgUKhadi5Vr4aj9uUuXOHcbhnsPzRv7/3Z0ctvDxAs+oS5dQ
	 UmfP2WcGeBelWFMLRtweGfudR14l10UNgKluyN8kmUFmpwApGaLXEqnpOnjio6Hg2zfoi
	 Nl/phvH040EDdplzsPJ5CFVrUbTlVJ01utWC96GRnjs65pvfDts5AB9q2ME549XONow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792681391;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=fGLjRwMYowHqgQeaj0mToA9QAIYNGDXlao2noz3GoI0=;
	b=GkEKreA+AculOLsivZUTsgVDspDmwlk7HwJ3Xv+uSwfPANwZxPKxrPmXZjIaUZF7kfeR
	 IO2H7N1T12oOptko9qnpNoiOtkomndRPWimOyI94v97DriPLdSbyNiJ7NaOySysHwIFR8
	 SCnXH3slr1vbn5mQ94ESvvq9vZ2eaBWzDnyOxEajaoIf1WiMwzv6ifIj8AudIs6EWg/Up
	 PWR/83FrzOzMwJMGL4GJqyrhwvnEabRM1Q74+yvs6zTbZY7PGUVPVuZTEliB3TXcmVkDG
	 lOeaWH9dMiqV0desP/U0iz8TBHOWsKIhWT0or9ZEUpECg6WIZP6aqYZ9mT3bGnwNxig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=pXoD4ixC;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1F8606A328;
	Thu, 22 Oct 2026 15:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A1F8606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=pXoD4ixC
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2507B20B7167;
	Thu, 22 Oct 2026 08:03:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2507B20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792681382;
	bh=fGLjRwMYowHqgQeaj0mToA9QAIYNGDXlao2noz3GoI0=;
	h=From:To:Cc:Subject:Date:From;
	b=pXoD4ixCF5m0oBKb10WtUuJxi4FS/nffmPBdmiqtjcrVPYYR0jkEv7h7oqrHikdzy
	 BEvlsdleIB7Xg2DTY8aFlCTnLviT6hfjqj+lCChgJcaGm7Uh3jQTE12B9CleHMOlQE
	 Th2Y2N2ttYTWigRRLf66ssRpiCZx+uuuBrHRlL+M=
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
Subject: [PATCH net-next v9 0/4] net: mana: concurrent HWC requests and dynamic queue depth
Date: Thu, 22 Oct 2026 15:02:58 +0000
Message-ID: <cover.1792679388.git.weh@linux.microsoft.com>
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

This four-patch series adds concurrent HWC request ownership and
PF-directed HWC queue depth to MANA. It starts with depth-one bootstrap
queues and keeps setup private until the final channel is tested.

I am continuing Long Li's series. Original per-patch author identities,
dates and sign-offs are retained.

Changes in v9 (v8 -> v9):
 - Rebase onto net-next 207dd12bc195153fe6ca614d8add9ecb0b636270.
   This base already includes MANA BQL support (799cdeaa5c39).
 - In patch 3, replace the independent admission deadline with
   bitmap/waitqueue admission. Healthy contention waits for a free slot
   instead of returning EBUSY before a destructive command is posted.
 - Wake admission on slot release, recorded response abandonment,
   cancellation and channel stop. With no available slot, abandonment
   or cancellation returns ETIMEDOUT; a stopped channel returns ENODEV.
 - Preserve available-slot best-effort posting after cancellation and
   keep the response timeout for a posted command.
 - Suppress expected ETIMEDOUT/ENODEV logging after cancellation or HWC
   unpublication, while retaining live-channel and other diagnostics.
 - Correct the eight reported source-line length warnings across all
   four patches under netdev's explicit 80-column check.

Healthy admission no longer has a separate elapsed-time deadline,
matching the upstream waiting policy rather than treating healthy
contention as a channel failure. Response ownership, timed-out slot
quarantine and sender draining remain in place.

The PF specifies the HWC queue depth and corresponding ring sizes. It
reports the required depth through HWC_INIT_DATA_QUEUE_DEPTH, and the
VF rebuilds the rings to implement that PF requirement. Ring-sizing and
establishment behavior is unchanged from v8.

The pre-existing individual Ethernet/RDMA CQ publication and lifetime
issues, malformed-response RX reposting, and wider control-command DMA
failure policy remain separate work. This series does not claim to fix
them. Existing protections introduced later in the series are preserved
in their owning patches.

Validation on this revision:
 - Clean application of all four patches to the net-next base above,
   with no conflict resolution or three-way fallback.
 - GCC and Clang W=1 builds of the MANA Ethernet/RDMA target objects at
   the baseline and each of the four intermediate commits.
 - Full-patch netdev-style checkpatch with --strict --codespell and
   --max-line-length=80: no errors, warnings or CHECK diagnostics.
 - Bounded actual-source C models cover admission and response
   ownership, cancellation/logging, destructive callers, retained state,
   initialization, rebuild and producer limits, with negative controls.
 - Exact application and author/date/message checks on the outgoing
   patch emails.

These checks are static/offline. The models use typed userspace
substitutes and modeled hardware acknowledgments; no new full-kernel,
hardware, performance or runtime qualification is claimed for v9.

This HWC series remains independent of queue-set replacement. The
separately prepared queue-set series is not included here; its dependency
and shared CQ-table changes must be reconciled separately.

v8:
https://lore.kernel.org/all/cover.1791998462.git.weh@linux.microsoft.com/
v7:
https://lore.kernel.org/all/cover.1791561995.git.weh@linux.microsoft.com/
v6:
https://lore.kernel.org/all/cover.1790665894.git.weh@linux.microsoft.com/

Long Li (4):
  net: mana: prepare HWC ownership for safe reinitialization
  net: mana: give each HWC message slot its own completion state
  net: mana: support concurrent HWC requests
  net: mana: add dynamic HWC queue depth with reinit path

 drivers/infiniband/hw/mana/main.c             |   19 +-
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |    5 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  158 ++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    |   15 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  | 1025 ++++++++++++++---
 .../net/ethernet/microsoft/mana/shm_channel.c |   58 +-
 include/net/mana/gdma.h                       |   17 +
 include/net/mana/hw_channel.h                 |   70 +-
 include/net/mana/shm_channel.h                |   10 +-
 9 files changed, 1155 insertions(+), 222 deletions(-)


base-commit: 207dd12bc195153fe6ca614d8add9ecb0b636270
-- 
2.43.0

