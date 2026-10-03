Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5206047255A;
	Sat,  3 Oct 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045328; cv=none; b=j76L4Sh8TOPUsJchuJi0CHQ+0uZtzP/saMKd15fvL8Bb1rbvNDgt/ImFtAp7RQcBPOk3bCan3BkpcIINEAbPAVOTb6nTcMVvXWxD1rURknrkcYShKoXdQVUeoKSsxjek1FhwT69gcQvyhkNmGMWWY+feJNYw6H/Re2FSIP1+X+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045328; c=relaxed/simple;
	bh=7P5haTQVhP8gUZwWXPA5DaBWwruqAwOAUIlUekyZu2U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CkXMrCfC7/jc1DzXioHGn+IPC/GXPg7/rLhSM5T6Y4fokaanAPLzKVCZLyXmUKMg2j7YASTSqjGO8u+ddrJGCTyR3Ga1GRM7/zJ3ighODgvvYJgFo5zv8Q3qXA94MYknCV/LWZqdYjdL9iL4s/hLQ8zq939zUezJWXhpos4jH2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drNqF8Wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drNqF8Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5E31F0089B;
	Sat,  3 Oct 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045327;
	bh=F9KWweFw1xj/dFmgE0bxq2l5YmXG9MzCEOyS98AAsyE=;
	h=From:To:Cc:Subject:Date;
	b=drNqF8WfKQldS+2zbIZzhZHgjQLP1Vr+hq0fXQr0hfbYLh/MynXUmxIVvJ9A0eEZL
	 GOGGHo0Olj4toPtFcoO/ESsZ39NeY+Q3Ed4y0EI0Yjg0YwdhjDQT4gKt0wEOePVTNf
	 nmhqBrfhGL58DnePckMMR8rrWMkLhS6KCc+i9Hz5AbtWZrUWtcmgCowb2HDeiMZr+R
	 ZJwNFiMdRS9gvgGZBiY7LpJrBkTNVXb1MXFpGcOUHqdFjGXLRAvbYBIOaW/I61xEnn
	 TwoGeROUwweOQDhMZM66uowspv2IlbP4qBPau61SKF47ZwF6dzjMtxcRbS0/3DNA+X
	 OoDWY61Q0LinA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v3 0/2] net/rds: scope-aware sendmsg connection cache
Date: Sat,  3 Oct 2026 09:35:24 -0700
Message-Id: <20261003163526.250805-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v3 of the sendmsg connection-cache scope fix (v1 at [1], v2 at
[2]), now two patches.

  Patch 1 gives the connected peer's link-local scope its own field.
  rds_connect() used to store it in rs_bound_scope_id, the scope of
  the socket's own bound address, which a later bind() to a
  non-link-local address resets to 0 and which a later connect()
  pollutes for a globally bound socket.  A send without a destination
  now takes its scope from the connected peer's field, and rds_bind()'s
  connected-socket check compares against it.

  Patch 2 compares c_dev_if with the request's scope in the cache-hit
  test, so the cache uses the same key as rds_conn_lookup().

Changes since v2 [2]:
 - The v2 "scope 0 matches anything" wildcard is gone: it sent a
   connected socket's traffic out whichever interface the socket last
   used explicitly (review of v2).  Instead the destination-less send
   carries the connected peer's scope (new patch 1), and the comparison
   is exact.
 - Rebased onto current net.

Changes since v1 [1]:
 - A request without a scope kept matching the cached connection
   (superseded by the above).

[1] https://lore.kernel.org/netdev/20260921215046.174745-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260927062312.169097-1-achender@kernel.org/

Thank you,
Allison


Allison Henderson (2):
  net/rds: keep the connected peer's scope id apart from the bound one
  net/rds: include the scope id in the sendmsg connection cache check

 net/rds/af_rds.c | 12 ++++++++----
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/send.c   |  5 +++--
 4 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.25.1

