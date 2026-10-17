Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8422931F4;
	Sat, 17 Oct 2026 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207440; cv=none; b=C+K5R+sNhICvcYOH873cHjqAXY7BXP2sRy/dk0zyAbjbzj/SV6VeOzp3jgtCcs1oClwtpQ3qseFONbK79GJNpJ9mxQbu5XFIeEvlldvy2JN2Aqat3DS2nqSilc2i6FGABwX3Gri6xQV9619z8z0uoKCao3VCM0ETBsdwVs8Wonw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207440; c=relaxed/simple;
	bh=iBiBVh5QrvHtU5Enr/Cua8MXpD8nAt99eDeqIdX+rtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d/d6YxYVwmM6YAFP/fBwFhDW3YFW1wlf/bWA0I6jideY1ZrASIptFb7JTl8rIBdMxqkFqjR5SlvrcsIP5Xo8muzhnpzWBx7PBLXv/bRH1UJXiu9Vv5FOiJK/J3kJzEXh5MtmIQGaVQ5BwapOwyz0NHkG78Pz+TPfN+e/f8UnG+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NP8TfUDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NP8TfUDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F4F1F000C4;
	Sat, 17 Oct 2026 03:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207439;
	bh=IUPaOfXSNH1I8mBSQOpbB/CrSbGJzOFXTtCcePYFWaM=;
	h=From:To:Cc:Subject:Date;
	b=NP8TfUDZsWvM5j8Xomp1eBHvMkYPTDbjoBov1yG6V9I7uh28vFHNUW/7UaERsEP+G
	 sizz7gYAZcxNYa/qoRTDQlakoq55f7Qo43bASK7GZMFzW/V2MVhRwXCKM/772JdAjA
	 41yrfDwg5WuOMxqIHQCSYh2hp+ZNnJXBk5cVDBchWV72Oq0yc4Vcxsfi5LORrN0v4m
	 qfOXjV3GaqZSLNNOpBIkbBfnjmgAFFUZAK8WHcskB9Bcv89JKMee40Um6eLuEYRSlF
	 Tpkm1HIZU5lxGpG5bHMNwhufkive2gBnZxCD/Hd62/btyRu+6/XyrdBPY2BIfOhzDz
	 2yHw8md5XUqNQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v5 0/2] net/rds: scope-aware sendmsg connection cache
Date: Fri, 16 Oct 2026 20:23:56 -0700
Message-ID: <20261017032358.2563121-1-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v5 of the sendmsg connection-cache scope fix (v1 at [1], v2 at
[2], v3 at [3], v4 at [4]), now against net-next as Jakub suggested:
neither issue has been observed in the field, and both were found by
inspection while reworking this cache for the connection-lifetime
series.

  Patch 1 gives the connected peer's link-local scope its own field.
  rds_connect() used to store it in rs_bound_scope_id, the scope of
  the socket's own bound address, which a later bind() to a
  non-link-local address resets to 0 and which a later connect()
  pollutes for a globally bound socket.  A send without a destination
  and getpeername() take the connected peer's scope from that field;
  recvmsg() reports a link-local sender with the interface its
  connection came in on.

  Patch 2 compares c_dev_if with the request's scope in the cache-hit
  test, so the cache uses the same key as rds_conn_lookup().

Changes since v4 [4]:
 - Patch 1: recvmsg() takes a link-local sender's scope from the
   connection the message arrived on (c_dev_if) and reports 0 for any
   other sender, instead of the socket's connected or bound scope - a
   connected socket receives from any peer, so a per-socket scope was
   wrong for every sender but the connected one and could send a
   reply out the wrong link (review of v4).  getpeername() and
   recvmsg() now agree for the connected peer.
 - Retargeted at net-next.

Changes since v3 [3]:
 - Patch 1: a destination-less send falls back to the bound scope for a
   non-link-local peer, so send() and sendto() to the connected peer
   compute the same scope; getpeername() and recvmsg() report the
   connected peer's scope instead of the bound scope.

[1] https://lore.kernel.org/netdev/20260921215046.174745-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260927062312.169097-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20261003163526.250805-1-achender@kernel.org/
[4] https://lore.kernel.org/netdev/20261008031426.1142344-1-achender@kernel.org/

Thank you,
Allison


Allison Henderson (2):
  net/rds: keep the connected peer's scope id apart from the bound one
  net/rds: include the scope id in the sendmsg connection cache check

 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   |  9 ++++++++-
 net/rds/send.c   |  9 +++++++--
 5 files changed, 28 insertions(+), 11 deletions(-)

-- 
2.50.1

