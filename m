Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F947CA6D;
	Thu, 23 Jul 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820075; cv=none; b=NJ/JsuRSBwhR6Ll2DIbo5i7Qi1DtBEiUmrMLKOCkkIWhC+Y6VrIS3d/hZNoI0W+ebluQcB1CSSdCpItxI1iD+kmFaZIrqFbVry3X7/ZAYyvBCWkmXPBiu5uayXDhi+uRJsgVlirnrCUTjwPqoVaUSSdHO7+h4J9z+a3wKk+qV5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820075; c=relaxed/simple;
	bh=owoktXhjxcCD4r/Jvrd9tF7OOHyow72fwWha0JovKbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYzH99yTHFh2KR6YgKKf08ySVBn24robWEF2LVwjiYsJIq2xi2sfS3lyIaSSPykELaMlokljSYdzkKHkWUrY7Lot2zVwrzILFaXiFd6herqXR2FnoBhrN1ehBFdQXEKCOdsMPUdGVyTrWSeIDFqCeAXgbSKEhmVzeuTiadA8L8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9701F000E9;
	Thu, 23 Jul 2026 15:21:09 +0000 (UTC)
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	cratiu@nvidia.com,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	saeedm@nvidia.com,
	shayd@nvidia.com
Subject: Re: [PATCH net] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
Date: Thu, 23 Jul 2026 08:21:05 -0700
Message-ID: <20260723152105.679019-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717073041.1241894-1-tariqt@nvidia.com>
References: <20260717073041.1241894-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
--- Patch [1]: [PATCH net] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock ---
commit 194675fd6608821b2119601ea9e7369a43686a86
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock

This commit fixes an AA deadlock in the flow deletion path by introducing a
new PEER flag for duplicate flows on peer devices. It also claims to rename
the existing DUP flag to PRIMARY to clarify the distinction between the
original flow and its peers.

> In addition, rename the existing DUP flag to PRIMARY to better reflect
> its semantics. The DUP flag indicated that a flow has peer flows on
> other devices, but the name was not descriptive. PRIMARY clearly
> indicates this is the original flow that manages peer flows.
> 
> This makes the distinction between the two flow roles explicit:
> - PRIMARY: the original flow that owns and manages peer flows
> - PEER: the duplicate flows created on peer devices

[Severity: Medium]
The commit message states that the DUP flag is renamed to PRIMARY, but this
rename is completely omitted from the patch.

For example, MLX5E_TC_FLOW_FLAG_DUP is still defined in the flags enum in
drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h, and it is still set
using flow_flag_set(flow, DUP) in mlx5e_tc_add_fdb_peer_flow() inside
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c.

Was this rename intended to be included in this patch, or should the commit
message be updated to remove this claim?
-- 
pw-bot: cr
