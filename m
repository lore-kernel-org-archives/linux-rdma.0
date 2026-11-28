Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795878318;
	b=qoB46S00CD3mWQ1KTSgxHZXbNUJfdrCkrZU3gU2osIhYyhcroYSBHrF3nyAlHvw/0jLE
	 Hs/S+MTWhb3DmFYM/RgNkcWlB4pQMrl8ICMSuFsPdYMIXSO7QjYFIcKAEUOb7kpZHM60s
	 sGHBCLGuc/TBBVSYChHJmEDbEWrT+x2bpr1UsJXVTijbv6dl44hUWJTpeWxGUY7nyGR0p
	 Bplm1mRG/vA3+QyVz7IQTJfp/YbvZQqvlgzpAMPh0vG0REUV1QYFgAFjMYhqb/FYfJy0v
	 dXWfzfK/Lf0um058eSLVdAB26KfpkBKExoeMchDpCd7wRmFwntFPW/OagXZRYN9TH+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878318;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eVMjLwC5yy9xhSWodj39EnH2Oatzv5HZmax4eE4RdCs=;
	b=Zjk0IQczgS/J+9pNEPUZ6Ck1fHTYRO1I5afwDvJBlHOXBdazP4fR7378ZpX7YaCDiJ95
	 cl8C9drtrtHDDzwxJZKiGkribc1SyjctrBA0Os+3HDA5vQx60y/gCunW8hxJ25x0zwL6O
	 pyxERSnxbdgj+xVSb3EuEW9zV5QRCHNN+LgM6XG8Un3DhUAqo271ecFtFsQByGVP6wen2
	 pWTcII8573GoJRqn14+zJoR8j3JolkB2ZMxPDFnDNITHXrGpJJkO4Jbv5oEoyOQjXaW3M
	 /ch5kNyVR7+LNvN/v/PT2Oe83g3d5zgCSF7RjwI5E3mOSrFX9IMf65vIgzskQW/y8JA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fmg0Y5L7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE474606A330;
	Sat, 28 Nov 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fmg0Y5L7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795878318;
	b=rExPnKdmZbhi+IEtF7tII3EjZWpg5WgV3hQRc6dUrFTv6f/doTVCyRi+BAyN0dckIz7/
	 W/qivR8Yy1EmcS/OHBP0SXIRXX1Ph+DNaJSbK0K0Esp7yyEe1WGzQ01b3VRM8ZO+veukx
	 f6kD6dpSwu3Yt0uA05sndjERFkJU7JN3VzhVDZQYf2wdKmKfPlTjrdiULXBMo5/CgB1NV
	 WVgFtHE29FuqmJx7A0oi7PDi90wCIbutrDZVP02f9xIl+7QOYzEWyULHo4cJI0X83Zi8c
	 /dCYfNN5aNKBkErt1NCaqxtGPeDYFvsTVSGahPWS9WGBc6chxrMqCyhleNLuyjX3Xhg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795878318;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eVMjLwC5yy9xhSWodj39EnH2Oatzv5HZmax4eE4RdCs=;
	b=kEDuadxvyIZJSaFpeD3H2PJLdrl2FGOkpealm/IatT/cs7oaQ9lgqoZhYOFqsNwZ25TY
	 vloFCLITvpf0uJjeoHfSThc4Gh3zs9UIvuYqbYRdxdLNyDwnfeJvVkJP2PAb9pObpeQr5
	 6WdoXSGxCljV46nERGCVBwa+hteWvImbmjnRNncN/vythzCAev1z2c04I5R8RWzrzh3Ad
	 Gl9gtlscnPets5gjxbz1P50gGEQPdUTnFcj2BCuzw6x+9RQXMuSjgPPj8N/hS6+fIhuOu
	 4EDhpjJGUPDg3wLYfeDa0lix+/UBrr15B63y+cB7zpRgXss7sF4B28ikVwGsLcX+80g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8EBC21F00898;
	Sat, 28 Nov 2026 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795878318;
	bh=eVMjLwC5yy9xhSWodj39EnH2Oatzv5HZmax4eE4RdCs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Fmg0Y5L7xaL3ksa8LDa54rd4IM5OKuJ506iFQt8G6H6cXom2X4hRmTuSPsvQ3xY5g
	 tzJB/C5heynzB5m/ymZsO9yWRdfezQEa2svouYwidtnQbFl50mfQwk+aPGT+oKpC5e
	 5SuULa2fey+9CJduWhuSQLXWgUnpmpQJ4UyUXhxEcV+ABqRKdvPfATtamM5RbM7yaa
	 HelrVIXY6PtDeCxef/qSFu7uNFwphtPdjliNF6gDfVhXUJJsdqW3A7/lCczsMJBMkr
	 54j6c986xPN3C7o25MtH/ZKK8rtOs3tzX3i/VRYokbIAwEht4ATt3Alsis7Zm/2iuS
	 Qj6Ve2/vuNKuw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 214344E126;
	Sat, 28 Nov 2026 15:05:07 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 10:05:08 -0500
Subject: [PATCH net v3 2/2] net/smc: do not reuse the DMB of a nocopy
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
Message-Id: <20261128-b4-disp-2c190c90-v3-2-c566f64196c8@proton.me>
References: <20261128-b4-disp-2c190c90-v3-0-c566f64196c8@proton.me>
In-Reply-To: <20261128-b4-disp-2c190c90-v3-0-c566f64196c8@proton.me>
To: Jakub Kicinski <kuba@kernel.org>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
 Julian Ruess <julianr@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-s390@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795878306; l=3021;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=TQSTuOnnPNT+E4GTIznojse1fg380ZEcVoDzWihFkbw=;
 b=lCXdXIdO2Bj2tC+ZzEAphy00w3wSe1I+HRG9QhlE99hsuc5QlOahk1x6xrcogaMxzfW9v8pIV
 3VfpXs+4q+SALpbBey6NjmF0OuyQAn/fse3E/UNKWsuMv5YeYzAd/hh
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

Unregister a nocopy DMB when the connection ends instead of pooling it:
the next connection gets a new DMB and token, a peer still attached
keeps the old one until it detaches, and a later attach fails. When the
link group is off its list smc_conn_free() skips smc_buf_unuse() and the
link group's free unregisters the DMB: clear conn->rmb_desc there, or a
retried connect() that cannot allocate its RMB unlinks and frees the
stale descriptor. Devices without nocopy keep their pool.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..509fc4c17bb8 100644
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
@@ -1306,6 +1327,8 @@ void smc_conn_free(struct smc_connection *conn)
 	 */
 	if (!list_empty(&lgr->list))
 		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
+	else if (lgr->is_smcd && smc_ism_support_dmb_nocopy(lgr->smcd))
+		WRITE_ONCE(conn->rmb_desc, NULL); /* freed with the lgr */
 	smc_lgr_unregister_conn(conn);
 
 	if (!lgr->conns_num)

-- 
2.56.1


