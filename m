Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123DE3A5449;
	Thu,  8 Oct 2026 03:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429269; cv=none; b=giz9SSh2H2KKZqpPJW7RSLH7jBWiL43vpF5U+zC6Vx54jp1JBcMXg0bpgPOd9lk6jUCD6Rpq3ECIKuf6CEH5/VjJn00yzQIrpC8/OzC6r4WSXoYztBIPJ1aq938AfJWdkmG6qkz49TDXhz9TzNg7oKrEnzMb8ZCRqKi3MdGgvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429269; c=relaxed/simple;
	bh=11GuSU/souJxYCXz+Ta/zPiOCb0XAP2PvSi1nVdcJ2I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nkLn/M4iKEIIAO/s+DihKYjMbvlFYojQLxKCw8zj2s690T9gvpz8Y8Y1YtnLy0XOEqyaoPDqGGb8QyEQhOSROhKzP0RMS+thLW+Rmr+gbkbFulik2fgar9AupuYJcyvQxCEc+SudUhSmpTrFIZEXglFwsoyLxeFAHswxOF3F8nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbhiElA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbhiElA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603DF1F000FF;
	Thu,  8 Oct 2026 03:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429267;
	bh=zw7dwWNFvq9IVxkR8Cb4w4vfF2i5/iPChgjAGXI1mm4=;
	h=From:To:Cc:Subject:Date;
	b=TbhiElA0Q8VlcJwj6960mCA8lPrDyYIRUhO2G+Z9R+eIAugxCtmwehWrQBmF3QbEu
	 BtigQ6jIn8WaX7spXqY9xScYEizZH1j0BZGM7SkZooQGckr6SdrcZbS5YOJ1OBZ/cd
	 8YictsGtoaB+v4oQxi/B8ggFnL7iAArTlc2taPUCIL6muBgqqUyvPmC71W9wZ1Qyy5
	 zHZpzgLnBH6p7I7QbVHoKdTBFG2VkhjeE2tHcFN1L0nwNCmQDzwYsLewP+IxROi4Fo
	 Y2tPiy9IlxVu9wA514v38jh92kfXgamiMMn6HokOHUb/JGBOxPyYOYcv2z4uz+uxZe
	 0TBudsHJJIRVg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v4 0/2] net/rds: scope-aware sendmsg connection cache
Date: Wed,  7 Oct 2026 20:14:24 -0700
Message-Id: <20261008031426.1142344-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v4 of the sendmsg connection-cache scope fix (v1 at [1], v2 at
[2], v3 at [3]).

  Patch 1 gives the connected peer's link-local scope its own field.
  rds_connect() used to store it in rs_bound_scope_id, the scope of
  the socket's own bound address, which a later bind() to a
  non-link-local address resets to 0 and which a later connect()
  pollutes for a globally bound socket.  A send without a destination,
  getpeername() and recvmsg() now take the connected peer's scope from
  that field.

  Patch 2 compares c_dev_if with the request's scope in the cache-hit
  test, so the cache uses the same key as rds_conn_lookup().

Both were found by inspection while reworking this cache for the
connection-lifetime series on net-next; neither has been observed in
the field.  The misdelivery in patch 2 needs a socket that sends to
the same link-local address through two interfaces, and the stall in
patch 1 a connect()/bind() order that loses the peer's scope.

Changes since v3 [3]:
 - Patch 1: a destination-less send falls back to the bound scope for a
   non-link-local peer, so send() and sendto() to the connected peer
   compute the same scope (review of v3: a socket bound link-local and
   connected to a global peer stalled otherwise); getpeername() and
   recvmsg() report the connected peer's scope instead of the bound
   scope (review of v3).
 - Commit messages say how the issues were found.

Changes since v2 [2]:
 - The v2 "scope 0 matches anything" wildcard is gone; the
   destination-less send carries the connected peer's scope instead
   (new patch 1), and the comparison is exact.

[1] https://lore.kernel.org/netdev/20260921215046.174745-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260927062312.169097-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20261003163526.250805-1-achender@kernel.org/

Thank you,
Allison


Allison Henderson (2):
  net/rds: keep the connected peer's scope id apart from the bound one
  net/rds: include the scope id in the sendmsg connection cache check

 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   |  3 ++-
 net/rds/send.c   |  9 +++++++--
 5 files changed, 22 insertions(+), 11 deletions(-)

-- 
2.25.1

