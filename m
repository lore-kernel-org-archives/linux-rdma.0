Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9CC34DCE3;
	Sat, 22 Aug 2026 05:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787376303; cv=none; b=EA/eJjhJcJ+ruwPMOUW0sXZYr/mai2IMO4GtY4eFvo8zEKhIosy+Ql0x4iTvhiVn5L2++eT5W/gS896pGwnLAdqYCY8h+Ck+do4kL5DtWq68MTJxdxGSW03KHPXA2yJhA/34rGEOIKwW4pggss2nmP85wclD/GGBgGSViKh+AOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787376303; c=relaxed/simple;
	bh=mIUig1Dg7Gl2ox092NhbKW4OTzxwCC7uosB53XBiG5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iw+Z2g8fKfQRq8mR4PsEKtVIphEmVABxyQVqKBa1pWTpezWV7Ryn6NTlsgUtPhg0ezGjqOj4WIe0whwIth8WVfL6CXg4UZBZUglVsBJg2uhgVjIMxx72YcMIW+oI7Z9cY1ZIkFcDrbzkAuh/in3sNvmgTBjduXToggHhH2UGdvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljTGWJqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljTGWJqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8650C1F00A3E;
	Sat, 22 Aug 2026 05:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787376302;
	bh=LGqebxKXVIP8L9ldF/9BFTI+d9H/Ad9vXxGcDElWeKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljTGWJqRBRK7ZGkyMbC2xPu8x6txWZTStKCkD1ckPjUm7jmFle9GCSwcTzOfxBCeN
	 sG9fjksM91hO0Uf71xTfEviCY7eCAalTHcTQJjDxR47zilAYwXtd1e1HnZhOBTk+y8
	 D2g6eQ7QSUDvOWKRQ29wK/+mWSYz/q0EVenMy6dGjcmJZTiHT+nibxRcOahwp9V89B
	 SLUZu39q98Zk5SRZWcVdsI80RhQx09mGJLceHApsgmoJM1v18PhAOFoCz9N7xKe+ML
	 EohCg31IhnijMtr8yXC8uTUFZz8qcAkybtE2qLmkrhlYzgZlKurtDMLT4gBgcsN09W
	 g6XN61pliOGbg==
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
Subject: [PATCH net v3 2/5] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
Date: Fri, 21 Aug 2026 22:24:56 -0700
Message-Id: <20260822052459.88017-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260822052459.88017-1-achender@kernel.org>
References: <20260822052459.88017-1-achender@kernel.org>
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
RDS_IN_XMIT and RDS_RECV_REFILL need no store at all here: they
belong to the caller, rds_conn_shutdown(), which waits for both to be
clear before calling the transport shutdown and this reset.

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
owns both bits, making those clears its unlock.  Upstream that
release belongs in rds_conn_shutdown(): once a later patch in this
series turns the two bits into locks held across the teardown, ending
ownership needs release semantics and a wake-up that a plain clear
inside the reset would not provide.

Based on Oracle UEK commit "net/rds: Preserve essential connection
state flags" by Gerd Rausch.

Fixes: 00e0f34c6166 ("RDS: Connection handling")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v3: reword the comment and changelog so they no longer claim a
    quiescence guarantee that only patch 5 delivers; the bits are
    described as belonging to rds_conn_shutdown() and left alone here
v2: add Fixes tag
 net/rds/connection.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7c8ab8e973e1..46ac72088f84 100644
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
+	 * RDS_IN_XMIT and RDS_RECV_REFILL belong to the caller,
+	 * rds_conn_shutdown(), and are left alone here.
+	 */
+	clear_bit(RDS_LL_SEND_FULL, &cp->cp_flags);
+	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 
 	/* Do not clear next_rx_seq here, else we cannot distinguish
 	 * retransmitted packets from new packets, and will hand all
-- 
2.25.1

