Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C937C929;
	Mon, 11 May 2026 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484197; cv=none; b=cSwPzFmzZ90pJzm8PHktefZAip7Bp5xm9HeKLZwQ/SPFfQ00lVppd+FKcfFsD3a7ZrtGjWexQJca1u28ll4hygJD3uq4jOKw6uxWR8Jzi5V3se+a4Q6FiXiB52oXxGXJQPFY24N7LlDJgP7oDD1wsfV0NkNv/0OqEdVmbjMh0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484197; c=relaxed/simple;
	bh=BcTv/ED+0/u7gfcCYFfnLcperXqu5umutlLkInzTbVM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=MYjx0YQZma+pj1lQOLcNRtSPx0v8kYS5H0bc5w0wOXOomdr/zapolUBvP/jA3lY0DzO5aSrnUIW6/LkB0VTa+xO3hCX7I+PIpXoiYEwHrX3hDYlOILIr6HfePbO16JCJZO8dUyaxhP3/6uuDdRhKAxl5d60dyFCxXKeOVk2Y3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X00noxfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X00noxfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EC2C2BCFC;
	Mon, 11 May 2026 07:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778484197;
	bh=BcTv/ED+0/u7gfcCYFfnLcperXqu5umutlLkInzTbVM=;
	h=From:To:Subject:Date:From;
	b=X00noxfWXsuH9q8LisItJ2H+iGNffWGIIPfC1v9ptcndBdd+GNTA3x22KD2W+8jc4
	 RWO6i8SjpoVm5r0+8nIA/OxSUzkRVZ90DxjCeBjxBEH5D/q99pBNlEyt2WYErJAsSA
	 J3+n08ZM6vMdFMf80c0KFB9WfC36r/uiWZBRauYqqKEwt9Lvt/RRAh/6u0CqtajE1q
	 zNX27yAVoN72+u1oZgtC5E3zT9kyHn/JvXj0Et+T2PdAvEkStuTQePlpsApYyq2qcI
	 O20cjgOJEMFo95pyb5B3n/9IXIZkTAFfjlqcS6TrsC5hoejMf0NrG6WcZrd+KZ8k12
	 9As++HCukk2FA==
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
Subject: [PATCH net-next v1 0/9] selftests: rds: Add ROCE support to rds selftests
Date: Mon, 11 May 2026 00:23:07 -0700
Message-Id: <20260511072316.1174045-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the rds selftests only tests the tcp transport.  This means
most of rds_rdma.ko has no testing coverage.  This series refactors the
rds self tests to add an rdma option when running tests.  When used,
the test creates a pair of ROCE interfaces to run the payloads through.

Most of this set is refactoring the existing test.py module.  Since most
of this code is one long procedure, it is difficult to modularize it
without creating a lot of pylint complaints about lengthy functions
with too many variables or branches.  The first seven patches address
this by breaking down test.py into helper functions.  After we have
modularized the send/recv packet logic, we introduce the new ROCE
equivalent network configurations, add the new command line flags to
build and run the test with rdma support.  

Questions, comments and feedback appreciated!

Thanks everyone!
Allison

Allison Henderson (9):
  selftests: rds: Capitalize ret global in test.py
  selftests: rds: Add helper function setup_tcp() in test.py
  selftests: rds: Add helper function check_info() in test.py
  selftests: rds: Add helper function send_burst() in test.py
  selftests: rds: Add helper function recv_burst() in test.py
  selftests: rds: Add helper function verify_hashes() in test.py
  selftests: rds: Add helper function snd_rcv_packets() in test.py
  selftests: rds: Add ROCE support to test.py
  selftests: rds: Add ROCE support to run.sh

 tools/testing/selftests/net/rds/config.sh |  15 +-
 tools/testing/selftests/net/rds/run.sh    |  51 +-
 tools/testing/selftests/net/rds/test.py   | 555 ++++++++++++++--------
 3 files changed, 424 insertions(+), 197 deletions(-)

-- 
2.25.1

