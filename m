Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089304FC8FF;
	Mon, 31 Aug 2026 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183695; cv=none; b=rqvWlnpFjykNcgDeynR3XlfKdeCrLaMYcgE8q/7+AA3iS7z6GtljZxhhv+DQf3KQ9Vr9RvXAbM7DqhPjr4YB9wj3lcaax579zi1UHHOoZDDnP5pG0gKajLPIKRa8pUYPR24sPrxJ7f8bhj5nPPyAKtLjRN5VEvXDH/Eg+7EaLt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183695; c=relaxed/simple;
	bh=+YAD5OjFnFye6nrKqNVp283zzmWnDPvXMARL+9eF1zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLwbcoudDoR/5cbgakIfQH2+FCds7PvPvIc2y9sGsRy73hrEAfanGNcCsluiEIu6X9PxgTiXf22zHGj0DRy71ya0dkCEGk30FOpJz8uMHoxN4DYNBP8qpg96ra6RwwL4KOJ+Atm1mJIRC+6bGpojtlnAGWQTtjR1oi08zkJxBtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNzcebOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNzcebOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADCD1F00A3E;
	Mon, 31 Aug 2026 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183692;
	bh=LhuCyi588EnORNxJAkDbj0Bd3XdNav3hGk3E+pQ3P34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNzcebOZXuR/eK8/3RwSmC++dnlCgfnN02PNBqwHKE8TJbmueq7gfkjY8FVkJxwZd
	 qgUFtyDsZ1DjwEpel9kD4rUy2LTMe1wR6Ixb6eu4lw6LDctMIxo4NxV+XGdv5AfPLr
	 LR/us6PSQy0ASQT6oiH0N18oLb3gLNRF8NRz0ZHA965hqj9gWBL/6Ia6xfDDAT/evy
	 YKaufuLeHyhHoBCxlOPnAGE05y/UWKQRW6H+N2DWQysCLJw72Tfdy1wzyx/wdLhO/Y
	 HQXIwNW2kk0aT6q6JoKVa9FyReX1BABnHEHBeGxCrsxuWcLuFOYsqfJc3YaJRRamET
	 d3jb4xKnbXboQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rds: annotate data-race around rs_seen_congestion
Date: Mon, 31 Aug 2026 09:24:36 -0400
Message-ID: <20260831133314.4125787-248-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 67636cab273ed0c0b0f2adab6c9369a471cb7966 ]

rs_seen_congestion is read in rds_poll() and written in rds_sendmsg()
and rds_poll() without any lock.  Use READ_ONCE()/WRITE_ONCE() to
annotate these lockless accesses and silence KCSAN.

Reported-by: syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a0f8d94.050a0220.6b33c.0000.GAE@google.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Allison Henderson <achender@kernel.org> 
Tested-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260522011621.304470-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The backport check finished: prepared stable commit `95ef1f3da4846`
(upstream `67636cab273ed`) exists on the `autosel` branch but is not in
current HEAD (`v6.18.44`), where the unannotated `rs_seen_congestion`
accesses are still present. That supports the **YES** backport
recommendation.

 net/rds/af_rds.c | 4 ++--
 net/rds/send.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index cc3a898bf5d51..a9445937d225b 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -217,7 +217,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	poll_wait(file, sk_sleep(sk), wait);
 
-	if (rs->rs_seen_congestion)
+	if (READ_ONCE(rs->rs_seen_congestion))
 		poll_wait(file, &rds_poll_waitq, wait);
 
 	read_lock_irqsave(&rs->rs_recv_lock, flags);
@@ -245,7 +245,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	/* clear state any time we wake a seen-congested socket */
 	if (mask)
-		rs->rs_seen_congestion = 0;
+		WRITE_ONCE(rs->rs_seen_congestion, 0);
 
 	return mask;
 }
diff --git a/net/rds/send.c b/net/rds/send.c
index 071c5dca969a2..d474c9cda65ae 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1339,7 +1339,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 	ret = rds_cong_wait(conn->c_fcong, dport, nonblock, rs);
 	if (ret) {
-		rs->rs_seen_congestion = 1;
+		WRITE_ONCE(rs->rs_seen_congestion, 1);
 		goto out;
 	}
 	while (!rds_send_queue_rm(rs, conn, cpath, rm, rs->rs_bound_port,
-- 
2.53.0

