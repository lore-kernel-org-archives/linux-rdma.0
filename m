Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA336346AC2;
	Mon, 18 May 2026 19:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133641; cv=none; b=C3RlBUm4zScrsQDoVPZkKrYyS8E/zQ3gFtGnq+02gHCOLvsZ0BdvE7z/cVbviQfifaWLoajL5ld/YqKslxlLEMhshGjtUg6sx+aPdT6HVOjGta6Fi95/ETsP7JH1LLD9Usz2Z6LSzTxW6+KkxWvf1lnpwzQKMyBwdJI46zW48+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133641; c=relaxed/simple;
	bh=kxII/5G2NwPmXEG++FHPsH1/AEBqc9FKZzrBq4bibjc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bdzeSFxRnCs81iwUQ8goUzEsX7eBa5qZ6DGlmBkqSpfC8zG1pE5ERfxLLYMd4aD20Kjb25+GJGk/YnDzJ0uG02SorsD8U/xrfMSMPkrULaeOqP9B8YWjL6+DdmVW6t8Iq+v2twqjOUnfRwpLWPTcdXp8lzA8NPrWH04stP6dJOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CazOhGFW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CazOhGFW"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7D3B220B7166;
	Mon, 18 May 2026 12:47:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D3B220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779133634;
	bh=fyTfiydw4H8mIqzNYtreKgjRdnGF1qAhJXcvnEyTJws=;
	h=From:To:Subject:Date:From;
	b=CazOhGFWXaypq1pD5CFDrY/+iNmzm5o6PiJ7ox8jpZvJYqw84KJonnLZmSZeAVj7B
	 OG+A/XbnmSewzH/pKJ4fyaobPtl3eFn+8C5IylCqk3sE2St7RMwOBjFDw/nhy3ECix
	 KjWk/RWMBdg136Qmnfykz9wTjqd71RczCJH2lsJQ=
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com
Subject: [PATCH net 0/2] net: mana: Fix NULL dereferences during teardown after attach failure.
Date: Mon, 18 May 2026 12:43:49 -0700
Message-ID: <20260518194654.735580-1-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mana_attach() fails (e.g. during queue allocation), the error
cleanup frees apc->tx_qp and apc->rxqs and sets them to NULL. Multiple
subsequent teardown paths can then dereference these NULL pointers,
causing kernel panics.

Patch 1 adds NULL guards in the low-level teardown functions
(mana_fence_rqs, mana_destroy_vport, mana_dealloc_queues) so they are
safe to call regardless of queue initialization state. This covers all
callers: mana_remove(), mana_change_mtu() recovery, and internal error
paths in mana_alloc_queues().

Patch 2 addresses the queue reset work handler specifically, where an
unconditional mana_detach() on an already-detached port caused
redundant teardown. It checks netif_device_present() to skip the detach
and directly retry mana_attach().

Dipayaan Roy (2):
  net: mana: Add NULL guards in teardown path to prevent panic on attach
    failure
  net: mana: Skip redundant detach in queue reset handler if already
    detached

 drivers/net/ethernet/microsoft/mana/mana_en.c | 77 ++++++++++++-------
 1 file changed, 48 insertions(+), 29 deletions(-)

-- 
2.43.0

