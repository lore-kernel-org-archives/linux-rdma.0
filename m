Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0392C304BB2;
	Thu,  7 May 2026 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778196735; cv=none; b=oYnBZx+iIs8/lT2XU3UzFrIilDLC+t/U3rcVlZDGiiaDzCgMT0Udsb/qeI2AoZLrpn8myE7VsmXnZE14sR3/4HTL/9LELo1JKRfmi3rAzal8CIJSyfhpZQ1Z5vFiXZmCEdHwf6s++5nVEWXXV9jumlUte5KXXpLtjHGDuxZSizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778196735; c=relaxed/simple;
	bh=US9JiAZDJD186r12khj0E2NvSxnpsZEPYuUXZ8e8gYA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=LMuZj7oPHLQ8TgKcJpQct8z1CaExM2e7lr9CRLcgbzCEHARaar92l9QKzK7482TdwwJ/sW/Al0YMlnxTHhIXh5257b8Fh/0zQlfQWaJmfBTmjSr0Q0RbtlQFDHRQgB8TNdGAjk3+HKkjaoqa0JLao74zdUkoP02OY/bn/kNA2I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KO9Sq80I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KO9Sq80I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A05FC2BCB2;
	Thu,  7 May 2026 23:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778196734;
	bh=US9JiAZDJD186r12khj0E2NvSxnpsZEPYuUXZ8e8gYA=;
	h=From:To:Subject:Date:From;
	b=KO9Sq80IVa3hANJ1kQ1Re5wStHqHt8DjoqGWZFCXhPNZRQhN6NgxNk0d0DFvwOu+Y
	 4UYhWMcM6ZTHR6IG59mThWL0Dly8Z/fLHgRvsDmqQyOUqqE37xKQyzUEwe0HehsFkY
	 tYSR0PQ6lTQb6WLD0jk/8LF+G/5br4aUxW8D38zUOQAWIqMYgfSW0jDIbCoKq3KGnJ
	 KI4+ZealrbPqEVEGt6LNBsFegvmls5T6fEWVU2wQhlop8mesFAvP0rwWaGFj5oxZVu
	 o6BKdwoRLpL9dktI6x4zpNPbckodkILJpHhfiMV0lLqvrvg++Zni+xQTNZzuBdfHM+
	 LyGy8ivSS0/MQ==
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
Subject: [PATCH net-next v1 0/3] Log clean up and TAP follow ups
Date: Thu,  7 May 2026 16:32:10 -0700
Message-Id: <20260507233213.556182-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is a follow up series to the  "Log collection, TAP compliance and
cleanups" set.  The sashiko report had made some points that I thought
was worth addressing.  This patch set fixes a few more TAP compliance
prints in the check_gcov* routines.  Also since the user must now pass
in the log folder to collect logs, log clean up is tightened to only
remove rds* prefixed artifacts instead of the entire folder.  Lastly a
the signal handler alarm should be disarmed after the completes to
avoid multiple calls to the stop_pcaps routine.

Questions, comments and feedback appreciated!

Thanks everyone!
Allison

Allison Henderson (3):
  selftests: rds: Fix stale log clean up
  selftests: rds: Fix TAP-prefixed prints in check_gcov*
  selftests: rds: Disarm signal alarm on test completion

 tools/testing/selftests/net/rds/run.sh  | 28 ++++++++++++++-----------
 tools/testing/selftests/net/rds/test.py | 10 ++++++++-
 2 files changed, 25 insertions(+), 13 deletions(-)

-- 
2.25.1

