Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BD82C21C3;
	Mon,  4 May 2026 05:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777873311; cv=none; b=aUGq/3bUrW4uKiLMqwk38pGXG5F8u1BEgRh/OBrquWkccaPjduXvdsEl7kRo2kVLeK8xrDXRelcqH7b/XPrk/u/qKo78vQYTuZxWJyJg++rY+3nEyAZPb+THprCV/jHZlgwRZDM0RRF8MTaEPV41t6zYukEj7jkHft16kpw999w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777873311; c=relaxed/simple;
	bh=QLLJOK5MJdS7kMIsHrw3c6NmYF4R9oN92XVLBq5USGk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pdqdf9Zlx1frAqVFRpXOzKnzvFkmQ2maUlp1ONIk/1NOrxZXLgLtkVQbVvcvqqyebl1JxEGkweBYQhe0LfREO8RkzqKkqa0mqRoPLwtyuYykClnry3t6VpU4DgGJwDyLTAoNDQVld++1lNA8M0B6ofLKoV/1t2SmFrCUZYGhoAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwkIHdxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwkIHdxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829B6C2BCB8;
	Mon,  4 May 2026 05:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777873311;
	bh=QLLJOK5MJdS7kMIsHrw3c6NmYF4R9oN92XVLBq5USGk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XwkIHdxTVRjXmWAF0fb7UPaT3ar6IBn2Y2IKKBnvinAJHSTj2beVaWnRlbZaxC9Zu
	 i9Wn5Mq9dfnmLnF1BgU9NL3LaqIw/NCBEuh0rSoEyuEehdVQZBkEuCe0EYwp9youfh
	 CUB5yR5AGfIk7Z6zLNupRSboejuP5CBMs6OIDugN1BHx9gbawnr8UQgmUvfS9KY+hm
	 HzpVdFugjhaVDspw2U4ohCe1tx5icvjbGIy+9z7BjUPpLO/Y/InT1fAJc0S7xAja5L
	 xnBWQqnEEywJWj4fesHIkmV6I4QnSC9UTU/EJwo/BoYnY47vrSe+hE65P1lHQ+TKpO
	 aFtP+Fw86QT0A==
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
Subject: [PATCH net-next v3 09/10] selftests: rds: Fix gcov collection
Date: Sun,  3 May 2026 22:41:42 -0700
Message-Id: <20260504054143.4027538-10-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260504054143.4027538-1-achender@kernel.org>
References: <20260504054143.4027538-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

debugfs is not mounted automatically in a virtme-ng guest, so the
gcov data copy from /sys/kernel/debug/gcov/ silently finds nothing
depending on whether debugfs is mounted by default on the host OS.
Fix this by mounting debugfs in run.sh before copying the gcda
files.

Finally when invoked through the kselftest runner, the working
directory is the test directory rather than the kernel source root.
gcovr defaults --root to the current working directory, which causes
it to filter out all coverage data for files under net/rds/ since
they are not under the test directory. Fix this by passing --root
to gcovr explicitly.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/run.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
index edc021f4dec9..c07e3785ff79 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/run.sh
@@ -215,6 +215,12 @@ fi
 
 if [[ -n "$LOG_DIR" ]] && [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
        echo saving coverage data...
+
+       # Ensure debugfs is mounted before reading gcov data.
+       if ! mountpoint -q /sys/kernel/debug 2>/dev/null; then
+               mount -t debugfs debugfs /sys/kernel/debug 2>/dev/null || true
+       fi
+
        (set +x; cd /sys/kernel/debug/gcov; find ./* -name '*.gcda' | \
        while read -r f
        do
@@ -223,7 +229,7 @@ if [[ -n "$LOG_DIR" ]] && [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
 
        echo running gcovr...
        gcovr -s --html-details --gcov-executable "$GCOV_CMD" --gcov-ignore-parse-errors \
-             -o "${COVR_DIR}/gcovr" "${ksrc_dir}/net/rds/"
+             --root "${ksrc_dir}" -o "${COVR_DIR}/gcovr" "${ksrc_dir}/net/rds/"
 else
        echo "Coverage report will be skipped"
 fi
-- 
2.25.1

