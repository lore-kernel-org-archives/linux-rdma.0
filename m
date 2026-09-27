Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60B525FA29;
	Sun, 27 Sep 2026 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790525822; cv=none; b=fHQ46fgLO7mQqeZnzhewe8ZvBJImDG3iVgbH9kPjR1R3CZe9gNh7qfM2D3COmGJOFktnOzTYW6MtLfwYlxpNfVZaZcuDUE5C4PBtcXpX3rfj7v6A3YNOibbM0R64N3wGJUqEi500LwKNlu1T70WXXbBzbnY3Ht2R9vGUvkX+HiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790525822; c=relaxed/simple;
	bh=7Oymxgl3G1RSRBegvwb878wRTaguTlFQt/CQQly8Fzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PyUoAbRbX39o43f5Xdr+r6oYmkXQZyayBWQYZRFH5ZLd9uV6ahGcbe1RJrdvV9Y0UV3RrBVsHPHzXhbgIwvjMAo+S+QUNohr2OQEzMqfF2taSKUyt0F3jsZ5yHhomf1mXMk0lUzM2rW/HLDGnpEPZXNZ3/ED8h4SK1E3NOcqne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSBqmlCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSBqmlCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F91A1F000FF;
	Sun, 27 Sep 2026 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790525821;
	bh=wvz35V0KcKH7pOO5J/njM+N7JbUckkdSga1rrtpfn4I=;
	h=From:To:Cc:Subject:Date;
	b=kSBqmlChNQnZq6/3ZjoBhWBgeJ2W9JFn6xS/qHLKlSX0xTtpAQNYAh8jGModVq57a
	 N4/3Uucc0euODru08bS3oSwdOffO6CoVrQknSl3s9Ly69KUjC24YQChVeVudltRpx5
	 OU4zEtxI6IPoYkl3VQJfXxp/7Z3dTaBBdZI2K5/tzT6r9jGO4YfGpLBXVCI9AQWgl+
	 SSPPpWnppFiYQYmDKclkV/oo9tyn+W0eh98oI2qrp1+GiuLBCVU0AdMjZFvB2W8DI1
	 d8G8unJjGNDzGqTn/CTT8+8T70XWTLH9v0T1LewBeHsfjeIO0PEX5to+5uwmXMmoa4
	 K2YHLSr8c1+Gg==
From: Sasha Levin <sashal@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/selftests: Fix the kernel config fragment
Date: Sun, 27 Sep 2026 12:16:54 -0400
Message-ID: <20260927161655.1184153-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The config fragment lists bare option names with no values:

  CONFIG_TUN
  CONFIG_VETH
  CONFIG_DUMMY
  CONFIG_NET_NS
  CONFIG_RDMA_RXE

which is not valid Kconfig syntax. When the fragment is merged, for
example by "make kselftest-merge" or by CI systems, the lines are
rejected:

  .config:5514:warning: unexpected data: CONFIG_TUN
  .config:5515:warning: unexpected data: CONFIG_VETH
  .config:5516:warning: unexpected data: CONFIG_DUMMY

and none of the options gets enabled, so the rxe tests skip or fail
for lack of the modules they load.

Give each option a value. The scripts load and unload tun, veth,
dummy and rdma_rxe with modprobe, so build those as modules.
RDMA_RXE also depends on INFINIBAND, and rxe_rping_between_netns.sh
runs rping, which needs the RDMA CM userspace interface provided by
INFINIBAND_USER_ACCESS, so add both.

Found by KernelCI kselftest builds.

Fixes: e01027cab38a ("RDMA/rxe: Add testcase for net namespace rxe")
Fixes: ecdcc8a455b7 ("RDMA/selftests: Add rxe_netns_names test")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rdma/config | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
index e1ff54ec0f579..1be43c4274bb8 100644
--- a/tools/testing/selftests/rdma/config
+++ b/tools/testing/selftests/rdma/config
@@ -1,5 +1,7 @@
-CONFIG_TUN
-CONFIG_VETH
-CONFIG_DUMMY
-CONFIG_NET_NS
-CONFIG_RDMA_RXE
+CONFIG_TUN=m
+CONFIG_VETH=m
+CONFIG_DUMMY=m
+CONFIG_NET_NS=y
+CONFIG_INFINIBAND=m
+CONFIG_INFINIBAND_USER_ACCESS=m
+CONFIG_RDMA_RXE=m
-- 
2.53.0

