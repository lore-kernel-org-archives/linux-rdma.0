Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE4821CA13;
	Fri, 13 Feb 2026 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770954851; cv=none; b=acPqraiInqdDOfi47yTger/3pjgnYNtFEIAEjFGbx98Bpr+VdIl/I5/EM8sX9oxKO5qbHhnQRu7Rwf8RaJnyIZJiumHD33uyS3ansiiitUhu6psgJPT8a7vqRRza2jaKRMaH1cKk7khY2UaAJh3P+dQ5HaxyJIbyJ1eouK1KoVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770954851; c=relaxed/simple;
	bh=j3L15o309ByFtBtp47cJcGfKNymgf1cc1XknsWZtO44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FzSi82J5fcgh84MgQOw68uafZ/75TJNwEP1IlN0p3ja1eDDcCyPAMTvBtJiOGSwvpg/gZpxjaqec32fZTU98DE5XKZhLvQY+xFo0a/i/Ms11AwbpXuBmY4tROxmrZ3lxGUlbiNe8cTqvKApk02QbflDMfb77sVf3J5jlFQPAtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Um5zlyod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Um5zlyod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE41C116C6;
	Fri, 13 Feb 2026 03:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770954850;
	bh=j3L15o309ByFtBtp47cJcGfKNymgf1cc1XknsWZtO44=;
	h=From:To:Cc:Subject:Date:From;
	b=Um5zlyodtKajsyI9sUpRvYdoeNEWBZEZh/SI5WFJ+RfGEsXh533W8gkDLVJpn+57R
	 H8E309RNTJYOGjxxF/58mDxJIw45lfZkKYautQsbqgeubz8nB2OwjqjxIHi/RSG4TX
	 QBLEDcDt5E2sA2XZwdyugq40AZ8S3Fo8VcwsoUK3PD79DeCiX+7Bvz/IDZLhfIEBSq
	 AbstHN3Ld4aU1C8O+CM8IWNhrJJgWxuph2ZrWpM4CQCmHnq8AsdXFsL4GVKndinmgd
	 f8yCoBb+YOhUL5v3leuFLat+hAH51Pz0CV/CGP7TWz94BvrAx9s8Ho9u4AD35AFSUG
	 CKtnS0Xgtapog==
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
Subject: [PATCH net v3] net/rds: rds_sendmsg should not discard payload_len
Date: Thu, 12 Feb 2026 20:54:09 -0700
Message-ID: <20260213035409.1963391-1-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with
connection teardown") modifies rds_sendmsg to avoid enqueueing work
while a tear down is in progress. However, it also changed the return
value of rds_sendmsg to that of rds_send_xmit instead of the
payload_len. This means the user may incorrectly receive errno values
when it should have simply received a payload of 0 while the peer
attempts a reconnections.  So this patch corrects the teardown handling
code to only use the out error path in that case, thus restoring the
original payload_len return value.

Fixes: 3db6e0d172c9 ("rds: use RCU to synchronize work-enqueue with connection teardown")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>

---
Changes in v2:
- Rebased on net/main to fix apply failure in v1

Changes in v3:
- Rebase to updated net/main

Signed-off-by: Allison Henderson <achender@kernel.org>
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

