Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25D4B049F;
	Wed,  7 Oct 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383925; cv=none; b=MXSwW6h7E0P1GsYjeb8mZigjhEb4fmaopbFWILS8UbqJrBAIASQ+t6eURBeUPxjvZEyiw9cmDJKldRE+lo7FNu1nT+J8blTaJgXmWmODKUBx5NC41cmiWDExNrU4KX+qLmqddX511o73I1L0ROuBSXGZdVy9u4D/fL1IgE9qllo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383925; c=relaxed/simple;
	bh=zUQfm2JaDqXAvZhZYyIo8svOl1WIEiKjCHBGoWEvENQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jF2hREQyO4aFhcmquOB5o77HCrEFGGoaFyrakSpd7kj1c9o9XogAX1c8ltOAnmTrMUZHp3Hv7cfmsp4Wmh4VbgZ8NdIge8CKW5Bh2oetXdb+U9MDsRkw+uX0UpX15BwVzrJ0LRYsbbDBv9EnLlM7dtqq9/EZeOKQq7gAiBaJWBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=ex1mY1o2; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="ex1mY1o2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791383918; bh=zUQfm2JaDqXAvZhZYyIo8svOl1WIEiKjCHBGoWEvENQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ex1mY1o2niY+xxu4vYSGEkYVhKraL4aKe3w/0T6cV/EcDYJ1I8qLDhzQI4dUmvU3w
	 uK70Ux/4m9rEI2yAq6Y0m1vhwXDbBWK7VokElutVzZTohCp7fKrSO2DZPBW8TOzuGi
	 2nhS6Kr+2eYsO+gN/sGuXvKEg29kjfYV0BzmhJ8l78c4SYWK+SsqVutKoK/l5YhfsH
	 60rXikuYsjrEJAM2a1wLcTLidjZYmrU0v9Kw34i/jpwSFIY9pG6ZU7mZ+AKQ1HFxVe
	 4Oz6ANLz+w9uSzIy//EbftNZNPiJdjSH4YY7qHO1H+Z1v72XMacpJeMdFUIES6kzu2
	 7n+q1k2tU56Aw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 0FA7D44C0D0B;
	Wed,  7 Oct 2026 16:38:38 +0200 (CEST)
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
Subject: [PATCH net 0/2] net/mlx5: HWS, fix reformat release and meter offset
Date: Wed,  7 Oct 2026 16:38:21 +0200
Message-ID: <20261007143830.1733583-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two issues in fs_hws found while offloading one tc
rule with its own encap and meter:

- Releases L2 to L3 tunnel reformats to the pool they come from.
- Makes a rule select its flow meter within the whole ASO bulk.

Alexandre

Alexandre Cassen (2):
  net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
  net/mlx5: HWS, fix flow meter offset within its bulk

 .../net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c    | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.43.0

