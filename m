Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE02423EAE;
	Thu,  8 Oct 2026 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791492183; cv=none; b=ZxX8Jf7jJh755fwsf6D09u6NvCIx8751is5bvdjPAV7C6x2rKdqKX9Yx5lRCamCb78JvskfLiyp7NdD8AA8Fyn8u5lrUgrwkTzL0AfMc9u0FUxqpDXuADcgZAStuXiSbg3+9tkoi0SZojkIl86cW9jSis+ujBI7IPf01PJ2wRl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791492183; c=relaxed/simple;
	bh=yOQ8nm4OJgAXSIu5wtPzKcV8o8gZIaUXxVHIfV0QT+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2BaMzH7K6x6WyPaVLEl2XbMOZ29T6ZAXQvJ88jUQx3eYD6mOFJyJjnh+evee/QKcwC/mzYpg0PIfmcA9P2y92Eu65iPDBRiJP6SUopr5i3V+CjyTZBkOp/LXkMlG/SbhlZVibEqHG3+fX7xPgMdQLChdIm7yNkFk9TmVNsC0ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=F1+iUefi; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="F1+iUefi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791492178; bh=yOQ8nm4OJgAXSIu5wtPzKcV8o8gZIaUXxVHIfV0QT+o=;
	h=From:To:Cc:Subject:Date:From;
	b=F1+iUefiTJ9VTo1tcPjYWCCN1IEHww8/sl6lszWVRsnguPKXkDpe6O1aORP3Q3ZZH
	 BG7V1fXM8OjjgQcTSP3HmIyUz8VfOhwqeSFt69uVoMXtooVLmTzghWVKfs63/HgcvH
	 +B2FjNUVlC1jeJ6dIO+NN5YiS5yoGGeUAXZmp/B7xglaOTh3j7yOUa3OCyzEMBVgL8
	 vb1IPAifyaVthno9zQGRASXqThKPKwxUBgl9ulze88YEjD+Y7cJRpV8gZ58q0VXzVB
	 RYFE6rEeqtxujpML7XASyFjfFjaiiDXq4MuW3N3HGBQED5NrmGfCebd1eKsmgWijRz
	 0ukRAvYGflZCg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 8CE2E44C045E;
	Thu,  8 Oct 2026 22:42:58 +0200 (CEST)
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
Subject: [PATCH net 0/2] net/mlx5: HWS, fix pool creation races
Date: Thu,  8 Oct 2026 22:42:19 +0200
Message-ID: <20261008204230.3222198-1-acassen@corp.free.fr>
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
- Modify header pools serialize the pattern lookup with the pool
  creation while keeping a new pool on error.

Alexandre Cassen (2):
  net/mlx5: HWS, fix reformat pool creation race
  net/mlx5: HWS, fix modify header pool creation race

 .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 34 +++++++++----------
 .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
 2 files changed, 18 insertions(+), 17 deletions(-)

-- 
2.43.0

