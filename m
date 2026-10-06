Received: from cvsmtppost06.nm.naver.com (cvsmtppost06.nm.naver.com [114.111.35.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343FF37C119
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311974; cv=none; b=PKN7euB2mF/JWGjAcdaVIf0aknckOF+u1edEgywGW1KBLRFwMXfg6ZuK8CQeEZQesQw2hQBsVJ69gP8dDHBAObhf4pZulheWyI9JtQFrYePEqv9lSnqrqL7b2lCZoKdie4YCVzcBZIvC6MR9tH4gbI/p42Mni6R71cki5dtuZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311974; c=relaxed/simple;
	bh=CJi3s/0v6JU4A6iTZVVHnEv5OWBNiUuN4DmFKtXQuMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h/DtNRhgnsc9HYrBqEk9NbS0TYm0KTvDYSQPJyE8fvGMhH8tRuodL1+rPmiRBwydB4G6v3htAFpJRl7Yzzw9o8NPKFPFvBZFPmHzF5UCoqTdnzw9DEo9cruqAnS0OOCZlccPXSIkEpls68ZijPB6M/CTbftR3g0YBr7y9WhlEag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=fDBr9mCP; arc=none smtp.client-ip=114.111.35.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="fDBr9mCP"
Received: from cvsendbo019.nm ([10.112.22.34])
  by cvsmtppost06.nm.naver.com with ESMTP id RB6JsOtITnu7dDZC4SHApg
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 18:39:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791311970; bh=CJi3s/0v6JU4A6iTZVVHnEv5OWBNiUuN4DmFKtXQuMA=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=fDBr9mCP0PzE6YpIx54R+cybDPyd5ognJ1ZcxaM6ozE2KieNQQLLfdVyPbnfVGKJY
	 7UMAmIN2WQim5oOyYbpyRowerwV/IRH4zxT6+hTHcqfsvT50z2hKXwHgBLmkhjaZdV
	 rtPJ6HJZ/ay1IYCN014CO1utXJp56Nj1hhF0Fw0iN1KpD+3PdakDTc+RVTNk3OW3b3
	 +GsUc8g8Bm2jlBKh5Jco7d+7Az3hLW5N9S9bWO8Lq1CTd79qG6kbzX6ZGH3R1adE1Q
	 BdHBHxRE9nbvBV0gDs2eoEnftrngQ+Sr+yreJffc4oJuwKZxYFVXVOIjXaIcJbFT/2
	 JNjvim/2YFc9A==
X-Session-ID: zJjiOR3iRcuLxonRdmXMKQ
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: sdbXKoulFqJZ+HmmFqEl+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp007.nm.naver.com with ESMTP id zJjiOR3iRcuLxonRdmXMKQ
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 18:39:30 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/rxe: enforce memory window ranges
Date: Wed,  7 Oct 2026 03:39:18 +0900
Message-ID: <20261006183919.1304642-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RXE records the address and length authorized by an MW bind, but the
responder does not compare a remote request with that interval. After
validating the MW key, PD, QP, access, and state, check_rkey() selects the
backing MR and applies only the broader MR range check.

A peer with a valid rkey for a 64-byte type-2 MW could consequently READ
and WRITE another address in the same 4096-byte backing MR. In two runs,
an eight-byte READ returned the exact nondelegated sentinel and an
eight-byte WRITE replaced it with the peer's chosen bytes. In-window
operations succeeded and a request crossing the backing-MR end was
rejected.

Check the complete request extent against the MW interval before selecting
the backing MR. Use subtraction-form comparisons to avoid addition overflow
and handle zero-based MWs relative to address zero.

The fixed kernel rejects outside-window READ and WRITE with remote-access
errors while preserving normal in-window READ and WRITE.

The demonstrated impact is access to registered userspace memory outside
the delegated MW. Kernel memory access, code execution, and privilege
escalation were not demonstrated.

Fixes: cdd0b85675ae ("RDMA/rxe: Implement memory access through MWs")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8f..01eb111f81ca6 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -520,6 +520,8 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 	pktlen	= payload_size(pkt);
 
 	if (rkey_is_mw(rkey)) {
+		u64 mw_start;
+
 		mw = rxe_lookup_mw(qp, access, rkey);
 		if (!mw) {
 			rxe_dbg_qp(qp, "no MW matches rkey %#x\n", rkey);
@@ -527,6 +529,14 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 			goto err;
 		}
 
+		mw_start = (mw->access & IB_ZERO_BASED) ? 0 : mw->addr;
+		if (unlikely(va < mw_start || resid > mw->length ||
+			     va - mw_start > mw->length - resid)) {
+			rxe_dbg_qp(qp, "request outside MW range\n");
+			state = get_rkey_violation_state(pkt);
+			goto err;
+		}
+
 		mr = mw->mr;
 		if (!mr) {
 			rxe_dbg_qp(qp, "MW doesn't have an MR\n");
-- 
2.43.0

