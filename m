Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38F4360EFF;
	Mon, 14 Sep 2026 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357047; cv=none; b=qLI7IRNasP5+ihXkVWR1tPjaeuPkXPU25pQnEAyyjFGSa+x2rz03JoBHaUS0sGsuOMWvNLhJ/Hnt0NW5jrSb9pum4UKMndy2lYsMtIemSPlLTqJPrhNh6aCvzHfXeIIzibEEEWol+dztZ8fDVraeGL1mr1YLecMPdap0qdAeGCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357047; c=relaxed/simple;
	bh=Ebs4txm/BLTES9byGTjP54XDJaQeK+ncStDbQThooBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HLvuTWltNAEP92ZaBy2X0frp1PT4Hl1eHhuhpIgajaV7hrJJLuFA+x0aXdoAc6X/6V5EZW9ARjezbJWlAzhemIkLX3M7Jz5DuCVO2dxtp2Rt2rJice9f9rM5JlcK8RSt00Zs08ZQHMFp5N4pTxM+jH6uOoyz7Bgp/1cngGmHAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ociSh1vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ociSh1vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543E91F0089A;
	Mon, 14 Sep 2026 03:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357045;
	bh=VIPWv6EdOOpAeS6rFYbz6gn/Mi/IWWvj1hfabzKp83M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ociSh1vy+DOBHogTlkzuFDFkpasRoQcb0zJZNid0MEFtKA4V6Ird/a84kfm+FIMFH
	 dZcLGatdoxIEjRlGFn5XmnNwj+HjX1kzFud587xZcZ5Z1bA2BWSTNGrZ5Bmudm+CgC
	 nRW+/0PuzTyzpzFZmnHPiPgSW/Ltid0197vZbLWL1AA3OayA0PqVVUeLsCS5lq1D8g
	 qD/ZPOLQKdnIIPUDG6tr16yaQTD3PZAzYlqUYMPykqzkkqGOj5WcbXWcsphMJq22Lz
	 m3XZiIuKpQ+miKX2UL+WvGacfSuMeXZtVcZbMTsllG+qzJmg6U/KQOdRpF66EuAWOk
	 6eiMDnyS4/Fqg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 10/13] net/rds: tcp: don't attach an accepted socket to a connection being destroyed
Date: Sun, 13 Sep 2026 20:37:16 -0700
Message-Id: <20260914033719.138057-11-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260914033719.138057-1-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_tcp_accept_one() looks the connection up, claims a path with a
DOWN -> CONNECTING transition and installs the accepted socket on it.
A connection whose destroy has begun is quiesced - its paths are DOWN
and its old sockets released - but stays allocated while a reference
holder is still around, and rds_conn_create() hands out exactly such
a connection with a reference of its own.  The path claim then
succeeds, the socket is installed, the accept drops its reference,
and when the last holder goes away the path is freed with the
socket's sk_user_data still pointing at it: the next byte from the
peer runs the socket callbacks against freed memory, and nothing ever
releases the socket.

Refuse the accept for a connection whose destroy has begun, the same
way an unexpected path state is refused: drop the path claim and
reset the new socket.  The peer reconnects with backoff and, by then,
either finds a fresh connection or nothing listening.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/tcp_listen.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index dcac10a91a67..e22ea9ca8c1c 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -278,7 +278,15 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	cp = rs_tcp->t_cpath;
 	conn_state = rds_conn_path_state(cp);
 	WARN_ON(conn_state == RDS_CONN_UP);
-	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
+	/* A connection whose destroy has begun has been quiesced and is
+	 * only waiting for its last reference: its paths sit in
+	 * RDS_CONN_DOWN, which rds_tcp_accept_one_path() happily claims.
+	 * Installing a socket on it would leave sk_user_data pointing
+	 * at a path that is about to be freed.
+	 */
+	if (rds_destroy_pending(conn) ||
+	    (conn_state != RDS_CONN_CONNECTING &&
+	     conn_state != RDS_CONN_ERROR)) {
 		rds_conn_path_drop(cp, 0);
 		goto rst_nsk;
 	}
-- 
2.25.1

