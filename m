Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7761D43E4A2
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791463790; cv=none; b=kuITRSbzKzujI7xeR1gR4Go/mXidqG4zg7ojZZTPJs3gICx8GR3usJE83gHxSO4k/ZIMWHI2D1pC1+TNiq60B25XjUW5uaUbTVlHznTzBs93CZbyMHG/Jo44znhSs79An37rlJaA9lwzgqb1rDzCVV44Lwtp4OT7nlbRiSVKJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791463790; c=relaxed/simple;
	bh=B8O4UyYWgKHjCyiEvWQaDVeXppuTnbg4pu4xhsW+PqI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HtZnSCHrGvIoCHZTih4t3z6g1A7xLRImdiAygWbBHXtG9/cPQL/fB8dJR4j7tINjnWeOmMRoz+CLeITnHJ/mMMMPc/Fj6Axl4jNU6JpMa57uSGMUd+83C4vEmN3O1/zCj64+7AKyi0/aafBeiTP15go9bvjwrPZVR9L9Du0gtoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=octane.security; spf=pass smtp.mailfrom=octane.security; dkim=pass (2048-bit key) header.d=octane.security header.i=@octane.security header.b=QU2PqQAX; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=octane.security
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=octane.security
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=octane.security header.i=@octane.security header.b="QU2PqQAX"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15354aa70e8so1572029c88.1
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=octane.security; s=google; t=1791463787; x=1792068587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aw49x50i74crGqe52PxPoi4v9QJFpR0yZ1MGPQQ+JH8=;
        b=QU2PqQAXbY0/Xx88zUSVelSV7Hcx4Ugt71ZgsD+PMsQkp3+EgDS1kUlbJ1M7441+W/
         ewXvtSK15+rVc1OHtXG+kNoqYAAfPKkLZNQ60c7HDqAiD58dewNM5/0TxaxdKT3oVtnm
         EEFUxmEO8CHMUVwRP7gMoEINkYVMXCLe+4wV4SCE4SwCHLX4SmS5Cg0lcmy3SWAK0vuS
         1+a/xPMnq1sNJ7Zj9it1e7ZiO9NUkq17/99Ifk0UQ56II6xpueZ3V0OY2pRTxNnsACZ1
         Z2j/K9IYT65Uh8WfHr5QMB51J4bFfGbWryCyFTmZQhcQwosV20DAGXhRNCRdJYdW39Sp
         i69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791463787; x=1792068587;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aw49x50i74crGqe52PxPoi4v9QJFpR0yZ1MGPQQ+JH8=;
        b=N4m9+pczC5CRezQjjFtVPlehKuH2fOY4G5KjvVZIp174YLDbeTTL1TTK+qVqSz6gKC
         Y4TKNqE/Ve1YEFHFbEXS5liTHkaMVakhfytZqKWPNTpsXmN0f/oGaFzqWtf47QkDXPPK
         T29JrjMN4gYmSjLxzg6dSJ+N4EjpQ7itU1t0BvdOY3E2W4Bb98XsB8yUu3ZI6qo/X8T0
         9COSWHIW6Xt34MSTpp1nLtm7DImz4YpRQkwJH1Odpm3FOwgvSfQGnlqEIo0gt5S07zNF
         tDaWrHp2XbnuoM/OpzQvpdXpaDghaiTEG7I7H5OBE+zXMWjkN3iEy8wdPHygrfbl23gI
         Nyuw==
X-Forwarded-Encrypted: i=1; AKwUvBx4gtLYa5GvkTE2Z15cU4vljn/h63RU7XYuW/et2+tATFKQqIcd9VpxLo6m45+wEwwmdmIPeYfVsCJ8@vger.kernel.org
X-Gm-Message-State: AFuF++npypAfQr0X1wZFbeqBo1vVn8UjtdXaDfI934eCYqTF43UOYEQ8
	ChFumx14H20ELy8aGVXHs41RNmj60LYTwNsvBf9S/OM+QXo9tDN7pY3UM0BZLyrswwc=
X-Gm-Gg: AYBFou2fGd+ztxeZp8XfYtUlMw7+Gon2bg/Gd9FSDNipcz+z3qq/2x1xQVHlH9dc424
	omlVWh03fBbaaI3McPuR+9ognMgnuyZAOhTen8nk4MRgGoPvB2JsCahJGHB57zz4XYSmOTSDn7E
	hjkP1i0MswJxyZKWo41k/NATQ08n58L6bwZ1bHD7GhVtC4R/maD/ZR44n/oms81kqRIDmJWpch8
	/JQJZ2nkGreNAvBZAuHV35VB6pG6DGyI6kn3eFgFtwxQTg4zAfBW/dq91P707vav7qVLwYWiwFL
	OQ9ll7HYYmG/LYo/9lIvnDYi4ZKjBAdpA0lLSofylnKYUxbc5Z7Cd4JWDpQj6bbnJhgPpD4Mz0R
	QfEl9VhRSbQpC7tvX7vNkJFhlpDASVSLd9h5+F2rYf+V5d/T77iYr34HthVv5mMAR8+moRQ9ao4
	r66Fo5B45tGlVNOp4ogPGqmk5FEDQ4KaPaB25vHqFnDrN3575rrBtBNmMMv+/hS4Hl2aRcp8Aeh
	y/M8G29AC0e5LWfqAk7bSrAwt2R55VyAZfBMm28IfAH9JSJVk0OnsFrQvV6n/oQrsBJHIR48RJI
	T1j29C2ufFszwg==
X-Received: by 2002:a05:701b:2419:b0:168:3243:c911 with SMTP id a92af1059eb24-1683243ccb8mr540174c88.37.1791463787193;
        Thu, 08 Oct 2026 05:49:47 -0700 (PDT)
Received: from localhost.localdomain ([103.207.175.177])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1630180f6a5sm11100896c88.22.2026.10.08.05.49.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 05:49:46 -0700 (PDT)
From: Shubham Antil <shubham@octane.security>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	Giovanni Vignone <gio@octane.security>,
	sungbyeongchan <tjdqudcks0424@naver.com>
Subject: [PATCH net v3] net/rds: ib: zero the unwritten tail of a short receive fragment
Date: Thu,  8 Oct 2026 18:19:40 +0530
Message-ID: <20261008124940.13371-1-shubham@octane.security>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_ib_process_recv() accepts an RDS/IB fragment once the receive
completion reports at least an RDS header, and then trusts the
header-declared message length h_len: rds_ib_inc_copy_to_user() later
copies up to h_len bytes from the fragment pages to userspace on
recvmsg().

When a fragment carries fewer payload bytes than h_len accounts for, the
bytes between the end of the received payload and h_len are read from the
unwritten tail of the fragment page.  That page comes from the per-CPU
receive cache and is not zeroed, so recvmsg() returns stale page contents
to userspace.

Zero the unwritten tail of a short fragment page on receipt, so the copy
can only ever return received payload or zeros.  Fragments that fill the
page are unaffected.

Confirmed under KMSAN: without this change recvmsg() returns stale
frag-page bytes and KMSAN flags an uninitialised copy in
rds_ib_inc_copy_to_user(); with it the same over-read returns zeros and
KMSAN is clean.

Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@naver.com/
Reported-by: Shubham Antil <shubham@octane.security>
Reported-by: Giovanni Vignone <gio@octane.security>
Reported-by: Robert van Eijk <robert@octane.security>
Reported-by: Paolo Gentry <paolo@octane.security>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Shubham Antil <shubham@octane.security>
---
v3:
 - Zero the unwritten fragment tail instead of dropping the connection.
   A zero-copy send with a small iovec segment can legitimately produce a
   non-final fragment shorter than RDS_FRAG_SIZE, so the v2 length check
   could force a reconnect on well-formed traffic; zeroing the tail avoids
   that while still keeping uninitialised bytes out of recvmsg().
   (Raised by the Sashiko review.)
 - Drop Reviewed-by, since the approach changed.
v2:
 - Add Reported-by (sungbyeongchan, first to report, and the Octane
   Security reporters).
 net/rds/ib_recv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index bd6cb3ffa..9695c7f24 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/highmem.h>
 #include <rdma/rdma_cm.h>
 
 #include "rds_single_path.h"
@@ -949,6 +950,19 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 		}
 	}
 
+	/* The device wrote only data_len bytes into this recycled fragment
+	 * page.  Zero the unwritten tail so a later rds_ib_inc_copy_to_user(),
+	 * which copies up to the peer-declared h_len, cannot hand stale page
+	 * contents to userspace.
+	 */
+	if (data_len < RDS_FRAG_SIZE) {
+		void *frag = kmap_local_page(sg_page(&recv->r_frag->f_sg));
+
+		memset(frag + recv->r_frag->f_sg.offset + data_len, 0,
+		       RDS_FRAG_SIZE - data_len);
+		kunmap_local(frag);
+	}
+
 	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
 	recv->r_frag = NULL;
 
-- 
2.43.0

