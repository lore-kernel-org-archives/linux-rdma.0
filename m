Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4253314B8;
	Sat, 31 Jan 2026 01:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822713; cv=none; b=lkQBH6SyD3Fh6D7+Izpzb8UswkMSb+aVWClVur/h7rcClwshQRAQWZLdWxSwPftoQ3RgDudsRJDkxnrGNI61TO9X/OnSUzTpCHwt+5oEiUOgg6qtpldV7dq1wuKtTrHVwgV7ZnUM3vMiegNv7ELWwISIq7f66jsHwcotQHIq/zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822713; c=relaxed/simple;
	bh=YZvCmVjouOSOm1pcxaO24JXHnRqJmdoBqq6+LTkBkhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nuLprYXLB3L4bLcjSjRJMywgLlHhOkeXJXzkr0cvwImvhmCnGXwXXPksVQWuTYg6/lHAWkwq5wVRXc1VLo/97dV0gztIDupQrpGtYUitGWPTuS/VxRJEVPKvnxBj7h2RTddamNUWX9uDPIjiTuDr84kL8l2xXXCp0LFLkmLci0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SC1oEpeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SC1oEpeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED4C4CEF7;
	Sat, 31 Jan 2026 01:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769822713;
	bh=YZvCmVjouOSOm1pcxaO24JXHnRqJmdoBqq6+LTkBkhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC1oEpeL/iHmtwgwWlJCtzftEojIraaj3w4RCEN8yRzQ0u1SVwPI/OHX+YA65hxPZ
	 QLc/5dQzORkbUosGS1fbOCn//5VZ+Q5yKF1Kr3DcNu5OMdV9fzKyeEp4YsJ9vKUrXz
	 SFwdiF0mNINPSmgv6Z5FNd2lBNXuIg/IsdoHdtsfODP02sJAWenSOwibLX/nwnV1fJ
	 fvZrltfRwEvAq/F82IjWZjyQw6IFAfLTU//8EfpJPHbBrZAUmzVA5vOo3qveDuzOjG
	 1LooyMwxOrRzmE0/x6xJ6mHqm1jvUEnhP9b4bsfwMdDx7TXBKX7N06mfIoqEM5CmPM
	 vzcfGs6f6svIA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v4 5/8] net/rds: Clear reconnect pending bit
Date: Fri, 30 Jan 2026 18:25:04 -0700
Message-ID: <20260131012507.814119-6-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260131012507.814119-1-achender@kernel.org>
References: <20260131012507.814119-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

When canceling the reconnect worker, care must be taken to reset the
reconnect-pending bit. If the reconnect worker has not yet been
scheduled before it is canceled, the reconnect-pending bit will stay
on forever.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 net/rds/connection.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 3f26a67f3180..4b7715eb2111 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -442,6 +442,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 	 * to the conn hash, so we never trigger a reconnect on this
 	 * conn - the reconnect is always triggered by the active peer. */
 	cancel_delayed_work_sync(&cp->cp_conn_w);
+
+	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 	rcu_read_lock();
 	if (!hlist_unhashed(&conn->c_hash_node)) {
 		rcu_read_unlock();
-- 
2.43.0

