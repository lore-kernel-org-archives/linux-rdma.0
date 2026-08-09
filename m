Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734054763;
	Sun,  9 Aug 2026 00:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786236666; cv=none; b=TG2iGx1STGkLc+77mStzfhq+L+twH4eTd544nsyRZNydLTXA9wiGLwpfr9MWk+tEjGjNQPo0cxYDzVOMrLauiw4DON4BWTKykveI7GhmIukUhZ2P87CdbQSsQ1BjzoZWT9P8fFjZErjTxlTUnvxbSvVpH5DGtjt+l4/Ga+wvEI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786236666; c=relaxed/simple;
	bh=RK5tWlHtIoBtv98YlitTUVqKbpGqVsOzfvW0IDt2kSk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t/6uMCgltL8tOO2xUbGKqs1zS45Z1hYGj0i7fxiO+tnDUDWGTyUC4NFR1WQ3aa5Xb3xIsqsTNieM/d4aAZ3I7aVVOme+w6QCzqSLRdBNaVMcbx5Bhh3bG9zfq8ubXXHVfz6PIjSlJU9jEY2JstJwVyTUE6uKzCLVb4e4IA2z5LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNA8X265; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNA8X265"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846631F000E9;
	Sun,  9 Aug 2026 00:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786236665;
	bh=rkLDAIhcc+FB11Ne0HP3tt+wOegsu+7jLhBqD0QeDQY=;
	h=From:To:Cc:Subject:Date;
	b=lNA8X265RsxFo7LRTunGFjm6wEr+/AyKjKvLE6Niwf4pbP5YT/qQDkNJZwpQw14fw
	 xwlWf9Z9ME9kNZdAs2dHrSscVg7aZSygfwyV5e8Y5OiIPhHzxXtaZzvOhxxv1p1yCb
	 GmHQXhDVEGpq2RNCw7RhbTRQRHFsNM5YYrq7lJUrFovsaZlmRCyesXTYh0Z7+57gL8
	 T7V/hqw7d+wn7FqM3bpnof7DXmH7ss0CWefJjzQ8yjrs8v0C0F3zvD8KZPhRWfeCLL
	 scFUmEyBEqqX+fmkwgQdGiHp/7PKBoFEzBm/LxgPmNhKUe6JtQzfJtXT1w3KwSbt3f
	 +MJe+8LnwjdPA==
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
Subject: [PATCH net-next v2 0/2] net/rds: Bug fix ports, part 2
Date: Sat,  8 Aug 2026 17:51:01 -0700
Message-Id: <20260809005103.82371-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is the next batch of net/rds fixes ported from the Oracle UEK
kernel, following up on the first set now in net-next [1].  

This is v2 of patches 1 and 2 of "net/rds: Bug fix ports, part 2"
[2], which contained two initialization-hardening ports.  While
re-reviewing v1's patches 3 and 4 (the fastpath-lock teardown changes)
I found their locking needs more rework than a respin should carry, so
they are split out and will return as their own series together with
two companion fixes.  The two patches here are independent of them.

[PATCH net 1/2] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
  Port commit 7f52b9968d79 ("net/rds: rds_send_xmit should INIT_LIST_HEAD (&to_be_dropped) on restart")
  https://github.com/oracle/linux-uek/commit/7f52b9968d79 

[PATCH net 2/2] net/rds: initialize i_conn_path in rds_inc_init()
  Port commit 0ec6a520da4f ("rds: rds_inc_init() should initialize the inc->i_conn_path field")
  https://github.com/oracle/linux-uek/commit/0ec6a520da4f

Questions and comments appreciated!

Thanks,
Allison

v2:
  - Patch 1: the comment now names rds_send_remove_from_sock()
    instead of vaguely blaming "the callees", and the restart-time
    invariant is enforced with a WARN_ON_ONCE(): entries still on
    the list there would keep their message reference and their
    RDS_MSG_ON_SOCK accounting, so a silent re-init would orphan
    them.
  - Patch 2: for loopback the field held a live value written by
    rds_send_queue_rm(), not garbage; rds_loop_xmit() now uses
    rds_inc_path_init() so the re-initialization keeps it valid, and
    the commit message describes the two transports accurately.

[1] https://lore.kernel.org/netdev/20260730041629.3512480-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kernel.org/

Sharath Srinivasan (1):
  net/rds: reinitialize to_be_dropped on rds_send_xmit() restart

William Kucharski (1):
  net/rds: initialize i_conn_path in rds_inc_init()

 net/rds/loop.c | 6 +++++-
 net/rds/recv.c | 1 +
 net/rds/send.c | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)


base-commit: 4fa4977a0d900f936bcae5cd2c510be5554e8dd6
-- 
2.25.1

