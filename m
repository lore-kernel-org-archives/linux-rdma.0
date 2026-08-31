Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458F23FBB44;
	Mon, 31 Aug 2026 12:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788179461; cv=none; b=mBg2NONQ6SNPcaodl3mIU8DL0DwN/JXOV/TxQlK0lOR9EiLAGkcn++UuAxO6ux7xGbbyQRn1eMUCCsbMkQ+p3bKw9xx+CpkF+Opz5+lVwtf2L2ObIANQcBlgri4MZ7OG9RqTNGm5szjsoFkRbtNlG3AlU35MvZuu+654NkdW6XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788179461; c=relaxed/simple;
	bh=8kESiFRNnkEyqsmqiEeTAtwD/twPIyY5fNwDn00OYEY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=BuhhQWc9DmUQWunNPGit7T1CzSqucMOykKHPh1eqSenj5dQbTca8czDLLdJi94EysLUE/O8koYucxbs91i3OJGt1ZtMxlqeEfHcNMkcCmpGRj4Cu/zzyiVpcsHatq81woxKWX++ozqtu6i78G0pzLSoynfqyycCSMlrUxfEzkCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrJf7jzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrJf7jzC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2641C2BCB8;
	Mon, 31 Aug 2026 12:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788179460;
	bh=8kESiFRNnkEyqsmqiEeTAtwD/twPIyY5fNwDn00OYEY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=nrJf7jzCqO8Juaw8ag7xft6eHX1Aerh16Ysoq3vc2Awgkw/1NOq4gWiHG6r9MGxdc
	 cfuaL20QK2CFZcRkiInZNHHU79Guge9y0wXq2rs7G/FdVa+jHNODeNhLzrRVfuTlUw
	 cR8O3GM6OdytbEOaYM9y7BHXMsB4nFO8Zj9QAJQpQclDiX7dPuIreb9vTI2vxDz8gm
	 WgtRl69kZ3jMyjNOjP1ckITC4kLe0XI67/TM+3+k/Khdw7IXdWfg8nX/1EhbrHkFue
	 b/E5Z/iPg9kuHFutSTxGw0QyFFwWdj/548ShsqX+kvOOQsBL2gXtkrICM8omTw/zMM
	 SwobR34RWf0ag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8969C624A4;
	Mon, 31 Aug 2026 12:31:00 +0000 (UTC)
From: Quanye Yang via B4 Relay <devnull+quanyeyang.proton.me@kernel.org>
Date: Mon, 31 Aug 2026 20:30:58 +0800
Subject: [PATCH] RDMA/ucma: Serialize join and leave on copy_to_user
 failure
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-rdma-ucma-mc-uaf-v1-1-b8eeb7046aff@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDC2ND3aKU3ETd0mQgkZusW5qYpmuZZJ5oYGGZZGmQaKwE1FZQlJqWWQE
 2MjoWwi8uTcpKTS4BmaNUWwsAh1Te03QAAAA=
X-Change-ID: 20260831-rdma-ucma-mc-uaf-9b7a089b90a3
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Avihai Horon <avihaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com, 
 stable@vger.kernel.org, Quanye Yang <quanyeyang@proton.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788179458; l=2901;
 i=quanyeyang@proton.me; s=20260801; h=from:subject:message-id;
 bh=N3XkbQXD0jkOovzK5vafwV1Ou+3QGRVYe0LDvdcx34w=;
 b=IxVh3gAhyL0mBxvWCrkT21TIG7bhE4/cOXVYVi7bUaf+5wjESyYMnZDFcznT1819Fj+uxfp9U
 QB9yZwh8dm/CzZryGy83ptOgevddwWJSAupMaSBNI5RcNPTl2H4xYNp
X-Developer-Key: i=quanyeyang@proton.me; a=ed25519;
 pk=9L9FrcvzMgxPaBRU6XV0EnqTgjDqVO596rQKSZ9qZoY=
X-Endpoint-Received: by B4 Relay for quanyeyang@proton.me/20260801 with
 auth_id=963
X-Original-From: Quanye Yang <quanyeyang@proton.me>
Reply-To: quanyeyang@proton.me

From: Quanye Yang <quanyeyang@proton.me>

rdma_join_multicast() queues RoCE work that later reads the ucma_multicast
through event->param.ud.private_data, then list_add()s the CMA multicast
at the head of id_priv->mc_list. rdma_leave_multicast() matches only by
sockaddr and destroys the first hit.

ucma_process_join() used to drop ctx->mutex after a successful join and
retake it only if copy_to_user() failed. Two concurrent JOIN_MCAST calls
with the same address can therefore insert a second CMA entry before the
first thread's leave. leave then cancels the newer work and the older
worker still dereferences the ucma_multicast that the first thread frees.

Keep ctx->mutex held from rdma_join_multicast() through copy_to_user() and,
on -EFAULT, through rdma_leave_multicast() so leave cannot miss this join.
Do not leave if join itself failed: that path never published this address
on mc_list, and a leave-by-addr would destroy an earlier successful join.

Reported-by: syzbot+a6ffe86390c8a6afc818@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a6ffe86390c8a6afc818
Fixes: fe454dc31e84 ("RDMA/ucma: Fix use-after-free bug in ucma_create_uevent")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
---
KASAN + rxe, virtme-ng. The syzbot C repro (two concurrent JOIN_MCAST
with response=0) no longer reports slab-use-after-free in
ucma_create_uevent.

Based on linus/master
---
 drivers/infiniband/core/ucma.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 4929636f7c53..c3611e2f3248 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1556,27 +1556,27 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 	mutex_lock(&ctx->mutex);
 	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
 				  join_state, mc);
-	mutex_unlock(&ctx->mutex);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&ctx->mutex);
 		goto err_xa_erase;
+	}
 
 	resp.id = mc->id;
 	if (copy_to_user(u64_to_user_ptr(cmd->response),
 			 &resp, sizeof(resp))) {
 		ret = -EFAULT;
-		goto err_leave_multicast;
+		rdma_leave_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr);
+		mutex_unlock(&ctx->mutex);
+		ucma_cleanup_mc_events(mc);
+		goto err_xa_erase;
 	}
+	mutex_unlock(&ctx->mutex);
 
 	xa_store(&multicast_table, mc->id, mc, 0);
 
 	ucma_put_ctx(ctx);
 	return 0;
 
-err_leave_multicast:
-	mutex_lock(&ctx->mutex);
-	rdma_leave_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr);
-	mutex_unlock(&ctx->mutex);
-	ucma_cleanup_mc_events(mc);
 err_xa_erase:
 	xa_lock(&multicast_table);
 	list_del(&mc->list);

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260831-rdma-ucma-mc-uaf-9b7a089b90a3

Best regards,
--  
Quanye Yang <quanyeyang@proton.me>


