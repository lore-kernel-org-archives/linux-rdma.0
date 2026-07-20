Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA62399002;
	Mon, 20 Jul 2026 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567288; cv=pass; b=d+oPIZybu+5iC30c3rrn9bDSMhfODwWHDipaIAcau6hKLbzgfSNjRp6ro+aAXF5KGhTzzk8lcwSVztlbmR7Tg5yYDm2Hut9s0NFuC6jsoSEvx0qEjv1sFplO1W8nt2eSpmFg8jXMTieFG87JPLUY8KYwRd2Qux9TId6zpKo5XmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567288; c=relaxed/simple;
	bh=dNqVxR63V6xQon7zsJn+Ma77TefGiYPz54fRdZ8GDJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e/gveVBHrHY7M0P1E2GvI8flibGhKE89YKwy6SVJAgsPZ2wHw2J0z0X9OO59Yrrv5lfpsywx3H7qvJ+fcb//fhezKd4NcCACx7H5lcH8DfPBaXeubkLTNYudbynkUjm8fQfJ/zhRwTSL1H0VcMkN41ZiGyls6HR8zxWO5rHGW/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=ku50Hzrc; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="ku50Hzrc"
ARC-Seal: i=1; a=rsa-sha256; t=1784567244; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ld8knbAu/Ah1xIom4ITHvPesNMHjfsXzJ6OSFIiwQ+SJtXvZ7KGOalBfVX5K5JrXMPtOtlefZbJjfFJQrfl9lxEjk/UMA1tMSm8FhtZUg21e8yadLJLldLNv69FVLcAFQAZswIBPzfIX0wLlKjxLGHAjt663gVf5g4TO+lFe3qk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784567244; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HjByz5AvHsIQNltISoR9+2X9Bmm/qrLTUWsUjkq8GY8=; 
	b=UDLZFinvllHs7jIEOTFx3rgQyruEbU1oRT86rjUmiKFp4SqSjQzBd59EgkEeE0yuS8vLT73c86GsLLJrt10sH9OoY3jz2wRCWM8WLrSOodqQXRleKWPTSIQbN8KJtiIm5h/hYeAPn8oQ+g8GZPVcQPWvYoGGvy9UT+GLFZUYNro=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784567244;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HjByz5AvHsIQNltISoR9+2X9Bmm/qrLTUWsUjkq8GY8=;
	b=ku50Hzrc4DRQ5WqQiTWRTVI3Hz5nicabKWCgmkKJzz42FlWsfpR4Dri6xvjY+Dwd
	jdbOryCN4+SaRReYpsFYXLqunJRAVR5qgc9rWL4THGzInUtGx/ACQ68Jg/vrQkVX7hK
	pQ9CB7EptjY9KemObm931E07X9lKbfGCidG2IdHI=
Received: by mx.zoho.eu with SMTPS id 1784567241224482.3073788218354;
	Mon, 20 Jul 2026 19:07:21 +0200 (CEST)
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
Subject: [PATCH net] net/smc: validate peer CDC cursor against RMBE size before accepting it
Date: Mon, 20 Jul 2026 19:07:17 +0200
Message-ID: <20260720170717.11425-1-security@auditcode.ai>
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
a cursor that goes backwards, but never checks that the cursor's count is
inside the buffer it indexes. Per smc_host_cursor ("an offset in an
RMBE") and the invariant smc_curs_add() enforces for every local advance
(0 <= count < size), a valid cursor count must be < size; the wire cursor
is peer-controlled and was never checked against that.

smcr_cdc_msg_to_host() accepts the producer and consumer cursors, and the
unbounded value feeds smc_curs_diff() in smc_cdc_msg_recv_action(), which
computes new->count - old->count without clamping against size. A peer
that puts an out-of-range prod.count on the wire (e.g. 0x7fffffff) drives
bytes_to_rcv far past rmb_desc->len -- the very invariant the comment
above the atomic_add() claims but does not enforce.

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

Fix it where the wire cursor is accepted, mirroring the cursor-sanity
idiom two lines above: reject any incoming cursor whose count is >= the
size of the buffer it will index. smc_cdc_cursor_to_host() gains a size
parameter; smcr_cdc_msg_to_host() passes conn->rmb_desc->len for the
producer cursor and conn->peer_rmbe_size for the consumer cursor. This
bounds it at its single origin instead of patching every downstream
consumer. SMC-D (smcd_cdc_msg_to_host()) does not use this helper and is
a separate, out-of-scope gap.

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
 net/smc/smc_cdc.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..f07bbef47073 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -221,6 +221,7 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
 
 static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 					  union smc_cdc_cursor *peer,
+					  unsigned int size,
 					  struct smc_connection *conn)
 {
 	union smc_host_cursor temp, old;
@@ -235,6 +236,14 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
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
 	smc_curs_copy(local, &temp, conn);
 }
 
@@ -246,8 +255,10 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
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

