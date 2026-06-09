Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE73603DF;
	Tue,  9 Jun 2026 02:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780970414; cv=none; b=LQO12quXWKUzv6skJOhE+GzomXgkN2hbH2LJpDjinbVwPZCrU2h6Xw9/bkRRkVVn4n/uvJ/78NNRZy9MsROcI2jEzKZ+E9zeKQxdWFy3eLAwzY+6kRaeTbyi2Tl69Fh79wq7+A7zYrCqWX7S6xr9uwqh05lheKTEWsI0GXenDgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780970414; c=relaxed/simple;
	bh=Nb3syNVUCbIsKR4fOLTg2kYNKY5iyRqf2bzTkYQVfds=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Bp2mUeH4CsTe9JIhCtF79ZU35pgp7PZmJ5feh24YH8WJ73ORGqenXoiul5USmJylkw9W+Z4IySlAhkdghbCLkizfqduggoVM17zC0RLjU4ca4fRdRB86aGTZeFGeHARXum0g2Ah6AbizeGeb3LeJkqOCHzzOYrL5xWPJ7kXOmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Of6NNlln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of6NNlln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734351F00898;
	Tue,  9 Jun 2026 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780970412;
	bh=GuPGsfl+3nepH4XQSbxK+iliY5cP1RFHvLwVMbEza/A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Of6NNllnLRODkvrVsS3RQRfgSS0t8VraU+GpoT3pAPlNqnMOTGyF9F7OreXqVldWA
	 tBArmvSRikmvXzoPpMWdTrlHt353KM3qc4u0dMR1aqGnXJNiR8m7SN++Ar436cpqb6
	 kZWZryvTle7bjMZTxCv5hFV0LOshqc2iFubn/81tZPigg76a4fbrKqDoFuwf+my6VM
	 n8whAYGFWg5/Aw6H2BUiG9CROhO7T7+u7pHsBCuDu7KKtjUgta18zr7C5SpuUESwOi
	 grBPgkd5CYBv34tGFJEjlQeOl/W51UN/7wwYpArTndgD2OkcOHc3LGwVY/aHuqI9JM
	 xenqEg9WOOOFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569733822D43;
	Tue,  9 Jun 2026 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX
 xmit
 failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178097041089.1753037.7766508727996138928.git-patchwork-notify@kernel.org>
Date: Tue, 09 Jun 2026 02:00:10 +0000
References: <20260604135446.456119-1-tariqt@nvidia.com>
In-Reply-To: <20260604135446.456119-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 saeedm@mellanox.com, tariqt@mellanox.com, maxtram95@gmail.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 4 Jun 2026 16:54:46 +0300 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> In the XSK branch of mlx5e_xmit_xdp_buff(), when sq->xmit_xdp_frame()
> returns false (e.g. XDPSQ is full), the function returns without
> unmapping the DMA address or freeing the xdp_frame allocated by
> xdp_convert_zc_to_xdp_frame(). The xdpi_fifo push only happens on
> success, so the completion path cannot recover these entries.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure
    https://git.kernel.org/netdev/net/c/b69004f5a6ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


