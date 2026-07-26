Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A12F12A5;
	Sun, 26 Jul 2026 23:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785107091; cv=none; b=mi6UY4pJRNq3WS7x6lPf60Btbv8mrCc+saeR5EEOfGigGTEdkNPgJR2BKNVucXmke0aemPW08+GwX3k9p4oVmmtzZ9490FUEoxDhxPkw0gdH4OFA4oSPARDLnOUMJp3avOih6SRSGvh/USXSbNxXNuP7FwhyqiMayEVACY15E74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785107091; c=relaxed/simple;
	bh=W1pTT3whH94GD5bJKuu5frN6dBnZlHOOIzxbk4nQZ8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=az4lzelciGM1GaNiFG6Q21AB71FOmo86uX8nKdeOdLRkdeUq+GN2F9UtmCaxH+LpWjBCMByRhrrYUam3ocII16KNHX+xrmSZMttz8Xr8dJ0ylEITRVVPkDG34tMQ0zGdgM2kwN4fb/MRCvZvB3uE+gxddgtehN++5+O58HoFR7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTsQOp79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTsQOp79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4F01F000E9;
	Sun, 26 Jul 2026 23:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785107090;
	bh=8AdbpoYf0+cIqdFcsC9foLV8oxaNqC+212rEw43ROjg=;
	h=From:To:Cc:Subject:Date;
	b=XTsQOp79fq3EpYYRs9l2Gv0fTsnm+S4v9dJ8Crkw334UVd7FPi0RcTfa39WGIn8+1
	 z7c7ooFNFG/Q+q9wEh815uibyQ+SrLLIZGy0u3DFOcgC1cb2tE4nFqXWMP3KKkYXQa
	 rtFrXMjZKCGoBbt289SAC7jEJPSQujBeCBIss2eTv/Wg88J5uoYIzHZ5KBVgBY9t9H
	 wxYLZ+PwayNKD49Nv7GX0FgmTYN59XmpD5Cax54OydGUaQx/Wuv9Al0WCaUcSUTHnv
	 UoSUJQG9uoyVtVm67XmV1egDpldkmcTpN34zSJcVLPbPlbbWrcLs18CYnt14W3G5Bk
	 ZTtO84jU4Og3w==
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
Subject: [PATCH net v3 0/3] net/rds: Bug fix ports
Date: Sun, 26 Jul 2026 16:04:46 -0700
Message-Id: <20260726230449.2880446-1-achender@kernel.org>
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

This is a small set of net/rds bug fixes ported from uek to upstream
rds.  I've been working on extending the rds selftest case, but need to
stabilize a few more bugs and the first few fall into net with Fixes
tags. I decided to leverage fable for this set and I thought the ports we
clean and well explained.

[PATCH net 1/3] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
   Avoids potentially sleeping in an atomic context by queueing page dirtying in a work
   item, which is then completed in a process context.

[PATCH net 2/3] net/rds: hold the socket while an rds_mr references it
   Port: commit c4d69e511f3b ("rds: Add proper refcnt when an RDS MR references an RDS Socket")
   https://github.com/oracle/linux-uek/commit/94549e4732d8

[PATCH net-next 3/3] net/rds: fix rds_message leak in the rds_send_xmit() drop path
  Port: commit 94549e4732d8 ("net/rds: fix rds_message memleak in rds_send_xmit")
  https://github.com/oracle/linux-uek/commit/94549e4732d8

These were carved out of a larger porting effort, but I'll follow up with a few more
targeted for net-net after these land in net.

Question and comments appreciated!

Thanks,
Allison

Change log
v2:
  - Patch 1/3: re-written to delay ditying through queued work items
  - Patch 3/3: fixed check patch nits
v3:
  - Patch 3/3: Added extra flush for possible purge work item queued
               after the first flush

Allison Henderson (1):
  net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Håkon Bugge (1):
  net/rds: hold the socket while an rds_mr references it

Sharath Srinivasan (1):
  net/rds: fix rds_message leak in the rds_send_xmit() drop path

 net/rds/ib.c      | 12 ++++++++++++
 net/rds/message.c | 34 ++++++++++++++++++++++++++++++++++
 net/rds/rdma.c    | 18 ++++++++++++++++--
 net/rds/rds.h     |  6 ++++++
 net/rds/send.c    | 18 +++++++++++++++---
 5 files changed, 83 insertions(+), 5 deletions(-)

-- 
2.25.1

