Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794683369;
	b=03IjXrtYQbAz2gQcXSHnLY+JKQdcyZ1tOQAuSLZhDukCGvwyAbx0QAf96FNrz9t2NGdu
	 I4RMCm4NHv4JALJa28M+c6AWrpSVQW4Wl3peqct0Gs7ygMgEfQ3o9EhGufspAa7mPJyPR
	 IqBPb52iQwn+flILmQRzpmrj1ADK7MUslknyi4IyNbobmuWHxEdwQJhty0C25c05PnwPO
	 9LPzL/sC21Gn3qE9nHzkjlr5D41ve2xrvCW41hG2Eg0Am27K/cFhCJCY3CC95Invpy1uw
	 HvuT8YErYeg+Z/7pevqba7UE4jFTHEqQCGVxkyMfkka6YMO5trwdHaqs7TM60GwR1hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794683369;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=s+aiMjctAiHJQXwqtY6POx3oc38E/xM+Ptz2zRA6gls=;
	b=J2W87GAOEXQLtdHU7MeEO3CfYCW0H3/F7J58BeJ8M1ytM30RV6oicmpDphkGfTpO4QVt
	 A5yciTnKDQO3pHF0cCKlYCmOQOkPnO+s7Wt9aAiWBGDOreIjWSBOfo8kM2pBZbFdFpZk+
	 oAvXjnFF0mITPwhFoTiXQeOL7v6+nkrEvl/v0Jg/ikoNWYfITFYzcq/MiS9dA7v14TvEF
	 466A+ngSscOI4I0kKG4CSWNyQuzhXzbS9ytK48MJpOUpq3ma9PHJD4sE8O/NtXI5j/BMj
	 Cwm2bCGz3og/6a2vUykznf7FMDOmQ8Q69P8Noa18VIPr1TxqBUWJfRwtty1w/MytqOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T34TNpTX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A3606A336;
	Sat, 14 Nov 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T34TNpTX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794683369;
	b=1ybSYnPwKGp/VTd+HUQUL91nFn9NNJm4b+at1J1F3+Ov3LmsaNtlEh322bI7//pmsSEA
	 wzZkLu6f7/zngAs9whLdtKg2OXfZ6MZbn31BkO24TTsXnimK81lrU0/LTFmV1qn8rZ7ui
	 r0ouUQTuOsjozTnxQ2KqaZFzUqUVwVeaspq92LoMnDvSrtRq6I5DVm9I5M4AcGVbMxFww
	 6oMvWOA8nanFQwveS2Jr6Y5/hR+RERHn0yRyberWEo/cCIeJ1OPyU0u2dmewqoWa4FCGz
	 smwHQVFxLRP+fV1hFMEkhFvOT5LyO80s3uev+bj4H8q8HFG1MD0WoTcU7ZzOt59RYHg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794683369;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=s+aiMjctAiHJQXwqtY6POx3oc38E/xM+Ptz2zRA6gls=;
	b=wHtKaVHpetdquvO6wlsOjMHg93S2j6XA0hlX/xFyVn0kDBEwQw5r7vE/iSBfJeKeY0Yq
	 b2LUs2/6KKDgPE6IFyk8Rz80pQn18Ib7vlOSZIzAvT12uOkmCTlqW9+nz4sr+7w1wyvA6
	 jZRbL5ZG32FztX17w9DIS2wo9iVoyLaBtluv0jguEm82zvSK7EL/nmVlcfvblwaplGnUv
	 v5kGdgZd8ftSj46nBxx95jmvQbD9ADjuvb/jAkwwBIeo947INHjLVFU8reMBkKgWG3iCt
	 ABLuB+XlNnE/HQ5W0Xs8ebI13HlNB1uG0r8hACUmVqwe3Km7SI6tyuFOVSTLhENCIZg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C6C351F000C6;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683369;
	bh=s+aiMjctAiHJQXwqtY6POx3oc38E/xM+Ptz2zRA6gls=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=T34TNpTX7VfS3wYkQy1Hren/C66m1Lquj/uY8bqi3XvSdCoRqCBSbD0lec7WcKSXG
	 7eTyJRVsHQU9PK64C8J+No2U2kJ9A+i7xssTKwjbyMB3tV6v+SOBblYj9qbe8kUwMs
	 K2sGkogeGPvi+xdOs+KG/tJ0CbtTmTZh2Salh3Mtt+SJf9zzTt/st1npw2VCMtuQbd
	 IhXL8jz0MGI6u2KUzjnBDTmWTsCuKAD4K41Ry044jBwjVWBjX0sNcfd44y9VlE5/ps
	 4lCGS72SYxyukbEfOmul5bfnSPSBiL5gjqMLT01K158nT/aiHcm7bNR8mDZrr+7Vjb
	 SvteUw3flJ4jQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5352749E72;
	Sat, 14 Nov 2026 19:09:28 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 14 Nov 2026 14:09:29 -0500
Subject: [PATCH net v2 2/2] net/smc: do not reuse the DMB of a nocopy
 device
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Alexandra Winter <wintera@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794683367; l=2946;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=uSm6fhhRSfpsta/rzRA93yjdtBG1K7WKe2FGd/O7Mb0=;
 b=2azoCofFqckc4LR3zOLCrZEl8/IZsQpGG/vIJbCUOKmSdLHCQW6Gdjk61r/P6uOjCDn0SFKVO
 Ncsb1ElCVCsBD2DKCa0Fby6mLrP9k5+iV6LwvxEZbAdKCR2XL42ioJ1
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

With DMB nocopy (the dibs loopback device) the peer writes into the RMB
through its own attachment, and it can attach late. smc_buf_unuse() puts
the DMB back in the link group's pool with its token still registered
while the old peer can still write to it: the next connection that takes
it gets the old peer's CDCs, and a peer that attaches after the other
end gave up lands in another connection's DMB.

Unregister a nocopy DMB when the connection ends instead of pooling it,
including when smc_conn_free() finds the link group off its list and
skips smc_buf_unuse(). The next connection gets a new DMB and token, a
peer still attached keeps the old DMB until it detaches, and a later
attach fails. Clear conn->rmb_desc, which a retried connect() would
otherwise use after the free. Devices without nocopy keep their pool.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..6a673ce74937 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1243,6 +1243,22 @@ static void smcd_buf_detach(struct smc_connection *conn)
 	kfree(buf_desc);
 }
 
+/* With DMB nocopy the peer writes into the RMB through its own
+ * attachment, which can outlive this connection: unregister the DMB
+ * instead of pooling it, so the next connection gets a new one.
+ */
+static void smcd_rmb_drop(struct smc_connection *conn,
+			  struct smc_link_group *lgr)
+{
+	struct smc_buf_desc *rmb_desc = conn->rmb_desc;
+
+	down_write(&lgr->rmbs_lock);
+	smc_lgr_buf_list_del(lgr, true, rmb_desc);
+	up_write(&lgr->rmbs_lock);
+	WRITE_ONCE(conn->rmb_desc, NULL);
+	smc_buf_free(lgr, true, rmb_desc);
+}
+
 static void smc_buf_unuse(struct smc_connection *conn,
 			  struct smc_link_group *lgr)
 {
@@ -1266,8 +1282,13 @@ static void smc_buf_unuse(struct smc_connection *conn,
 			smcr_buf_unuse(conn->rmb_desc, true, lgr);
 		} else {
 			bufsize += sizeof(struct smcd_cdc_msg);
-			memzero_explicit(conn->rmb_desc->cpu_addr, bufsize);
-			WRITE_ONCE(conn->rmb_desc->used, 0);
+			if (smc_ism_support_dmb_nocopy(lgr->smcd)) {
+				smcd_rmb_drop(conn, lgr);
+			} else {
+				memzero_explicit(conn->rmb_desc->cpu_addr,
+						 bufsize);
+				WRITE_ONCE(conn->rmb_desc->used, 0);
+			}
 		}
 		SMC_STAT_RMB_SIZE(smc, is_smcd, true, false, bufsize);
 	}
@@ -1306,6 +1327,9 @@ void smc_conn_free(struct smc_connection *conn)
 	 */
 	if (!list_empty(&lgr->list))
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+	else if (lgr->is_smcd && conn->rmb_desc &&
+		 smc_ism_support_dmb_nocopy(lgr->smcd))
+		smcd_rmb_drop(conn, lgr);
 	smc_lgr_unregister_conn(conn);
 
 	if (!lgr->conns_num)

-- 
2.56.0


