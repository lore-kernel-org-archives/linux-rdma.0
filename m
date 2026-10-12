Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFE647206F;
	Mon, 12 Oct 2026 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799582; cv=none; b=NPZ6OuTLv9oGnTNnsO/eVTVpcfnokUTvUZPlkVmUGczRZ54GKiLhVz9wYEac/My+HgMPiThi4g1DTQYy2cUGF5gUUaA6MKs52fMn+OJLIPEqCcd69BJFD4SjVJCh0H9BtQwfNmHkX1J1xuihe8Mlm7bfQg6WPEZzvV8c9tEEbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799582; c=relaxed/simple;
	bh=tHNHraEPZAMKF+UIoRjW7/z+zXnRWkv9w9GLrm/TpG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WjeDXas+MtfeLvPu/EpwiBzOyzR5lujvrQ0CvRwVe7zxBIORBOml6erPjCwQ2SkODlgbn7aZfBqwOWRbQ8yTKaS1qmBLfZp/W56o+1ZsLs/Il/r5Js6HQ4jHfnoNnDyOK/Sqp1eaJQzkGtu9I3HeEcN7JKHF0aQaCQwKal/n0A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=R3GV+BsK; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="R3GV+BsK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791799562; bh=tHNHraEPZAMKF+UIoRjW7/z+zXnRWkv9w9GLrm/TpG0=;
	h=From:To:Cc:Subject:Date:From;
	b=R3GV+BsK/dHxOGpQCMC3N8j8egQvBZ9JwrnD6I3Hc/oTx+7hYkbpQ3yuX0FAGdCcA
	 65hSlHPnlZ+nEsVBIn6BU2lWwBVqG9oVQz/Wl83C5wg7KBM/TxCaq2RBeopOkT6lFm
	 TSW1O+rZbTT1HhqRatcW94H2S5xAq77lSRnG8M5zRbPY1ryF6mu1B3yIFucW00wot2
	 5ibG4XPt/IiB35vM1aR1HQEPd1jy5LKZ33iIz0INKWg4H52+N93jrMv66YPddv6Xgv
	 gNUiLEuCzdkKbhcATAe6gnTlt4p7atXIANrjsnWm5LNvxHDd/kzJ/8dEMgPIrzs8ki
	 xzcj9OwUmsIuA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 08A0E44C2B6C;
	Mon, 12 Oct 2026 12:06:02 +0200 (CEST)
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
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v2 0/2] net/mlx5: HWS, fix pool creation races
Date: Mon, 12 Oct 2026 12:05:52 +0200
Message-ID: <20261012100555.1317878-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two pool creation races in fs_hws hit when two
callers create the first pool for a reformat size or a modify header
pattern at once:

- Reformat pools keep the pool inserted first.
- Modify header pools serialize the pool creation while keeping a new
  pool on error.

v2:
- Keep the pattern lookup out of the mutex and look again under it on
  a miss (Moshe).
- Add Moshe's Reviewed-by to patch 1.

v1: https://lore.kernel.org/netdev/20261008204230.3222198-1-acassen@corp.free.fr/

Alexandre Cassen (2):
  net/mlx5: HWS, fix reformat pool creation race
  net/mlx5: HWS, fix modify header pool creation race

 .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 66 +++++++++++--------
 .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
 2 files changed, 40 insertions(+), 27 deletions(-)

-- 
2.43.0

