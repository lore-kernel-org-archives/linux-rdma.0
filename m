Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE8C3B6C1E;
	Wed, 23 Sep 2026 04:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790136601; cv=none; b=UhaPFKAbW1XUmx6gaQhP02EDIRjVsfewqb3ZZBLsYoVgY8/UT3NeQfhPo2ELBBVRA5nzSrrviWLuqEYkwHGITz5TgdgNDswKwKSyof0qvV3ozp+zCI8eNI9Zza1y/WO6+Sjq0dnfVbORNZSB2HS6DOuHUF1qKDMwejBj1UYw4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790136601; c=relaxed/simple;
	bh=j1aK9+Uy++IRwjgNlfd1wIlCOpwbsqKe6LxIzTq19dU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=J3c+dYlYEBw4pbpZgedeYg3pVN+vp1IgJmaK+ENKWGsBay7FHCA+/lxXsbHG0EeGFGA1BLR0fpWXxULcw/F5OJOIKTSKKLKHF+tAfA6B7uK/WvMRhWKUKbAKceNwBQaULhnalDUwXAVb9ZoYf7emrjXoVYDAodYIdGItvyeyeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8ou6D1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8ou6D1K"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 271A1C2BCB8;
	Wed, 23 Sep 2026 04:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790136601;
	bh=j1aK9+Uy++IRwjgNlfd1wIlCOpwbsqKe6LxIzTq19dU=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Q8ou6D1KhMU6A7J+u8/P6/mVOZKnYPEBdv7LhX3cFDtrZWJXs9yjFYtZwrYuYV3m5
	 luNUCvFfpqhFjxguMlYmDqbtOIJx8OygqifmKDBqAhYVeuMQbd1zys7ABf1PVVnL+R
	 uMN2ja3aUwJNQtgniSpDULHhkFQ4UYhk4yrdxA63/R+hu74JZRrmtgSPIABUReuD1c
	 GJidBpbK+TVFnDZTr3JR9nBeoSXQyhsPWYLpej4+2LvxgF3pSCNfEyeDlHRoReA7T6
	 oQf1ZON5xfJwPMuHgpuh8CSkWRyiL8shlhxg/BBnjWhuYB30EIofqFvuJNjIiRLruK
	 9CP7i1jXJenDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0217EC98302;
	Wed, 23 Sep 2026 04:10:00 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Tue, 22 Sep 2026 21:09:58 -0700
Subject: [PATCH] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWN3Q6CMAxGX4X02iajKlFfxXAxtoo1ME07fxLCu
 zPk8nzJ+c4ExipscKkmUP6IyTMVqHcVhLtPPaPEwkCOGncmQs1qeJMffr0mSf02hCGjxtFjGLF
 ocWBFqhvHvD+eugND+XspF+/furYb27t7cMhrAOZ5AQ4XHHCNAAAA
X-Change-ID: 20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-2160ee358b4e
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, 
 Danil Kipnis <danil.kipnis@cloud.ionos.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790136599; l=1555;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=D5EbnVMniwVpv/h4+71Ucz1i6HnqTkhM/rK1ZxWuGb0=;
 b=9effqmgmW2GTIc9ttanljElvpmgL2uBAofiD0G+t96vNEPW/HX/9oacwNvbMiBQH//GA8macQ
 A03allaNXfNDivP+J5/D9RpRBmW/d+cg6x6QAHE/rTENoNYKNQfQuzb
X-Developer-Key: i=quanyeyang@proton.me; a=ed25519;
 pk=9L9FrcvzMgxPaBRU6XV0EnqTgjDqVO596rQKSZ9qZoY=
X-Endpoint-Received: by B4 Relay for quanyeyang@proton.me/20260801 with
 auth_id=963
X-Original-From: Quanye Yang <quanyeyang@proton.me>
Reply-To: quanyeyang@proton.me

From: Quanye Yang <quanyeyang@proton.me>

queue_depth is taken from the server's CM private_data and later
used as a session invariant.  A peer can send 0, which the client
stores and then trips WARN_ON() in create_con_cq_qp() when the
next connection is set up.

Reject a zero queue_depth on ESTABLISHED, same as a bad
magic or version, and fail the handshake with -ECONNRESET.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=8+-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index eac38b57b00d..7fbbb9a53607 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1853,6 +1853,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 	}
 	if (con->c.cid == 0) {
 		queue_depth = le16_to_cpu(msg->queue_depth);
+		if (!queue_depth) {
+			rtrs_err(clt, "Invalid queue depth %u\n", queue_depth);
+			return -ECONNRESET;
+		}
 
 		if (clt_path->queue_depth > 0 && queue_depth != clt_path->queue_depth) {
 			rtrs_err(clt, "Error: queue depth changed\n");

---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-2160ee358b4e

Best regards,
--  
Quanye Yang <quanyeyang@proton.me>


