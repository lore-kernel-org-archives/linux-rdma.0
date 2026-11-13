Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794578244;
	b=26iF2X6HUr+EUUfNm7l5ScttsQ2avifK2cHRKrx1fr6/HvdD714toW4QaTm3Vz3cwcdo
	 1GJPVz0wGcJjP/LMBZZLArqJQbZyzvlBwtnVirKcQ9oVtjo5d88lWg9GeU27eQEgKaTTU
	 +vKiULfmV3/HrjaNnp9i1ixST570gvm337Um7w7jaCtn3aaq17BF0QWgqxJgFQ1gVr8ZM
	 3J0WDqxzgz68tO/l+QL9c3mXrpXz4hlhZ+Ppj4/UFJJrC8wb/CKn7XKO40YrphYIZTvBp
	 xieepo4oCx78G7DLZ88VgIIx9R8Ct3pwdYsTgdHz2qVch33T/aoqzjAr/tWfh71jU+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578244;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dBIonlssolJ46cnPadu4bfqSNVHG6jiddRpL+CGQTKQ=;
	b=jSxeO2gxgRKESFdlhq+aEsJY9nmkc0glHiREVQ91zLT9GuJsj/+v9xxcsik1+jTxnGCJ
	 N/PWVBpaVgUHR0nRbCi6NbzQuf28KhjS3lIycafMmkql8ottTHE1DFx7xuOZ6ufcKwUlt
	 ltxsGckUQl+gRDSIFnSvZ4QLHJXiiIOxamc2Dak8TJe1ROmcc6nIrNb8tDvvSdSCdMbGy
	 Hm+JSAotC4xk6bi9oludDaP8ZrKDyP1OwG89IhsfwpXUdObosLsM0HMwc3LNEjaOIG+IB
	 sJH0JLLfphwAQEAVsSvtxzFnMzHcQb0qS2/Ard3R9VYt4BPcjvX2Bby9S4a9l9TktkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YRivWX0Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24DF606E0DE;
	Fri, 13 Nov 2026 13:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YRivWX0Q
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794578244;
	b=vB2R1Lptnitm99odvfrlrwSVWJ259VkHEI7s8SImLIKLhO9llW+jYsz+dkPNrvKFLiaE
	 FTOVHScCwyipx9nPkKxrF6QkMzILJRiQcf2lqFLltD/P2yFJmi53DI3NqgHxI8cJunudf
	 Rii59s6uyncsnAFCh15Jq4422rkDFzhRhrDcjZaKxXcBOOQ5aeIeAqo1nrt8a5JETKwxf
	 bFeHKGWCP2hR/o0vwAbyZaTdnHy6QahDAAbnC4OxAQKlpZm6+mMOcBPe6bssADeuhU7/w
	 SRgdIeEHoh7baaFHonxp/z7o/pR32a1VnQSnBe5gCrakOK9MrertS/BR3uk2QFYU8Iw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794578244;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dBIonlssolJ46cnPadu4bfqSNVHG6jiddRpL+CGQTKQ=;
	b=AkAlCLcX9EVtN8bk8cMDAWuq7F17zh0a5MPsA0uNa42plmiyky9d36zP3I0a5ul24FPS
	 RmhWCIwqUXB5uGtEuAZ/110dpvoP+3tPaaUZFXIjpi7MyxF4GvErIYm6TrJOPP/k+h9XC
	 IJYV6SdhCrJPcYoxuDe/rakIHJGyu5ZOaD1aAylkAcqTZQo610VpkRAIGAc9d+YIK6LxY
	 EjUY0qNDfQgxowKb/Pd6X9bCuEfh9M5pAW/i9Cwjr19OdM6ZALTfOIBNnsizjf0tkuoMs
	 ZXLl0h00igV5vKlAzmGJpIeX39JU1o4De9CSNuMuf/mGWDVJ/HvXj/WDH+8p07qkvAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BCBD31F000CE;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578244;
	bh=dBIonlssolJ46cnPadu4bfqSNVHG6jiddRpL+CGQTKQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YRivWX0QIozefBXDPHB5qIrlc/AyhcP9hpsyDTwAdNmapDE5eER6W3k1R49giGV/7
	 6zrH0IjcDxn4BrQo+2G4C4OiH8uL58tlsBkKP+y5FsXyIolW9LuH4PuqsHOwNJdwVm
	 mf57aOdgpdMg1bNthe68pOo5rCTsRtFx6XRmJ5dCWCnNh4glkjsa90Qzu4xzvj2PpJ
	 IGfVswmt7RUS1MfMRfynYIMaM/Mpc5PVUsSd5q0oaC1vfS/thUhX3fw3nsmQfluY7H
	 tSuGy5eSbwylxH0nxbGCbAEylMB23N+1Cvl85hpbJb3vxBGVgrBatmUTMmWrSlhJrF
	 kXyT+0MGhtv6w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 49451477E2;
	Fri, 13 Nov 2026 13:57:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 08:57:23 -0500
Subject: [PATCH net 2/2] net/smc: do not reuse the DMB of a nocopy device
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
Message-Id: <20261113-b4-disp-19244662-v1-2-39b256b70ca7@proton.me>
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
In-Reply-To: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, 
 Julian Ruess <julianr@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794578241; l=2533;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=2c0oGp/kSpbmU1m2vd4sv8n20H7zF/Cz6Diq2SpwN9Q=;
 b=7bK6FBgLiHQDiMxXglHCd3sC0MFnUZktHKFkxQYWmADm++J21lbzquRm43cGUZ1uC3BGLXJ4u
 9mvDWOHRLKUCVbplaIqC5Id4sXHSU6RNB5LvKKuUraRP8iLoyEoYXp1
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

Unregister a nocopy DMB when the connection ends instead of pooling it.
The next connection gets a new DMB and token, a peer still attached
keeps the old DMB to itself until it detaches, and a later attach fails.
Clear conn->rmb_desc, which a connect() retried on the same socket would
otherwise use after the free. Devices without nocopy keep their pool.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..88855d9f6617 100644
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

-- 
2.56.0


