Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456098;
	b=NYCYkAu2GkwR75+lELkaAzTqSbIsOFBaV9hiK6rMCXHTi+kGv3sj6uo6bidd50vrjHUB
	 xCoNU+9Bs+eyQMSTLHmZBl0VAg1WcO0AkHHzI6VnZbYVcSsKEByRcN09uO2+F1vKt4kzV
	 txI35/rwZyBAL8ixIcVF0gx+njB17uRb/RXnorRDnHk65uY9iNws6Eq+n+hTg7qQp4Kzy
	 0tup4K3dSR/f+4GBTnm8pF+vexKC65O/nlPdhFIe7pcI/sB2lwZn7ac6UX5hfNEKUymHF
	 2hG2EnVA/TH5s9ycbt6OGrUpk7qC8TwUNJrJrXL5vRWONVowx0toRgH0h/M9BOvf9nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+ea9LKm3dup9mnLZmTgtBMVlSm3XwpNGYhLXRG8Rj8=;
	b=Nk9fuoOvA0xd1jESFeTigtXDxiJO4ClBbkhZv3/Z6Oxpf4FWCleiyRs65YnXUWhdBWgr
	 9Nw9MybpRRzC4AwI2+eCcIDWirZl7OIh2cPAfbzLElmR/qYERBfA5WjzwDniM8/pO8Vrf
	 A89QwwLT2uS4qQM5nh0tM+3aul8DqNdNoSd5ipJUSd4KXKVxuGKLC1BT+RDD7zCD2md+6
	 DSDKK5K43TkitEwT9M/Lzw9Wi6oICvnBIYAVCxDvh1kTb98OcqiY9ypclfmHnMKXnjuxP
	 /yPJf90dyiheh4gsApGIvWBJZZAJoTi2CPRiHKeeY+cu8nB337oOg8+Qad02e7oQBYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=az0VvUGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3567606A319;
	Tue, 20 Oct 2026 00:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=az0VvUGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C5B1F000C4;
	Tue, 20 Oct 2026 00:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456097;
	bh=s+ea9LKm3dup9mnLZmTgtBMVlSm3XwpNGYhLXRG8Rj8=;
	h=From:To:Cc:Subject:Date;
	b=az0VvUGONRy1PdhwusOQwBqH3GPkngdh7Pv1Dc5TEjSIXCMDQCjCfn9iFHLXiQg8u
	 oCYiBzXWB18PW+D4Kn3TsPNqQO42PtRa6f9WOLORGInJb2jzTXoVr+CizDV+l3eAlG
	 z9SX9o0Nre2c5Tr8Czh08yBp4Cwz3q3jNsPdABadkLuRzCx2CtM0YElU6IdGsLnIni
	 PxBUAVx4WuGhHm53kJxzCttA6c+W2AXmX3qULlqBpsYMcNhTD3LrKybJr7YqrSnixD
	 ja0B84QgDT2LP66cW3+6Oam/BZ0GT+M/p4CxBlNYe4o8u0fvO3tJCv3hQl9JqQa0ne
	 OnugevaafHZLw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 0/2] net/rds: scope-aware sendmsg connection cache
Date: Mon, 19 Oct 2026 17:28:14 -0700
Message-ID: <20261020002816.3087414-1-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v6 of the sendmsg connection-cache scope fix (v1 at [1], v2 at
[2], v3 at [3], v4 at [4], v5 at [5]), against net-next as Jakub
suggested: neither issue has been observed in the field, and both were
found by inspection while reworking this cache for the
connection-lifetime series.

  Patch 1 compares c_dev_if with the request's scope in the cache-hit
  test, so the cache uses the same key as rds_conn_lookup().

  Patch 2 gives the connected peer's link-local scope its own field.
  rds_connect() used to store it in rs_bound_scope_id, the scope of
  the socket's own bound address, which a later bind() to a
  non-link-local address resets to 0 and which a later connect()
  pollutes for a globally bound socket.  A send without a destination
  and getpeername() take the connected peer's scope from that field;
  recvmsg() reports a link-local sender with the interface recorded
  on its connection.

Changes since v5 [5]:
 - Swapped the two patches.  The scope-field patch lets a globally
   bound socket connect() to the same link-local peer through a second
   interface, and without the cache check in place first the next
   send() would reuse the first interface's connection, so the series
   is now bisectable (review of v5).
 - recvmsg() comment and changelog no longer describe c_dev_if as the
   arrival interface: that holds for TCP, while the IB passive side
   resolves it from the local address (review of v5).
 - No code change beyond the comment.

Changes since v4 [4]:
 - recvmsg() takes a link-local sender's scope from the connection the
   message arrived on (c_dev_if) and reports 0 for any other sender,
   instead of the socket's connected or bound scope - a connected
   socket receives from any peer, so a per-socket scope was wrong for
   every sender but the connected one and could send a reply out the
   wrong link (review of v4).  getpeername() and recvmsg() now agree
   for the connected peer.
 - Retargeted at net-next.

Changes since v3 [3]:
 - A destination-less send falls back to the bound scope for a
   non-link-local peer, so send() and sendto() to the connected peer
   compute the same scope; getpeername() and recvmsg() report the
   connected peer's scope instead of the bound scope.

[1] https://lore.kernel.org/netdev/20260921215046.174745-1-achender@kernel.org/
[2] https://lore.kernel.org/netdev/20260927062312.169097-1-achender@kernel.org/
[3] https://lore.kernel.org/netdev/20261003163526.250805-1-achender@kernel.org/
[4] https://lore.kernel.org/netdev/20261008031426.1142344-1-achender@kernel.org/
[5] https://lore.kernel.org/netdev/20261017032358.2563121-1-achender@kernel.org/

Thank you,
Allison

Allison Henderson (2):
  net/rds: include the scope id in the sendmsg connection cache check
  net/rds: keep the connected peer's scope id apart from the bound one

 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   | 11 ++++++++++-
 net/rds/send.c   |  9 +++++++--
 5 files changed, 30 insertions(+), 11 deletions(-)

-- 
2.50.1

