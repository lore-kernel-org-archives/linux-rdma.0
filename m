Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C556C1F2B88;
	Thu,  6 Aug 2026 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786000847; cv=none; b=ucEROFFjNBX3xVEQVIJFQFD10WEYw/L82npCLIXR/SKuZUBH+GGWQ691mPgLK4cJZsV+bD8s9ZpZvqeDdNuyumsBKNvhhosxh4LFeKPQIlNsbt4aaUgdLsIP3CkLEN0dS+Ywe6c82lxK0gzHtwBfOWRU9gKO0ZW+erLxL5wVhgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786000847; c=relaxed/simple;
	bh=C765vW/NymtNTCg1/ZiXQVE7LNPtnsLLio+eH2vGyE4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sewhOKmkcDdhfFHOTUQ1WWPbbre7bO70tdyybqPf8gPsTxk5nRxx0KZT04FmogGu6/mcQV0icOAfCh5FI1KVW9odK+/9PCyOcJO5mn6WCRX/CbamYuR7rzZ+tSTqAcugv5nUsC+dMdTfbrgiPZbFn4kR3yVi7FNgCJoYq0yh468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhFnlXRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhFnlXRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23D51F000E9;
	Thu,  6 Aug 2026 07:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000846;
	bh=iHIqpI9jTYrzQGObPhJiEG+Jyvj+Wd21PXh4r6QgcxY=;
	h=From:To:Cc:Subject:Date;
	b=WhFnlXRXvq2FkG8MO4VNvMUhRAngBBgRYeS6nswXZ4a5FxQURKZ6op7mTEggBsA2n
	 WY+6nX1hYhpg3ZHJggla7O3ng3JJRgn4W45JXDfn9smqzIqO5kMDp9+sfaAKs9L/ad
	 mOIaiIjVSlVbJa3Ah+sh9n/hGCNRl6Dp+5ufOAg3WFdJDVnkpbAjaQqsStYg2M58bT
	 VmW3zbLGQJlZK4h4XYEGucBUC5fzv+Z1PPP5QTRMUWOgrrImDG1GdMqdxg2DPMpzka
	 LC7ZtkzJZaTmLkv8NmEmA/caiFgrobzygcu/glXYA/bMkga4ty2HxK2PAAclGaVRCB
	 iKZhBoYYFHpAw==
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
Subject: [PATCH net-next 0/4] net/rds: Bug fix ports, part 2
Date: Thu,  6 Aug 2026 00:20:41 -0700
Message-Id: <20260806072045.1092968-1-achender@kernel.org>
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

This is the next batch of net/rds fixes ported from the Oracle UEK
kernel, following up on the first set now in net-next [1].  As
discussed on the previous series, these target net-next since the
bugs are pretty old and could probably use the longer cycle.

Patches 3 and 4 close a teardown race that UEK fixed after a long
tail of failover crashes: quiescing the transmit path by *sampling*
the RDS_IN_XMIT/RDS_RECV_REFILL bits clear instead of acquiring them
is a store-buffering pattern.  So on weakly ordered arches,
rds_send_xmit() can run concurrently with connection teardown
resetting the transmit state under it. Patch 3 makes
rds_conn_shutdown() take the bit locks.  Patch 4 does the same for
the only other rds_send_path_reset() call site in
rds_tcp_reset_callbacks().

Patches 1 and 2 are small initialization hardening ports from the
same UEK series. re-initialize rds_send_xmit()'s to_be_dropped
list on its restart path, and initialize i_conn_path in
rds_inc_init() so both inc init helpers leave an equivalent,
fully-initialized structure.  Neither has a known user-visible bug
upstream.

[PATCH net 1/4] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
  Port commit 7f52b9968d79 ("net/rds: rds_send_xmit should INIT_LIST_HEAD (&to_be_dropped) on restart")
  https://github.com/oracle/linux-uek/commit/7f52b9968d79 

[PATCH net 2/4] net/rds: initialize i_conn_path in rds_inc_init()
  Port commit 0ec6a520da4f ("rds: rds_inc_init() should initialize the inc->i_conn_path field")
  https://github.com/oracle/linux-uek/commit/0ec6a520da4f
 
[PATCH net 3/4] net/rds: acquire the fastpath locks in rds_conn_shutdown()
  Port commit 2b8aaa4f163b ("rds: Make sure transmit path and connection tear-down does not run concurrently")
  https://github.com/oracle/linux-uek/commit/2b8aaa4f163b 

[PATCH net 4/4] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
  Extend the last port to cover extra call sites in rds_tcp_reset_callbacks()

Questions and comments appreciated!

Thanks,
Allison

[1] https://lore.kernel.org/netdev/20260730041629.3512480-1-achender@kernel.org/

Allison Henderson (1):
  net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Håkon Bugge (1):
  net/rds: acquire the fastpath locks in rds_conn_shutdown()

Sharath Srinivasan (1):
  net/rds: reinitialize to_be_dropped on rds_send_xmit() restart

William Kucharski (1):
  net/rds: initialize i_conn_path in rds_inc_init()

 net/rds/connection.c | 22 ++++++++++++++++++++--
 net/rds/recv.c       |  1 +
 net/rds/send.c       |  6 ++++++
 net/rds/tcp.c        | 15 ++++++++++++++-
 4 files changed, 41 insertions(+), 3 deletions(-)


base-commit: b0057c68df711bf6a62033c072ac61c4f9d3cbc1
-- 
2.25.1

