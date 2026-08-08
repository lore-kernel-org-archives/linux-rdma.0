Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FF13451A6;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786173684; cv=none; b=rkexsyHIwlyBDzVGzEY9wG3iXXbvQqfISjFWyYlxudtx5/aq9Mdw+oEv4HLmM3SSxGsU90Bg9m0LKxo08UmTen5n56SiJb+7O3SSPiwhAhy+KGLunRBO1Aw3SW3qYfDwz7eG8ovCqpFseIAX3JlaXgnj5YQ9viRfXcTubN3ia5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786173684; c=relaxed/simple;
	bh=QVUG/SkNdheT8KJ51bIudq+N3GENpF/FZXOkrCJVdtU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nRV7m4Z2shtNfCdQFfDsn8DR/R8X8Tb410dLRD8grejEf3UZXrEle6KUcH7i+b14X0kNj+Pt6Qqn8Y4EPE2E7RvFHz6wpRCP7QAKcKGHeC440yYia2/kODMyVJeJ2+meRlS/d7kfJ/YTYcUCF4FEgls1qme4vA4JXQjDYXCcwNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwoVTXrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwoVTXrA"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94E25C2BCFA;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786173684;
	bh=QVUG/SkNdheT8KJ51bIudq+N3GENpF/FZXOkrCJVdtU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OwoVTXrATDGV7QC7GJdLLKSd5Xll7sE6jqXYH+sVDGw1qZdnngfdEc/oXNrpAITmG
	 o0NsQmCyneMBOro9GtsMblwkOcaIjVumIh3nM1SaAGsq2opkTD9cF83tDW0QtnSAJ4
	 RrFgGA9ckghrtY7GYrJC5nyKpXpZzpk81hrtUgiJQ9hRiz9HJy6sXx6lPNp+Bw8Vih
	 TWD5hBCUAHNDq9QJS6xS/v20gjVBq/OccBiiBa8h/tmPE0TJDsDGTpplbi+fW4v/+X
	 rr3SQOMH1W0TPBn+1qX2sVItyNe3zrMO/B00ZiJIKs4ezA0IzShFXKSAwIhlkqrBA7
	 cXCSz6UDhmZTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780EAC5AD44;
	Sat,  8 Aug 2026 07:21:24 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 08 Aug 2026 02:21:24 -0500
Subject: [PATCH net v2 2/2] net/smc: do not dereference an unset send
 buffer on the SMC-D teardown path
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786173683; l=2204;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=bUpsk29UNDMOBjMmaIhQLlOEXAr9bmtNl3+Vr8jHznI=;
 b=4P3PCV5pt68fjyRwrLWoWy8f33cvl058xvyvqwgSiauaBBYdbf7tw/NWuAVR8xMCy/+RKpHwS
 c00UpdWGqGwA8V6duNj3y+30tQF2NLnZ+9lI4FvSX5ai1ve3Z+Lxxxs
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_close_stream_wait() calls smc_tx_prepared_sends() from inside its
sk_wait_event() condition, and sk_wait_event() evaluates that condition
once with the socket lock released. smcd_buf_detach() clears
conn->sndbuf_desc from smc_conn_kill() under lock_sock(), so a link group
terminating while a socket waits there leaves the helper dereferencing
NULL, faulting out of close(). SIOCOUTQ reads the field by hand, and
smc_close_cancel_work() drops the lock across two cancel_*_sync() calls.

Sample the pointer once in the helper, report nothing prepared while it is
unset, and bound the ioctl the same way. The receive tasklet dereferences
the field directly in smc_cdc_msg_recv_action(), not through this helper;
1/2 is what keeps it from running that late.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/af_smc.c | 3 ++-
 net/smc/smc_tx.h | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00403175b740..cff910cedbfc 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3233,7 +3233,8 @@ int smc_ioctl(struct socket *sock, unsigned int cmd,
 			return -EINVAL;
 		}
 		if (smc->sk.sk_state == SMC_INIT ||
-		    smc->sk.sk_state == SMC_CLOSED)
+		    smc->sk.sk_state == SMC_CLOSED ||
+		    !READ_ONCE(smc->conn.sndbuf_desc))
 			answ = 0;
 		else
 			answ = smc->conn.sndbuf_desc->len -
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index a59f370b8b43..610a945aefd6 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -20,11 +20,15 @@
 
 static inline int smc_tx_prepared_sends(struct smc_connection *conn)
 {
+	struct smc_buf_desc *sndbuf_desc = READ_ONCE(conn->sndbuf_desc);
 	union smc_host_cursor sent, prep;
 
+	if (!sndbuf_desc)
+		return 0;
+
 	smc_curs_copy(&sent, &conn->tx_curs_sent, conn);
 	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
-	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
+	return smc_curs_diff(sndbuf_desc->len, &sent, &prep);
 }
 
 void smc_tx_pending(struct smc_connection *conn);

-- 
2.55.0


