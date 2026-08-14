Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61753B5305;
	Fri, 14 Aug 2026 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671311; cv=none; b=sZBTztxF8Zfy1Fh7TlU0CdP1pmtXpIPLmV50aQg/GTeCWaP7Ca6jT38VbL+PgAN/oxFhxckQuHbes+rWkFKROqi7WgLBHzP2PoyHDom4CV90L3eowohVLyBEOcnKur36N4ZCX0Hke76WhbXTL9LN+Mz4Z70U81CVGOzhTXKL4G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671311; c=relaxed/simple;
	bh=+HCHsuxbPxDYqC/P5aZQNZzfLpoobclKnJXcrDcHURg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gJOmUo1nwIfrJaRrNMVCc5LrCBVuxAH2VEFNv55hBomQffuX8tE9FcVsvztuRFp0xTejGER9oc7dYGCn8LqEB2MUa8l3k/aqJ4kZjPX6ramJIjRgyo3d/uDv8vxgvGKaWx26ZQGGIFdIP1/wZcgd1Dw7tthRYq4bfkBcCOtkVIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrEXLDgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrEXLDgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D851F00A3E;
	Fri, 14 Aug 2026 01:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671304;
	bh=wQqa4vIretSKrUJakJEBG2lCRw5kURDYG1TqrNrFFiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrEXLDgn6nMTcSQHJmT+U+oYQM8WARqIH8mjyHQd+6TViUvUqPA6SNzBUX0DWoKck
	 Ajo+xud6IoAmpIZtPYR0e80cxUeHZ22cg2oXTCvdXdzGsUw50HZQ+6lo9Y9BFIRGCK
	 8r3SrLynf30c/LHfow7Wxr3Wxc08rtZNLWJWz0tqQtFQG/fb9HW21oMCjf2MsNLWPo
	 wD4jHxKff4kSrDcbMBu5U3lVCER+MQV6nFajpVBoxeB4cnugqvOUwwKotfAlg7naS0
	 ibhNnCzw0lM7ra1tGplasLSNEkk5yS6a1qZorOqJ9dhbGDZpws2yGHjoSqlPChGq45
	 IwUJ2G2oDJmEQ==
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
Subject: [PATCH net-next 2/4] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
Date: Thu, 13 Aug 2026 18:34:59 -0700
Message-Id: <20260814013501.43760-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814013501.43760-1-achender@kernel.org>
References: <20260814013501.43760-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_conn_path_reset() wipes the whole flag word with a plain
cp->cp_flags = 0 store.  Every other accessor of that word uses
atomic bitops, and some of them can run concurrently with the reset:
RDS_LL_SEND_FULL is set from rds_send_xmit() and cleared from the
transport completion paths, neither of which holds anything that
excludes the shutdown worker.  A plain store racing an atomic
read-modify-write on the same word is a data race, and whichever
side loses has its update silently discarded.

Clear the two bits the reset is actually responsible for instead.
RDS_IN_XMIT and RDS_RECV_REFILL need no store at all here: the
caller, rds_conn_shutdown(), waits for both to be clear before
calling the transport shutdown and this reset.

This also gives every bit in cp_flags a single well-defined writer
discipline, which the following patches rely on when they turn
RDS_IN_XMIT and RDS_RECV_REFILL into bit locks held across the
teardown: a blanket store mid-teardown would destroy lock ownership
that an atomic clear preserves.

Oracle UEK carries the same conversion ("net/rds: Preserve essential
connection state flags"), motivated by its asynchronous shutdown
state machine, whose progress and destroy flags must survive the
reset.  UEK's variant also clears RDS_IN_XMIT and RDS_RECV_REFILL
because there the reset runs as the final step of a teardown that
owns both bits, making those clears its unlock; upstream the unlock
stays in rds_conn_shutdown(), which needs release semantics and a
wake-up that a plain clear inside the reset would not provide.

Based on Oracle UEK commit "net/rds: Preserve essential connection
state flags" by Gerd Rausch.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7c8ab8e973e1..ddd7e2291eea 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -120,7 +120,15 @@ static void rds_conn_path_reset(struct rds_conn_path *cp)
 
 	rds_stats_inc(s_conn_reset);
 	rds_send_path_reset(cp);
-	cp->cp_flags = 0;
+
+	/* Clear the bits the reset is responsible for individually: a
+	 * blanket cp_flags = 0 is a plain store that can clobber a
+	 * concurrent atomic read-modify-write on the same word.
+	 * RDS_IN_XMIT and RDS_RECV_REFILL are already clear here - the
+	 * caller waited for both before tearing the transport down.
+	 */
+	clear_bit(RDS_LL_SEND_FULL, &cp->cp_flags);
+	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 
 	/* Do not clear next_rx_seq here, else we cannot distinguish
 	 * retransmitted packets from new packets, and will hand all
-- 
2.25.1

