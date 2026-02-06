Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AF3242925;
	Fri,  6 Feb 2026 02:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770344661; cv=none; b=KkFXUlUMjiDaLf2TIhOuraQFTaCQKgAHQgcrUChRhK6FFbtHThVjpu1Lsgb/wp7BThoUpsRg1Gg1BecWU071AMbHXJIgWUD3ItW4LIfNfvESvWIsdHrIpOR4r8BwsRwAshDW/wErSMoy1Ak2C9HQLuKnMQ1cz3rvJern1DSqOOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770344661; c=relaxed/simple;
	bh=yv159P0RHugAW9YwJn+BxOxvORjNnY0x8sqlJIBp0GE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g4fbHrLOgYNzP6Q540tdcg+xnx6yY9xk2QsZ6s0YorUjB0DlRkt3IedvClMUogvmPIVNkWe+5CKFepB+f/F96mnbvBFZBOosBESTIBfLuaxPEdirntZ6JD3NE3Q4YfpG+qkAewrTIGDg8H06aMIPgEr89B3bkz0cyMk+KAGk8uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCEQHHz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCEQHHz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B289C4CEF7;
	Fri,  6 Feb 2026 02:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770344660;
	bh=yv159P0RHugAW9YwJn+BxOxvORjNnY0x8sqlJIBp0GE=;
	h=From:To:Cc:Subject:Date:From;
	b=cCEQHHz/JFFkjCYVqdHaIatMwawST7suYp0BfyylGceewOeA2I2wM3eZX4iz+Ks08
	 J3cmgrENshNYMqSWDI/QC3Jh/cjrWlG0wBJsJo8cYt+FKApVPQdOxBjwtwqWdZR9zU
	 TV+X/ijNWV8Nz6Gpc8kWSEAnX7LEniEH6LV1G6V65ORMYP8VuCJ84z0qgYNdKXyfHU
	 7Io1cMwEQChDs+5uoOn2m5v95omFJYfQIsIdc2b0iUZ/56OQtl8g1lYoenOrkc4ibn
	 fdQD7Er9nhX9EY8bZQZr7vE/uxkq4xv3ODkCfbl4B3njOqpRDfvzKPDxI6ojZt37Ay
	 LH+Tp66kkQk6A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v1 0/3] net/rds: RDS-TCP reconnect and fanout improvements
Date: Thu,  5 Feb 2026 19:24:16 -0700
Message-ID: <20260206022419.1357513-1-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is subset 4 of the larger RDS-TCP patch series I posted last
Oct.  The greater series aims to correct multiple rds-tcp issues that
can cause dropped or out of sequence messages.  I've broken it down into
smaller sets to make reviews more manageable.

In this set, we address some reconnect issues occurring during connection
teardowns, and also move connection fanout operations to a background
worker.

The entire set can be viewed in the rfc here:
https://lore.kernel.org/netdev/20251022191715.157755-1-achender@kernel.org/

Questions, comments, flames appreciated!

Thanks,
Allison

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Gerd Rausch (1):
  net/rds: Delegate fan-out to a background worker

Greg Jumper (1):
  net/rds: Use proper peer port number even when not connected

 net/rds/send.c        |  6 +++--
 net/rds/tcp.c         |  3 +++
 net/rds/tcp.h         |  7 ++---
 net/rds/tcp_connect.c |  2 ++
 net/rds/tcp_listen.c  | 63 ++++++++++++++++++++++++++++++++-----------
 5 files changed, 58 insertions(+), 23 deletions(-)

-- 
2.43.0

