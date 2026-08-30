Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C0735C1A9;
	Sun, 30 Aug 2026 07:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788073799; cv=none; b=NaBUaIoSIzzNlOD6qyY6DL0tNqucYKFVkQLy8L9Qu57NYNwY7KrvuZV5crBIhYeXbhX88ZxAnR8VuRNWJNlzx1xyATJfVwXYevl4Q65HyMYlANAaEtQn7AcimUSDgifNtiV2ljfA5nddAu5D8Ptrnk+AjqFD5gTIK5SUYieQTUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788073799; c=relaxed/simple;
	bh=WUy6WoO/WqUl1q9oVvwQFB+Di9tkCZw+1WB5W+xqYpc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kHStPVQy+7XHXauuQM7tS/DIdGIEm9DmfFBYfLPzP9WbfcEpTkpcL0GeKzAMCJVNgdbowUyCNYo1BLHRv04NMdcRo90E+2QgdGTCxszw6fqdjjR+imFLG3b5KwVkCT5HCEHqCZdi6UlrTXinnTWfUtqIUlckiNxj/P/FLp+z4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFUnuKTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFUnuKTD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56737C2BCF4;
	Sun, 30 Aug 2026 07:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788073798;
	bh=WUy6WoO/WqUl1q9oVvwQFB+Di9tkCZw+1WB5W+xqYpc=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=JFUnuKTDT8omAZKCvVKCOpwb7oZgRhlEgwN7hh3qbsL/T9f/DO0prBrW5TVmGpEiJ
	 i6g84lJ8ZMCzCCnQEuvwRvkmDO64k+D5TAy3DoSYT05duA4nYtH8J8ify7e8NeHDUZ
	 gjn1GfHi9athTb2Phs0q54hGSqK4t5LEBE1UbQWsxObLW5XbX3e9GRMHFDOVk+nKpE
	 lRR//Ma35v7WHxbfsKEmDYNBrxrp9oT+xWlMOrN4QIYRP4O8ymWF0mLyFT0zQNh1VQ
	 t+Um/J0NxjSyKY1B1YRjEPDQf5M958eQz0+bRXAH4+M3A1x+PelTLvx2mBruKJJS1R
	 a+/FvS8tX7wrA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CDEC61DE2;
	Sun, 30 Aug 2026 07:09:58 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Sun, 30 Aug 2026 15:09:55 +0800
Subject: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is
 interrupted
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMwQ6CMAwA0F8hPdtkA+KIv2I8jFG0Ohm005AQ/
 t2px3d5GygJk8Kp2kDozcppKrCHCsLNT1dCHoqhNvXRdI1BGZ4eJYtiiBnDgnNKESP5B7putL1
 xjprWQglmoZHXX36+/K2v/k4hf0fY9w/JgTQkfgAAAA==
X-Change-ID: 20260830-rdma-rtrs-clt-cq-pool-leak-78f1b077e341
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com, 
 Quanye Yang <quanyeyang@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788073795; l=3778;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=cn9IkRUu0B89uWfK7vLWOhB21IgObrIMhVPL+RLvT4M=;
 b=aDuIS6UusZbS31KSqt2aMZnI1gtCGGold4AKeQ8ALgGzI9GcUH8Rxd2ul3d4COI5PPUaBxmHb
 6dVUDASJ/bWCiY+RaiE8sp1ALqEDqC8ASBTQjiJx0xgPfa8rdyhgCgx
X-Developer-Key: i=quanyeyang@proton.me; a=ed25519;
 pk=9L9FrcvzMgxPaBRU6XV0EnqTgjDqVO596rQKSZ9qZoY=
X-Endpoint-Received: by B4 Relay for quanyeyang@proton.me/20260801 with
 auth_id=963
X-Original-From: Quanye Yang <quanyeyang@proton.me>
Reply-To: quanyeyang@proton.me

From: Quanye Yang <quanyeyang@proton.me>

The client borrows shared CQ credits in the ADDR_RESOLVED handler via
ib_cq_pool_get(), before the peer is connected. create_cm() can return
-ERESTARTSYS from wait_event_interruptible_timeout() without destroying
the CM ID. The init_conns() and stop-and-destroy paths then call
destroy_con_cq_qp() while cq is still NULL (no PUT) and only afterwards
rdma_destroy_id().

CMA serializes the handler against rdma_destroy_id() with handler_mutex,
but that does not order the GET against destroy_con_cq_qp(). If
ADDR_RESOLVED has already passed the DESTROYING check, it can take
con_mutex, GET credits, and then lose the con to kfree. Device
unregister later hits WARN_ON(cq->cqe_used) in ib_cq_pool_cleanup().

Set a per-connection flag under con_mutex before CQ/QP teardown so a
racing ADDR_RESOLVED cannot borrow credits after teardown has begun.

Reported-by: syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d396918a29afb8543e1c
Fixes: 3b89e92c2a95 ("RDMA/rtrs: Use new shared CQ mechanism")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
---
Fix a syzbot WARNING in ib_cq_pool_cleanup(): an ADDR_RESOLVED handler
can ib_cq_pool_get() after connection teardown has already skipped the
matching PUT.

Reproduced on rxe with rnbd-client only (no rtrs server): write
map_device with path=ip:127.0.0.1, interrupt create_cm() with a signal,
then rdma link delete. Device unregister no longer reports leftover
cqe_used after this change.
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 ++++++++
 drivers/infiniband/ulp/rtrs/rtrs-clt.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 7b2c51ae614f..eac38b57b00d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1732,6 +1732,8 @@ static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 	/*
 	 * Be careful here: destroy_con_cq_qp() can be called even
 	 * create_con_cq_qp() failed, see comments there.
+	 * Caller must set con->destroyed under this lock first so a
+	 * racing ADDR_RESOLVED cannot ib_cq_pool_get() after we PUT/SKIP.
 	 */
 	lockdep_assert_held(&con->con_mutex);
 	rtrs_cq_qp_destroy(&con->c);
@@ -1766,6 +1768,10 @@ static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 	int err;
 
 	mutex_lock(&con->con_mutex);
+	if (con->destroyed) {
+		mutex_unlock(&con->con_mutex);
+		return -ECONNABORTED;
+	}
 	err = create_con_cq_qp(con);
 	mutex_unlock(&con->con_mutex);
 	if (err) {
@@ -2221,6 +2227,7 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_path *clt_path)
 			break;
 		con = to_clt_con(clt_path->s.con[cid]);
 		mutex_lock(&con->con_mutex);
+		con->destroyed = true;
 		destroy_con_cq_qp(con);
 		mutex_unlock(&con->con_mutex);
 		destroy_cm(con);
@@ -2387,6 +2394,7 @@ static int init_conns(struct rtrs_clt_path *clt_path)
 		if (con->c.cm_id) {
 			stop_cm(con);
 			mutex_lock(&con->con_mutex);
+			con->destroyed = true;
 			destroy_con_cq_qp(con);
 			mutex_unlock(&con->con_mutex);
 			destroy_cm(con);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index 1305601a6251..ad64f4517c4b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -75,6 +75,8 @@ struct rtrs_clt_con {
 	unsigned int		cpu;
 	struct mutex		con_mutex;
 	int			cm_err;
+	/* Set under con_mutex before CQ/QP teardown. */
+	bool			destroyed;
 };
 
 /**

---
base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
change-id: 20260830-rdma-rtrs-clt-cq-pool-leak-78f1b077e341

Best regards,
--  
Quanye Yang <quanyeyang@proton.me>


