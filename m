Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B0221FCD;
	Thu, 12 Mar 2026 03:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773286401; cv=none; b=eeVVy4PxJfi9aSRsu+dqPPXj/EcQ9mDCRa0sFhZ605Q8HrvkMvfwwkQwqGGpKwDP8JKUzKY9SIziMzFKRdR4EpktaRFOj1K9SHiROqtVEGJZ4nX2CmBfoOj/bOgaQTErj8iuDAgwqIV20p2LkPcza0p5hAKhH/w+WY8w06EePhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773286401; c=relaxed/simple;
	bh=9rgwBN4KgHcwoIa7ezCCM/dYf9VHg6Q0vDwthV2vBX4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SeHNr0lYBEXX4bCB7zxw3+N1nFYRSYNy7c+z0HNTDdqQ5daL3o+aZiwuNDYMXRgY35reRMXnawAA0vduIs/5x5mCUUBHIzMeef+RFG6d5ZXz4btN08ba6Ws+nESLRWC4dx7I+NJZQHXdHI78q0opAi6HHb66WEbpwHmXTIGBsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksofKqnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksofKqnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF98C4CEF7;
	Thu, 12 Mar 2026 03:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773286401;
	bh=9rgwBN4KgHcwoIa7ezCCM/dYf9VHg6Q0vDwthV2vBX4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ksofKqncXZtbYl4At45xJWgbNVm6hsyFk+tqKaCoXRqhkav3s8eG04UrRV6XBO6Yk
	 30mp7lB9ptoxmQEDyXLDxhrjqHCceWyOz8V0R1gL56ED+QMwGB3bLWDwRgXV29NijV
	 ykCBY9D91r+ntUxeRi7sdd7Ejx1m5SYGplpAG4nKsoIQmGYkczrmCUdZj1OS6SyYK/
	 eb52Bq5l4Z48Cv/Y9BCXHHv6rHgFNMD6ebvehoUmcVrfxfE2drsagbVrAvEHM4u/BM
	 a963Llun88mve22IjfO66Q7qNW2qE1arHyTo5i2Co+t1/sWTXDAsNLDrT9qlcpknoh
	 JFSY2E7UQn9iw==
Date: Wed, 11 Mar 2026 20:33:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, "Mark Bloch"
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5e: Enable mac forwarding on uplink
 representor
Message-ID: <20260311203319.76d35ce0@kernel.org>
In-Reply-To: <20260310104841.1862380-1-tariqt@nvidia.com>
References: <20260310104841.1862380-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Mar 2026 12:48:41 +0200 Tariq Toukan wrote:
> This small patch enables mac forwarding to MPFs via uplink representor,

"mac forwarding to MPF via uplink representor"
Can't wrap my head around this "via". Could you explain this better?
Perhaps some tool can spit out a little diagram to make the flow clear?
