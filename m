Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95C6264A97;
	Mon, 22 Jun 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782143555; cv=none; b=QhQmT0wRKY0Y4NzMJ0FClzR1i/+F4Qk3FAiy/oBOvL7G/jx+Tdrq9tk7f9UqmyuUmMuwwbJvQP9pQYoK3CgJqw34nwGyRapuXkmkHj5sNA31dTR9lN6prfXQCBdBbzr9Xsrqnn/zqiGVNrRMKJHVZL2+DVv9wVy+Ys1Y9WXnzXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782143555; c=relaxed/simple;
	bh=7VIGyVRF0G8SLl70rRa4kAPFZ7fICm9uqSiCfGJz4Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfs1Su2iVE8ZyPDjK8Rzv0nk3cbHejCWYLYkSQ6/P9KQQhERF1wHGlHaYhPEye7OczlfbuJcYLdx/rDVSRiJppQ9sMZuZECXFKHxHwdd/p51URLeRFEHmReGN6jmDXZwVlrYr5Mk0Niadodddh2vSLzDjmAOD6Ez4CuMcXTm/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEzB/4RZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEzB/4RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F61F000E9;
	Mon, 22 Jun 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143554;
	bh=7VIGyVRF0G8SLl70rRa4kAPFZ7fICm9uqSiCfGJz4Dw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fEzB/4RZ8Hz666TAUQbehEpF7F4xglCph556Wwc/uGt54L0f2Xu0KmKGDX8eqK6V4
	 HIrUfl4KrFHTavJl9NhUzCIHvsmrXZbJSieleiljQz1QAfvbbvH0bY0Z+wkK3Qi436
	 tE/164mPeHKAVQw0rE2GpFsTi9sT6JzaOhUwjS9eCBDiYgTEqaECAOUygKuqTMG/6e
	 L/AiBlKUu5Q7+AuhdTMV5AVjhLD/UCpWYGiFbNUW1S3xTu4m9gXE09ai6fmCjrujeN
	 0tR6ZPb1dpUr+moonk0UpHQOcVRk5PstHkWu+RbmBQdtqjMlI62Txrjejt8H71ITJP
	 Vc22Pg/xDsaBA==
Date: Mon, 22 Jun 2026 08:52:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: lirongqing <lirongqing@baidu.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix L3 tunnel entropy refcount leak
Message-ID: <20260622085232.37d9d5f7@kernel.org>
In-Reply-To: <cd725cc0-9be1-4d12-bc9f-95ecf789613b@nvidia.com>
References: <20260613153631.1752-1-lirongqing@baidu.com>
	<cd725cc0-9be1-4d12-bc9f-95ecf789613b@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jun 2026 09:49:17 +0300 Tariq Toukan wrote:
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

To be clear -- you have to take this via your tree now.
Our UIs doesn't even show patches older than a week.
