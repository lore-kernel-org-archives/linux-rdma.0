Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D5F3B83F9;
	Sun, 27 Sep 2026 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490662; cv=none; b=HqdRmNSnds4o5kroFcPQ82zoU+7m1we/diZhT+Cx3UBTTL5qCTDc2MQkOOBK0CDxrIpkVsfgGoQeB9EHxTIxRKz4+zw3Zy+QOA7BUIAYRpeEAs/WztP+py7W6UM67lS2GeLjp9GmhI4xjqV95SYNS0rd9ybcX8tpp68ylulWdOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490662; c=relaxed/simple;
	bh=xlU9JPGxQbbQ6tUBEtk6dBuhzuisPUzoxd4OAG9vWOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cF6liW5XbEzuVVJZqpCmV4C5U1nfs8C7jA0bWSoLdj1yjLkyHpsWoIlO85eRR7/+kB+W/+EVNCJL9OyY4tozB/TuOgRcYJLbOJpbtE+bn+AhNw2AcpVEdVhQDMebbcJXj3rA3mcxM0Pt5cp6lT53uz59mJ+lUw8rA3OtiYjzdqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaJPbZGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaJPbZGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB17B1F00898;
	Sun, 27 Sep 2026 06:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490660;
	bh=pBOjbN4fahma9x91igeh6YkWLS/3hdI0nC9dKVonbtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NaJPbZGpB/7sMt0CMqibOANIK6fYZl7sjjFum+B4znCYZKIQmHJK6qBjJtkogzQm/
	 bcHCfRqmocXh0JsCUmbfbimf7YZrY2SR0V7lX/l9nM5BYDHEl2otjUGQDYvB6EEu7j
	 6KRHrMjm8v1ORsYKR/YHG6384c2N7MUf3ykXEXfp+25EgTNm+tuBmzJ98L/AUE7TXR
	 RzRolmPve2aqtcEr17ro5i7uv8RwVHNssgXr3BSW5u9OrT89neRAkh5s/Z+9xxEqnd
	 VuEIw8BPQ85rGyUH6JO+RMC6yhDldhiTICcsjcDOiscmEL9syCPfmcSQtUJ/x4WlXR
	 46X7OVUmmSGzQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v4 2/2] net/rds: log the port a listener actually bound
Date: Sat, 26 Sep 2026 23:30:58 -0700
Message-Id: <20260927063058.170273-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260927063058.170273-1-achender@kernel.org>
References: <20260927063058.170273-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_rdma_listen_init_common() reports every listener as being on
RDS_PORT, but only the IPv4 caller binds that port; the IPv6 listener
is bound to RDS_CM_PORT, as rds_rdma_listen_init() explains, and its
debug line has claimed 18634 instead of 16385 since it was added.

Print the port from the address the helper just bound.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/rdma_transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 91ff1dde26af..3f853004c490 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -236,7 +236,10 @@ static int rds_rdma_listen_init_common(rdma_cm_event_handler handler,
 		goto out;
 	}
 
-	rdsdebug("cm %p listening on port %u\n", cm_id, RDS_PORT);
+	rdsdebug("cm %p listening on port %u\n", cm_id,
+		 ntohs(sa->sa_family == AF_INET6 ?
+		       ((struct sockaddr_in6 *)sa)->sin6_port :
+		       ((struct sockaddr_in *)sa)->sin_port));
 
 	*ret_cm_id = cm_id;
 	cm_id = NULL;
-- 
2.25.1

