Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0C742DA5A
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787582495; cv=none; b=WrMAdHunA6wspEgLCGXFyTQn7NuPONkfdMegklrDC+/g5aPGJayz67r1BWW+Brntx0SqGpeo9g8iqwZ8Ius4uCRsIN6FNu54sk7fFpeY2vfVz5BU+NBHlfLcnvmwpm/JtiOHebfCGD+HQBbgTB5O8PdFplpg9V6Xt8zFJgUXiwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787582495; c=relaxed/simple;
	bh=YB1kN1yE34OofMdvCRJ4l8peBsR/9Ti6joBfzsqueHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MOSYwcttAgCXNdH4wPyfC808mdKWaw/rEb0LWl41M3rSVGoEavhwdV/oF+QpxuuOzH0TbhS2h0WHrNipUyhtyWniCG2UA+G5YGqlBQQqLufclmXs0lcp9O1F3idAoABSyUX6ZtnlQlqG1bkVmk2msEvnHu8PR1yZw4IM6s5YJeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=ewDrsIIN; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="ewDrsIIN"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1677c91969so431986366b.1
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 07:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1787582492; x=1788187292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nf7EVRYxoxQWsxoCyroYFHFo05h0v+nfMkplrl85KEI=;
        b=ewDrsIIN7H3wOE/CurJ1UQ8cCfjvm1GgTp3Oboun2TD/HOqHSNhCCJmUoLRHLP8BXR
         wk9bzjOoXK5/HnpTuisD59yBj7hwmKw8WtHkJZbUGJyBlF2gHpHaLPfXJ/HT4GDnd6Uy
         kZu6jxosRWehD+LrNBQhy7v2cXxL4To908shg/dr4LFpWqo8iqadmBhA2spuP27mgS5e
         8gthaPGGIwIPC64xQOEyPxrUKABE+RdURgNs8VE1nNm/EfQDQZCyOTjk77MdMefGljZm
         tQ1izu/C9s/Wy+sVO3e0dXPiTHyqQHQXHHA98l99WgceVoY3L8Xi8dj8itNL/5YhwGzq
         HCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582492; x=1788187292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nf7EVRYxoxQWsxoCyroYFHFo05h0v+nfMkplrl85KEI=;
        b=sMqbjhqL5+ryG20aIhrtCjaNcuNgm3rLLYu65/woH1G7mT+uzdxvSqxwoAqIwdlZWp
         t/fcXqVzDMLTrangCvhjJE+Vuy6OpuduWQjC++mWLYJXlWMshKjPZPef8MiaCRNMZYqh
         6GqRvhgow5pSSObtjhkiRknI0LJkztLE+/E4rMOE/7N9FnBzUFINgPpwPItZVZUq1mj6
         v/cjtg4bhxkI9jtW3Al4oYBWdVmwkfWYmK3zp8oO+RhmaNi1YC6M5ho/yHtXR8zfJ7Jo
         uUqZikmG8sLU9zYjL74yZo7frVgm15BYxNhCgOdoJQsohFZnrjlG9yHPAXhWvARzS85i
         Adsg==
X-Forwarded-Encrypted: i=1; AHgh+RoGDU5Qlrj6vpitrU4WRHhjuMPByk2tEQ2BkERDistW6zJZYlb7RWG9n/xoz5DkZnjqC5mP6DWtevFE@vger.kernel.org
X-Gm-Message-State: AFuF++mIEbMRAU6ykie+BtcSL4H42BvoLcQ5zelOo3/TYIwwVSnYp5b2
	pSJocqwjeNjg+2AC8SZnAeP7aX+A9/2qb1UuPW52CvXgaOJAnoru9IsEEZVS7860JRqk
X-Gm-Gg: AR+sD13nA5EIyLNq0dSy/kqNTwlrYr1QCQxv7xh6su2MH/34tzgI+nN8u0uabi8uFof
	+j1QUDBubYVzIz7x8nAYJBVA72XCitZxuG8DR8ASgszvncfVnq89sMksfBf96ZSHRaUljuJbSh4
	nEBow/97zSCh3xYWxz26YASIyPGESEbcALuim88YuqtpVXD/DgLPcb4EnWcdiNdjUNB6MdxS0fJ
	vvavBAJsNAmNHLq4iAn1vQq9+CF4sUWHdtbWGmrfC3mNHZwKyFuEhQ4z4j9tEJJCRszSQ7cyL37
	W+xJfs/XUJA2sZ0gHiuFoFHVL6pNBgm2IqRTovGR10auH9UI2BAoEmc4AdIFbg+P/UjDO56EMNo
	4O9ktEYqsGVbZECxfN2qQUbIhR2SL4CJufcJO7WewsW3+gbrgGuJNp1m/XamxRPCUwkJahL2+Y9
	DAWJR+Jja/XcNfiNfv5YOxM7MuJg84r5A+GUKbpeO7625ZbOiLbtQsmshA0/TYnO00l+DrHtIBn
	N0fsTIrGMGzJu9yxZTGiOH6D7Wzpbs2Weg5fkhw+Buc3nwdqVnrwLcEjMg5
X-Received: by 2002:a17:906:6312:b0:c24:6445:d19 with SMTP id a640c23a62f3a-c24926f3cf9mr2285240266b.17.1787582491234;
        Mon, 24 Aug 2026 07:41:31 -0700 (PDT)
Received: from localhost.localdomain (cpc69057-oxfd26-2-0-cust39.4-3.cable.virginm.net. [82.6.0.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968a336fsm1341874566b.60.2026.08.24.07.41.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 24 Aug 2026 07:41:30 -0700 (PDT)
From: Paula Moutafian <paula@bynar.io>
To: achender@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net/rds: fix out-of-bounds write in rds_conn_peer_gen_update()
Date: Mon, 24 Aug 2026 15:41:24 +0100
Message-ID: <20260824144124.64756-1-paula@bynar.io>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_conn_peer_gen_update(), rds_start_mprds() and rds_check_all_paths()
all iterate conn->c_path[] up to RDS_MPATH_WORKERS (8) or conn->c_npaths,
but c_path is allocated with only

	npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1)

entries in __rds_conn_create() (net/rds/connection.c).  Only the TCP
transport sets t_mp_capable, so for the IB/RDMA transport (and the loop
transport) exactly one rds_conn_path is allocated.

c_npaths is derived from the peer via the RDS_EXTHDR_NPATHS handshake
extension header and is only clamped to RDS_MPATH_WORKERS, never to the
transport's actual allocation.  A remote peer on an RDS/IB (RoCE) fabric
can therefore complete the unauthenticated handshake and, by sending a
second RDS_EXTHDR_GEN_NUM with a changed generation number, drive
rds_conn_peer_gen_update() to walk c_path[1..7] past the end of a
one-element allocation -- taking cp_lock, writing cp_next_tx_seq /
cp_next_rx_seq and walking cp_retrans on neighbouring slab objects.
rds_start_mprds() and rds_check_all_paths() are reachable the same way
via a peer-supplied c_npaths > 1; note rds_check_all_paths() is a
do/while and dereferences c_path[0] before testing the bound.

Reproduced against an unmodified 7.2.0 KASAN build, triggered from a
hand-rolled RDS/IB peer completing the handshake and sending two probes
with differing RDS_EXTHDR_GEN_NUM:

BUG: KASAN: slab-out-of-bounds in do_raw_spin_lock+0x55/0x9a
Write of size 4 at addr ff1100000425a624 by task ksoftirqd/0/13
Call Trace:
 do_raw_spin_lock+0x55/0x9a
 _raw_spin_lock_irqsave+0x12/0x18
 rds_recv_hs_exthdrs+0x34a/0x52a
 rds_recv_incoming+0x5a8/0xb33
 rds_ib_recv_cqe_handler+0xda1/0x12b6
 poll_rcq+0x8e/0xb1
 rds_ib_tasklet_fn_recv+0x1c4/0x348
Allocated by task 10:
 __rds_conn_create+0x5b3/0x168f
 rds_conn_create+0x18/0x1b
 rds_ib_cm_handle_connect+0x486/0xa35
The buggy address is located 44 bytes to the right of
 allocated 504-byte region, cache kmalloc-512

The corrupted neighbour's cp_retrans.next is then dereferenced on the
next line, producing a fatal GPF (RIP: rds_recv_hs_exthdrs+0x3ba/0x52a,
KASAN: null-ptr-deref) -- a crash, not merely a detected access.

Bound every loop by the number of paths actually allocated, mirroring
the npaths computation already used in rds_conn_destroy() and
rds_conn_message_info_cmn() (net/rds/connection.c).  For t_mp_capable
transports the behaviour is unchanged; for single-path transports the
loops now stay within the one allocated rds_conn_path.

rds_conn_peer_gen_update() and rds_start_mprds() (net/rds/recv.c) were
both correct when written, with c_path still a fixed
RDS_MPATH_WORKERS-element array:

commit 905dd4184e07 ("RDS: TCP: Track peer's connection generation number")
commit 5916e2c1554f ("RDS: TCP: Enable multipath RDS for TCP")

They became wrong when the allocation was made conditional on
t_mp_capable without updating either loop:

commit 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")

rds_check_all_paths() (net/rds/connection.c) is unrelated to that
regression: it was added new, three years later, and was unbounded
from the moment it was written:

commit 9ef845f894c9 ("rds: If one path needs re-connection, check all and re-connect")

Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")
Fixes: 9ef845f894c9 ("rds: If one path needs re-connection, check all and re-connect")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Paula Moutafian <paula@bynar.io>
---
 net/rds/connection.c |  3 ++-
 net/rds/recv.c       | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7c8ab8e973e1..282e320516f5 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -976,11 +976,12 @@ EXPORT_SYMBOL_GPL(rds_conn_path_connect_if_down);
  */
 void rds_check_all_paths(struct rds_connection *conn)
 {
+	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	int i = 0;
 
 	do {
 		rds_conn_path_connect_if_down(&conn->c_path[i]);
-	} while (++i < conn->c_npaths);
+	} while (++i < conn->c_npaths && i < npaths);
 }
 
 void rds_conn_connect_if_down(struct rds_connection *conn)
diff --git a/net/rds/recv.c b/net/rds/recv.c
index cf3884d87931..3813aa323731 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -133,15 +133,16 @@ static void rds_recv_rcvbuf_delta(struct rds_sock *rs, struct sock *sk,
 static void rds_conn_peer_gen_update(struct rds_connection *conn,
 				     u32 peer_gen_num)
 {
-	int i;
+	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	struct rds_message *rm, *tmp;
 	unsigned long flags;
+	int i;
 
 	WARN_ON(conn->c_trans->t_type != RDS_TRANS_TCP);
 	if (peer_gen_num != 0) {
 		if (conn->c_peer_gen_num != 0 &&
 		    peer_gen_num != conn->c_peer_gen_num) {
-			for (i = 0; i < RDS_MPATH_WORKERS; i++) {
+			for (i = 0; i < npaths; i++) {
 				struct rds_conn_path *cp;
 
 				cp = &conn->c_path[i];
@@ -285,12 +286,13 @@ static void rds_recv_hs_exthdrs(struct rds_header *hdr,
  */
 static void rds_start_mprds(struct rds_connection *conn)
 {
-	int i;
+	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	struct rds_conn_path *cp;
+	int i;
 
 	if (conn->c_npaths > 1 &&
 	    rds_addr_cmp(&conn->c_laddr, &conn->c_faddr) < 0) {
-		for (i = 0; i < conn->c_npaths; i++) {
+		for (i = 0; i < conn->c_npaths && i < npaths; i++) {
 			cp = &conn->c_path[i];
 			rds_conn_path_connect_if_down(cp);
 		}

base-commit: 564973a259ec76f2dad0853420e7034cc43994c4
-- 
2.50.1 (Apple Git-155)

