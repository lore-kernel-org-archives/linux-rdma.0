Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7A3F23B7;
	Thu,  7 May 2026 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778166519; cv=none; b=CYsApUyTTHVzCCgz7rSPvUtNgKRfYBVlpIb+dYKaxPd/5dJ8p/XPVeWWL2j9pA/yN0AwJR5NE3ZPXRC5HHL4foGgIeShGqn3iiSc5Ph3WHhs5SWnfO0RE0iTjifDTbsKztaud30tM8E6LIPLcIJW8ZeIxwyTuuJbTkzt7Ju8TZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778166519; c=relaxed/simple;
	bh=SXIUITwOGAEBChqgHkDlZ0KO2AJuywRrmHkOcxS3OKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT5UQ02+Ot5QiKpXGm1GmKI2h8tTFxhDlZndCPCCzBllkH33zS6oMfT4RWYSAQ+ZCsT5LCADhGFBGrHtiNuskBDxhesgNta3FIDjs3H+ylgH6p/PK2hBKKwpGoYKHa0Za7aMGMqU2eUdmk37xxrInS0WTWT5WNs5QS+f821M2Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sEDswSL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sEDswSL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310DBC2BCB8;
	Thu,  7 May 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778166519;
	bh=SXIUITwOGAEBChqgHkDlZ0KO2AJuywRrmHkOcxS3OKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEDswSL12C1di4LyvhAV2FoQ3Ogz0NxRiWZqNJzylg98RMum4p+bR04x+ubKzV11R
	 hfKOUnK27wDAvox/jbvv13DPHWW5gxGJFRVrFmnGH/M+kXht89Z4SgRvHo7Qm5EohU
	 r0c0cMr3UhmuDrBYZQI0Z8i+p6VUS6dcZOm3qWTbKlW5JOcxVCZNudpN+N1c9TNau1
	 d9EvWLJEAmCT+h1smjOP+i/EqvdyHQKkOHRoud1+w5z7yovWmZzFLvHDSsGuraTnmN
	 +KlqUu+xdI1AHGz+ctaxARpg3WOpqNdVE7wDlMI6R6dcf/8kBrYLsbmr3+5FGC3s/C
	 yZeNothdkoBow==
From: David Ahern <dsahern@kernel.org>
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	leonro@nvidia.com,
	linux-rdma@vger.kernel.org,
	David Ahern <dahern@nvidia.com>
Subject: [PATCH iproute2-next 1/4] namespace: Add function to return fd for netns by pid
Date: Thu,  7 May 2026 09:08:32 -0600
Message-ID: <20260507150836.28105-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260507150836.28105-1-dsahern@kernel.org>
References: <20260507150836.28105-1-dsahern@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Ahern <dahern@nvidia.com>

Add netns_get_fd_pid - verifies string is an integer,
then returns an fd to /proc/$pid/ns/net.

Signed-off-by: David Ahern <dahern@nvidia.com>
---
 include/namespace.h |  1 +
 lib/namespace.c     | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/namespace.h b/include/namespace.h
index 98f4af59..6a6fa438 100644
--- a/include/namespace.h
+++ b/include/namespace.h
@@ -52,6 +52,7 @@ static inline int setns(int fd, int nstype)
 
 int netns_switch(char *netns);
 int netns_get_fd(const char *netns);
+int netns_get_fd_pid(const char *pidstr);
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg);
 
 struct netns_func {
diff --git a/lib/namespace.c b/lib/namespace.c
index 74b7e7ca..f391c694 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -114,6 +114,19 @@ int netns_get_fd(const char *name)
 	return open(path, O_RDONLY);
 }
 
+int netns_get_fd_pid(const char *pidstr)
+{
+	char path[PATH_MAX];
+	int pid;
+
+	/* make sure it is an integer */
+	if (get_integer(&pid, pidstr, 0) < 0)
+		return -1;
+
+	snprintf(path, sizeof(path), "/proc/%s/ns/net", pidstr);
+	return open(path, O_RDONLY);
+}
+
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg)
 {
 	DIR *dir;
-- 
2.50.1 (Apple Git-155)

