Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BB54E36EF;
	Mon, 19 Oct 2026 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416731; cv=none; b=i+mPA7kDzvA5Nkp2ljba9uLChJrMwjl4F2QlIJI7d5Vms7gfr1yJFU8BmxUDOmLITIbDXcT8882mWaN9e6iCVrNchUkCFiddAN+SxFETFGrGK16jtDFUgVqrHHGj/5IPowXo54D4wuEQAb5tYpxh/XUHimzEyN19nVzP0gB0qPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416731; c=relaxed/simple;
	bh=ZGqlpKqm0fY383Q+CT4wqy/BCHXdNH0mC/V308vCYS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwV1XnDEVzCYwlzutSzmBUSHqRrdQ21satFQYPCuzqs5tQPJbxJsqhQLwKwuMz2q/qcm6rTYA9sfn4SoBLJEJSI95S2ck6iIkW7bO1VxkvBfSolRFvIba9Emz71GO5X2lYhiVF/6x5DoMZT+oDbBhGsR1V/iVQSh+UI2ejipk2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=iGVvPYua; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="iGVvPYua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1792416725; bh=ZGqlpKqm0fY383Q+CT4wqy/BCHXdNH0mC/V308vCYS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGVvPYuaN9cz7FQorjzIHaGOpU7tTmU5YutWxpU2RLH4Cr3wrUWCVQtlHWwzKWnHA
	 8W1yyHkxq9NJHrGEc3Xq88B4/a1gQ4xOVA1Lk3xpUoL/3nRvMY1Ks+Mry2OOUmc09v
	 qNz1cfQDiKhtoH05L7b63kA9Cq4XY56zHXJkQdei9BETuhor5Kj5Al0wYN3cFU9Okl
	 lelvkDgDLr1S/2KKfpHV0T9hsATN9/EOxNgoEVsEvpW/D6l9yFVkSU4GEYY0tngoAk
	 Vg31EVkn52wa7gjQ6nDn9zyX8ieqytNmcJuS8OARiqKd5SdjGGAHpevbzaL1njr/N1
	 vKDc5zyafAePw==
Received: from localhost.localdomain (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id A68D244C0DEA;
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
Subject: [PATCH net v3 1/2] net/mlx5: HWS, fix modify header pattern compare on big-endian
Date: Mon, 19 Oct 2026 15:31:56 +0200
Message-ID: <20261019133159.1742411-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019133159.1742411-1-acassen@corp.free.fr>
References: <20261019133159.1742411-1-acassen@corp.free.fr>
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
Tested for regressions on ConnectX-7 with firmware 28.48.1000 on a
little-endian host.

Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
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

