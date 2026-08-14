Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E2638A29A;
	Fri, 14 Aug 2026 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671313; cv=none; b=dnWuYQzVbGsPRVOiuXyk0nw5InwOPIbTzZ/pwVx7Y4o9c7KlTIkPo9jVA5WUV/qeGMH8qoqdBuJPU2NszDFD6y/Oj6ngP6382nXEM5W4c5v2eC8sW/R45fRaiol1iyRjO/WT47EVGurPKRnrM05zTL59hMWwcYCKupCxau5s2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671313; c=relaxed/simple;
	bh=UIb/TVRTwgD8aeFJgMvFslXcomzvBm8dptDVMaoJEPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=PMVbQq5g0GTKPrF2E7XN1SCCtWnoMfIRVMK3UzSxXip75Z2oer6pLRNlTSMR3+JsbH0TE1D16aMB0p1Ai8vAuHkHAZ0ldUdHYxRZT2F1BdXCffo3ZxRT9PbIlDG1KP0rbBTkb+dMt8U6dY84ASkdeqzuicI14oDETpxtxLxebq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsU+NWZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsU+NWZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984521F000E9;
	Fri, 14 Aug 2026 01:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671303;
	bh=b1I0BUSn8GVNXy9+2Aomx4OGZKsXqSBtbCi9glaJZJ4=;
	h=From:To:Cc:Subject:Date;
	b=YsU+NWZLS0UVsVtvKZnca9v1g5cdqtUrr5O6hPXmBJf2mAZCyJbRE9a1YVZTVTf00
	 6vLn57IJGMuJYI1r7D1231UL9Umowny1A+qOZP0LTUGMcIrGroKBpOO4ZXo5lqC89H
	 oKR2HgcsoD8uQIFCzfoV/FDtCdeko6VA7oIUhMcnuP8LS0JnQ/zKENjMuDHrcQ+4JN
	 ha6ndid46JYDuh23hnc3l43/pyD1tA8Lfmz9/J0RUTr/Iioko0GY/p1skgesI32hZR
	 lgQoO+o+U5i0v4k6M6IPpcfpLYFYwUhdZS8G35NOTDjWVm1UkJylarCG1/XP/VUA0L
	 nf3AszTu4549g==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next 0/4] net/rds: own the fastpath locks across connection teardown
Date: Thu, 13 Aug 2026 18:34:57 -0700
Message-Id: <20260814013501.43760-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

This is a follow-up set to the recent "net/rds: Bug fix ports, part 2"
series [1]. During review of v1, the later half of the set needed more
work than just a respin, so it was split off into a separate set here
along with a few other companion fixes identified in the reivew.

RDS connection teardown quiesces the transmit and receive-refill fast
paths by waiting for the RDS_IN_XMIT/RDS_RECV_REFILL bits to be
sampled clear.  Sampling a bit clear is not owning it: the fast path
can re-take its bit right after the wait returns and then run
concurrently with the transport shutdown and the send-state reset.
Oracle UEK closed this by making teardown acquire the bits as locks
("rds: Make sure transmit path and connection tear-down does not run
concurrently"); patches 3 and 4 do the same for the two
rds_send_path_reset() call sites upstream.  These pacthes are
effectively v2 of patches 3 and 4 from the aforementioned
"net/rds: Bug fix ports, part 2" [1] set.

Making teardown block on the bits as locks promotes two latent
ordering bugs from rare to load-bearing, so they are fixed first:

  Patch 1: release_in_xmit() checks waitqueue_active() after
  clear_bit_unlock(), which does not order that read; the wake-up of
  the (now uninterruptible, untimed) teardown wait can be lost.  Use
  wq_has_sleeper().

  Patch 2: rds_conn_path_reset() wipes the whole cp_flags word with a
  plain store.  Once teardown owns bits in that word across the
  reset, a blanket store would end lock ownership early - and it
  already races atomic RMWs on the same word today.  Clear the bits
  the reset is responsible for individually, as Oracle UEK also does.

With those in place, patch 3 has rds_conn_shutdown() hold both bit
locks across the transport shutdown and path reset, and patch 4
converts rds_tcp_reset_callbacks() from waiting on RDS_IN_XMIT to
acquiring it, which also serializes the duelling-SYN accept path
against a concurrent teardown of the same path (the old code could
resume with a socket pointer the teardown had already released).

[PATCH net-next 1/4] net/rds: use wq_has_sleeper() in release_in_xmit()
  Restore full barrier before wake-up checks in release_in_xmit()

[PATCH net-next 2/4] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  Partial port of commit d04896037223 ("net/rds: Preserve essential connection state flags")
  https://github.com/oracle/linux-uek/commit/d04896037223

[PATCH net 3/4] net/rds: acquire the fastpath locks in rds_conn_shutdown()
  Port commit 2b8aaa4f163b ("rds: Make sure transmit path and connection tear-down does not run concurrently")
  https://github.com/oracle/linux-uek/commit/2b8aaa4f163b 

[PATCH net 4/4] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  Extend the last port to cover extra call sites in rds_tcp_reset_callbacks()

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/

Allison Henderson (3):
  net/rds: use wq_has_sleeper() in release_in_xmit()
  net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Håkon Bugge (1):
  net/rds: acquire the fastpath locks in rds_conn_shutdown()

 net/rds/connection.c | 32 +++++++++++++++++++++++++---
 net/rds/send.c       | 12 ++++++++---
 net/rds/tcp.c        | 50 +++++++++++++++++++++++++++-----------------
 3 files changed, 69 insertions(+), 25 deletions(-)


base-commit: 3da8c3c8b8fa99505624b65ef590482f48e766b6
-- 
2.25.1

