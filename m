Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD55A357D10;
	Thu, 30 Jul 2026 04:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785384992; cv=none; b=a/XSwikmU3I7zDDuyrKfEvXl+J5vtBR+y21E7JgDtAk4LMMtU2rlqDLgiQ9byqZmprWjnk5ZdHyDSsAmQ7BH69DUdyZyM1KWAES0UJKCr4W+WMeVRvSDxeM3hjShlvl3mdakHkXM7nbsDcRHpEHI6kRN+XGpiSIPlAw0Je6Zvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785384992; c=relaxed/simple;
	bh=ai/vqb9Zuqdc/epRqtSd9mn2uLFfQWfWWfRC6ACpPEw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=S2h05EOv1sspz1Vlrcfgqhovr+LzS1YsXG4hISk6EZzj5Qpt1rnC0kbCtIuSSkIWGbJUv7ksmHsA5qmgPiXS/UUlTBGkJOK22Rb9cOO9pye8oBrmVZeTQxVqITxkpiAZ5SxyI0Z4UoiOGPJOsQ++pG6pNb7OjPi9eHTnutmVpxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSaEuePk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSaEuePk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA281F000E9;
	Thu, 30 Jul 2026 04:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785384990;
	bh=QcNWEIPWss26jS8GBtz9OaQr6IWq6VVjmrLE9jNef90=;
	h=From:To:Cc:Subject:Date;
	b=XSaEuePkJhO/kuOQ+4k66R07hkcFE7CJf6Sk040Vn20II605ixoNcRIg76oOijRVG
	 8kEaUuQwlD+5+6iVFWx3U/EfJmDKE26W7hgisJ3IPx/Cfta3+PiqQHBvVlu2G7bOhc
	 mTlwprCOp5O/TqJiFj5WjcUvw6De5uSl/Xph3TianL+0BNQHrEAtjMEcHRNwmSjb7y
	 b9jvR8RPPBzSThwSgSrlVTIVzBxXEUeNbHNisvAqIZO8TxOxaXxELKx4DvxHxfzxbb
	 4hZCBJvKIF7xLZSS7gN8nM3700pxpDtYZK5PEPl/57tX9WGCOehIRtLoZgXlqoXmkQ
	 xF0AL5I3a4Obg==
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
Subject: [PATCH net v4 0/4] net/rds: Bug fix ports
Date: Wed, 29 Jul 2026 21:16:25 -0700
Message-Id: <20260730041629.3512480-1-achender@kernel.org>
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

This is a small set of net/rds bug fixes and ports from uek to upstream
rds.  I've been working on extending the rds selftest case, but need to
stabilize a few more bugs and the first few fall into net with Fixes
tags. I decided to leverage fable for this set and I thought the ports we
clean and well explained.

This series fixes a sleeping-in-softirq bug in the RDS message free
path, a use-after-free of the RDS socket through long-lived MR
references, a message leak in the rds_send_xmit() drop path, and - new
in v4 - a pinned-page leak in the IB transport's MR teardown.

The first three patches are ports of fixes carried in the Oracle UEK
kernel, reworked where the UEK approach no longer applies upstream.

[PATCH net 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
   Originally a port of ueks 4d4a5551a1d2 ("net/rds: Avoid
   unpin_user_pages_dirty_lock() in tasklets"), but reworked to defer
   the user-page unpin to a work item.  The rest of the message purge
   (including the MR and socket reference drops) stay in the caller's
   context.  The deferred work touches only core mm and the rds modules
   own memory, so it cannot race with transport module unload, and the
   flush_workqueue() calls previously added to rds_ib_exit() are gone
   along with the concerns raised against them.

[PATCH net 2/3] net/rds: hold the socket while an rds_mr references it
   Port: commit c4d69e511f3b ("rds: Add proper refcnt when an RDS MR references an RDS Socket")
   https://github.com/oracle/linux-uek/commit/94549e4732d8

[PATCH net-next 3/3] net/rds: fix rds_message leak in the rds_send_xmit() drop path
  Port: commit 94549e4732d8 ("net/rds: fix rds_message memleak in rds_send_xmit")
  https://github.com/oracle/linux-uek/commit/94549e4732d8

[PATCH net v4 4/4] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
  Fix page leak in __rds_ib_teardown_mr() by releasing
  pin_user_pages_fast()-pinned pages with unpin_user_pages_dirty_lock()
  instead of leaving them pinned with put_page()

These were carved out of a larger porting effort, but I'll follow up with a few more
targeted for net-net after these land in net.

Question and comments appreciated!

Thanks,
Allison

Change log
v1: https://lore.kernel.org/all/20260711025118.2449428-1-achender@kernel.org/

v2: https://lore.kernel.org/netdev/20260725082939.2546624-1-achender@kernel.org/
  - Patch 1/3: re-written to delay page ditying via queued work items
  - Patch 3/3: fixed check patch nits

v3: https://lore.kernel.org/netdev/20260726230449.2880446-1-achender@kernel.org/
  - Patch 3/3: Added extra flush for possible purge work item queued
               after the first flush
v4:
  - Patch 1/4: reworked to delay only user-page unpin
  - Patch 2/4: ODP path now takes the socket ref next to kref_init()
    and unwinds its get_mr() error path through __rds_put_mr_final(),
    so both MR allocation sites follow the same ownership rule.
  - Patch 3/4: commit message corrected to name the code paths that
    actually clear RDS_MSG_ON_CONN.
  - Patch 4/4: new

Allison Henderson (2):
  net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
  net/rds: unpin MR pages with unpin_user_pages_dirty_lock()

Håkon Bugge (1):
  net/rds: hold the socket while an rds_mr references it

Sharath Srinivasan (1):
  net/rds: fix rds_message leak in the rds_send_xmit() drop path

 net/rds/ib_rdma.c |  4 +--
 net/rds/message.c | 26 +++++++++++++++++++
 net/rds/rdma.c    | 63 ++++++++++++++++++++++++++++++++++++++---------
 net/rds/rds.h     | 15 ++++++++++-
 net/rds/send.c    | 18 +++++++++++---
 5 files changed, 107 insertions(+), 19 deletions(-)


base-commit: 89d8006259b81dd25c962f6cc8d7ab268d6ea426
-- 
2.25.1

