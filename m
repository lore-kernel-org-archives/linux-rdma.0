Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1413AD1C;
	Thu, 19 Mar 2026 00:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773881180; cv=none; b=utCla5rk8Z6AeWm3tf+QDyn2f0kyGTkkf25lRz8QzWytn6ZeOMmHciPocWAxOtdFEiZ+fgl4y+UnMhjbhzWlYcMeXF1sDgOZh71HU8fh21cld3PbOGZDapNA9WkyRb460TVooG6g8ayGTZsXfrKk/aNSi1SfpXNS61sx/+pUV34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773881180; c=relaxed/simple;
	bh=eMc4gcwUOTvKK337uVKYgA4IkAVgLJnvGRUw/2lNN8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cPjAMKTtZMgGgI+80x5jLSWLa9ojV0pXXzGyiy6FRQeyef3AHLlvIx2lTiVOgBLtzxEjikVWjhRVbqBdR/63VvxAPOEIwkgTDv2C/65/Zx+eKKoKds7XlGh2RKsUJ2atoP9dIbrNyaGIFNX07FgWtS0a9dVZrPyXE93SfBypzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dk+xN8vR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dk+xN8vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E0C19421;
	Thu, 19 Mar 2026 00:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773881179;
	bh=eMc4gcwUOTvKK337uVKYgA4IkAVgLJnvGRUw/2lNN8A=;
	h=From:To:Cc:Subject:Date:From;
	b=Dk+xN8vRuuk+e0QUEuoqcMrK7mH/JI/XQrLsYdDBBKgeAnmH5/bzBYyx8/bUSRSsC
	 M4hQCTq7J8SyXP93JX84iTbCf4gINcPYNRF4w2A9gFC8oKkZfbFbcelJGyuQ6De7BN
	 XoqGNqHg3TAauOrsptGsM2sNeJ33gV0Q/bLkshdxQT20poacF9+SSX3iO4aQs1KNbc
	 aFcQjl1fU7APJQfpOYu3d9HTmcSqq9y+4VuJ1YlonCre63Q2LYKAHUQxiY4Zt2oR/t
	 I42CjYY0LSTnl+qKZyYe1ufsEVkRTu4d+y6qgR3fUO/pHo7yyUmOuOBssi04qW+Spl
	 IHacYMoxe4i2A==
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
Subject: [PATCH net-next v2 0/2] selftests: rds: add config file and config.sh -c option
Date: Wed, 18 Mar 2026 17:46:16 -0700
Message-ID: <20260319004618.2577324-1-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds an RDS-specific config file for ksft CI and extends
config.sh with a -c flag to specify an alternate config file path.
Users can now specify the path of the config they want to update, or
default to .config if none is specified. 

Allison Henderson (2):
  selftests: rds: add tools/testing/selftests/net/rds/config
  selftests: rds: Add -c config option to rds/config.sh

 tools/testing/selftests/net/rds/Makefile  |  1 +
 tools/testing/selftests/net/rds/config    |  5 +++
 tools/testing/selftests/net/rds/config.sh | 37 ++++++++++++++---------
 3 files changed, 28 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/net/rds/config

-- 
2.43.0

