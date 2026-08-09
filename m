Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEC71DF26E;
	Sun,  9 Aug 2026 00:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786236667; cv=none; b=rXJqwH+jHtjOIghNOy7mBpnX2bfnZpgcbVJA80qmka/kx+cRbhGZ/WvLLqFLBUDFGWYrdI8UGZX3fxENBjk4IgSM9mrcjxjXf7RN8OqqObXlXAhOC89DA8LbTUO4q4YelXgChgXd89e/6jEwAT0jy1I90Oehni8aMOB9jWIdDPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786236667; c=relaxed/simple;
	bh=i5qV7wAYUl1B6V5gudH0Br6KnW1TlKFqhkfxHXSkjFk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NyZQxkpnQZsXC482Y8eUYs78KYnaE5RTakcCaaYn+DBRRHXFzNg0mrSG9xN9XEYB6i2BSMFsrQ2573Z6vwFAG9sy4ZgMHiKg76vOraStynOJ7ApgOrLKR8Op7je6ymYbVDVesdAmBwI3/TLggxay5B77+jDmmGKMJKJfWJjkGIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dk2fclnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dk2fclnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6F41F00AC4;
	Sun,  9 Aug 2026 00:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786236665;
	bh=YvNLAIL3K91rW1RmZIOyx0oM2V00aiD6ENApbGea5Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dk2fclnuWjqYtIQNdYLuyMvaEaHyaVxyJ9wKhzCcMy5SWRXtEn01uznLPLefZOmu4
	 mLrC6FRCTu9FQk/0xvkcBTvRls35xKtqcJsxss2QvAb+uenJftjnqFlFmdfn3GQR4d
	 CCrKdMnyWG5phb3OW4puMz9ZXxHKHaP0SJFmqZh5jZG8ztVXs8JQUSWARh+8lURuoz
	 o+/UZGV5z/momB23HbksGQPeUU/qLZRcljbCVFVvnHS5jKntxFt/L4SK+uYndtiu8c
	 uo3qs5ra1hT0JT41/h+yU/2XFkmxWyjCDgJhz2uTsAn8ckSUcppc+Hm/dnWD9InVsD
	 xrh/B/d4VUAVA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next v2 1/2] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
Date: Sat,  8 Aug 2026 17:51:02 -0700
Message-Id: <20260809005103.82371-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260809005103.82371-1-achender@kernel.org>
References: <20260809005103.82371-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

The to_be_dropped list is declared once at the top of rds_send_xmit()
but the function can loop via "goto restart" after each batch.  The
code currently relies on rds_send_remove_from_sock() having emptied
the list entry by entry (via list_del_init()) at the end of the
previous batch; nothing in rds_send_xmit() itself guarantees the list
head is empty when a new batch starts.

Re-initialize the list on every restart, and warn once if it is ever
found non-empty there: entries left on the list at that point would
keep their message reference, their RDS_MSG_ON_SOCK accounting and
their pending RDS_RDMA_DROPPED notification, so a silent re-init
would orphan them.  This is hardening: no user-visible bug is known
in the current code.

This mirrors Oracle UEK commit "net/rds: rds_send_xmit should
INIT_LIST_HEAD(&to_be_dropped) on restart".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: port to net-next (keep the existing LIST_HEAD declaration and
 add only the restart re-init); warn if the restart invariant is
 violated; update commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
v2: name rds_send_remove_from_sock() in the comment; warn once if the
restart-time empty-list invariant is ever violated.
v1: https://lore.kernel.org/netdev/20260806072045.1092968-2-achender@kernel.org/
 net/rds/send.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rds/send.c b/net/rds/send.c
index 309021e0cc9b..15a1b97f13e7 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -200,6 +200,14 @@ int rds_send_xmit(struct rds_conn_path *cp)
 restart:
 	batch_count = 0;
 
+	/* The drop processing after over_batch relies on
+	 * rds_send_remove_from_sock() emptying to_be_dropped entry by
+	 * entry; warn if that post-condition ever stops holding, and
+	 * re-initialize the list head.
+	 */
+	WARN_ON_ONCE(!list_empty(&to_be_dropped));
+	INIT_LIST_HEAD(&to_be_dropped);
+
 	/*
 	 * sendmsg calls here after having queued its message on the send
 	 * queue.  We only have one task feeding the connection at a time.  If
-- 
2.25.1

