Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92F548A2AA;
	Wed, 22 Jul 2026 10:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784715515; cv=pass; b=SISVsBq7KsDctZYcAPGFSYplzowpfB42B8BnDce0C4m1+UxZ3glLtrmD4VWn2EVwB+RIWsbo4GP5HReomDhMbVhxejaq0TvJgpuqUYjsegkCmRYXmOaORLVoAKRJM/H6iz78bkQyznmOsj5KMV3Qd1L2mBejOelJ63ACM9kBe88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784715515; c=relaxed/simple;
	bh=5IK0E5VfLWQFyv9kEBje5gPPeAhXHabQJOyuDTyUoxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JyIMVflHSPefINXEEXYjoAqqcH1jzb4ATj8hhXVa2jI5olLatJdb0Wln6krfDMBmCpd7MS+Gprt9SCo2ZWAb3r3T6t5zu4C9IscXHCufF215lh1uWSjk8jFYtCm3WVQNNi4na0wencHo6mxjzjieTAQVHyPl57rFnQKhC2A1Clw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=ucwSM2pr; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="ucwSM2pr"
ARC-Seal: i=1; a=rsa-sha256; t=1784715482; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=DSPBifPtK3vXBuHvG7IsIfm3DkRgbzHB9rnx63XMWvqW4AWajEZWQPAfIbIBdtZL69uHifpsI0DD2MiuATPpSpl00R9n41y0z1y5Lf16FCNfKvpsSlWyujpNsEsDGHzdXQaD2/Y/H6HF1a1RZbo85Qp6G8Y0nTUsK1TYw3RJca4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784715482; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nPfVdwY5n496Gpr+RRe/9aJXt3Vr8Qe8AO0w56laRGY=; 
	b=ItZiXlRcq02UXd4YmFVJrpBGBX28KkAUQTcC5U3Vp2lBIQD2UXUyVUAica3mAixhhtwP1IdxGtCtMPLRJa1pEXRoIamBdvXrm+hY27AQ1UgZI58gRNA3U/qcGkpVP3FSSSh3KbUjxVsbmwLfoAYqhA7glGkgrBsvaNINYZeYnJk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784715482;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=nPfVdwY5n496Gpr+RRe/9aJXt3Vr8Qe8AO0w56laRGY=;
	b=ucwSM2prSzCBzAPtI10YAsZmkbHF9NV2mvNBE1AQrDsukjdg5PJ0ZlVMIupkmdTH
	OiZNoyPKrzcSZZDw/1XJiREHoHS/5fF3WRCHA/vvgKvd9eMa41EIL8RjBdlrukAFC/Y
	+Y96KGCEt5Xrc2eLVaK2ud2SqZbyf+LD9+ASABGw=
Received: by mx.zoho.eu with SMTPS id 1784715480713346.6775599105855;
	Wed, 22 Jul 2026 12:18:00 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	wenjia@linux.ibm.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v2] net/smc: validate peer CDC cursor against RMBE size before accepting it
Date: Wed, 22 Jul 2026 12:17:58 +0200
Message-ID: <20260722101758.37817-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

smc_cdc_cursor_to_host() converts the wire-format producer/consumer
cursor of an incoming CDC message into a host smc_host_cursor. It rejects
a cursor that goes backwards, but never checks that the cursor stays
inside the buffer it indexes. Per smc_host_cursor ("an offset in an
RMBE") and the invariant smc_curs_add() enforces for every local advance
(0 <= count < size), a valid cursor count must be < size and a single
advance can be at most one bufferful; the wire cursor is peer-controlled
and was never checked against either.

smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
computes the advance without clamping against size. A peer can inflate it
two ways: an out-of-range prod.count (e.g. 0x7fffffff), or -- since on a
wrap increment smc_curs_diff() returns (size - old.count) + new.count --
a cursor with a bumped wrap and new.count above old.count. Either drives
bytes_to_rcv far past rmb_desc->len, the very invariant the comment above
the atomic_add() claims but does not enforce.

smc_rx_recvmsg() then trusts bytes_to_rcv as the amount of valid RMB
data. Its first copy chunk is safely bounded by rmb_desc->len -
cons.count, but the second chunk copies (copylen - chunk_len) bytes from
offset 0, and copylen came from the inflated readable -- an out-of-bounds
read of the RMB's backing (v)malloc allocation, copied straight to the
receiving process via _copy_to_iter(). This is a remote kernel-memory
disclosure driven by a malicious SMC-R peer, needing no local privilege
on the victim. The same unbounded count also reaches
smc_cdc_handle_urg_data_arrival() (base + urg_curs.count - 1) -- a
second, narrower OOB read.

Reject the bad cursor at ingress, mirroring the cursor-sanity idiom two
lines above: drop any incoming cursor whose count is outside the buffer
(>= size), and any whose advance from the last accepted cursor exceeds
one bufferful (smc_curs_diff() > size), which catches the wrap case.
smc_cdc_cursor_to_host() gains a size parameter; smcr_cdc_msg_to_host()
passes conn->rmb_desc->len for the producer cursor and
conn->peer_rmbe_size for the consumer cursor, bounding it at its single
origin instead of patching every downstream consumer. SMC-D
(smcd_cdc_msg_to_host()) does not use this helper and is a separate,
out-of-scope gap.

Reproduced on a v6.19 KASAN kernel (SMC-Rv2 over soft-RoCE): a peer
emitting prod.count=0x7fffffff triggers a vmalloc-out-of-bounds read in
_copy_to_iter() via smc_rx_recvmsg(), returning ~960 KB of RMB-adjacent
kernel heap to userspace; an in-range cursor transfers cleanly. With the
fix the out-of-range cursor is dropped before it reaches
conn->local_rx_ctrl.prod, and the reproducer returns rc=0 with no report.

Fixes: 5f08318f617b ("smc: connection data control (CDC)")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
v2: also bound the cursor *advance* (smc_curs_diff() <= size), not just
    the count. A wrap increment with new.count above old.count passes the
    count check yet still inflates bytes_to_rcv past the buffer -- thanks
    to sashiko-bot for spotting the count-only gap. Resent standalone.

 net/smc/smc_cdc.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..b0ae4d43b017 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -221,6 +221,7 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
 
 static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 					  union smc_cdc_cursor *peer,
+					  unsigned int size,
 					  struct smc_connection *conn)
 {
 	union smc_host_cursor temp, old;
@@ -235,6 +236,21 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 	if ((old.wrap == temp.wrap) &&
 	    (old.count > temp.count))
 		return;
+	/* count is an offset into the RMBE and must always stay inside
+	 * it (see smc_curs_add()); the peer is untrusted, so reject an
+	 * out-of-range wire cursor the same way an out-of-order one is
+	 * already rejected above, instead of letting it drive
+	 * bytes_to_rcv / the urgent-byte offset past the buffer end
+	 */
+	if (temp.count >= size)
+		return;
+	/* Bound the advance too: a wrap increment with temp.count above
+	 * old.count makes smc_curs_diff() report more than one bufferful,
+	 * which would inflate bytes_to_rcv / peer_rmbe_space past the buffer
+	 * in smc_cdc_msg_recv_action(). Reject such a cursor.
+	 */
+	if (smc_curs_diff(size, &old, &temp) > size)
+		return;
 	smc_curs_copy(local, &temp, conn);
 }
 
@@ -246,8 +262,10 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 	local->len = peer->len;
 	local->seqno = ntohs(peer->seqno);
 	local->token = ntohl(peer->token);
-	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
-	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
+	smc_cdc_cursor_to_host(&local->prod, &peer->prod,
+			       conn->rmb_desc->len, conn);
+	smc_cdc_cursor_to_host(&local->cons, &peer->cons,
+			       conn->peer_rmbe_size, conn);
 	local->prod_flags = peer->prod_flags;
 	local->conn_state_flags = peer->conn_state_flags;
 }
-- 
2.50.1 (Apple Git-155)
