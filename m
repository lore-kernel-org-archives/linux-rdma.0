Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C2C47ECCA;
	Tue,  5 May 2026 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777989055; cv=none; b=q5ckcImYP3/Q34ocv94J0MmDjzv5JgX2kkdjo0w3TIDD+3DYzH+rS1AhHqYYEr+dFNP8Skeog5/orkdoLxuN+EuVzjA3z/diV7QPEiAFc386JpZu3ifvH5qaMdsC1NQTZnJI422IrfpMALmbbpFmgRD5tkJ+yru9P/61MRJ+0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777989055; c=relaxed/simple;
	bh=dxSFC6cP0Ql4v7WRghtRbrO7p1KLq30hD6iB9ytHjPQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dY+OWTkSaYYLp653vqnPIQZ/150HhCFrAGvcMJoA1VQlpIjaQApNNjTSq0X9Tn6e+OuVLLmoj4pJvYC67/PJelR5/VRM5teAwdLyED12ZdpE1O7CpD73+fcww3Qmh8ZEx0MqmyuhtPCFC8aYNg8ajDe2/P+uFKyqlsV2WS6AQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXL0JWbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXL0JWbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F434C2BCB4;
	Tue,  5 May 2026 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777989055;
	bh=dxSFC6cP0Ql4v7WRghtRbrO7p1KLq30hD6iB9ytHjPQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NXL0JWbKeHOB5TbZ2tOAhi+JilCacuR1QFeBKjxUqRNnC/uIeph7g79PAM4AliO8K
	 sAGlKexet3Xnv9/76S9iihKk910A7vnsb2AEWXUMuiiPwtTrDnL8MXoIw1SNT6tifY
	 eYkjlJxGYzGU0U26TTmP5A7aZehFEVwjjRNEyRNC+0RQTgidsv5x+wuesDZYoQXf6g
	 Sd/0Efa0JjmRRUylynOCsqvLcFRixX8ut2U0ZYiyQbon+4ma/M9C41ABoYbO9Lxnue
	 yGEYFnh+J1jP9V5hhqT73qVG1xG2uy4EElu52/piAYZ8hVh5B7i6DovLhvNgb2lDgn
	 jErSlhgT6l1Yw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D003930235;
	Tue,  5 May 2026 13:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net, v3] net: mana: Fix crash from unvalidated SHM offset
 read from BAR0 during FLR
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177798900580.2064937.15974739888920715703.git-patchwork-notify@kernel.org>
Date: Tue, 05 May 2026 13:50:05 +0000
References: 
 <afQUMClyjmBVfD+u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: 
 <afQUMClyjmBVfD+u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
 john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 30 Apr 2026 19:47:12 -0700 you wrote:
> During Function Level Reset recovery, the MANA driver reads
> hardware BAR0 registers that may temporarily contain garbage values.
> The SHM (Shared Memory) offset read from GDMA_REG_SHM_OFFSET is used
> to compute gc->shm_base, which is later dereferenced via readl() in
> mana_smc_poll_register(). If the hardware returns an unaligned or
> out-of-range value, the driver must not blindly use it, as this would
> propagate the hardware error into a kernel crash.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: mana: Fix crash from unvalidated SHM offset read from BAR0 during FLR
    https://git.kernel.org/netdev/net/c/95084f1883a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


