Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792494609;
	b=Tl09GXtGedDitEAEw5QSopPWU/kTAqwU6lkSTS0onWIKgdZhjmQFbmZVVFqZYtZWjKKj
	 ABuT1iW93l2tqzgqr2Tmcjsx+PsegaiKye2N3LXsmBJLYRNQadpUZ9z+omEh9V6p6+JtV
	 TNGx8CTZOyF+pKMTRYjJNHigQLjcDO5/3dWh+y8owEvsH3KKPZe3JQkskLbUWHectXc/5
	 C62euvTrR4Tp9Y/tRi53vql+Y2CzuqBYvTsk3BJXpkgywXzw8Ce8OeYptKxJrKwhcyoes
	 vNDYPR8iJzgJnSLgXREmwvlxoqGSQfA+DxazzEwl+YdKgXyHl/dZbiR7n4yhuNnimcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494609;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=yFDhqZ/GigELU52rkTAKVWD/cNGCa17xWBnqRhZe+D8=;
	b=qspNl4+urB9Hp1om7gajsZ03VC9Lqlk3Jd2EZN49hn8RalCkc1rR+6qIcVXiuduPyIfi
	 S0uwwf5zjvo0xqKM/AkAN2BaT43A/Ix9trIXAPU3Y4An5ClkLKR7SdKAs+uRr7I0qNmm3
	 aAlQSLtBzSIVud1VYSjVfhC09plrUeu+jVeOnxJ2GtoH6XVhsBPmthrCi5ywK98Z/cGeq
	 2h7jpjCy5xGY0bd7Wh+d9+L0IhqH+bOCygFJrdBSwYZmnGvNu1pfs5AvJFCamqqAWzwZ4
	 E1vCJ16loumnnWpJRX5zkYH3X4iq5hzecfmuQJmk7LrWjfXROQ+/Kjlg/Bigla1EsLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ebtu2X1d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5966A606A31A;
	Tue, 20 Oct 2026 11:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ebtu2X1d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090521F000C4;
	Tue, 20 Oct 2026 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792494608;
	bh=yFDhqZ/GigELU52rkTAKVWD/cNGCa17xWBnqRhZe+D8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ebtu2X1dwQXJGBmrea0MZo4vbQMq3CufZ4BZa7JDpLa+wHLuuaHYPc90hk3/SfcQz
	 +bfVoAsKVD898TRqxxlTCn4jHMfecGF1ReT70nFsChiXw3i7XniEPHE0Gyj/Mwu+F/
	 /QcWnYY1IvZ0YGYz9N/tNdVH0Dt5hMh+gp2SIFYEq4WV1J2i5jiDSmTaNFdXtyREgX
	 uA7su20mmTaeq2qspTcJuHeMljaP5D0Um+qBLNBKkUJ79gmSOlhj2ylIamN7wIiG5+
	 ZadInnd5RoZWGTaRk5p89dRr0n/z0o1a32VCBPWXzJ54PeU4s5GEH9r1Yj+vTl9bBD
	 INOAcMsVIljzg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14883808209;
	Tue, 20 Oct 2026 11:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net/mlx5: HWS, fix pool creation races
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179249460657.3669402.17912100393322078875.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 11:10:06 +0000
References: <20261012100555.1317878-1-acassen@corp.free.fr>
In-Reply-To: <20261012100555.1317878-1-acassen@corp.free.fr>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Oct 2026 12:05:52 +0200 you wrote:
> This series fixes two pool creation races in fs_hws hit when two
> callers create the first pool for a reformat size or a modify header
> pattern at once:
> 
> - Reformat pools keep the pool inserted first.
> - Modify header pools serialize the pool creation while keeping a new
>   pool on error.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net/mlx5: HWS, fix reformat pool creation race
    https://git.kernel.org/netdev/net/c/d730ca15cf3e
  - [net,v2,2/2] net/mlx5: HWS, fix modify header pool creation race
    https://git.kernel.org/netdev/net/c/e4ab8ab27ab1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


