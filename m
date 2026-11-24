Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795490463;
	b=L4WtPTyqVr6akERgvD+axdGZr5B6d1OIN/iw+KOxobsf67glTMM+ZxbHbvAOIgVw81i+
	 +zYFGj/Qwqat7WyFEvdFxFotGmuIx+xJAvFCmYWRuXe8+pE4HrHe7CXvcMTiclGMo3aeE
	 xwRKii2zFN85ygd8DRgBOMWqL4Tm4Jv8lMg6r0s/oE8oMcWvLMsHi7GjHCNjJ4jg5v5m/
	 amrcnL9/w0umzd5rLL1YOQDHM5AF3AIYYBXKtGAg7bT1818Cdd/b1ejdeafVhUT7SneOv
	 xZRNdfXPW+FYIcXdMr0ibAHT6bLCpxRgOYLl3WEVWR5x/SE/No8+vtU28GB8ac94OjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795490463;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=dQLdeF9jwjKOm16H9Rh/oCI9s4JuYbrfLxFcAqEQOUI=;
	b=T6YHdZz6iPIIRnlFVWjz6YVXXdDrSSEc7M3I1s34K7vWLsYFL18jXeFbX60xYvE5gkGX
	 CSQbQsLwut3hWtv/8XrE8OhepoNJPB8aJb47mGOO94qVWp0TOs30aMzepikW1VNw27pzr
	 huFxXkGsYReXdXokF3R1Tx4BEkyxi7EEF8p8gy67BlO+WiTxmC/HeaJEw94+fbmu6ciHl
	 eRTmiaNEY75QJaSoQFzPpL8Kjh6lCmL501b4eh+F3me2yu6SNTNp1HyYgfPSVahexiRRI
	 ArrA79WnvMUXaZgXTGwTf+BQTg3VrJf/OPD4bYkOu+QBnLFugpch+A0FwmEMaO9p6dQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Tn6/6sCB";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.49
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABBF606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 03:21:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ABBF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tn6/6sCB
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6767d92cde6so4362997d50.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 19:21:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795490462; cv=none;
        d=google.com; s=arc-20260327;
        b=E9YSli1L/3nx35CtE6f3tPpgIZ83Mt+YquQOtuQ0YFpq/hyoEpK1mvhHuQarXOolTE
         AA0sMY9PqJpiCtVU6No1a+OSdQ6Jqu07PC6JU2gl4bnDv3pztFWEaQiHX9ANyusfT/eo
         9tlcLyX3335DQH7KpmMhyLHo50ImKttTiJHzJ9sfTe/105EJ3grJOJtoHYIuNpdJqoME
         dePaJ1r4Qg85vAAWdeaRnm1+fz6YRvp4SCz+pXgjpoG2T3XbAjy/2hH4WAccEkZexOjI
         rtX9m63nN3ylCqfu/HNvSP2QOv8bUhKHc36tXDNbK/nKTPd97/tO3CFz/nbLVPWqzFnb
         hppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=dQLdeF9jwjKOm16H9Rh/oCI9s4JuYbrfLxFcAqEQOUI=;
        fh=xaL93BH3fNn0Spm/XnHmhC8VJZ/tYqj92y1dTXQ9zQQ=;
        b=r7LNZ+z/BgkeFP87v8TIDHI3X4sPMXvHm6yUgUm8xz+fYpZZ7JgSiAM1gTkYag7wa6
         wpED+MJO5532Tt0O9PjvOLLYF1Ag1mIi4x8RM8Qirqfd8mpVZjb/PYSBNfpuEq8tB4/z
         dUXAs5/AtjhyaepjTrsQIJLF70X77EO7h+c1H0PlROcoYIiSVd8+UPxH638XjgH/VpGP
         Xie6KfWAmNDAzzYvaDLA5DMCeXpv+GySqf+Tc1aYIGQC/cur+2z0XZqQAbHRJslOi68A
         KPOqAJLRBdchWE+rup10uqC7NNa1Nwqqx87bxTzafJYE59t3Jci9Vf9g6LanjG0XC1bI
         lR2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795490462; x=1796095262; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dQLdeF9jwjKOm16H9Rh/oCI9s4JuYbrfLxFcAqEQOUI=;
        b=Tn6/6sCBM2z1QteltRHf3JVlPrQx1QfFDpcq+nFYZCZOKfU26pOIEZmHkWQ1/o4261
         qdQ+84gC352gwLnCNCXBHpyQ++5rL/jtxYpVIUg55znQSOluEglySt5ZPpldLzDWyFWy
         T9f4enOw8u5dhqq0D/t50vJbPiQ9pvbbRazOfxhn7PsfGv3fDBmXs8ctnCnLjyNOLmZM
         lIjBjfwnpEjS4bE1RyTmnt0CrR9FKrZY7593C3axqBGAkiBatP6piioC7cK0GCBmtjt/
         GSAlWY87t8KPhPEZsjagLz68eiKKxgQsDPVHb/F/C//99as/rjt6n/Zuobk6Ln3ZY9k3
         /8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795490462; x=1796095262;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dQLdeF9jwjKOm16H9Rh/oCI9s4JuYbrfLxFcAqEQOUI=;
        b=XOOjIWc4KqVuxUkPDPMc6mybnN4efsh0syIRL1VXiNKFCcSrSNPvLMLSEXuRBSdIM3
         zwVjwnNoMZ9XlREakfLRgV6QlbRDCVhTPfdEteLdQki3RTmJ59V+I92wFkgJ2TTthR+q
         r3tSba4IsF3mlrp3agxijs6lHdsrSA2Z5BvOCXLDzbCRgBdVlu5wvBoAXFBd6/iLdwJb
         OW7Hg+JYQJVaj8dl8osem3u7FYOCxS22J66IPPREiVnmUc/tG3lQ7OESmVAsM0ydTsaw
         9l6kviWzy53/fUiB7KDwzseUA2iG2I0TEurI9Ll7wNHdtEhssKjmT034II0g9gmGxr7A
         Jx+g==
X-Forwarded-Encrypted: i=1; AL+hErFVOdA9PVzkaYplzMT3R7whKRioE4X1OMR4FXovBREotkxgI++A/R6OFLAhCdEtQIObV3dvYZyWWkjQ@vger.kernel.org
X-Gm-Message-State: APuU4Z8q4jWjtYu7mlayLAl4xKuXw+N16C/Ah+mDMmGsbhswWN7P8TYa
	1sn+UR/So67Tw9o5LMhYiqKI4lq3oAmRX7/N5p3/Pc4TCL3sNVFmzhCmnP44eCMyxZ1VMdJnFAX
	I1W5gTIkGwBBrx4kFvB0AJGNGj0SDJZQ=
X-Gm-Gg: AZFdTZe93rXE+RzDTJaJSGxPhqmP5hprEdE/oD6MYflVL7pb4E1CIrEzaVNGeXzd6Q/
	+VOpuO+ATZUWkrrlp56rsdoK8YG6zg3S0UDvB03OE6bnbbq0Df73lBh9T2xvO3i/h7iPtZypoMU
	OXpaQsAGglroMHpF1NXmvFy4szA39OryFvfgDzOqXQ0ML2nbbx/kfiqGVFwHcDcyxmS/dh59Ba8
	lea4WGScRI8vfkFdFJDe86cIalLtWTaEgi3rlAwA6brvwgWpxrcq95YHfXwZmbs5xOjYpSbq2Sz
	ASFGgQj3LwxaNRD+k3FoPUg9eP4/NvJ5JgNwu58Kg9wy/yiH4xlugWYfO3hNfObTvwh44cHtRAF
	eaI5JizXe08AgZY7LQ9sE4Gx3p1R7N8EshA/9
X-Received: by 2002:a05:690e:4852:10b0:67c:664a:9006 with SMTP id
 956f58d0204a3-67df442350bmr3743774d50.64.1795490462283; Mon, 23 Nov 2026
 19:21:02 -0800 (PST)
Received: from 723974502065 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Nov 2026 19:21:01 -0800
From: Qican Ma <goonsomeway@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 19:21:01 -0800
X-Gm-Features: Aa3M54o-isdJh2GWELyKgDAhaVRdXLz0zHe-XJNinNk_CrP5_D5lsQjTiIb73Yw
Message-ID: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
Subject: [PATCH net] net/smc: validate peer CDC cursors against buffer bounds
 and window
To: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, 
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net, 
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

smc_cdc_cursor_to_host() only checks cursor monotonicity and
smcd_cdc_msg_to_host() copies peer cursors without any validation. Neither
verifies that prod.count < conn->rmb_desc->len or
cons.count < conn->peer_rmbe_size, nor that the resulting cursor deltas
stay within available buffer capacity. A malformed or malicious peer CDC
message can therefore:

1. Drive conn->urg_curs.count past conn->rmb_desc->len in
   smc_cdc_handle_urg_data_arrival(), causing an out-of-bounds read from
   conn->rmb_desc->cpu_addr exposed via recvmsg(MSG_OOB).
2. Inflate conn->bytes_to_rcv past conn->rmb_desc->len (either via an
   out-of-range prod.count or repeated wrap increments), causing the
   second chunk iteration in smc_rx_recvmsg() to copy past the end of
   rcvbuf_base.
3. On SMC-D dmb_nocopy links, inflate conn->sndbuf_space past
   conn->sndbuf_desc->len, causing the second chunk iteration in
   smc_tx_sendmsg() to write past the end of sndbuf_base.

Decode incoming CDC messages into a temporary smc_host_cdc_msg and verify
both cursor offsets and their deltas against rmb_desc->len,
peer_rmbe_size, and (for dmb_nocopy) sndbuf_desc->len before committing
the update to conn->local_rx_ctrl.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; not runtime-tested due to lack
of an SMC-R/SMC-D setup.

Fixes: 5f08318f617b ("smc: connection data control (CDC)")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
 net/smc/smc_cdc.c | 46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df32..fd5e296e8be 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -332,14 +332,48 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 {
 	union smc_host_cursor cons_old, prod_old;
 	struct smc_connection *conn = &smc->conn;
-	int diff_cons, diff_prod, diff_tx;
+	struct smc_host_cdc_msg rx_ctrl = {};
+	int diff_cons, diff_prod, diff_tx = 0;

 	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
 	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
-	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
+	rx_ctrl.prod = prod_old;
+	rx_ctrl.cons = cons_old;
+	smc_cdc_msg_to_host(&rx_ctrl, cdc, conn);
+
+	if (rx_ctrl.prod.count >= conn->rmb_desc->len ||
+	    rx_ctrl.cons.count >= conn->peer_rmbe_size)
+		return;

 	diff_cons = smc_curs_diff(conn->peer_rmbe_size, &cons_old,
-				  &conn->local_rx_ctrl.cons);
+				  &rx_ctrl.cons);
+	if (diff_cons > conn->peer_rmbe_size - atomic_read(&conn->peer_rmbe_space))
+		return;
+
+	if (diff_cons && conn->lgr->is_smcd &&
+	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
+		if (rx_ctrl.cons.count >= conn->sndbuf_desc->len)
+			return;
+		diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
+					&conn->tx_curs_fin, &rx_ctrl.cons);
+		if (diff_tx > conn->sndbuf_desc->len - atomic_read(&conn->sndbuf_space))
+			return;
+	}
+
+	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
+				  &rx_ctrl.prod);
+	if (diff_prod > conn->rmb_desc->len - atomic_read(&conn->bytes_to_rcv))
+		return;
+
+	conn->local_rx_ctrl.common.type = rx_ctrl.common.type;
+	conn->local_rx_ctrl.len = rx_ctrl.len;
+	conn->local_rx_ctrl.seqno = rx_ctrl.seqno;
+	conn->local_rx_ctrl.token = rx_ctrl.token;
+	smc_curs_copy(&conn->local_rx_ctrl.prod, &rx_ctrl.prod, conn);
+	smc_curs_copy(&conn->local_rx_ctrl.cons, &rx_ctrl.cons, conn);
+	conn->local_rx_ctrl.prod_flags = rx_ctrl.prod_flags;
+	conn->local_rx_ctrl.conn_state_flags = rx_ctrl.conn_state_flags;
+
 	if (diff_cons) {
 		/* peer_rmbe_space is decreased during data transfer with RDMA
 		 * write
@@ -355,12 +389,6 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 		 */
 		if (conn->lgr->is_smcd &&
 		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
-			/* Calculate consumed data and
-			 * increment free send buffer space.
-			 */
-			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
-						&conn->tx_curs_fin,
-						&conn->local_rx_ctrl.cons);
 			/* increase local sndbuf space and fin_curs */
 			smp_mb__before_atomic();
 			atomic_add(diff_tx, &conn->sndbuf_space);
-- 
2.50.1 (Apple Git-155)
