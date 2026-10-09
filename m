Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A23BC680;
	Fri,  9 Oct 2026 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523272; cv=none; b=Ha2S1Je9ZGVcGsSca/Rg7GJT/OLfIpDKKHF7SFkq/5MG8yPiEpOhvV8K/2vPCoRNvImXVMX3UvAZi3itCuSbqOzTWRlFNVpUfXoVVvRYr2yFsWtxj/Qlp+oMisQ4b8U1njZ8GpHSllIEW3u+S7dJnoz23Zp24ldlPS5ajPmpL9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523272; c=relaxed/simple;
	bh=Aoi+FScMs1oXrwhDzPRYaLIBrjXVMZKX9oIxsz6BQAg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FE7ejZ299scqF7CXjWckAVt8phdirxeFu5wawcoaap8wmKrCoAZbTng6bSrQas8kiWqm4A9d1P2gdOt27TJzXLcBzYn6OqvTeIx9xiwGy/bFwSsRvgTIj9ud9fvnot24VlGSdPxW29sc0rgRHQqNbou+9ql+Mv2gU2vPw/0K2L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=ICjkJM54; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="ICjkJM54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791523269; bh=Aoi+FScMs1oXrwhDzPRYaLIBrjXVMZKX9oIxsz6BQAg=;
	h=From:To:Cc:Subject:Date:From;
	b=ICjkJM54cV7R6lqcTyO7ldcjtJuoXROmq2l0nkA/OTyq39tG3AUlQauhrZDvyulOK
	 YX4r2Z6YjusVtKA6BJ4Q4hGDUC0M0QhZK84/D2TMismZTRa/m0rPL/C9ZcjtO8chDQ
	 4HXh5zciGG+d2VzemHIwvx4RgfHSS/iuSoz6+CJj/n2lrxAYvyiQ+X+W4/jEzYdQ96
	 6PPiz46egZ8o1qJvGOTZmnjubrJEHcN3N7aOgaENPA1yC5ao1Zr/MekfR8lAeSsCzT
	 0fje8VAvQ9stoxv1R79sT6ud+LniFSK6wADdb1ASAQt1Xj76vHLxD0dzIILuPUaIfe
	 JA55NKHdmnkZw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 171DD44C0B4E;
	Fri,  9 Oct 2026 07:21:09 +0200 (CEST)
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
Subject: [PATCH net-next 0/2] net/mlx5: less memory per offloaded tc rule
Date: Fri,  9 Oct 2026 07:20:59 +0200
Message-ID: <20261009052103.3621855-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two mlx5 allocations hold more memory than an offloaded tc rule needs.
A NIC flow keeps a 4 KB allocation for parse attributes that nothing
reads after offload. An FTE under hardware steering keeps the 1 KB
action array it was built in while a rule rarely needs more than three
entries.

Freeing the first after offload saves 4 KB per NIC flow. Shrinking the
second saves about 1 KB per FTE under hardware steering.

Alexandre Cassen (2):
  net/mlx5e: TC, free NIC flow parse attributes after offload
  net/mlx5: HWS, shrink FTE action array to fit

 .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 +++++++++++++-----
 .../mellanox/mlx5/core/steering/hws/fs_hws.c   | 10 +++++++++-
 2 files changed, 22 insertions(+), 6 deletions(-)

-- 
2.43.0

