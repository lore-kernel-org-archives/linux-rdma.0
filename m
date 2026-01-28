Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627A4227563;
	Wed, 28 Jan 2026 01:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769562837; cv=none; b=FqEkpxO9eIQHh8KCMUi5sWuIxFGrNHo6i6qQNikrg0/FZSZeLyv0ezXTs7mBFxc0ADI2Z8K08QjN8T3ZC8VNIJD+wp9yX92p/amK7EiZ9ugDmln4PHDQ/FcnfHl5WGSDFIhooPaadGEo9o96DD0YNNw2soKdpyLuBFR/ZlK9pKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769562837; c=relaxed/simple;
	bh=YZvCmVjouOSOm1pcxaO24JXHnRqJmdoBqq6+LTkBkhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BCa81FRgTZ2GvDrSeFq8xM3ecukk5DfzTBWdqmzAwhiexmCSxzlHwXDmniJDgHpEvff9/bBsY+hECLA2W79a0OBpCpRuNhWThr1zQ9trcUNYAurv7nN2S2adlEKjoM8ZozAMYlHkzP/PZ2gIt8JszElJQ7d+AIdcFFjibiGJSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1Lq+s9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1Lq+s9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55878C116C6;
	Wed, 28 Jan 2026 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769562837;
	bh=YZvCmVjouOSOm1pcxaO24JXHnRqJmdoBqq6+LTkBkhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1Lq+s9sbVZ+05j+oSTF1194H8d1hHN3opW66htNapQJldoQm2Bn1vwhVih50jFLK
	 oVPimP4/qPNYClSCI87BhDVyRRJfrMEz27czAZU5gT3Fj1XLUIddYhYf0C3SHl8C7j
	 PCG7txs0xHXD3/0fUOIhM9vPRqYMw7ppLKWJU0Smva3vM+ACqQAYQB7YnByM1I74Y7
	 WO4SZe4aPx6mrrf9aJSDOSj2+VLEnLDe8BJP9HEuRlW+0YLp+dooog2aZhjppwAAY8
	 qI6duko+1DbWvhuJ7KAXiW4wm0wnpVDN7HDkJJV/ee7G2X5H6AZM8iAF1ZMoKWPxe0
	 WdjrHrg8RneYg==
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
Subject: [PATCH net-next v2 5/7] net/rds: Clear reconnect pending bit
Date: Tue, 27 Jan 2026 18:13:49 -0700
Message-ID: <20260128011351.78511-6-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260128011351.78511-1-achender@kernel.org>
References: <20260128011351.78511-1-achender@kernel.org>
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

