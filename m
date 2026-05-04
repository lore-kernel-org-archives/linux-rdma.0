Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B7327B50F;
	Mon,  4 May 2026 05:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777873305; cv=none; b=pXK31G6Lm+/Nd2snaDNh62uLaxiDAJ4K4oGuNeeP72f/Hsq6jasGk2keSj0sEAVY/x0gOS++Ks6xIANTzVk5uy4NaHFvN6Ukb76ZcVyZridZTdGuwAPbRcg1pgHz7C6jh81peXqcMu6VjSbzqMiUNCWku7Y1QQqCv/F8U3u3T34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777873305; c=relaxed/simple;
	bh=ELl+5FcS3itoozWPf/UNsLQ1fqPBJAhMt2j2GnSGKl0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3HVNuY9A3ElsXjPj/93gVKtgRf9blE2JQphD9XYEAgGOLJ11j4SA0INxxS1v1HF257jvnO08kH7Dl17k3IESSAyK255Vc61NeUdbDt085+ZoQ2Iqu7rfVLCRgnwjnC1a4QQxxXESOQ1lpnHtkn3um09CJrnIh0sCzDKOkk1+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9WHwAqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9WHwAqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3C3C2BCC9;
	Mon,  4 May 2026 05:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777873305;
	bh=ELl+5FcS3itoozWPf/UNsLQ1fqPBJAhMt2j2GnSGKl0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=r9WHwAqJIbqj/cEGTuPZI4YtZFrO1KqkaIPArpH0p6GYQra7bCKnYXHEJoZPqTCRb
	 L1MejYGVcqxCsfkE3RAd/fjTiBbteUiSSlrpS2GWgBZG84vScIB5Dg15NGWN42ljTy
	 p8lNuAbuzwb8lcn6BlXO3r2HwRLcHZLQdNgPAQhjzOZ5To+YdLkF59pY4hg849mlBW
	 Vt4OQpw3W8FExeKttm/oAosm0F32tzOeJorcpQH20o26Ms6SiXvsoNG9kGQLqysOWh
	 FK4iuzyJqICFPvDFY2Efks7nFUCR2MdT4pb2nqTFP5MedtN5nsqi4GtnOHnruMRf42
	 FPAQ/hO3mLWnw==
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
Subject: [PATCH net-next v3 01/10] selftests: rds: Increase selftest timeout
Date: Sun,  3 May 2026 22:41:34 -0700
Message-Id: <20260504054143.4027538-2-achender@kernel.org>
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

The 400s time out was originally developed under a leaner
kernel config that booted much faster than a default config.
Boot up is included as part of the over all test runtime, as
well as any log collection done when the test is complete.
A slower config combined with the gcov enabled test means
we'll need more time to accommodate the boot up and log
collection.  So, bump time out to 800s.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rds/settings b/tools/testing/selftests/net/rds/settings
index d2009a64589c..8cb41e6a83cc 100644
--- a/tools/testing/selftests/net/rds/settings
+++ b/tools/testing/selftests/net/rds/settings
@@ -1 +1 @@
-timeout=400
+timeout=800
-- 
2.25.1

