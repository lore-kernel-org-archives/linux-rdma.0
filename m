Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04AD30BB8D;
	Fri, 16 Oct 2026 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792112407; cv=none; b=TnxRHJdylJxeL6dQB9NcV4acuSlThz+UqOUDqPHLpFUBSd+eahEWZyyXbyigL45DgLvbdo7oCKRHhtUdEl/AxSVmVhSDba7YnN+Bqin02pScNL9GNKHIcX+GM4dFzNUwD4eom4HExuc91r9RTMqYmG5fPIxNolPSpdwlF2SdwW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792112407; c=relaxed/simple;
	bh=JEQGAuoX4CRBL2aeJSCyMPnR/2L89ZCgfAOtYQ6CE94=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CKj1qGaqw0ZNzG3uOfmmB/SQKVlXVTfN7ylpDpNZiT3kQfiOxNzbNy6tF3x0WNk2FHVW2NJaKgirrLum6uQ2NfIHiGmX1WDZX2q7jzp4oNaS4M/znj2o1me5mT0URDO93QZY9MaXxjB4uMXMTYA0yYOcV5WVGvgCG6eo8cvLFhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA/MBr7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA/MBr7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4562D1F000C4;
	Fri, 16 Oct 2026 01:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792112406;
	bh=9zecb8tpAjNqt1TGPdy7GXAvrfpY+vvrEfyLOpFNhps=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gA/MBr7WK59N9YerOPlm4F9/lbHhKbnHTjb58lY5FFBHGF1yJX2xxL+bGiY+WaRuH
	 ekR03gB0+yGKYBJmGYZTpiCCE9HWoevqrcwMfyXb02doruxK2DHlxLajEhrAoAaWJu
	 SgLXWvSuQZCV1HJ/qG4SL79djNqWiPAmvpXMy0JfXzdxxWLDLqNa/znzRgfOPJalNF
	 rOaCHdfHOMFoxKEYodKDuBvwE6F0s/ZXB22fb/GI3GKVUwj/bsaohEv0BjdMjeOTMU
	 y/Vy123sD0hEVhjOXsKHUvwIFaOEX6ZLAHqHIHjEMQogwjjy2o0rBZq5E56pg61KPr
	 c3Q7R8kEhcCBg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A9373808209;
	Fri, 16 Oct 2026 01:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: fix out-of-bounds conn_path walks via
 handshake
 exthdrs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211240503.4182913.6701476579804696289.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 01:00:05 +0000
References: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: achender@kernel.org, pamoutafpro@gmail.com, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Oct 2026 10:53:36 +0800 you wrote:
> Both the lane and the connection-generation negotiation are driven by
> extension headers in handshake packets, and both are processed
> unconditionally, even on transports that are not multipath capable.
> A non-MP connection (t_mp_capable unset) owns exactly one
> rds_conn_path slot, so a peer claiming up to RDS_MPATH_WORKERS lanes
> makes every subsequent fan-out walk conn->c_path[0..7] at 504-byte
> strides past the single allocated slot (KASAN: "Read of size 8 in
> rds_conn_path_connect_if_down"); the generation negotiation opens a
> similar out-of-bounds walk on the same array.
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: fix out-of-bounds conn_path walks via handshake exthdrs
    https://git.kernel.org/netdev/net/c/50f2103fce43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


