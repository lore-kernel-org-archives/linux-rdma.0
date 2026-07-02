Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042C22E0901;
	Thu,  2 Jul 2026 04:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782965595; cv=none; b=SJv4yN0Fw8xIIJ66uHxA1zjkzwpLbpr11Ejz3EeT9uZBO+qrt/5Ql7FbRwTezXCRfIaTgmexRK0gXjb6qJk9RnllN1IIUoAEzrKvB8JDV8lJtzKYn4uhtcZ7+zDLEmUYHH9gg/kv5Ya7CjwHUiwbMWUTXMw9R/bpIKWRaIIxZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782965595; c=relaxed/simple;
	bh=gZPjvKr3IxnQ6hiSUc3ilImgoP+GuC2xkdc+CgjbSWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFnk5cW6ouFj6lBWVq4CSffzb2BaLnpLxa2XS5/aOCJDmQ5NVV4RV52I/bh+Fb3czZncd0SM+1svtUAkZShzoLir9dMPuhMIwVlzvAYw6+RGbE9oIvAuYqyjcO60vrKcqGVi6Rs7MV5vbhZz6c9KRbJtvP7rDVoigxXg8jgFCQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1009)
	id ED9F320B7169; Wed,  1 Jul 2026 21:13:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ED9F320B7169
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
Cc: stable@vger.kernel.org
Subject: [PATCH net v3 0/2] Fix MANA RX with bounce buffering
Date: Wed,  1 Jul 2026 21:12:35 -0700
Message-ID: <20260702041237.617719-1-decui@microsoft.com>
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
of full pages to improve memory efficiency.").

This happens because, with the standard MTU=1500, the aforementioned
commit uses page pool frags with PP_FLAG_DMA_MAP, but fails to call
page_pool_dma_sync_for_cpu() to sync the received packet for CPU acces
before handing the RX buffer to the stack.

Here patch #2 adds the required page_pool_dma_sync_for_cpu().

Patch #1 validates the packet length reported by the NIC. With patch #2,
page_pool_dma_sync_for_cpu() uses the packet length, so we don't want
to blindly trust the packet length, just in case.

There is no change between v2 and v3.
v3 just swaps the order of the 2 patches in v2, as suggested by Simon [3].

Please review.

Thanks,
Dexuan

References:
[1] v1: https://lore.kernel.org/netdev/20260618035029.249361-1-decui@microsoft.com/
[2] v2: https://lore.kernel.org/netdev/20260624222605.1794719-1-decui@microsoft.com/
[3] https://lore.kernel.org/netdev/20260626145048.GB1310988@horms.kernel.org/

Dexuan Cui (2):
  net: mana: Validate the packet length reported by the NIC
  net: mana: Sync page pool RX frags for CPU

 drivers/net/ethernet/microsoft/mana/mana_en.c | 61 +++++++++++++++----
 include/net/mana/mana.h                       |  8 +++
 2 files changed, 58 insertions(+), 11 deletions(-)

-- 
2.34.1

