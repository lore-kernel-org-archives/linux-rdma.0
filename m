Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B04C3DEACA;
	Mon, 25 May 2026 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779696750; cv=none; b=Q6SB+GC9X71dLjbBeDo9wZEUvNHuDZ4KNc/dv31Z2QAyLC5l3yQiaIOayJS4fVMxjMZCvQv8ufVbi6QF95fAniyycoQTjGdABnfRBFfogKaIEc1dt9UoX9TchXuBR29Liw5IpHln2y5iqWGhre2+zM+iN41oEFa36W8x6Og0+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779696750; c=relaxed/simple;
	bh=hRQ0me5CbZEyBfO7tkqlH9qgYZ65fbsPko7igW1e4hY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=c4COYv/XkYFmbm6x4gtTo4lJtnPNTDJyCVf+TwhPeLXsJwCqsKJci8QXhghf+grL2uan/kBDHBVsZqPttzw/qyh7C4bn7dPo8qDf3/fRKjIFDqdkhY7bjZvZ6SIiY4TAP7fZaf3LzNknyXdI34FlOJiOM4A1lmn/IbMr901B/nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RfEgDkAz; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RfEgDkAz"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id B291220B7166;
	Mon, 25 May 2026 01:12:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B291220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779696725;
	bh=h5zycZZ8L/qFpkXhbHcyu6Sj4Vjn/Be0BxFeEgx8Wbc=;
	h=From:To:Subject:Date:From;
	b=RfEgDkAzmLG5pn5fsmi7QgZCl3n/8HaVHUhZA+wJAYGWPnnjSGTSMzsqrnM7/boLW
	 RA2K74/sKb3z6KVbrS3er76geDgCLcqRqh6HL+NLSj85LHLpXKVuLX2uLJGPODF+v5
	 ONo2tIDWlF+R6I1kXllehuds1yOuwabQO2SU+Tkc=
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
	yury.norov@gmail.com,
	pavan.chebbi@broadcom.com
Subject: [PATCH net v3 0/2] net: mana: Fix NULL dereferences during teardown after attach failure
Date: Mon, 25 May 2026 01:08:23 -0700
Message-ID: <20260525081129.1230035-1-dipayanroy@linux.microsoft.com>
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

Patch 2 adds an early exit in mana_detach() for already-detached ports,
making it safe for non-close callers. This allows the queue reset
handler to safely retry mana_attach() without redundant teardown.

Changes in v3:
  - Patch 1: Fixed commit message and fixes tag.
Changes in v2:
  - Patch 2: moved netif_device_present() check into mana_detach() as
    an early exit instead of using goto in the work handler 

Dipayaan Roy (2):
  net: mana: Add NULL guards in teardown path to prevent panic on attach
    failure
  net: mana: Skip redundant detach on already-detached port

 drivers/net/ethernet/microsoft/mana/mana_en.c | 76 ++++++++++++-------
 1 file changed, 47 insertions(+), 29 deletions(-)

-- 
2.43.0

