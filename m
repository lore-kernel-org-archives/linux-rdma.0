Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442021;
	b=XBYlmRcnQLatyccfxU/qj37C27yRRqT4ghDnwPado6kSi1AIeXPk12hY/6NJds6zOzjt
	 EfJampfHScALksDYuauNyw9rJQt5gV/t6EQzL2DoKDtPw/z68m9cX7P/C5As4jBJOV0UI
	 i9YMW5GJggibuvLpgWgZa5hFt/YPHkNBVDfN85Y/L1Hfd4Tf9X1W72YDBvQNMZkum3Q7H
	 AFumr3/d6ErTiuCkCbILVoHZiXZcCPs2hblWAPAXSGF/xtQYQGczqFJI0Ze5N31fKWuXl
	 i4i4UlXWPKfkwdQUDBPWkRcR9sotwmoE+PSipcs7UQ89dkCOLTmhmjUHz1FWF1/ik0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442021;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wm3Sj40aRyFsmu65pREyfH1l8+4v7dZwchrk4/0U/TI=;
	b=T4ycjnrEchbGH3BioCunraMYFiXxZ1Qmf/PMIY3LzofBC4x86lYWSyP8C6voKL+3XCPf
	 bKOFffHV73kCXVfgEdtdAPkcs/jkQ80zCQPIEvqYZ46xFQKjzMrX5ZEzXZcUzpqXyGXyL
	 aa8pKnwEAobZn41gfmdOjKwpi/kPWm1vvyKBVgv29acfz1HAZ/g4NUxyYDi1du7El4lI7
	 p3izqfGkcfJ7ZTWZ62pyhpRaPpTUyApZyicDKSQxslBg0EZ3X6dKFkp5RHafEKIFN5E/9
	 pIeKgdLXugJNIYXxVVf45246F7KIUR6XK77ENtN9qiHm/bBrsGohUtNX5O3noT8svzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=YF6GU2Mf;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C93606A32E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 13:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7C93606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=YF6GU2Mf
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b9c51097e2so1112897b3a.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 05:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795442020; x=1796046820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wm3Sj40aRyFsmu65pREyfH1l8+4v7dZwchrk4/0U/TI=;
        b=YF6GU2MfzFL+xw6V4/1FgEhvCJ+SGtt7ZwKiCq76seKeW2U+Gmqpj4vH03OMUyVDDn
         bbKQCoH9Sz4bpDHyQY8LdxiQudYEt4WlhgauW4/H9O1bFOZxObOgqoLBVjW1cnxmAi/j
         UBvrOYUztODKaN999/b5ZgmkvhcpiB4UKNcEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442020; x=1796046820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wm3Sj40aRyFsmu65pREyfH1l8+4v7dZwchrk4/0U/TI=;
        b=Hwb4ioysZAfMcd3ep79QDbJKCCm7IOZvGsUflVdI80BJE+SSo60KdgGJ+LQHmbj7Ey
         3PPz0SuCzz3O4SeCip1xl/xEwB8JykHrxUwXaQjkwm7oyaB6aL0kwKzFgRXwd/sTwqty
         asrdR5qgc+qs65hN+srjUexqvxS/t9wOKI2Bv/yLaEdXOmqXz5e7MYhBfoF7dqTVsEPi
         4P4Vgtl/gOTUj1GxLvB8IdZ7+kPGoxQUaQm7WTcufZ3Qqr+NuLYZ8s4WRQIbFu/3nJmm
         85eM51/MSHLtGdAhZEjBdKJSxezEPiAdYz6XcKXMHxXhELOhM6NpueDBPWwWb+6G6S6O
         d1QQ==
X-Forwarded-Encrypted: i=1; AL+hErFNxgm1GomFRQJXPzuijXd0SpLGuRqHsKvAWnC00Ov9mh2H5BIEfBr8iHfB1Da4/4FJtgOnd4QOvQYo@vger.kernel.org
X-Gm-Message-State: APuU4Z+iqS9UMz3LwH3nXp2YDazjsyHZKrCfcy6UStSMjoSAmnLkz1oW
	OhFKDoxwMv4kN9umgMCMl1OrkGFhqqvRQp2v1DZ4q55CVdwnBRCpWMFic4p+NW/IQyU=
X-Gm-Gg: AZFdTZfiHdvF1hmRrVV587SATJEYoH96L785k4wUKAPE7Rroqf0rNS02mBE1aGyUF33
	bOgxwze6JiCbD0FMX2Q/hrQYfrnT2QOqUIwbWnsfLrmpXVHqgIFRJlTxVa/ZzXN6VEaSuLALzLc
	auVa0OG+nQtNfneTIRx5XbgDlK9vUpv0q4b3HUiWwnu7bNhBPoGO5apUXp98VImBd2aw69CsxeF
	ibxx34AuH/UXZWkklwdPXCphmNIRodE+G2b1cTkHwgGL/yWPFGlMEE0ar0CQMvuqf9/ucdbtEXt
	4Z2AZSTgC144BKCfF36FCKy3mXzgssBxhaWB61g6F3I5WXuZCXte09Oxz20bR0nGPNv+6OBRwo/
	DEoKGJdyE/jVSehIpx9Lo77x8LVf7DM17BOsLDU7wHL7HjKS70EhnO5v/kcif+W1qjoDyvFoZzM
	XRM9xbJWShRg4Ehx7/3dajyHiJYAnKuN0btPIgInZPm3my1fYRBhBUi5SCQ3XtNseJy1D9vVWQB
	xIE57MWnk6hTp2mh7p89//Ra9YlGlMgCJSk5wZY0k9R7mQ83eWLor7MTnwC4FF67GWShlWMxTam
	Bd9PCMQ5qp4ffaYsB3Cs6sg90B5/nJlNIVgN53J3bqO4hhwl85vY7PGvDYXJZzCBCQK1IH23ERr
	OFcADGPPTo79WqApY47/JfaEQEzjFoR2ROdfSEgwqDMLq2p1B4UAFpmGnBLIBeMw5/gJ/xdUAIv
	8zl3fwc674nA==
X-Received: by 2002:a05:6a20:d10f:b0:3eb:9c9f:8b8e with SMTP id adf61e73a8af0-4014e74d04cmr10179615637.92.1795442020015;
        Mon, 23 Nov 2026 05:53:40 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c873c1cfafsm5713466b3a.50.2026.11.23.05.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:53:39 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>,
	Piyus Kedia <piyus@iiitd.ac.in>
Subject: [PATCH net v2 2/2] net/smc: bound the DMB-nocopy send-buffer credit as well
Date: Mon, 23 Nov 2026 19:23:27 +0530
Message-Id: <20261123135327.3953509-2-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123135327.3953509-1-piyus@iiitd.ac.in>
References: <20261123135327.3953509-1-piyus@iiitd.ac.in>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_cdc_msg_recv_action() credits sndbuf_space from the peer's consumer
cursor on the SMC-D DMB-nocopy path and then assigns that cursor to this
side's tx_curs_fin:

	diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
				&conn->tx_curs_fin,
				&conn->local_rx_ctrl.cons);
	/* increase local sndbuf space and fin_curs */
	smp_mb__before_atomic();
	atomic_add(diff_tx, &conn->sndbuf_space);
	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
	smp_mb__after_atomic();
	smc_curs_copy(&conn->tx_curs_fin,
		      &conn->local_rx_ctrl.cons, conn);

sndbuf_space can already be non-zero when this runs, so the sum can
exceed sndbuf_desc->len and the comment asserting otherwise does not
hold; smcd_cdc_msg_to_host() takes the cursor in host order with no
validation, so tx_curs_fin can also be assigned a count outside the send
buffer.

Unlike the failover path in the previous patch this is not reachable from
a hostile peer today.  The branch runs only when
smc_ism_support_dmb_nocopy() is true, which needs a dibs device providing
support_mmapped_rdmb(), and the only provider is
drivers/dibs/dibs_loopback.c - where both ends of the connection are the
same kernel and the cursor is written by SMC itself.  So this is
hardening rather than a fix for an observed attack: it keeps the
invariant in the comment true by construction, keeps the cursor inside
the buffer, and stops a future device that implements the op from
inheriting the problem.

Bound the credit by what this side has outstanding and advance
tx_curs_fin by the bounded amount instead of assigning the reported
cursor.  For a cursor that reflects real consumption both are the value
that is used today.

How this was found: by AI-driven fuzzing built on top of syzkaller, on a
loopback-ism connection with the peer's consumer cursor forged by a debug
patch so that it reports consuming data this side never sent.  KASAN
reported an 869056-byte write past the send buffer in smc_tx_sendmsg()
(use-after-free in _copy_from_iter).  With this patch the same forged
cursor credits nothing beyond the outstanding bytes.

Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>
---
Link: https://lore.kernel.org/all/20261122053223.2497832-2-piyus@iiitd.ac.in/

This is 2/2 of a two-patch series; there is no cover letter.  The v2
changelog is under the --- line of patch 1/2, and in short: v1 was a single
patch that clamped the copy length in smc_tx_sendmsg() and named this
DMB-nocopy path as a remote attack.  Both were wrong - the clamp left
sndbuf_space inflated, and this path is reachable only on loopback-ism, where
both ends are the same kernel.  v2 bounds the credit at both sites where it is
added; this patch is the hardening half.
 net/smc/smc_cdc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df321..9ffa3e422aa1 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -333,6 +333,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 	union smc_host_cursor cons_old, prod_old;
 	struct smc_connection *conn = &smc->conn;
 	int diff_cons, diff_prod, diff_tx;
+	int sent;
 
 	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
 	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
@@ -361,13 +362,26 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
 						&conn->tx_curs_fin,
 						&conn->local_rx_ctrl.cons);
+			/* This difference comes from the cursor the peer
+			 * reported, which is taken as it arrives.  A peer
+			 * cannot have consumed more than this side has
+			 * outstanding, so bound it by that and advance
+			 * tx_curs_fin by the bounded amount rather than
+			 * assigning the reported cursor: the invariant below
+			 * then holds by construction, and tx_curs_fin stays
+			 * inside the send buffer.
+			 */
+			sent = conn->sndbuf_desc->len -
+			       atomic_read(&conn->sndbuf_space);
+			diff_tx = min_t(int, diff_tx, max_t(int, sent, 0));
+
 			/* increase local sndbuf space and fin_curs */
 			smp_mb__before_atomic();
 			atomic_add(diff_tx, &conn->sndbuf_space);
 			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
 			smp_mb__after_atomic();
-			smc_curs_copy(&conn->tx_curs_fin,
-				      &conn->local_rx_ctrl.cons, conn);
+			smc_curs_add(conn->sndbuf_desc->len,
+				     &conn->tx_curs_fin, diff_tx);
 
 			smc_tx_sndbuf_nonfull(smc);
 		}
-- 
2.34.1

