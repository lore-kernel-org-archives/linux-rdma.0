Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C71304BB2;
	Thu,  7 May 2026 23:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778196736; cv=none; b=uu3cBIg0qpF1ng7uU7w64l+FtMT8ZkLX2ew4V5LiWu0pqrN4Q4ikLZysPDTeTbJtwxGx6Nkt8TlkxQ5BvxEyiIJQVwwo3/CVFIGOhs3nvLz1Qia1PZAGt/8S0kKgVvoVyM1FtzWfEiVRmOVoBRsQlIXaDu3dsfwxjP1Ak51h5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778196736; c=relaxed/simple;
	bh=J8FLX/8S7d0qEfvsXh9CL7q60+tVl1XPXSiN27j1vMM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=izeDZ0qcBKApldGC8qM5HKmzDZKVmngdd0jlYOPSltA25YkFDxkP8A4M6f7Z+onAnvqdooW8s6Rdpyzlp3xDdaEXimOOe9wizx0oOPP8IyJAjnvWXOWpJdMyiCA7EA/W6GI0ScBGg8cMLWuGnPAeduIF/Y4iDHYrJA3hwcztprA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNG8PA0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNG8PA0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99007C2BCB8;
	Thu,  7 May 2026 23:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778196736;
	bh=J8FLX/8S7d0qEfvsXh9CL7q60+tVl1XPXSiN27j1vMM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LNG8PA0C1YxpUd1NXzQNBPFwxQgHpm1oT/DOZi9V7Lrh71Dx13h6E3HGOOwBJMjUm
	 6I7P/eusPDLA/NLMfUgZHChW2CorsKPLbp5bMT1WbpIG0zEnGEii1Eo3Wbn4KTdZeW
	 CaBbvH7mqJyRGKj0DZyMq+1i6/bS4ZCnX1IhRCbZmLwoW9DZSk/xnuIa05ssXStGc6
	 oteO2kmtgdsgp4h86vRWEtJlfrll8uLtqIUUPNzB94N+/eNXBkuYgaZIlXA1jqG2c4
	 eLbSODA9Lgd2T6YmkzfRXdupVs7Lxi9NAlChdYI0xNhYvg5oqCVrx+p6SzotbDy4Hq
	 65KkUwv43wvJw==
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
Subject: [PATCH net-next v1 2/3] selftests: rds: Fix TAP-prefixed prints in check_gcov*
Date: Thu,  7 May 2026 16:32:12 -0700
Message-Id: <20260507233213.556182-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260507233213.556182-1-achender@kernel.org>
References: <20260507233213.556182-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds the # prefix to info and warning prints in
the check_gcov* routines.  Since these routines do not exit,
as the other check_* routines do, the output here should be
kept TAP compliant.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/run.sh | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
index 4930aed8846b..424fd57401d8 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/run.sh
@@ -35,7 +35,7 @@ GCOV_CMD=gcov
 check_gcov_env()
 {
 	if ! which "$GCOV_CMD" > /dev/null 2>&1; then
-		echo "Warning: Could not find gcov. "
+		echo "# Warning: Could not find gcov. "
 		GENERATE_GCOV_REPORT=0
 		return
 	fi
@@ -48,7 +48,7 @@ check_gcov_env()
 		GCOV_CMD=gcov-$(gcc -dumpversion)
 
 		if ! which "$GCOV_CMD" > /dev/null 2>&1; then
-			echo "Warning: Could not find an appropriate gcov installation. \
+			echo "# Warning: Could not find an appropriate gcov installation. \
 				gcov version must match gcc version"
 			GENERATE_GCOV_REPORT=0
 			return
@@ -58,11 +58,11 @@ check_gcov_env()
 		GCOV_VER=$($GCOV_CMD -v | grep gcov | awk '{print $3}'| \
 			awk 'BEGIN {FS="-"}{print $1}')
 		if [ "$GCOV_VER" != "$GCC_VER" ]; then
-			echo "Warning: Could not find an appropriate gcov installation. \
+			echo "# Warning: Could not find an appropriate gcov installation. \
 				gcov version must match gcc version"
 			GENERATE_GCOV_REPORT=0
 		else
-			echo "Warning: Mismatched gcc and gcov detected.  Using $GCOV_CMD"
+			echo "# Warning: Mismatched gcc and gcov detected.  Using $GCOV_CMD"
 		fi
 	fi
 }
@@ -71,20 +71,20 @@ check_gcov_env()
 check_gcov_conf()
 {
 	if ! grep -x "CONFIG_GCOV_PROFILE_RDS=y" "$kconfig" > /dev/null 2>&1; then
-		echo "INFO: CONFIG_GCOV_PROFILE_RDS should be enabled for coverage reports"
+		echo "# INFO: CONFIG_GCOV_PROFILE_RDS should be enabled for coverage reports"
 		GENERATE_GCOV_REPORT=0
 	fi
 	if ! grep -x "CONFIG_GCOV_KERNEL=y" "$kconfig" > /dev/null 2>&1; then
-		echo "INFO: CONFIG_GCOV_KERNEL should be enabled for coverage reports"
+		echo "# INFO: CONFIG_GCOV_KERNEL should be enabled for coverage reports"
 		GENERATE_GCOV_REPORT=0
 	fi
 	if grep -x "CONFIG_GCOV_PROFILE_ALL=y" "$kconfig" > /dev/null 2>&1; then
-		echo "INFO: CONFIG_GCOV_PROFILE_ALL should be disabled for coverage reports"
+		echo "# INFO: CONFIG_GCOV_PROFILE_ALL should be disabled for coverage reports"
 		GENERATE_GCOV_REPORT=0
 	fi
 
 	if [ "$GENERATE_GCOV_REPORT" -eq 0 ]; then
-		echo "To enable gcov reports, please run "\
+		echo "# To enable gcov reports, please run "\
 			"\"tools/testing/selftests/net/rds/config.sh -g\" and rebuild the kernel"
 	else
 		# if we have the required kernel configs, proceed to check the environment to
@@ -208,7 +208,7 @@ if [[ -n "$LOG_DIR" ]]; then
 fi
 
 set +e
-echo "#running RDS tests..."
+echo "# running RDS tests..."
 "${TRACE_CMD[@]}" python3 "$(dirname "$0")/test.py" "${FLAGS[@]}" -t "$TIMEOUT"
 
 test_rc=$?
-- 
2.25.1

