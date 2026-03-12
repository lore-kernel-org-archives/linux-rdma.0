Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039C346E7A;
	Thu, 12 Mar 2026 03:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773285966; cv=none; b=uxvn4cYw2CBPqLtWG8xyHmtid8wXZv0ypgNux6pVMBFcyknf1c9+O2bjSK94Wefg65PxsK5lgxdeV5jR8mcwDYZbs8mAIuOI/f/KaAfmTWjQe+mZ77gnFaDQBd90SvUn8mTmVRLF56o8Xr+uZdn0/610JHDvrvXIbm3pQz2nHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773285966; c=relaxed/simple;
	bh=q3EUBK4jLA/YX/UN7xyDj92eGsiZwUVakDFEjt10Fl0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ry2xxoZFhJj/FioinTw3GHrEbJRn60Li/1kCzJDvTX3mWuFl1YYslixiZL9Z1WtBVHolQwSq33pRN/K/UAJAsqJtxauf8rqOSWfV+qvcC90EyfOxlKWQ5pUr3SVLRoxOhTA4ZSQb3uhZ690pHbtfNCnwA2j4VpFLH5H0D+/Oqw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJmC1fCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJmC1fCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B7CC4CEF7;
	Thu, 12 Mar 2026 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773285965;
	bh=q3EUBK4jLA/YX/UN7xyDj92eGsiZwUVakDFEjt10Fl0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MJmC1fCEFGd2aiqg/Nfeti+WGQRz0lh+Sk/uAGhMXCAbxw29f8GoDLRPaiANKC04s
	 +kYyii6goR6ZsFgjqczIEeEcqrC1kmso8KG8j4nI8mlE20P5uDSDwe0LgPrTloz0jy
	 tbi3xNalojfTbAzmba+ieKZyoh+UacDt78/Qs1tHemzJW4MJ26qBwIsGhAVLxAMq3M
	 5ha8WpdQu+UmOqqdCLTxspVe3TpXQ0VklR31/UEA2/1Y85FKsmZsfjX1NAS6lw9zm0
	 y+lFkJaJ11AEjz5V+9KU66eiHbhBscE7dts/k4nhLKSlK3uL02SpAwmKklPICRRxbm
	 Wk9QfeDNQn6Qg==
Date: Wed, 11 Mar 2026 20:26:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Jiayuan Chen
 <jiayuan.chen@shopee.com>, Jianzhou Zhao <luckd0g@163.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Edward Srouji <edwards@nvidia.com>, Or Har-Toov
 <ohartoov@nvidia.com>, Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Maher Sanalla
 <msanalla@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Kees Cook
 <kees@kernel.org>, Jang Ingyu <ingyujang25@korea.ac.kr>, Moni Shoua
 <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Christian
 Benvenuti <benve@cisco.com>, Selvin Xavier <selvin.xavier@broadcom.com>,
 Yuval Shaia <yuval.shaia@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] IB/core: Fix use-after-free of ipvlan phy_dev in
 ib_get_eth_speed
Message-ID: <20260311202603.265198cf@kernel.org>
In-Reply-To: <20260311100313.284589-1-jiayuan.chen@linux.dev>
References: <20260311100313.284589-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Mar 2026 18:03:08 +0800 Jiayuan Chen wrote:
> Subject: [PATCH net v1] IB/core: Fix use-after-free of ipvlan phy_dev in ib_get_eth_speed

FWIW this is not a net patch (infiniband is not net)
-- 
pw-bot: nap
