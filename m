Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5039D301704;
	Tue,  2 Jun 2026 05:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376823; cv=none; b=QTJEqfXADppX1vy84t6lZHcV+oOB1WEZ9EPRTF7OYKuxUVHyRavmTzmtqH6xT6ZQKULnFMzIJCH0W3OnkLeoHzz6orRFbdJXoIR4HCthoLCh2+UeWYFAo15+g6OtCre7J8r8VbQiy+yjOUZeENzbM8Zkq3p2k+7EuFo0IcdtVlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376823; c=relaxed/simple;
	bh=2xw4z+denoQtaqUQTWsmf3BYesfCsapdpHSs5vga+Qw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrPUQJtQSKCabMLYUeBDgJgKaboDrLCJm7rOrUPQRBWmjp8b2t3MIoh+4lrnRoELJfAvmH4YoWijfI6sO6vSu2Or+JQ4UYb2aD4XVtIiOOEVWvibavU34ups20/2ygj/5E+HFmxUkRwXzoUejYF/h/40/uYd7xCWzPMHGf04UoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeN/pKUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeN/pKUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4321F0089A;
	Tue,  2 Jun 2026 05:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376822;
	bh=gFJ8W6CrDyhZmev0pJLOWqhXjFC1ddwFDwPpjpyRgXk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=UeN/pKUsymmpU95tafi+ZF8dofQOQsE2iqGDbtkpmfL7NVdZEbOMciEjFhT/kzxPn
	 ppclcD9USPu5PSxvLNDwjt0UP+LDB6yvYMzGz9/13SmVyvB6iBWpMkHmN3NednYMsu
	 +ecQsIextJsXphEZq1ysJcfk7AEi1CMixPscqCzub8CA4gygG6WKQfqVHm86F6lVsq
	 TgyFrEHSBMwUXxMpl+D+vxiZj86uuUdfY701D9I4nVecuNkGfP2Nkx41exoFcPyM1D
	 NGgkYo6f2cF7jATVFFQ57/Rv+A6dCQVZY4m0eEBXquP4azu10y4RS4YETS5qqZfux3
	 J5J8VG2WyGsdg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH net-next v3 4/4] selftests: rds: report missing RDMA prereqs as XFAIL
Date: Mon,  1 Jun 2026 22:06:57 -0700
Message-Id: <20260602050657.26389-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260602050657.26389-1-achender@kernel.org>
References: <20260602050657.26389-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the RDMA test return XFAIL rather than skip when RXE is not
available, since the RDMA datapath is not run in netdev CI.

Change the three RDMA-prerequisite checks in check_rdma_conf() and
check_rdma_conf_enabled() to exit with KSFT_XFAIL (2) and tag their
messages [XFAIL] instead of [SKIP].

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/rds_run.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/rds/rds_run.sh b/tools/testing/selftests/net/rds/rds_run.sh
index f01c81415331f..cdf487ec97dcc 100755
--- a/tools/testing/selftests/net/rds/rds_run.sh
+++ b/tools/testing/selftests/net/rds/rds_run.sh
@@ -123,10 +123,10 @@ check_rdma_conf_enabled() {
 		probe_module "$2"
 		return
 	fi
-	echo "selftests: [SKIP] rdma transport requires $1 enabled"
+	echo "selftests: [XFAIL] rdma transport requires $1 enabled"
 	echo "To enable, run" \
 	     "tools/testing/selftests/net/rds/config.sh -r and rebuild"
-	exit 4
+	exit 2
 }
 
 # Load the module backing a config that is built as a loadable module
@@ -148,7 +148,7 @@ check_conf() {
 }
 
 # Check kernel config and host environment for RDS-RDMA support.
-# Exits with SKIP (4) if the user requested rdma but prerequisites
+# Exits with XFAIL (2) if the user requested rdma but prerequisites
 # are not met.
 check_rdma_conf()
 {
@@ -163,9 +163,9 @@ check_rdma_conf()
 	check_rdma_conf_enabled CONFIG_RDS_RDMA rds_rdma
 
 	if ! which rdma > /dev/null 2>&1; then
-		echo "selftests: [SKIP] rdma transport requires the 'rdma'" \
-		      " tool (iproute2)"
-		exit 4
+		echo "selftests: [XFAIL] rdma transport requires the 'rdma'" \
+		      "tool (iproute2)"
+		exit 2
 	fi
 }
 
-- 
2.25.1

