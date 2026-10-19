Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E3C4F30DB;
	Mon, 19 Oct 2026 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416730; cv=none; b=GRgnxSPFeLlNq5Xt0N2B7zGkT82CV49Ec/q3njPgJG9KWX4Mlr1hxsUASZRG+OmQeA9QAL8JOGsKPyTQA1166o5XRLnMWq/HE8CxIXdMN4rKVbQQ/pL0eAXfbp7zRF5ytw/g9o98WkAarI3u7lLmoK4c2hfu+g77v/I4UESbLVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416730; c=relaxed/simple;
	bh=bCJfm+07mbS4D1+FgFVr7qNmSRbdGCKaUwDoIiITbxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tc8mwJ3yBRB/vt3qBuAz903QN0nL/M7KfyEp/wEYlddFx0o8dOaG9gLnQWNI7nAOTAcAUOkZaj750hbOQS6N1aofRdRZ8kiRGUcuGiuetUz9Ur5HKumdalffLOVMEBrrZ8Ou2BVTHNc9KwvS5oL0aLGV8LAMJmM/LGtqXrzUuDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=QWDhC+eL; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="QWDhC+eL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1792416725; bh=bCJfm+07mbS4D1+FgFVr7qNmSRbdGCKaUwDoIiITbxE=;
	h=From:To:Cc:Subject:Date:From;
	b=QWDhC+eL/qUqbHTyaGTAYjX6PalC3tR9Q9yZMZ+Z3zB26UWYKK+xgPrGCv/NRWDNS
	 ZGT9zsamxb/ekIo+EYeh9LUy6N3h+bmd/rNmHPwiIX2/EM6rDm+k+aoK8D8Yp12/t1
	 NHxO6GCEoNqGzPB+ggZ6AFfEuPAcpxcGxQTcF7ANPg5K/r56e2hyEKawISyg1LN5B3
	 F7sIGEl5gdKbI8dRFLeP84qoOsPWfb/S8M2ZXl2xggdByjee6Vx/T1IKSlol90sneZ
	 hGqLVyn5eL+OVIONA+lSZhUutw0jnl6lMobld+yUvXm2kNzWtvRKMvurAAYxl5av4u
	 Zu2HstNQpHQpg==
Received: from localhost.localdomain (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 521EF44C0B51;
	Mon, 19 Oct 2026 15:32:05 +0200 (CEST)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Hamdan Agbariya <hamdani@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v3 0/2] net/mlx5: HWS, fix modify header pattern compare
Date: Mon, 19 Oct 2026 15:31:55 +0200
Message-ID: <20261019133159.1742411-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fs_hws modify header pools and the HWS pattern cache decide whether
two modify headers can share a pattern. Two bugs let different patterns
compare equal:

- On big-endian the HWS core comparison checks the data dword of each
  action instead of its control dword.
- The fs_hws pool match ignores the destination of copy and add_field
  actions.

Patch 2 moves the pool match to the HWS core comparison that patch 1
fixes.

v3:
- Declare mlx5hws_pat_compare_pattern() in pat_arg.h instead of the HWS
  API header (Yevgeny).
- Name the test hardware in the commit messages.
- Add Simon's and Yevgeny's Reviewed-by to patch 1.
- Drop Simon's Reviewed-by from patch 2 since its code changed.

v2:
- Add patch 1 for the big-endian compare (Sashiko).
- Reword patch 2 to stay true on big-endian.

v2: https://lore.kernel.org/netdev/20261012101937.1335231-1-acassen@corp.free.fr/
v1: https://lore.kernel.org/netdev/20261010120147.135825-1-acassen@corp.free.fr/

Alexandre Cassen (2):
  net/mlx5: HWS, fix modify header pattern compare on big-endian
  net/mlx5: HWS, fix modify header pool match for copy actions

 .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c   | 11 ++++-------
 .../mellanox/mlx5/core/steering/hws/pat_arg.c        | 12 ++++++------
 .../mellanox/mlx5/core/steering/hws/pat_arg.h        |  5 +++++
 3 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.43.0

