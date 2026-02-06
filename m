Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6376126CE2D;
	Fri,  6 Feb 2026 02:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770344663; cv=none; b=MtRGkI7w6L2kBAn7P4YAjujTmyaUkHauoVSA3sRW04KyOu2y+heDGhS54Wts9Y/ahBMbhUrXF/e4yAT/QNOMqK4BO6An2kj948hfvkaZ9Iat/JWASjCQbZHB07YPHb9BGCOkXg2LACc3x2VWawFtwYP6mNno7lQu3OkWjsA1mE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770344663; c=relaxed/simple;
	bh=TUGZs3VCsG3R3upJb5hZDjDQh0S2r6zsbhzPDbzbjhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j97jriuqIlfhikeTWQXAbtyY8gVjSW+TSIdwqqdXSnYqClJyW9D0V/jBjSpXosAHOvTQbb8FElPm7F4MiF3i/ilDtlPoewdTqxmpTA9Ji+ZqKyKtyl1gR9kzpRv2P9dOMiW6JC/6QXx+CYihy3Q3KlG96ErsFke1mrWMlbK8jCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2MCWaS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2MCWaS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A73C19423;
	Fri,  6 Feb 2026 02:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770344663;
	bh=TUGZs3VCsG3R3upJb5hZDjDQh0S2r6zsbhzPDbzbjhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2MCWaS/4d2v5jy/otnmBzgH5ONueOJ3Z//Wltf7fEUAx+nLfkY+gAl8wZ3x6beig
	 Wjk6aiBdCykDnzhnpop3nZ/LHREUTNjsqrX/EJ/ExPG+37Gk7eKDHnf8loaMk19Nh7
	 XISe2uF10wEUU7edyLX+5Uat8zloELP+Vc6/a6Wmxhk8ssdkNglNIuk4LAIP1wCcOg
	 dB07rMu0dpbtXNOjZ5hapQk9ziQY2L00epk5WB8xJpcRdu3ijlD1ar1UiS9+aySHrX
	 PhCdjUXwQRMenSCIJ3X85CVnIeaA1R6yOatXYvub7qKwY+YwNrhf23JxbpFgvs4GLi
	 7Clu4Wq6NQlYg==
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
Subject: [PATCH net-next v1 3/3] net/rds: rds_sendmsg should not discard payload_len
Date: Thu,  5 Feb 2026 19:24:19 -0700
Message-ID: <20260206022419.1357513-4-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206022419.1357513-1-achender@kernel.org>
References: <20260206022419.1357513-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Allison Henderson <allison.henderson@oracle.com>

Commit 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with
connection teardown") modifies rds_sendmsg to avoid enqueueing work
while a tear down is in progress. However, it also changed the return
value of rds_sendmsg to that of rds_send_xmit instead of the
payload_len. This means the user may incorrectly receive errno values
when it should have simply received a payload of 0 while the peer
attempts a reconnections.  So this patch corrects the teardown handling
code to only use the out error path in that case, thus restoring the
original payload_len return value.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 net/rds/send.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 6e96f108473e..a1039e422a38 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1431,9 +1431,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		else
 			queue_delayed_work(cpath->cp_wq, &cpath->cp_send_w, 1);
 		rcu_read_unlock();
+
+		if (ret)
+			goto out;
 	}
-	if (ret)
-		goto out;
+
 	rds_message_put(rm);
 
 	for (ind = 0; ind < vct.indx; ind++)
-- 
2.43.0

