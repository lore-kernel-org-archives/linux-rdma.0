Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A835C6B6;
	Sat, 22 Aug 2026 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787376414; cv=none; b=N+ms5haRdDHs6BrretZBgCBXrjIcymxOlIwYxydzvLk/wl+vvFFC/VIXugY/V9irrnmTLgtBn1PKGkZpWeuR6DRl1i4qV/yVRtr86Tei+mi/9QKDhP2knAt53ifHPwK5l1kr/lE1gy15dodaZ47EHXWAZkWQTFZDdGNNqPT5uoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787376414; c=relaxed/simple;
	bh=tn0TKsfthA/LJRXqVe9stku1GFPbxFySd1tkb05Ej7w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LA+JErSGv4L6E8TzWj2O+XodRKHhlTvI/N6bFuXMctYR555M5BBpZ22aTim3DfDMXesKN99EBK281G6XKegpIMHWWoiUB+5MjDd3n+ZxRsFaZ2kRyi/FVOVZI3kR7ezlITpeBXUYJ1TnAegZ/xBVJIqjZo1z/eE7mOwl4hWN74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJFtU6zp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJFtU6zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F6D1F000E9;
	Sat, 22 Aug 2026 05:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787376408;
	bh=9dyuV46x+oe93DACV4CXBDvjNGaHrdjm18Wd87xj4hU=;
	h=From:To:Cc:Subject:Date;
	b=iJFtU6zpDXNjKjXWQO2BiTVJCgH4hanTJ2p300c2xD55MNtXE/p9TpYDukKXOMQq3
	 P8G/81Li8h7BpBiqk6YR1GzjDO1hDi4JuNxRhJWDw6+/XV05naNa2JX87WvtI/xhrC
	 YwSzwToQw+Bk6h7OjAG1NceHR0jRbRaWO+6C3v1h7lx31H9sDME1u7HLcej5qTkWfk
	 udtRLo+1ncQtg7NuL6OvEvcWkLIgxcAUcsyYXt74xknrfNo48PaR0+enWqzJd1m6bA
	 ak8tCWqLz/tt9oIwNYuIeTkbdawFONuXffZaFTRglppnUs2BukJI/RtkOmN2JUIrE7
	 oktkeSJC/+fTw==
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
Subject: [PATCH net] net/rds: use wq_has_sleeper() in rds_cong_map_updated()
Date: Fri, 21 Aug 2026 22:26:47 -0700
Message-Id: <20260822052647.88318-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_cong_map_updated() runs after a peer's congestion map has been
rewritten (by rds_tcp_cong_recv() and rds_ib_cong_recv(), or the
clear-all in the loopback and IB send-completion paths).  It bumps
rds_cong_generation and then checks waitqueue_active() on
map->m_waitq and on rds_poll_waitq to decide whether anyone needs
waking.  atomic_inc() carries no ordering and waitqueue_active() is a
plain load, so nothing orders the map and generation stores before
the wait queue reads.  The waiters do the mirror image: rds_cong_wait()
adds itself to m_waitq and then tests the port bit, and rds_poll()
registers on rds_poll_waitq and then reads the generation.  That is
the store-buffering pattern described above waitqueue_active() in
include/linux/wait.h - the updater can observe an empty wait queue
while the waiter still observes the port as congested, and no wake-up
is issued.

rds_cong_wait() is an interruptible sleep with no timeout, so a
sender blocked on a congested port stays blocked until the next
congestion update from that peer arrives or a signal is delivered.
A poll() waiter misses the map-updated notification the same way.

Use wq_has_sleeper(), which is waitqueue_active() preceded by the
required full barrier, as rds_tcp_state_change() already does for
the same pattern.

Fixes: 922cb17a5c81 ("RDS: Congestion-handling code")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
Raised during review of "net/rds: own the fastpath locks across
connection teardown", whose first patch fixes the same pattern in
release_in_xmit():
https://lore.kernel.org/netdev/20260820133832.5384be37@kernel.org/
This patch is independent of that set and applies on its own.

 net/rds/cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index 3133b91f9e69..f7634ce3ffc1 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -256,9 +256,9 @@ void rds_cong_map_updated(struct rds_cong_map *map, uint64_t portmask)
 	  map, &map->m_addr);
 	rds_stats_inc(s_cong_update_received);
 	atomic_inc(&rds_cong_generation);
-	if (waitqueue_active(&map->m_waitq))
+	if (wq_has_sleeper(&map->m_waitq))
 		wake_up(&map->m_waitq);
-	if (waitqueue_active(&rds_poll_waitq))
+	if (wq_has_sleeper(&rds_poll_waitq))
 		wake_up_all(&rds_poll_waitq);
 
 	if (portmask && !list_empty(&rds_cong_monitor)) {

base-commit: 4e15e89faac9f308baeb01f46c13a051814d2449
-- 
2.25.1

