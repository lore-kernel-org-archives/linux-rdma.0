Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4987833FE0A;
	Sun, 16 Aug 2026 00:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786839319; cv=none; b=qNpaC+yCQAV6T5aR9yRMgEHdB8TqKEufNO3dVGCckVlWJoR2khBF1CJLb2L+lQfm4L+t+yHqElDBvyyqup9+BKKlyo05WS5iLepxw9kpfucpiHjawKQHnZlbTeKxpJQQfFR2KQVrOtHB7/JzuLWroW/yE2yONz8XcoIV6NEanJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786839319; c=relaxed/simple;
	bh=X+3uryDn705HUR78QyM3WoV8vqfnjx5OvVK4EY+2EN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hcdg0xYtcSeyDoAgZGLp6QL07+s2kmzJMg62YYr1fRFTYsigOPHSkKB01Ela+JCkrTikdisyqaY2pdZevUnYeo7XPLN9z49tcnVdkYAoC8EK2YEa7i88uFccWeQOGQa2dBxGhrpyE2unYmfZ790x3XBc6kyoa9wgXqAEw+e7L3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAOwpnh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAOwpnh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531E1F00A3D;
	Sun, 16 Aug 2026 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786839312;
	bh=J3j+jf4iqsjyaoyj59ET2A4xK1texrEomuRZ8ikDMDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAOwpnh5cSaW32bJ8ExHkopjvRs+dgvL+LCDZgfCN+MoEFKanuZCvreh3Kz0xCqkp
	 pg5dk5Mj4ITZlzK1pe0N06XMucrC/S9OO4CEH0c68HQNQV6zkgh8eGQFJkGCyidozx
	 JtJycEe7hbfARkxLZNrcVn99AKLo1hnB5ZPvDCYIk2u6A5EDHtxIZ8i2AJRa8Cb4YQ
	 fpip2RuCxIIVf7HeTxmWB1SHEq8NOX59MUKN9E3WnYoVy2d11WuCs2WNaPf0uAd65K
	 +9vjnCutUtJJal/xxgijuWpoIifHIJS/XYDkeVOabTfDQwQUqZmTKwBMtc9gaV1Mi7
	 Ta6tWWvw16IPg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net-next v2 2/5] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
Date: Sat, 15 Aug 2026 17:15:07 -0700
Message-Id: <20260816001510.73645-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260816001510.73645-1-achender@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
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

Fixes: 00e0f34c6166 ("RDS: Connection handling")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v2: add Fixes tag.
v1: https://lore.kernel.org/netdev/20260814013501.43760-3-achender@kernel.org/
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

