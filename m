Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9D339D6FC;
	Sun, 16 Aug 2026 00:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786839316; cv=none; b=TNDNOy3BWtyW6qV7L4vbnXtqg+ors8Uzfsx1+4RXjIuCTySGE6zK2agQ55NO8c7V4EcI7N1M/kggMnNTRnCMXyL5yiZgcjKwEB6xij5P46QREOjxzdrcjVC3PilXK5Su7tLEykjvX29/vBRIVAC9gcRPkQEXNFh15C0xQfqbTf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786839316; c=relaxed/simple;
	bh=W6qu68Y0sF/RmgnNlJ5t+f2KFKsn+b7zH1XS8a0UlHE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QDzp6HK+T4BLGIj3pBy2k0/X6zLKweBIZ5WY5e8utfyZ6C2k8qlmhN5XUsVB0eu6GpOtPoC/wZ+dw9khE8Vy/CHiA9AenTTHhHI5sdoDx9aZL3IEMzVQ+2UNUacZwfQfVYHh1bSFH+4nuCTxiBXqWH5+akMVl6tnguFhUjka2wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+drIrwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+drIrwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964331F000E9;
	Sun, 16 Aug 2026 00:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786839311;
	bh=tP28fDcSsnIfsgwDwUNi0ImPaSZ2lrWzcry1YZUjLq0=;
	h=From:To:Cc:Subject:Date;
	b=P+drIrwS3mlwq5vb/baFfR4qMegYZrD4DwVPfjLuN+Myz7YJYTugPt/VsOnts7QLJ
	 gf+JV+LAjA5OD2KQj0vrHOkxFc1W1ZNuEHpFS6ykZMhK+I2st7e0l3z8dF90mTYWa7
	 6WNNzpYnKvAeVds3pXjUbtu2X5Eo9L1hsHAo7kJOkOKLjbWmPrJp0kG5V9ZdDmTaNY
	 GVbGPjjB9pDK6j6qJ84fH0ErsBHRC0aRKqoc5o4nU32HVLwdYKdEaZVu5XA2I7VQwr
	 YiQwz4LwvCaFKqoMfz0pJIVJM9crPm+V8h6SM24HD8fjAccdCXFdP9BwNFsbVZwETm
	 5JK6Nj8xWIP+Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net-next v2 0/5] net/rds: own the fastpath locks across connection teardown
Date: Sat, 15 Aug 2026 17:15:05 -0700
Message-Id: <20260816001510.73645-1-achender@kernel.org>
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

This is v2 of the follow-up set to "net/rds: Bug fix ports, part 2"
[1] (v1 of this set is at [2]).  During review of part 2, the later
half of that series needed more work than a respin, so it was split
off into this set together with the companion fixes identified along
the way.

RDS connection teardown quiesces the transmit and receive-refill fast
paths by waiting for the RDS_IN_XMIT/RDS_RECV_REFILL bits to be
sampled clear.  Sampling a bit clear is not owning it: the fast path
can re-take its bit right after the wait returns and then run
concurrently with the transport shutdown and the send-state reset.
Oracle UEK closed this by making teardown acquire the bits as locks
("rds: Make sure transmit path and connection tear-down does not run
concurrently"); patches 4 and 5 do the same for the two
rds_send_path_reset() call sites upstream.  These two are effectively
v3 of patches 4 and 3 of "net/rds: Bug fix ports, part 2" [1].

Making teardown block on the bits as locks promotes three latent
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

  Patch 3: rds_tcp_reset_callbacks() stores RDS_CONN_RESETTING
  unconditionally, which can overwrite the RDS_CONN_ERROR or
  RDS_CONN_DISCONNECTING of a shutdown already in progress on the
  same path and send that shutdown through an extra drop cycle.  Once
  the accept path can park for the duration of a teardown (patch 5)
  that window widens, so make the transition conditional first, as
  Oracle UEK does.

With those in place, patch 4 converts rds_tcp_reset_callbacks() from
waiting on RDS_IN_XMIT to acquiring it, holding it across the socket
swap and rds_send_path_reset(), and patch 5 has rds_conn_shutdown()
hold both bit locks across the transport shutdown and path reset.
The order matters: with the accept path owning the lock first, no
intermediate commit leaves it resuming on a socket pointer that a
lock-holding teardown has already released.

[PATCH net-next 1/5] net/rds: use wq_has_sleeper() in release_in_xmit()
  Restore full barrier before wake-up checks in release_in_xmit()

[PATCH net-next 2/5] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  Partial port of commit d04896037223 ("net/rds: Preserve essential connection state flags")
  https://github.com/oracle/linux-uek/commit/d04896037223

[PATCH net-next 3/5] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
  Port of commit 72c176a1d9ac ("net/rds: Don't force state RDS_CONN_RESETTING")
  https://github.com/oracle/linux-uek/commit/72c176a1d9ac

[PATCH net-next 4/5] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  Extend the port in patch 5 to the second rds_send_path_reset() call site

[PATCH net-next 5/5] net/rds: acquire the fastpath locks in rds_conn_shutdown()
  Port of commit 2b8aaa4f163b ("rds: Make sure transmit path and connection tear-down does not run concurrently")
  https://github.com/oracle/linux-uek/commit/2b8aaa4f163b

Changes since v1 [2]:
  - New patch 3, porting the UEK fix for the accept-vs-shutdown state
    race; the RESETTING store is now a conditional transition.
  - Patches 4 and 5 (formerly 4 and 3) reordered so that
    rds_tcp_reset_callbacks() owns RDS_IN_XMIT before
    rds_conn_shutdown() does; no intermediate commit is a bisect
    hazard.
  - Patch 2 gains a Fixes tag; patch 4 refreshes the stale block
    comment above rds_tcp_reset_callbacks(); patch 5's changelog
    describes the accept-side waiter parking on krdsd for the
    duration of a TCP teardown and why that is preferable to the race.

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260814013501.43760-1-achender@kernel.org/


Allison Henderson (3):
  net/rds: use wq_has_sleeper() in release_in_xmit()
  net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Gerd Rausch (1):
  net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent
    shutdown

Håkon Bugge (1):
  net/rds: acquire the fastpath locks in rds_conn_shutdown()

 net/rds/connection.c | 32 +++++++++++++++++--
 net/rds/send.c       | 12 +++++--
 net/rds/tcp.c        | 76 +++++++++++++++++++++++++++++---------------
 3 files changed, 88 insertions(+), 32 deletions(-)


base-commit: 3da8c3c8b8fa99505624b65ef590482f48e766b6
-- 
2.25.1

