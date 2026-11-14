Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794629683;
	b=VnSCaJTwM26vhh8sy7KRqdKeJg/6/DzmrINVUSjfpHzM0oVRTjeUpjAhitTUzCJieb+W
	 mGqg+huCHCKdaM0cJyn/Z/Pynfd9262O6irqADR4K33nEfmS8qYwlXi63TDlgA5sso7vk
	 Tw4bY5WRsly/U7JhvaUUWyr+EF0J6aPcLh1+RrtB688LYVVdRk6JxHn4sMMOzWRc2emru
	 3zQfk0rXbTNnQoWpsGgIzX0Qw2xC00gseeWu9bFuMZzL/amVSBPnjCU9jrCh/6eO8sErg
	 VjqLQbCeIxw8Bz2LmjzcO1B3VWWuAZJGJ3pgkgCC91lzot5DOg4z5VT78kt3M9Fq6PA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629683;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=R4HoKdbOrLiPP/UpFdU2O2e9kTKg+323yj+vdkYbDuU=;
	b=EkJxu1vNJ/MiW1y1QM78FJ0ujGArNNzfZQGYLxgpCO3WIbkhRYbF5dFJhMUIiTTbJtm9
	 znHIvNlzutBLYERyNau2KqtqgoyzYyHGAT0H09h3nwNkKUgPqzAdDXFsrSw4fj9dG5xwe
	 8bBtrnJWoeNlsI4tVxcnTDj9rOI/HY6vlT0FCbWMkN5j39Hm/v8wShc6uqc/YHZfCuY7y
	 VEkxuBS+YpGXU9VmgfP14dKEfwxJXZMp/GXMA4SMY+sqAj+wgiglC9IlJ6gDy4Vapv4pD
	 1YdGnX3KKMA19Ri6CHL4w9mt9hgeHpeVrh4GOQh35h/MFc4nnvlPu/FDanzsfEfZAIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsomsMOJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326D606A333;
	Sat, 14 Nov 2026 04:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NsomsMOJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794629682;
	b=2p+TkfP7bL4LrAIehzTGKhazVpgb2GegrOawGv1sjeGQGuVjWsfAVaKTBKAczfo7DBun
	 y2vcjp4Tq0U/kTmGTD/M7t/Eq/kaS26ILCge89+OTeoFc1PYqUaxPOrkGn/I4jKBXvrda
	 NDoEphDP3pExXq/Xbj2654emPkm+Swq9806CMNJE4tjBgOVoq7Bd2ZxQoU1RqZSqxSd+s
	 Nt+2h85Gjni7GMnUmHagVk+Efwd84Qm+XpXUqqFuIYoTDsNPLTQgWRX8tw+WjzdOiSH2f
	 fFaEWiy9HMTfomBAU1Uv6yf8SsWFeo0poKx5uIqTUqk51TRT/nWeBSdarYxRDA80ONQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794629682;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=R4HoKdbOrLiPP/UpFdU2O2e9kTKg+323yj+vdkYbDuU=;
	b=tBhYTHkqcaSwtV3fP7DGbiyozc9CDdtzr7Q5+SZY8Ai8e3LacNHfxvV3oQQJ71Jxv/Kr
	 9H1aWUgiTnDKO5FU+xGOngQkzjUHCFbMDSyHUJamRxCiCIboUy4ayb0FpO4NaXk2FIMc0
	 y2D+TEvDG6LJmxEr3WWbmA6OC6+B5rNOwxSlU9fCPEqzLpjjujaMZh1TUROi/ga8xhXBn
	 Haq8PDFEj4yWZ0/EP7ZgNO5yn93+ylGPXqIfFzp9MsdHuNZjW1VdI2bgO0nNVwJwqtC2d
	 guZrC0F95OtjLkUbL7oBFhRI3DyWDMp0nPgbCgtxSWPaN4zZMMfc4cXw4WYMo5dSItQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AD58B1F000C6;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794629682;
	bh=R4HoKdbOrLiPP/UpFdU2O2e9kTKg+323yj+vdkYbDuU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NsomsMOJN66d8dYTx8ewsvYwxO62mklil5pig44OcQn1qpXW6di2UPjynrVo+0iTx
	 duLCm9lKxdI/yuiIHL0OXaxAp0DxfYkOQunhin5h8Ykz9bpCgfQcBFac2Mq4OsBCTi
	 Ppxo9aRrHOie2CMdzzs/tbtt6WpU3Cd6KEIEaxgjzuAOhcXAgmIivTKWLO4q5VVU1L
	 IDxtRuhvQyZUCdWzoebr7HDiVvC5kfI4ZTqOZidlIPQDW6QKhZJw8MlC8dGTndLyIz
	 ZspIFJNtZ7sQ1XOdprs8+RUxOn6kcYmtkdnUyIlcxOMkgdktA6Ty5sXDC6hDbdYhGX
	 BGKJi8SCR6vfg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3AC2849C7D;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 23:14:41 -0500
Subject: [PATCH net 2/4] net/smc: do not credit stale CDC completions after
 a link switch
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
Message-Id: <20261113-b4-disp-1a9ab9b0-v1-2-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Paolo Abeni <pabeni@redhat.com>, Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794629679; l=4521;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=4Sn2P9DnOXO+NKmDKGa450qGEUkjLHBVxYGVT0Ek9hM=;
 b=vvdKcaXBQp92ElfK8fPvAdaTwcm4VaH+L4+m6+YKPDBoSXaL+C1Pa2ZULKIVhQxlZLid5RMsH
 xMokkbmQ6saDyaMA+v5Z7LZTvKAQLP0GSDJgUPz50QXd2UubiIsfJ9i
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

A successful completion on the old link handled after
smc_switch_cursor() credits bytes that were rewound for resend, so the
application can overwrite send buffer data before it is resent. A
connection in a closing state is moved to the new link without a rewind;
when completions on the two links are then handled out of order, one
whose cursor is behind tx_curs_fin moves tx_curs_fin back and the same
bytes are credited again, which can take sndbuf_space past the send
buffer size.

Tag each CDC pend with a switch generation that smc_switch_cursor()
bumps, and credit a completion only if it is of the current generation
and its cursor is not behind tx_curs_fin.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc.h      |  3 +++
 net/smc/smc_cdc.c  | 11 ++++++++++-
 net/smc/smc_cdc.h  | 13 +++++++++++++
 net/smc/smc_core.c |  1 +
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 36b243b34a9a..96f017938b9c 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -233,6 +233,9 @@ struct smc_connection {
 	atomic_t		sndbuf_space;	/* remaining space in sndbuf */
 	u16			tx_cdc_seq;	/* sequence # for CDC send */
 	u16			tx_cdc_seq_fin;	/* sequence # - tx completed */
+	u16			tx_switch_gen;	/* bumped when a link switch
+						 * rewinds the tx cursors
+						 */
 	spinlock_t		send_lock;	/* protect wr_sends */
 	atomic_t		cdc_pend_tx_wr; /* number of pending tx CDC wqe
 						 * - inc when post wqe,
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df321..d1f346376c08 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -36,7 +36,15 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 	sndbuf_desc = conn->sndbuf_desc;
 	smc = container_of(conn, struct smc_sock, conn);
 	bh_lock_sock(&smc->sk);
-	if (!wc_status && sndbuf_desc) {
+	/* A CDC posted before a link switch rewound the cursors: its bytes
+	 * are resent on the new link or credited by the switch's catch-up.
+	 * A cursor behind tx_curs_fin (completions on two links in any
+	 * order) was credited already.
+	 */
+	if (!wc_status && sndbuf_desc &&
+	    cdcpend->switch_gen == conn->tx_switch_gen &&
+	    smc_curs_sdiff(sndbuf_desc->len, &conn->tx_curs_fin,
+			   &cdcpend->cursor) >= 0) {
 		diff = smc_curs_diff(sndbuf_desc->len,
 				     &cdcpend->conn->tx_curs_fin,
 				     &cdcpend->cursor);
@@ -107,6 +115,7 @@ static inline void smc_cdc_add_pending_send(struct smc_connection *conn,
 	pend->cursor = conn->tx_curs_sent;
 	pend->p_cursor = conn->local_tx_ctrl.prod;
 	pend->ctrl_seq = conn->tx_cdc_seq;
+	pend->switch_gen = conn->tx_switch_gen;
 }
 
 int smc_cdc_msg_send(struct smc_connection *conn,
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..597acb2e123f 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -170,6 +170,18 @@ static inline int smc_curs_comp(unsigned int size,
 	return smc_curs_diff(size, old, new);
 }
 
+/* signed distance from old to new; the wrap difference is taken as s16,
+ * so it holds across the u16 wrap rollover, for cursors less than 32768
+ * rings apart
+ */
+static inline s64 smc_curs_sdiff(unsigned int size,
+				 union smc_host_cursor *old,
+				 union smc_host_cursor *new)
+{
+	return (s64)(s16)(new->wrap - old->wrap) * size +
+	       (s64)new->count - old->count;
+}
+
 /* calculate cursor difference between old and new, where old <= new and
  * difference may exceed size
  */
@@ -284,6 +296,7 @@ struct smc_cdc_tx_pend {
 	union smc_host_cursor	cursor;		/* tx sndbuf cursor sent */
 	union smc_host_cursor	p_cursor;	/* rx RMBE cursor produced */
 	u16			ctrl_seq;	/* conn. tx sequence # */
+	u16			switch_gen;	/* tx_switch_gen at send */
 };
 
 int smc_cdc_get_free_slot(struct smc_connection *conn,
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 73e86100e6db..fb9f6a4eb683 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1058,6 +1058,7 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	int rc = 0;
 	int diff;
 
+	conn->tx_switch_gen++;	/* completions of earlier sends: no credit */
 	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
 	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
 	/* set prod cursor to old state, enforce tx_rdma_writes() */

-- 
2.56.0


