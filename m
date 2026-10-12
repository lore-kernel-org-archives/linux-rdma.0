Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496763EF66B;
	Mon, 12 Oct 2026 10:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800407; cv=none; b=fxrS4qVwGD+wFuNtD+8QXzKPjK+ILWAQrr7DismQLrknnEor+czY1e0x/VOjGS1kZuGoirnwAfns6hwfciz7+fwL+vtI7+vMWiZOnbnMf0kA37zlLcdWGxzfGQL8+vJZMBqUZ4nF9N79lb0JxBtOe9faStUw/slMPdcWWihmSaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800407; c=relaxed/simple;
	bh=yBGMhd2W137o3Fy8V3ZHpeoCKfvOMcuKL3olnYwv1Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGEDXkIninbxIKM1OY2GULDPD2KupGWmejzxOz3lV3WHNLhydr10dIb3Jt3ZVCkeVxY1mePCB6Qnt/KxG5IcCD0TnidzKEQ02x+df1YPUntthZ1rFZOOlijcedctIDw4LLFR19KAEljIgj3mrBSf4HUhBbsqXGaTRtlvzQkj9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=tTc0hWep; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="tTc0hWep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791800384; bh=yBGMhd2W137o3Fy8V3ZHpeoCKfvOMcuKL3olnYwv1Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTc0hWepvGvqwNTTr7SJNHVd4ZTrM9qUQBoqJN/Wv6zmhdkkIgGmn/TRlZKf2tvl1
	 ols8mz72q8l5BrSdDX40bE54Iyy6valMvJXOBzP8ESgKqQWm9SaAhB/AJ02w2gd5bR
	 1zsOV9Oq0IH6iTzOallAyZzUnI9jqGIi9halUysplMY1zu9J3qUh9M4jI/jG32iJV1
	 E94IZ134BnEd8cgUOSHui0grwMGmP9TyHToC/O796Gb2nfHaJM2pH8jv/tq9jzVHLm
	 VoOJHUyYl6FIrQ5mNNDGmcxRTgsXW5wJhxrD653Xi29pqZ1OT0gPArkRrrGwClvhNN
	 E7yBQ2keNLuTA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 5708C44C12CC;
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
Subject: [PATCH net v2 1/2] net/mlx5: HWS, fix modify header pattern compare on big-endian
Date: Mon, 12 Oct 2026 12:19:34 +0200
Message-ID: <20261012101937.1335231-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012101937.1335231-1-acassen@corp.free.fr>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
compare only its control dword. On big-endian this keeps the data dword
instead, which HWS clears from the pattern of set and add actions. Two
such actions writing the same value into different fields then share a
pattern and the second rule modifies the wrong field.

Read the first dword of each action from memory instead. Little-endian
behavior is unchanged.

Discovered by an AI code review agent [1] and confirmed by code
inspection. Not reproduced for lack of big-endian hardware running HWS.

Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index 9af449c2b4d5..512299b59fd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -116,8 +116,8 @@ static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
 				return false;
 		} else {
 			/* Compare just the control, not the values */
-			if ((__force __be32)actions[i] !=
-			    (__force __be32)cur_actions[i])
+			if (*(__be32 *)&actions[i] !=
+			    *(__be32 *)&cur_actions[i])
 				return false;
 		}
 	}
-- 
2.43.0

