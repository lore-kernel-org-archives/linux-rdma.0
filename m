Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1061A493631;
	Sat, 22 Aug 2026 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787376302; cv=none; b=lWg8qShriSQWJjDgzlwSGIc/0tRektDTgodGP0fSgDyihl9GY4nRirhVkYOoPLISghYqbQEScYgVP9QLE9AjKeEmyKixZIEWJALjv6LHHv9uXLCMXlWTulQFdVeKTboT2p5gBtV+4kKZ1nCSws6V/UpC7PogD65QciIppJHL8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787376302; c=relaxed/simple;
	bh=Y6UmVHkxUNRuS1PBBbXhlQdbvhvAAKM+8ILLJn/HYsg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=My1S6agGY1raKDjwbHN7a+zPUCkvTIZtdWnd43YUqADH4yz7SL8RWa1CxUHpARPUJc34P6cdcKM4br9EsngrkHeNBGf7iyICMJ/Fk0JvB6UDcehVOffT1OAZxObTzpjwx70hHKrOWlBaC7gU/QZlpn/gidcMhcgedOBegRTrKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QADJGGFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QADJGGFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0583D1F000E9;
	Sat, 22 Aug 2026 05:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787376300;
	bh=CrvgJEkbQCloRyiBq5HghL7V+YaVMk2BeB4NQAbRu4o=;
	h=From:To:Cc:Subject:Date;
	b=QADJGGFhP/50e3S9jFo0+iOp9JD1+IVmH9DcFvd8Fv28LndfGAvvNhDSEzYHoqhAf
	 k31xIX/pdTw26y6XTsbAutjN2cbgYJIgepJGUpzm4SwzwS9RPvtZQBKzSGebbwc8Ex
	 gj1R4JsM49/TLFc26nKXHgIiASvYnQJ4JdzJ4mzKrVoNuXsfMg1GipJFVYu7NEAxD6
	 1+KSYns7Hb2v81HTjnwbMh4fOERRJm+WdL1OGo0Jevw/Uq4tiNN0JpyDavhRn09fKM
	 ot4W1dxZHpTrKNb148cSPp8xIefaEB5Ni02pS0ZdIET8hpYa1iRKU0e2vMUXXr94j0
	 tM5XVY9iBpZKA==
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
Subject: [PATCH net v3 0/5] net/rds: own the fastpath locks across connection teardown
Date: Fri, 21 Aug 2026 22:24:54 -0700
Message-Id: <20260822052459.88017-1-achender@kernel.org>
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

This is v3 of the follow-up set to "net/rds: Bug fix ports, part 2"
[1] (v1 of this set is at [2], v2 at [3]).  During review of part 2,
the later half of that series needed more work than a respin, so it
was split off into this set together with the companion fixes
identified along the way.  As discussed on the v2 thread, it is now
targeted at net.

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

[PATCH net 1/5] net/rds: use wq_has_sleeper() in release_in_xmit()
  Restore full barrier before wake-up checks in release_in_xmit()

[PATCH net 2/5] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  Partial port of commit d04896037223 ("net/rds: Preserve essential connection state flags")
  https://github.com/oracle/linux-uek/commit/d04896037223

[PATCH net 3/5] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
  Port of commit 72c176a1d9ac ("net/rds: Don't force state RDS_CONN_RESETTING")
  https://github.com/oracle/linux-uek/commit/72c176a1d9ac

[PATCH net 4/5] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  Extend the port in patch 5 to the second rds_send_path_reset() call site

[PATCH net 5/5] net/rds: acquire the fastpath locks in rds_conn_shutdown()
  Port of commit 2b8aaa4f163b ("rds: Make sure transmit path and connection tear-down does not run concurrently")
  https://github.com/oracle/linux-uek/commit/2b8aaa4f163b

Changes since v2 [3]:
  - Retargeted at net; rebased onto net/main.
  - No functional changes apart from patch 5 now releasing
    RDS_RECV_REFILL with clear_bit_unlock(), matching the RDS_IN_XMIT
    release beside it, so the teardown's ring and send-state writes
    are ordered before the bit is seen clear.
  - Comment and changelog corrections from the v2 review pass:
    patch 2 no longer claims a quiescence guarantee that only patch 5
    delivers; patch 3 spells out that the fallback drop replaces the
    shutdown's state with RDS_CONN_ERROR (which rds_conn_shutdown()
    tolerates) and queues one more down-work pass; patch 4's block
    comment names all three t_sock writers and what serializes each;
    patch 5 refreshes the rds_conn_path_reset() header, the
    acquire_refill() comment in rds_ib_recv_refill() and the
    rds_tcp_reset_callbacks() comment to name the teardown as an
    owner of the bits, and its changelog describes the knock-on
    effect of the parked accept worker on the shared krdsd workqueue
    and why that is a bounded stall rather than a deadlock.

The cong.c wq_has_sleeper() conversion mentioned on the v2 thread is
a pre-existing issue independent of this set and is sent separately.

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260814013501.43760-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20260816001510.73645-1-achender@kernel.org/

Allison Henderson (3):
  net/rds: use wq_has_sleeper() in release_in_xmit()
  net/rds: clear cp_flags bits individually in rds_conn_path_reset()
  net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Gerd Rausch (1):
  net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent
    shutdown

Håkon Bugge (1):
  net/rds: acquire the fastpath locks in rds_conn_shutdown()

 net/rds/connection.c | 46 +++++++++++++++++++----
 net/rds/ib_recv.c    |  4 +-
 net/rds/send.c       | 12 ++++--
 net/rds/tcp.c        | 87 +++++++++++++++++++++++++++++++-------------
 4 files changed, 112 insertions(+), 37 deletions(-)


base-commit: 4e15e89faac9f308baeb01f46c13a051814d2449
-- 
2.25.1

