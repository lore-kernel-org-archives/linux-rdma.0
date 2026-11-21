Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795224008;
	b=lYlmM32FbGgclmh+5yugKyKtaNz4mGtQ0KwdR92s0xknCjIKwjNZ6zqOJcIAlXXjibwe
	 p9zlqZBMnMeqbpsKfpH3jh7pkpgb1GjnhPB2IRXbMX8j7yo0Y73acxy6tsp1aklRtKn/d
	 x4+1qH7kiEf2idWfKgVv12kcwg22VG4jMAP7VSA5rA4G3VJ0NQVZxb+E3p65qC2mNlS3c
	 E4ctIV2FShWbirT4O1aIm8OjWWbnsoymma8WupBB89BkQ2wpur7VqbF+pG6KvspSLWsDQ
	 /zeK/V9MNLlYaQDaZDYjX6KLqLIfiH7+SQbWToqmqcy9VJxRXowGvdJEw12M4qGMpsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795224008;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=A63RxKAwkZzHm3paAKlK/vSXiupUAfz4QqcpNoWmH5U=;
	b=roOxIEPekgMQdzXsSCRYIrCFFPwKfLDgdt3zO/3psLXS1CHLP6J7cmFtJHsA1e4N4Ujm
	 yYFUW5oZPM8dbCGB/93S2EyoH9YhMttJCF5IkjeTyR/leRB9fzPkP9Zw9FP7XQ11vfSkR
	 MwSBgXuhy+O3uKMYgdJHkPEkphQiXoKIEjrU2WPLP8I7RQZgMIEBbJ7z2iYD77lo9iEeK
	 pcmOwY5YBYAAF2gRyQ5arb9SD/g7nwYZVACGll96UEryuJWF7i2uO9ZP5UpeZErq/rdqr
	 YDLozw+8TWXW8lKKcasml0x6UXxcbv4II+xYscQsFhEe+xm6joFuzDHehvT+9qzxDRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/t14ql0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065CE606A691;
	Sat, 21 Nov 2026 01:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/t14ql0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF1B1F000C6;
	Sat, 21 Nov 2026 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795224007;
	bh=A63RxKAwkZzHm3paAKlK/vSXiupUAfz4QqcpNoWmH5U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=i/t14ql03YL8lD31HV3R5rS+U+yvRGr70JIxa3SCNX0/3xdQs6LF67EOng+ACH+4m
	 Oy0CWkUKZT4TMBuLKiy0Y0+AjMbJu3by2rmI5FTqtyUVaDTlEbX20AK+hk1K2q8C4L
	 Ar7ooUAaFBCJnxPpcRw++tfBlyg5QI3VebEB2IszjgzG2GEI8IP643Kt1GRAAFNPBa
	 Oe89+dY8S8vyg/wN6JghaodfexzrmtFQdg4wlrSA+rbGl49qip+B4Mtgq4fhZmtFX9
	 cW/KsuVMsvPgY9n7VrlHGnNZbtrw33YDlta9TmkrrY8SxlPvl5lGncdBj8tGePJQwX
	 49eUqEjyYvaEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77454380AA5E;
	Sat, 21 Nov 2026 01:20:07 +0000 (UTC)
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
Subject: Re: [PATCH net V2 0/2] net/mlx5: Fix HWS and DR steering memory
 safety
 bugs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179522400603.873873.14923348650809812923.git-patchwork-notify@kernel.org>
Date: Sat, 21 Nov 2026 01:20:06 +0000
References: <20261118173227.1957670-1-tariqt@nvidia.com>
In-Reply-To: <20261118173227.1957670-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 acassen@corp.free.fr, valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com,
 kees+treewide@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 prathameshdeshpande7@gmail.com, saeedm@nvidia.com, horms@kernel.org,
 william@theesfeld.net, kliteyn@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 19:32:25 +0200 you wrote:
> Hi,
> 
> This series by Yevgeny fixes two memory safety bugs in the mlx5 software
> and hardware steering code paths.
> 
> Both are missing-check or wrong-handling problems that lead to a NULL
> pointer being inserted into an xarray, or an out-of-bounds write that
> corrupts the kernel heap.
> 
> [...]

Here is the summary with links:
  - [net,V2,1/2] net/mlx5: HWS, Handle NULL in vport destination action creation
    https://git.kernel.org/netdev/net/c/c0ec15a58655
  - [net,V2,2/2] net/mlx5: DR, Fix out-of-bounds write when sync to HW fails
    https://git.kernel.org/netdev/net/c/0e56ff4441ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


