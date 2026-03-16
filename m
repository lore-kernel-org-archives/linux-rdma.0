Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7183783BB;
	Mon, 16 Mar 2026 23:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773705530; cv=none; b=NNJbgpLe9d5H1Rlcadhgv/srDm5i6a4WW3ge8lUxDEv8ZiH90LULRuNTjYWY6Stf+yb6YcmpBzPqZa/sRgsvz7Ox7slxax/+nx1hbyOzsWudkTwpEQH7LBOiCF6itKn0xVC/D+VqNWmNCYdbYbL6O6f+GiDsQVAmdbhaloLQwEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773705530; c=relaxed/simple;
	bh=a+dZEUyDdeIHPJiM8oefSvBrM8pYFXqhXmANYTD+3vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g3oLflppJ7I9RyBWb3T4uTFILGJiGyUkm4ycQKan6C0j6/UzIv9nAMB18W7rg/efzgo03HcI9wEiK6CQ+AHFof+7bjpJMrM6fRXQq+AGh4KmrALHgNp9ouP2/BlSlqneD+V2xF4ThYNSZq/5cq79GB6h1kQtsCN7n8Xv4FzPT3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJ1mX8Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJ1mX8Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3A0C19421;
	Mon, 16 Mar 2026 23:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773705530;
	bh=a+dZEUyDdeIHPJiM8oefSvBrM8pYFXqhXmANYTD+3vA=;
	h=From:To:Cc:Subject:Date:From;
	b=QJ1mX8NtKnuWu39FtAk1jpREYWAVb1YzObRCQ6ku0yKy/+sLB/HjqwW4HDBzu0jXd
	 x7XqumFhuzgIDkVPGkgOyDktOAQ7CPdSDhg8OBJL2RvwKTUHJ8mejNfO4jKkKzv5UM
	 80RbM9PP58dR1hEDQNGSdE1SCVQ9a6LXZqp/0O3sAXFr2m3Vvzn7/9+6vRNA322/pf
	 GEbXyr3RDWlWV/RurYMWHjFosbU6unNsjIIBa/pODwQORxEG+GLPncysC1mNg2dC8t
	 EsZ/lCYfgtarqaKCYuyrcm1hvFeZGyxIIWsNxyWrTqwmhlwcz/ODHbv0JTp3m3u9Q8
	 vrP+zviZZgY/w==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	shuah@kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v1] selftest: rds: add tools/testing/selftests/net/rds/config
Date: Mon, 16 Mar 2026 16:58:48 -0700
Message-ID: <20260316235848.2395654-1-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds an rds selftest config.  Also adjust the config
generation script to point to this new file

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/config    | 5 +++++
 tools/testing/selftests/net/rds/config.sh | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rds/config b/tools/testing/selftests/net/rds/config
new file mode 100644
index 000000000000..103f9d941d10
--- /dev/null
+++ b/tools/testing/selftests/net/rds/config
@@ -0,0 +1,5 @@
+CONFIG_RDS=y
+CONFIG_RDS_TCP=y
+CONFIG_NET_NS=y
+CONFIG_VETH=y
+CONFIG_NET_SCH_NETEM=y
diff --git a/tools/testing/selftests/net/rds/config.sh b/tools/testing/selftests/net/rds/config.sh
index 791c8dbe1095..7cf56ee8882f 100755
--- a/tools/testing/selftests/net/rds/config.sh
+++ b/tools/testing/selftests/net/rds/config.sh
@@ -24,7 +24,7 @@ while getopts "g" opt; do
   esac
 done
 
-CONF_FILE="tools/testing/selftests/net/config"
+CONF_FILE="tools/testing/selftests/net/rds/config"
 
 # no modules
 scripts/config --file "$CONF_FILE" --disable CONFIG_MODULES
-- 
2.43.0

