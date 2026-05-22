Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5842340281;
	Fri, 22 May 2026 21:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779486872; cv=none; b=rsoQ4BRv6+RFUyX7PFZJhyj5tyiFCvXJoIpdvS0PxzTsHzfzRiXsZfCcVN66t8KG64xST3DZubVrLZO02XQHo9Iw5GnEKa05OdpRWYKJYx3FB4iNs/B/4sG5ggDhCBWgzqMmNjsgq2cUq+/DGf29saoZDV++oqybpo8Jpm074N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779486872; c=relaxed/simple;
	bh=FXxvypeUhIvVVHiJ9zEADS1Fn7Ky0VJvLn9oDbd8JMo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=X1qH7xnrljWSBHHK3plpzgcR4UK38X1jHJl69juNhd6baU1tUYUb6sK73qlpE0chetlIiidwNtP9QTTcaIims5UKrXtb9OB5IzorRHtUi1PQkIM26WEh+eCOvgx3uxQY51NhmsMYcv1OakYNnCbYh2PdwE1NNum0BrJKXCZ7ht4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/tbS2v0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/tbS2v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5A91F000E9;
	Fri, 22 May 2026 21:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779486871;
	bh=KxAu/FOwB7Rt33B2dM3eIygIo4s+mBKShRVjNFSpc+k=;
	h=From:To:Subject:Date;
	b=m/tbS2v0sAfVFcfNe43DILWhS6uVeDw5Sc74gcSRvJuROeDKiWrh9Dq9uY5IvMZ00
	 4nQsOphZFkW0tKkhQ67hX5d39iKOxxwZaXMdZq1O3BAxsEuigWtGy28pgtPNmDCaCs
	 NhxybsobxVivcwlGIdOi/Es/8lZyUTc12jGFcBHcebhNBuKqnmSuddLJ96M8ZIw1Y9
	 wJVdsS3RyRNpNqof6lap7KnWOIpAN8SutrphV1T2JPS6NlPevgwqAilwxo8B82UNWB
	 q75twfUasP7TF3bqc9q0+PtCDKhiCXj4src8KDYZ+KaaoAh4jMKBVj2TVoIKjUALcW
	 OfBbz6Fx9XFRw==
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
Subject: [PATCH net-next v1 0/3] selftests: rds: ROCE support follow ups
Date: Fri, 22 May 2026 14:54:27 -0700
Message-Id: <20260522215430.3748226-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is a follow up series to the "Add ROCE support to rds selftests"
series.  The first patch renames run.sh to rds_run.sh, and also adds
two wrappers to the TEST_PROGS target to run the same test over the
rdma and tcp transports.  The wrappers rds_rdma_run.sh and
rds_tcp_run.sh also provide self-describing names that appear on the
netdev CI dashboard.

The second patch addresses a sashiko complaint that I thought was worth
circling back for.  In the patch "pin RDS sockets to their intended
transport," sockets are pinned the specific transport they are meant to
test. By default, socket transports are implicitly selected based on
the network topology, but it is possible that they can fail back to
other transports if the underlying connection could not be established.
So the patch pins them to the intended transport to avoid false
positives.

Lastly the third patch "support RDS built as loadable module," lifts
the CONFIG_MODULES=n requirement, and updates the check_*conf_enabled()
to allow modules set to "=m" and further load the backing modules for
any component set as such.

Questions, comments and feedback appreciated!

Thanks everyone!
Allison

Allison Henderson (3):
  selftests: rds: add per-transport run wrappers
  selftests: rds: pin RDS sockets to their intended transport
  selftests: rds: support RDS built as loadable modules

 tools/testing/selftests/net/rds/Makefile      |  6 +-
 tools/testing/selftests/net/rds/README.txt    | 13 ++--
 tools/testing/selftests/net/rds/config        |  1 -
 .../testing/selftests/net/rds/rds_rdma_run.sh | 11 ++++
 .../selftests/net/rds/{run.sh => rds_run.sh}  | 63 ++++++++++++-------
 .../testing/selftests/net/rds/rds_tcp_run.sh  | 11 ++++
 tools/testing/selftests/net/rds/test.py       | 18 ++++++
 7 files changed, 95 insertions(+), 28 deletions(-)
 create mode 100755 tools/testing/selftests/net/rds/rds_rdma_run.sh
 rename tools/testing/selftests/net/rds/{run.sh => rds_run.sh} (80%)
 create mode 100755 tools/testing/selftests/net/rds/rds_tcp_run.sh

-- 
2.25.1

