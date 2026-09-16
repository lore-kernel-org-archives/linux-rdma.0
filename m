Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FDA509EE9;
	Wed, 16 Sep 2026 13:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789566573; cv=none; b=TH+U7dGtqd5Xbr4D2GM4G5WESBCgDi4t4EDk3WKWQot372WRCAfvLgcEZlddSnj5bCnN5ojk0P33eTZQvMB7STqOyJH/4E3uYTQ97+mTUUyvXisuKpGAsHEeZEVLjk+dfg1ySambFCYKhAk6bI96s+Bg5otZBPb3N/Pb0tMYnG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789566573; c=relaxed/simple;
	bh=7lGv0wYe9NR+ek/5jptYtj5O+KSHz6cOGNSyS5VS5YY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ANYhE41Il0pc0rts0xyTJwS2JrVjSnSL01DrFhDEeHgjlHdK7VIiKv4/J9ggn6snveO9l01++Ou7ZN5bPukIpk8qsTqMQzYo32aBWnMAiPfnMcoTEGW5UGcZ/1cFkJ6xLZNaAGvj22Wsddn0zJ3mzmmDLkP2GuiDqrGJqQOeNek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VtGKtNjC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VtGKtNjC"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id BC92520B7169; Wed, 16 Sep 2026 06:48:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC92520B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1789566515;
	bh=q/MWQORCGKudZJAj/DOVVxHs83PfcJtDotE/L1UysJw=;
	h=From:To:Cc:Subject:Date:From;
	b=VtGKtNjC9RI+vFWZokLinJuDuIC3qqxO+U5rXqXON+qlSelFzz8Qw9ktmsKuZPyvk
	 X7YCr0LGY9q0y997TR7Q0OqSJuX0TkPuNcaY8oGVIv3VltSS7S4unyHrGGenvlvcE8
	 xaZc95tSIbmGWI+KW6iexJSDBzpZpZ5Tl99+i3Oc=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/5] RDMA/mana_ib: Streamline kernel UD/GSI posting and completion handling
Date: Wed, 16 Sep 2026 06:48:30 -0700
Message-ID: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

This series updates the kernel UD/GSI work-request and completion paths in
the MANA RDMA driver. The existing completion path copies CQE information
into shadow entries and then walks the QPs attached to a CQ to produce
work completions. This adds bookkeeping and a second pass over information
that is already available when processing the CQE.

Generate work completions directly from CQEs and the corresponding posted
shadow entries instead. Keep only QPs requiring software flushing on the
CQ's error lists, and use the caller's remaining completion budget to
retire their outstanding requests. The explicit GSI send-drain path adds
the QP to the error list and invokes the CQ handler.

The shared GDMA SGE writer and explicit-index doorbell helper are included
with their first users so this series does not depend on a later GDMA
change. The WQE definitions and polling context also provide groundwork
for a separate kernel RC series; RC posting, PSN/FSN processing, hardware
error-CQE handling.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Konstantin Taranov (5):
  RDMA/mana_ib: Optimize shadow queue bookkeeping
  RDMA/mana_ib: Revise UD send posting and WQE definitions
  RDMA/mana_ib: Revise UD receive posting with GDMA_WR_IB_SGL
  RDMA/mana_ib: Make kernel CQ arming robust
  RDMA/mana_ib: Poll UD completions and flush software error QPs

 drivers/infiniband/hw/mana/cq.c               | 315 +++++++++++++-----
 drivers/infiniband/hw/mana/mana_ib.h          | 101 +++++-
 drivers/infiniband/hw/mana/qp.c               |  78 +++--
 drivers/infiniband/hw/mana/shadow_queue.h     |  60 ++--
 drivers/infiniband/hw/mana/wr.c               | 141 ++++----
 .../net/ethernet/microsoft/mana/gdma_main.c   |  43 ++-
 include/net/mana/gdma.h                       |   9 +-
 7 files changed, 527 insertions(+), 220 deletions(-)


base-commit: 63367df6e7255067ad6a83abe0d2799dfa491876
-- 
2.43.0
