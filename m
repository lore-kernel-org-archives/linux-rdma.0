Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97D81DDFE;
	Sun, 27 Sep 2026 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490660; cv=none; b=WZ3rHXCMIghbcVC5n+ZUPWmvh0TQsvnl+SUtRJBjs1SP0qHiyuWOQ+DUbAJbBWj0YNq3hUEgqbKkvH1B8ZLGxwb7BpcY02AznZlBgHRvA6MUGLAT8Otz3mhzdfJA9N6fNzJXv3LvlFEq6Eq6Gs8cncPSmcQvxhJV9vkt28Mqzq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490660; c=relaxed/simple;
	bh=NMVkelhdF9XpauXeWAA0NLB/wkZSiMnCMLj6Hjq1AE4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hs/kAViT7SyCYhW01j/TD26tuaAPRKSaGEXqX9VhKZ58lRAFQo/eZibH6OsJkaNQ35AOLtdFAA6RvJpjIyZ6gOZ5W/UwPVTG2f9ne37roM44etCiaX04lwRtbWnawhTJJKp5TVtFSpE0e8VgXVhzzWLYX6WVGAgv2r9JYzq63x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCF3uWTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCF3uWTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57FE1F000FF;
	Sun, 27 Sep 2026 06:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490659;
	bh=6Onuq46hT8HhCdCIsChHuCUHl1PPlOXGAOe3ar1Mxhg=;
	h=From:To:Cc:Subject:Date;
	b=WCF3uWTdPTErAMvPec+GadcsKld2nXpRLGOgtAzt+C11Laq03bcQTnrviRyiB3X6P
	 MEiLnkexQyV5N1pm1PlbYuNc+nICvowUhMXbs0ihIhj9s848Yc4Cn9AymFkVQdnD8F
	 ysYaFEJjJKc3cVVrLJjcDBCF0yMeC8+pJdn0fIc1U/bg/0ydgavTn5MqoO1NpwE15i
	 Fdi0UNR3JZmGWTKXPBLxAoMzHQQmZy0nt0uQSNf17nNpAdJBRD3LNylu8kvz30ci53
	 ISrgv0gsB3/xrxFbkXcnCxl/PkpQoQBFTPwsvK9/jfsQEWPc5Ap8Ye8fegMYGNlB/5
	 3yaJaDyGTgZnw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v4 0/2] net/rds: restrict the rdma_cm ids to IB devices
Date: Sat, 26 Sep 2026 23:30:56 -0700
Message-Id: <20260927063058.170273-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v4 of the rdma_cm id restriction (v1 at [1], v2 at [2], v3 at
[3]).  Patch 1 is the restriction itself; patch 2 is a small follow-on
the v3 review turned up in the function patch 1 touches.

  Patch 1 restricts the listener, the per-connection id and the probe
  id to RDMA_NODE_IB_CA with rdma_restrict_node_type(), so the rdma_cm
  never installs the RDS listener on, or binds an RDS id to, a device
  RDS has no transport for.

  Patch 2 has rds_rdma_listen_init_common() print the port it actually
  bound: the IPv6 listener sits on RDS_CM_PORT, not RDS_PORT.

Changes since v3 [3]:
 - Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport") added,
   with a note that stable trees without rdma_restrict_node_type() need
   the separate handler fix rather than a backport of this one, and
   that the two patches are independent.
 - New patch 2 for the listener debug line.
 - Rebased onto current net-next.
 - The v3 notes linked the wrong message id for v2; corrected below.

Changes since v2 [2]:
 - The changelog no longer claims a handler-side rejection exists in
   this tree; it names the separate net fix for the handler and the
   a760e80e90f5 prerequisite.  The node_type half of the
   rds_ib_laddr_check_cm() test, dead once the id is restricted, is
   removed rather than described.

[1] https://lore.kernel.org/netdev/20260917074108.174262-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260919061042.250462-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20260922084837.390414-1-achender@kernel.org/

Thank you,
Allison


Allison Henderson (2):
  net/rds: restrict the rdma_cm ids to IB devices
  net/rds: log the port a listener actually bound

 net/rds/ib.c             | 14 ++++++--------
 net/rds/ib_cm.c          | 12 ++++++++++++
 net/rds/rdma_transport.c | 13 ++++++++++++-
 3 files changed, 30 insertions(+), 9 deletions(-)

-- 
2.25.1

