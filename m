Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2B61A682F;
	Fri, 20 Mar 2026 04:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773980316; cv=none; b=QHwCA8KBRgDkbXQQk1xKF6Oo7Zm8Z7SJoi4X5DmnAh3tpmhw/yD8WZx9au04H+/Dz7uP+ES73X7VpXxR0h2+AvasEDSjYpvPYHZZ3d9q8cg6jHYaDja4qXj8eNXthXt9qRYouoLqaE4WSa3UgH32xzauZMsRCA/5arF2KMDJQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773980316; c=relaxed/simple;
	bh=oHYQglycu+fpc+p+cwrM1FU6F7rgABHTzbnm/mL6jI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Esx0XCvlgKHd9rxSh6sSygs0FrRbuLlYyDJC5fzeTCFwojKSzo4U4aZVQkMPvrkf366qz+iOswqg6c9pCJZ4TIpSMj/Yk8NbDBV0G7BVv7cULt8+BTtXBeIhTF8X0JLWbX/43eg/PKh/kI2qEKwUJw0tXmYg8zRolll+u3KIrno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r3il3SdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r3il3SdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4EDC4CEF7;
	Fri, 20 Mar 2026 04:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773980316;
	bh=oHYQglycu+fpc+p+cwrM1FU6F7rgABHTzbnm/mL6jI0=;
	h=From:To:Cc:Subject:Date:From;
	b=r3il3SdLqloNfwft8w4dxy3DSpH47WCyUScRGA4qfPHrxeUJtVN6Q3+kStE1beuqV
	 dJljdMJTWXRcaMBPP0t6H86esok8tSdIn4PN/wdPBSEkyPIrtTjYx705t84ICbhih+
	 YocfEuqYNOv/Sl5AkSS8tTxLVVfrsyfHv2Zr/R2vE99WiDOx8yx4/oGVFG5VdPukxm
	 UvkBRpu1abSYZBwB6o+9QgCD0Ki1V2FwB4I6D5To17aZDmmOHr/NYiIZbzVftjfKLI
	 dodAR/zEULdHZIlaobTMKrSwi2Igv7ZhgfFLg9uYYJQRFFLbXRtXiqjR0rei0rKrB/
	 2CdIbPXy1WW4A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	shuah@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v3 0/2] selftests: rds: add config file and config.sh -c option
Date: Thu, 19 Mar 2026 21:18:32 -0700
Message-ID: <20260320041834.2761069-1-achender@kernel.org>
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

---                                                                                                                                                  
Changes v2 -> v3:
  [PATCH net-next v3 1/2] selftests: rds: add tools/testing/selftests/net/rds/config
    - Sort CONFIG entries in tools/testing/selftests/net/rds/config
    - Sort TEST_FILES entries alphabetically in Makefile
  [PATCH net-next v3 2/2] selftests: rds: Add -c config option to rds/config.sh
    - Use bash array for FLAGS to keep config.sh shellcheck clean

Allison Henderson (2):
  selftests: rds: add tools/testing/selftests/net/rds/config
  selftests: rds: Add -c config option to rds/config.sh

 tools/testing/selftests/net/rds/Makefile   |  1 +
 tools/testing/selftests/net/rds/README.txt |  5 ++-
 tools/testing/selftests/net/rds/config     |  5 +++
 tools/testing/selftests/net/rds/config.sh  | 37 +++++++++++++---------
 4 files changed, 32 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/net/rds/config

-- 
2.43.0

