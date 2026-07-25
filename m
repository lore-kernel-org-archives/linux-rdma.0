Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB993361948;
	Sat, 25 Jul 2026 08:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784968183; cv=none; b=UFwyccG8gxFm1wIY3D0ETKqqS/W1Z0+Hvrm+V13WDHhnYZOOPC5HhwbldQYLeRkfA6DN94a9CgT92F3AWPxZNiHCeBK3skxi43JUV0+NCjpel7rpJfPHDltCB0uaPVa0LcsQTlfP3dfSOMm4GIF2P/vKRDyudr5di/g8OAXkqP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784968183; c=relaxed/simple;
	bh=xxqBiFBqnnI1UH07F7DoP2SMIiWtNyoURiiP6jv98H8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=eQAG2d56P8znUie980tKG8fqLbpeNz/kTmrVLL0/IuXURDSbJ8MGD+R6F2N/32RrxZZnfZ+Jy0rjePsH+baxSwasHb91WdZSH/H/sFWUA0BAb+eZC9mvXElo/IL7C/t2azCzUCcprootBKkRHhMEg/Ien+obBquqXyMDawhoJGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWjPVY6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWjPVY6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66411F000E9;
	Sat, 25 Jul 2026 08:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784968180;
	bh=KJmSCq4PTxZvleO7ym8qt3RHmYnDg09VX0sEVpyMIvg=;
	h=From:To:Cc:Subject:Date;
	b=iWjPVY6g6vwfQzXHKC2WsXFQ6TdZ99kUiue8SiSKxoxo5fT5EtO3SUPMGK3DGfemv
	 tnxHei11voIYJCvuVxyBSu/HdkOXbcWCBkhB4GT0/OCemMwU1rOezn7PVZwnDiVsoE
	 pXgvKy4rXT9t9wGhOu0Bu4E/JH1RA7cZyB+lIjoitPjBtRJ7xpL/lXOmkIlTGZ/O9R
	 WG5E2HE8SKQohGEY7hwfwiloGY5JmdU9UQfZsDLvOjMJSn+P1BnxLh572SvYzy7gCf
	 GqXB71bZhmIODZdE8mJ3iabvbG53223zPezy1hkaww/MXHeZBYFLTtOgGcIUJl+tyO
	 S8VgR2Cnx6FZQ==
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
Subject: [PATCH net-next 0/3] net/rds: Bug fix ports
Date: Sat, 25 Jul 2026 01:29:36 -0700
Message-Id: <20260725082939.2546624-1-achender@kernel.org>
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

Changes since v1:
  - Patch 1/3: re-written to delay ditying through queued work items
  - Patch 3/3: fixed check patch nits

Allison Henderson (1):
  net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Håkon Bugge (1):
  net/rds: hold the socket while an rds_mr references it

Sharath Srinivasan (1):
  net/rds: fix rds_message leak in the rds_send_xmit() drop path

 net/rds/ib.c      |  7 +++++++
 net/rds/message.c | 34 ++++++++++++++++++++++++++++++++++
 net/rds/rdma.c    | 18 ++++++++++++++++--
 net/rds/rds.h     |  6 ++++++
 net/rds/send.c    | 18 +++++++++++++++---
 5 files changed, 78 insertions(+), 5 deletions(-)

-- 
2.25.1

