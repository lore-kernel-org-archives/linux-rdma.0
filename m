Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E5E2C08CF;
	Wed, 24 Jun 2026 22:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340013; cv=none; b=GnpXV2UyppwiX2Cbuk5z8ZVdADUUJL72XfkEIcEmdo2EHouonCobHd8OQCvwkiDfAbHaviRgby3ZFGDvsdr2b0lz9PBk3+Mxd3sRm5BmZwOzci+kBRpP13d7YvxoN4gKmrSLpJVLOkhcdZw5TYa8MuumHlryknqHJqHQS0mMxxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340013; c=relaxed/simple;
	bh=Dcemh5adW4aUAyKSjdTU9WEGDohpJ/2reiBtr58yTn4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=O5JdFLdIzG7BgspkCeOSGIft6h19dSiR5/1P15whmkBndTv3zBItYajZH1qfl4MGCo/C7svhsMSw5D/RwaspXV49Cxf3Bd7Cjw/Yj70sxt2vtnVfMPbruANWdDhg+oas7/JVzLiRMUrL7Bb5kkrosCygNrUMpi4SS4KQLL2/G/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1009)
	id DA54520B7166; Wed, 24 Jun 2026 15:26:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DA54520B7166
From: Dexuan Cui <decui@microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	dipayanroy@linux.microsoft.com,
	kees@kernel.org,
	jacob.e.keller@intel.com,
	ssengar@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v2 0/2] Fix MANA RX with bounce buffering
Date: Wed, 24 Jun 2026 15:26:03 -0700
Message-ID: <20260624222605.1794719-1-decui@microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With swiotlb=force, the MANA NIC fails to work properly due to commit
730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead
of full pages to improve memory efficiency.")

Dipayaan tried to fix this by avoiding page pool frags when bounce
buffering is in use [1][2]. However, that is not a clean solution: no
other NIC drivers need to explicitly check whether bounce buffering is
in use. It is also not good for throughput, since
dma_map_single()/dma_unmap_single() are then called for each incoming
packet.

In fact, page pool frags can still be used with the standard MTU of
1500: all we need is to add page_pool_dma_sync_for_cpu() before the CPU
reads the incoming packet, so I implemented that in v1 [3].

As Simon suggested [4], this version splits v1 into two patches:
Patch 1 adds page_pool_dma_sync_for_cpu().
Patch 2 validates the packet length reported by the NIC.

There is no functional difference between v1 and v2, so I am keeping
Haiyang's Reviewed-by tag in v2.

Please review. Thanks!

Note that, with jumbo MTU and XDP, page pool frags are not used, and
dma_map_single()/dma_unmap_single() are still called for each incoming
packet, causing poor throughput with swiotlb=force; see
mana_get_rxbuf_cfg() and mana_refill_rx_oob() -> mana_get_rxfrag().
The jumbo MTU/XDP issue will be addressed later since that needs more
consideration if we want to use page pool with PP_FLAG_DMA_MAP there:
e.g., for XDP, the received packet can be transmitted in place, i.e. the
same RX buffer can be used as a TX buffer:
mana_rx_skb() -> mana_xdp_tx() -> mana_start_xmit() -> mana_map_skb().

In mana_create_page_pool(), we may have to set pprm.dma_dir to
DMA_BIDIRECTIONAL if XDP is in use:
pprm.dma_dir = mana_xdp_get(mpc) ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;

In the case of XDP, the next issue is that mana_rx_skb() -> ... ->
mana_map_skb() appears to call dma_map_single() on an RX buffer allocated
from a page pool created with PP_FLAG_DMA_MAP, which seems incorrect.
Any thoughts?

[1] https://lore.kernel.org/all/ae91hyrLf4n23XE6@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/#r
[2] https://lore.kernel.org/all/ae9pxvJfkAZYfKMf@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/
[3] https://lore.kernel.org/all/20260618035029.249361-1-decui@microsoft.com/
[4] https://lore.kernel.org/all/20260619090514.GT827683@horms.kernel.org/

Dexuan Cui (2):
  net: mana: Sync page pool RX frags for CPU
  net: mana: Validate the packet length reported by the NIC

 drivers/net/ethernet/microsoft/mana/mana_en.c | 61 +++++++++++++++----
 include/net/mana/mana.h                       |  8 +++
 2 files changed, 58 insertions(+), 11 deletions(-)

-- 
2.34.1

