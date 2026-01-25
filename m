Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A362C08D4;
	Sun, 25 Jan 2026 07:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769324816; cv=none; b=EFH6jiHKn0sGmct7g7+jaKkCaJlHbs94+s1Ki0ZU6d5dFaLbijDM5G+xLuOCVKzsnglXALHc2I8a3ru14DSqg9Pl3utk33QvpkPJLvTKf9GiAu//6hXxvhsE9p22Fi5oEBzO9qwgaCcvZvJ8wMIS5w66+X//StsBUAvM0v3LzfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769324816; c=relaxed/simple;
	bh=z6ReYwwgMcLq7QNSL0fbC71HU/ROm6V0HXcZ25KLxNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfcWGsa/EhuphdPXqgAD5ZuqfSNFkQ78o60qRdVNgeSASHrLrbALaKza5U/dkroHRvPEzvkk9dXGA/1TYXwT9c42+886fiydeGOZvSLc8Q2ibzXD84TZ4X0Hgq0fIbG55UBgkTuJuBMcgahuZBXA3EQ3YjbZQnKGamEI/C4fCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n65K1+vS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n65K1+vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895FCC4CEF1;
	Sun, 25 Jan 2026 07:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769324816;
	bh=z6ReYwwgMcLq7QNSL0fbC71HU/ROm6V0HXcZ25KLxNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n65K1+vSzqoiyLwPFnWutRFil+rg7E3pS8fNpzJPg7+3SywmsyYvwPOxY6veeUC+q
	 uRmXkxIAHwcNsiI1nW+jHihVft1m89R+hBZUAwoCv+ReizGo6OxB/E9qaukHKpktFO
	 0rn6W3O/3MfMYgCreZFMqWYoP6pAVfICitPl4ncDU7yqpyGMYuXGSsywoqughtIRSm
	 YvnXgOuzoNgk93fdxtopGPN4e+oWR5F/kyag8cGQtl+DETvtWUupJbk8ZyIfeD2MQm
	 eovq5i0dIjuv6PD5iW1W3gHfdF3zYMXaMWtSSOvcoojb2iRT/OWtXAxq5SfabYBpA5
	 17E2oiSTeEzPA==
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
Subject: [PATCH net-next v1 4/7] net/rds: Kick-start TCP receiver after accept
Date: Sun, 25 Jan 2026 00:06:48 -0700
Message-ID: <20260125070651.207042-5-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260125070651.207042-1-achender@kernel.org>
References: <20260125070651.207042-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gerd Rausch <gerd.rausch@oracle.com>

In cases where the server (the node with the higher IP-address)
in an RDS/TCP connection is overwhelmed it is possible that the
socket that was just accepted is chock-full of messages, up to
the limit of what the socket receive buffer permits.

Subsequently, "rds_tcp_data_ready" won't be called anymore,
because there is no more space to receive additional messages.

Nor was it called prior to the point of calling "rds_tcp_set_callbacks",
because the "sk_data_ready" pointer didn't even point to
"rds_tcp_data_ready" yet.

We fix this by simply kick-starting the receive-worker
for all cases where the socket state is neither
"TCP_CLOSE_WAIT" nor "TCP_CLOSE".

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 net/rds/tcp_listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index ec54fc4a69018..c628f62421d4e 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -291,6 +291,8 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	    new_sock->sk->sk_state == TCP_LAST_ACK ||
 	    new_sock->sk->sk_state == TCP_CLOSE)
 		rds_conn_path_drop(cp, 0);
+	else
+		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);
 
 	new_sock = NULL;
 	ret = 0;
-- 
2.43.0

