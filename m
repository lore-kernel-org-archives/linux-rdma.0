Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB29B3451BA;
	Sun,  8 Feb 2026 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770529040; cv=none; b=trVkyy9Nw89OlE08HjT0vANcULzLKfoz9CoHtDcoV+k3ZQnGkccDq3f9+AzAlKf5CCDUY33Sgn+J9CfKdkZUDJSilY/UQFqA8jJYv1sC4z2j4UpaqO1BPjEyE6rvSsCGOmIHeKmP/LMuqD7NIAcc6qbU4L6H0ueMOn2EoX6WeZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770529040; c=relaxed/simple;
	bh=JcN9S1fJE/PJc7rNTHFn48csxe3H653En5P0AHO9C+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKX4mpql+iiD8G3ciXn+ZrOOKwk87Z9immuzAkVVdu8AUUlCDTGb7dOeDVCjlV6B0KukrgdPmCQObfhgbEr+nPTJXC7oroXerTVLUM/PlULMr1fclRjUaP7w3TC3BptyorSrButIfCosmtyj/Lr8nxUIHCk/31Mi8uO29GdHYUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkVrHN8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkVrHN8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0238C16AAE;
	Sun,  8 Feb 2026 05:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770529040;
	bh=JcN9S1fJE/PJc7rNTHFn48csxe3H653En5P0AHO9C+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkVrHN8WBV4o0wup8uzALb4HOCdACc3HHu0c+A9adihbA4vfL0jQL7jDYXLWaZdwS
	 JMe2KdPW1yT30WY/irIihFYQvaLOWjJW4vuhF1hIV2u6wv73mjxwQIRlhnsh41MZ1Q
	 pdIAOwgIDM00n9IG7e2doSE9KqwH+rC/zR5mXBrXymWZqt5F/mrehv+OCVcCmVhcpt
	 S8B/68/NFsN2Qv4jgiGGrI4RBwhM0naKEUZ58bX1Ek3C0LolalC6E1OZuxpyrPTtNI
	 BvISadMrSwkwCUIkreTC2gfTWP7j/UXAP2UrAP6/O76LbAznS9ukONFF4HHn+wbVw1
	 ujdyxi/rOQbWg==
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
Subject: [PATCH net-next v2 3/4] net/rds: Use proper peer port number even when not connected
Date: Sat,  7 Feb 2026 22:37:15 -0700
Message-ID: <20260208053716.1617809-4-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260208053716.1617809-1-achender@kernel.org>
References: <20260208053716.1617809-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Greg Jumper <greg.jumper@oracle.com>

The function rds_tcp_get_peer_sport() should return the peer port of a
socket, even when the socket is not currently connected, so that RDS
can reliably determine the MPRDS "lane" corresponding to the port.

rds_tcp_get_peer_sport() calls kernel_getpeername() to get the port
number; however, when paths between endpoints frequently drop and
reconnect, kernel_getpeername() can return -ENOTCONN, causing
rds_tcp_get_peer_sport() to return an error, and ultimately causing
RDS to use the wrong lane for a port when reconnecting to a peer.

This patch modifies rds_tcp_get_peer_sport() to directly call the
socket-specific get-name function (inet_getname() in this case) that
kernel_getpeername() also calls.  The socket-specific function offers
an additional argument which, when set to a value greater than 1,
causes the function to return the socket's peer name even when the
socket is not connected, which in turn allows rds_tcp_get_peer_sport()
to return the correct port number.

Signed-off-by: Greg Jumper <greg.jumper@oracle.com>
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/tcp_listen.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 8fb8f7d26683..db4938fd1672 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -67,7 +67,14 @@ rds_tcp_get_peer_sport(struct socket *sock)
 	} saddr;
 	int sport;
 
-	if (kernel_getpeername(sock, &saddr.addr) >= 0) {
+	/* Call the socket's getname() function (inet_getname() in this case)
+	 * with a final argument greater than 1 to get the peer's port
+	 * regardless of whether the socket is currently connected.
+	 * Using peer=2 will get the peer port even during reconnection states
+	 * (TCPF_CLOSE, TCPF_SYN_SENT). This avoids -ENOTCONN while
+	 * inet_dport still contains the correct peer port.
+	 */
+	if (sock->ops->getname(sock, &saddr.addr, 2) >= 0) {
 		switch (saddr.addr.sa_family) {
 		case AF_INET:
 			sport = ntohs(saddr.sin.sin_port);
-- 
2.43.0

