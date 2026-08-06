Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6412838BF9C;
	Thu,  6 Aug 2026 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786000848; cv=none; b=bqXj9+0ZighLEp95zQZ70WI6H49fEsLVjNpxByKNYso7jfauPMJUt6Zffh77/R9XPmq7TOmgi1PC9Y4KJBgk13HHLR7XVLbAd99LKNuW2vgfOBYJ41s67WuhL7pNbDdeLEyFmJXP3nqUCgVISiH+JikTV2HUKnDkVyRduKfFjEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786000848; c=relaxed/simple;
	bh=D9kYkpuz9FQqbftpeScA2Y16jY65ddz23OE9KLlf4sU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K84Srr2oZDZasD4fL00IYZmuFjgL5thXtc51o5DeBZz+KSBrc85eHB/2sUE49dyhkVtr8YZr8WQbD0V1LsykUyvYxnQE7Bh6M1rnre1/aL+cPEp14bZ5TMCtJBtlRyGppEEUulTaW6QaWK5cuJVNNlNzNklhlSQz6d5A3yX9ApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pu83bTru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pu83bTru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D801F00A3E;
	Thu,  6 Aug 2026 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000847;
	bh=KnqA/+TYrcQqJRt48pgloBtLNC6nI5M3hNRKvct21f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pu83bTrup5O213Syj2A+cAVU5C1+KQaJCY3FtG7sKRy6Fx2VBpA/uoxf/dFS21krX
	 SgaQl1eaCCNJqtCpwfS0mgfcW2LeUewG26rcj+Tdz0KrMZyX3DN3RsYP/RCE/3q42j
	 QNDvqMswWFuRD2ZkMWKudSUADD3p+W1XC0NzcL/sp4gDE4nltYvuJIiliVad7z/yL2
	 kKxSf3GUxeSGYTvUdR/Z1j1IITg2hYLxCSke63i5UHUO5+sHS6Og3r9mNDGBzzmWHc
	 cNnUqiZhQ7pfZYE+xjTkzR69fbg1q3ggLkU9G25RhdVvtV/r8pGIDSwis2/9TKMHPF
	 eupZjRh9jUYTQ==
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
Subject: [PATCH net-next 1/4] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
Date: Thu,  6 Aug 2026 00:20:42 -0700
Message-Id: <20260806072045.1092968-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260806072045.1092968-1-achender@kernel.org>
References: <20260806072045.1092968-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

The to_be_dropped list is declared once at the top of rds_send_xmit()
but the function can loop via "goto restart" after each batch.  The
code currently relies on rds_send_remove_from_sock() having emptied
the list entry by entry (via list_del_init()) at the end of the
previous batch; nothing in rds_send_xmit() itself guarantees the list
head is empty when a new batch starts.

Re-initialize the list on every restart so a change in the callee's
behavior cannot turn into list corruption and double-puts.  This is
hardening: no user-visible bug is known in the current code.

This mirrors Oracle UEK commit "net/rds: rds_send_xmit should
INIT_LIST_HEAD(&to_be_dropped) on restart".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: port to net-next (keep the existing LIST_HEAD declaration and
 add only the restart re-init); update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rds/send.c b/net/rds/send.c
index 309021e0cc9bc..c28dc9f820af0 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -200,6 +200,12 @@ int rds_send_xmit(struct rds_conn_path *cp)
 restart:
 	batch_count = 0;
 
+	/* The drop processing after over_batch relies on the callees
+	 * emptying to_be_dropped entry by entry; re-initialize it here
+	 * rather than depending on that implicit behavior.
+	 */
+	INIT_LIST_HEAD(&to_be_dropped);
+
 	/*
 	 * sendmsg calls here after having queued its message on the send
 	 * queue.  We only have one task feeding the connection at a time.  If
-- 
2.25.1

