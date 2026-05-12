Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4782D7DD7;
	Tue, 12 May 2026 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614455; cv=none; b=HvS5IBRp2O9OlDzmRXet+oSXIJu9lZo5QuWYvfGOthWFrvZkQrhS0hbQJkU8khuUD3KaeT6hZVTe+7TUB+DQmdgmQURAbTb0R+k9Ua7BffVEu15h09NzqXQmOZcloYq5ONk8IwIPGk8WIFNUjfXI61kndnjz0/Guj7xm4/UTY/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614455; c=relaxed/simple;
	bh=XnyJ9HXr74bmm4ecRCtrCPQuMKlo0P1cNEN7loRKKHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJLBL9gEGTYgQ47aWcWnmCXeie+pHgo+p/Aoa6UoR9yALyfX5OpCq2aAZgR6aJBn1cliMtbujgQtg0Z5fi8GrYag4qIAIVfsFmF8rny89WxgrG0gTdk4SorN6XPerpGAnJMhRE1LW+0euDhhEDUNtcHrx3QrP/0R8VcGuE7sBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgVS3OmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgVS3OmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09315C2BCF5;
	Tue, 12 May 2026 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778614455;
	bh=XnyJ9HXr74bmm4ecRCtrCPQuMKlo0P1cNEN7loRKKHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgVS3OmErR35CNLEqdszs769IVM+BHo6Wba1mvdzOJNwLbTGj5D8edEnLippz2e09
	 Fk9l7ZuOIaqpV+uk3VCo2vX4CLEH+SzmedLyDcq+IMud73Wh2VVlgWxGIcVo+MQF77
	 RBA35ow8zy2hQZ3NDb0LtupMAzMCUk4KcgeH8BCJ0/m3VdJ1loG+mmG4dbnHfRSIZI
	 dfCpac/sg5Tbp5YmC8t4z+GdmPUPSNCR+Nw1ovUcuKO40GY4lhPXkkCmIUUWPUNC4W
	 zWV0DN27ycBDaMIl7ZR6GVbOs/bVjQH0qGmbrxF+2zoJkJ0rDMVCp2GhXltjoPmvkE
	 30fBXcvIlOREw==
From: David Ahern <dsahern@kernel.org>
To: stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	leonro@nvidia.com,
	linux-rdma@vger.kernel.org,
	David Ahern <dahern@nvidia.com>
Subject: [PATCH iproute2-next v2 1/4] namespace: Add fallback to netns by pid
Date: Tue, 12 May 2026 13:34:04 -0600
Message-ID: <20260512193412.32019-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260512193412.32019-1-dsahern@kernel.org>
References: <20260512193412.32019-1-dsahern@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Ahern <dahern@nvidia.com>

Update netns_get_fd to try the passed in string as a name first. If the
netns filesystem entry does not exist, try converting the string to an
integer and if successful return an fd to /proc/<pid>/ns/net.

This allows netns_get_fd to uniformly handle the 2 common use cases of
specifying network namespace by name and pid.

Signed-off-by: David Ahern <dahern@nvidia.com>
---
 lib/namespace.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/lib/namespace.c b/lib/namespace.c
index 74b7e7caf0e5..0bba3a163563 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -99,19 +99,33 @@ int netns_switch(char *name)
 	return 0;
 }
 
-int netns_get_fd(const char *name)
+/* try str as the name of the namespace first, then
+ * fallback to pid
+ */
+int netns_get_fd(const char *str)
 {
 	char pathbuf[PATH_MAX];
-	const char *path, *ptr;
+	const char *path;
+	int pid;
+	int fd;
 
-	path = name;
-	ptr = strchr(name, '/');
-	if (!ptr) {
+	path = str;
+	if (!strchr(str, '/')) {
 		snprintf(pathbuf, sizeof(pathbuf), "%s/%s",
-			NETNS_RUN_DIR, name );
+			NETNS_RUN_DIR, str);
 		path = pathbuf;
 	}
-	return open(path, O_RDONLY);
+
+	fd = open(path, O_RDONLY);
+	if (fd >= 0)
+		return fd;
+
+	/* make sure string is an integer */
+	if (get_integer(&pid, str, 0) < 0)
+		return -1;
+
+	snprintf(pathbuf, sizeof(pathbuf), "/proc/%s/ns/net", str);
+	return open(pathbuf, O_RDONLY);
 }
 
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg)
-- 
2.43.0

