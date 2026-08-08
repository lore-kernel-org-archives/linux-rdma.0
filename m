Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9179327204;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786173684; cv=none; b=ImehGiZtNHJdK+NHTXHLMrZh64g8cUWzEznyeHjVy1mo7qlYPQwsFIzN2LrIXZ01SxOdNI02yBNsv487qTjTyxnxeRkS3M/N8oZDoqFfmssrVWE8MX6HZBIB3JORNEYSuS+sVeRDNQq8wcvcerXSuwRXCDT2+h9YlUsn1gSb6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786173684; c=relaxed/simple;
	bh=ewJ/3ZqBvUtI9lQiMCnOLEQJGhX2b3bVbgRGRyiS9q4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fp9x1HN4hPQVer0649CCQQ+tRlxJ7kJZAL7RObx+mdU/NB0jQ+Rd0sHcQOkWlrWDymW+2DY8vQVFOA+khDqi8TvOI5OF3BpJvtCgBflnDOGgcuIoaD5ah25Udw2OTN2rz8Uf8tqKFS1S9/W45fTNyS0L1WDNpOjuVTP5dR+OsYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tz6GniAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tz6GniAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 852E4C2BCF4;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786173684;
	bh=ewJ/3ZqBvUtI9lQiMCnOLEQJGhX2b3bVbgRGRyiS9q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tz6GniAJXE/1pjXKj6LznhH0AJ63fM61ZpI22Dijia0HxjQ00jE0B0PZDu+P1dToG
	 RJYW9KXYwftTlkwyLpEM9OmvKPPYD8yuEYm5++SKwV95KqADgxDbiU0ooHllpVhPb2
	 q1G+AonVFNfPuBHabmNoIP+L8aj6hLLFWUNCz93RT7BN5TusAthFu2wHEMrpRqYSsD
	 B9V9YUkq7jsELcvBOO0HX/A4ssMtsF83YQ9tA28NtSvoFLAQPMDCBraN0XH8u0JKgT
	 qQtoBL2D9IaJf7LLCMZ8t/OU+QKwBnBKxYp75DGYfKS1DN3B3nsso8ITVe+G+VfGJI
	 baQHEFSeLSbMg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64417C55174;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 08 Aug 2026 02:21:23 -0500
Subject: [PATCH net v2 1/2] net/smc: unregister the connection before
 draining the rx tasklet
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me>
References: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
In-Reply-To: <20260808-b4-disp-22f119e6-v2-0-61647601a6f3@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
 Eric Dumazet <edumazet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786173683; l=2661;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=Nd2Ah3VugjHz7UvVYOJKMppfI+jftDy275brVglOEvs=;
 b=QE3npRELgIChYQZFpoZO00PLr29iOAKSyZlw+h7E+Fj5mJBV1QLOe0hUI+cqO53eoFlWnCfGi
 FTHK6uamdGSDmWku6KTtiG7GUIRBSm9T4wNh2rCQ/Zqxh2kch/rGrjD
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_conn_free() calls smc_ism_unset_conn() only while the link group is
still on its device list, and never sets conn->killed.
smc_lgr_terminate_sched() unlinks the group immediately and defers killing
its connections to a work item, so a connection freed in that window keeps
its smcd->conn[] slot with both gates in smcd_handle_irq() open, and the
device can re-arm the receive tasklet after tasklet_kill() has returned. On
the DMB-nocopy path the ghost send buffer is freed right after that drain,
so the re-armed tasklet dereferences it.

Unregister unconditionally and drain before the detach at both teardown
sites, mirroring rmb_desc, which smc_buf_unuse() releases after the drain.
Clear conn->sndbuf_desc before freeing it as well, so a reader that samples
the pointer cannot get one that is already freed.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index b4208cb186c5..181647982490 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1209,14 +1209,16 @@ static void smcd_buf_detach(struct smc_connection *conn)
 {
 	struct smcd_dev *smcd = conn->lgr->smcd;
 	u64 peer_token = conn->peer_token;
+	struct smc_buf_desc *buf_desc;
 
 	if (!conn->sndbuf_desc)
 		return;
 
 	smc_ism_detach_dmb(smcd, peer_token);
 
-	kfree(conn->sndbuf_desc);
+	buf_desc = conn->sndbuf_desc;
 	conn->sndbuf_desc = NULL;
+	kfree(buf_desc);
 }
 
 static void smc_buf_unuse(struct smc_connection *conn,
@@ -1268,11 +1270,10 @@ void smc_conn_free(struct smc_connection *conn)
 		goto lgr_put;
 
 	if (lgr->is_smcd) {
-		if (!list_empty(&lgr->list))
-			smc_ism_unset_conn(conn);
+		smc_ism_unset_conn(conn);
+		tasklet_kill(&conn->rx_tsklet);
 		if (smc_ism_support_dmb_nocopy(lgr->smcd))
 			smcd_buf_detach(conn);
-		tasklet_kill(&conn->rx_tsklet);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 		if (current_work() != &conn->abort_work)
@@ -1525,12 +1526,12 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
 	smc_sk_wake_ups(smc);
 	if (conn->lgr->is_smcd) {
 		smc_ism_unset_conn(conn);
-		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
-			smcd_buf_detach(conn);
 		if (soft)
 			tasklet_kill(&conn->rx_tsklet);
 		else
 			tasklet_unlock_wait(&conn->rx_tsklet);
+		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
+			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 	}

-- 
2.55.0


