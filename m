Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1BF2236F0;
	Wed, 28 Jan 2026 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769562836; cv=none; b=Vu1PheJbQ/IeclBBffzEDGuRA9nlks69zQAGr2HXdvwYBQY95YkMYemJOh4CUtZW/UNjBfV2PbRhQUEmEvP2Tmu9rj41FP8BJcuY8tod0htnGK3Hgd2oiVzXOvwY0fA7QpnO8OIIjQgr2qdRmFO384b1LORshwa3Gm+Spa3yOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769562836; c=relaxed/simple;
	bh=KHF5TjZ/e33ZkPfoy50mXkJbNt8TNknTRTxCCMOgNSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boDnI4atnRMtqw9eBwUK0hirdVCNzHZcGfVG81vLI7v/XsusGFS9+2UCaxev8uTrrn4rvj9rixrVtMe1ClRKQnUjBrP2oa97KFc0bWrkcrxDOrbTl0o+i3OJXqcHJuIm7iwemdn+hEQ8Hc3Zvnhs7vis1qO7Y+jwF9Iht2S+zj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFebnD+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFebnD+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF4CC2BC86;
	Wed, 28 Jan 2026 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769562836;
	bh=KHF5TjZ/e33ZkPfoy50mXkJbNt8TNknTRTxCCMOgNSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFebnD+kkeCQhevlRG7yMhLtMTl+Ig5AGAC722kmkfNd1IeBvtI6ApfY3jmSewbXp
	 JuZpt8gOhO32VhQyllYimCkXWGBddGWrOp558YCc1peef1Fg8oDSpP117WTZk6WAjH
	 MU+dbargDjX/wYLq5W6IztXBOdktgX4Q2md1kCqssm4FiO8bEtG1pK12yMkVftlod5
	 E2S1DMX3WX/U0rG7VIMklprRB24TB+Fj9Z3S2f/oL9C8bIY+OyrY+3JiGE2o6KTDmn
	 KIYTdC127lVWnSvULYfxyn1rd/3gZm2KbdtK4ryOCh0tu2MEoTRw10Q7QMiMP7/Unv
	 Aj7TIvN+6cr4w==
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
Subject: [PATCH net-next v2 4/7] net/rds: Kick-start TCP receiver after accept
Date: Tue, 27 Jan 2026 18:13:48 -0700
Message-ID: <20260128011351.78511-5-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260128011351.78511-1-achender@kernel.org>
References: <20260128011351.78511-1-achender@kernel.org>
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
index ec54fc4a6901..c628f62421d4 100644
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

