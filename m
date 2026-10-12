Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D223E51F5;
	Mon, 12 Oct 2026 10:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800408; cv=none; b=Emv28GzIkJ0CFj+J1+kWM3JJpDBO/EnOPZgoEj2eqNDQtRWgWWoi9ZK0fltycWmmQuAHCvPkGV6LUsavXiWRIYKvPjowdCgMU/CnyadRHuNvObuovtjIjrCSDlz44ruykltaXTS1NcquZjCGGlJegPbiNvR6RyNaXOZGNnBagfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800408; c=relaxed/simple;
	bh=U4s+GG5V2XJ4cj+9o4vFipLY9pxVY7PT0ptGOi9J/Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UowxymMftkxoSsXOoZ60g9Dla11TbAguReUrnrkwHSw0aAeFixmFfpRTPPGDMY+oros2XxIkgpel6WYfUmzrQ8WGo59arZ25u7upteiud3gzUUKqEXcPQX8RqyiY06EJ41vk6DN1WLf7IyGZJaDiv9IM8TXrNDjFdRZ/BMLyqVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=LL18k3/4; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="LL18k3/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791800384; bh=U4s+GG5V2XJ4cj+9o4vFipLY9pxVY7PT0ptGOi9J/Q0=;
	h=From:To:Cc:Subject:Date:From;
	b=LL18k3/4nq0uytSQqdAtTeBOSiF5MdBVCl+tQdvqvokbNDYqYv51V2wljLeXjxogp
	 B5BV5pmuV3QYz1sZJCRL0soyHNrjVTMEGfyrvk2+IdL5LOPyfLyR95xyDjHiacxLGB
	 cVSchMX31cV3GqpPHS9s4Wx5jZm7ywuYHQqHKcI90KLfKl2PEzinUOki0MMn69+ZIv
	 qHRaLsnPlk27vJMn9mS8oMIlfNri2NOBvFBoH5HnpHdvxsqLU02HbrOSiHs0F12X71
	 jb6miPy++klQ6Lix8qul0FmRcJDPCjnkxbnyKRsCfVAcMSgWamcOSLzUh1256CNQtW
	 rybg2oN69b7Nw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 05C2444C12AC;
	Mon, 12 Oct 2026 12:19:44 +0200 (CEST)
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
	Hamdan Agbariya <hamdani@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v2 0/2] net/mlx5: HWS, fix modify header pattern compare
Date: Mon, 12 Oct 2026 12:19:33 +0200
Message-ID: <20261012101937.1335231-1-acassen@corp.free.fr>
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

v2:
- Add patch 1 for the big-endian compare (Sashiko).
- Reword patch 2 to stay true on big-endian.

v1: https://lore.kernel.org/netdev/20261010120147.135825-1-acassen@corp.free.fr/

Alexandre Cassen (2):
  net/mlx5: HWS, fix modify header pattern compare on big-endian
  net/mlx5: HWS, fix modify header pool match for copy actions

 .../mlx5/core/steering/hws/fs_hws_pools.c         | 10 +++-------
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h     | 15 +++++++++++++++
 .../mellanox/mlx5/core/steering/hws/pat_arg.c     | 12 ++++++------
 3 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.43.0

