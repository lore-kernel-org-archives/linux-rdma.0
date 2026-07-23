Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EC39150E;
	Thu, 23 Jul 2026 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827841; cv=none; b=KJlACFaKR04dfFhPvlc7v/D9UYcH9+kUidhA2S+ByoLAfeiYzBl2MZFK7IojUk5EpI2iYe3MfMJbAqSoc/9/ZaOJ8nFkebn9t60XvQrDTSaGsNiRiAfqBQCpDd4ZONSME4GUg6YPKXduetVsInYakbdsk/s5b5UWijaKSElKrn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827841; c=relaxed/simple;
	bh=nbFdrOcqbg/t8ERm3fB9k0ShcBAhIoRkQqmqMotUCvE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QP/azxTMgeMKQC4WVRFTeqGYzpU6tMMCDuQ9c/TLzthpLFZ+ewE40xHvkEg0azMW/15qeWA1uCr8M4OpgScN2XFeVx8iumsuxddr1SdT1CsCt3derflc2a9EVJuSvC1UX2N06z/NieW/hTTmCO74ky3IHKA1YP6bj/vmfivdejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYSm1rBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYSm1rBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5125D1F000E9;
	Thu, 23 Jul 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784827840;
	bh=Tfzpjqyvjx7nfJVdPfBzDaZbT9I+gZXmcJMQKmkgvyQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=FYSm1rBkg+DXycG/blmG99gl9MaOe/hxXaPsyG8ZzRBZqcdHmrpGoygUDGYyz+5y2
	 LO0Pr2/aRgh9dleh8KLcRxnHHb8Ac+UtwR8ZAmndoi+FfUbrKHSeSnIt1Clz60KsPb
	 uex3OHUO2mh95n3RPVAi8hXTf+pZSObtHpz7Ia9NGnvotgVWhg+ACqllrAqpGW7E1v
	 jMlVlH2hscJNwvu9I+gaOF22s2HhBUp88/wpv92ivChHMMzoMu9dqLxOqD4iZrDz4t
	 YkLp5b1JrF4y1X9ce7uV+B4DaskPNJNFh0hh7akPA4ZKmWWev5CiqzFk8j3+MjhSLZ
	 xwo+HU0dBFeMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9398739244C6;
	Thu, 23 Jul 2026 17:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] bnge/bng_re: fix ring ID widths
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482780815.2797885.10912755981565020942.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 17:30:08 +0000
References: <20260721063731.2622500-1-vikas.gupta@broadcom.com>
In-Reply-To: <20260721063731.2622500-1-vikas.gupta@broadcom.com>
To: Vikas Gupta <vikas.gupta@broadcom.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, leonro@nvidia.com, jgg@nvidia.com,
 bhargava.marreddy@broadcom.com, rahul-rg.gupta@broadcom.com,
 vsrama-krishna.nemani@broadcom.com, rajashekar.hudumula@broadcom.com,
 ajit.khaparde@broadcom.com, siva.kallam@broadcom.com,
 dharmender.garg@broadcom.com, yendapally.reddy@broadcom.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jul 2026 12:07:31 +0530 you wrote:
> Firmware requires more than 16 bits to address TX ring IDs for its
> internal QP management. Widen the associated HSI ring ID fields to
> 32 bits. The values firmware assigns remain within 24 bits, bounded
> by the hardware doorbell XID field.
> 
> The fw_ring_id field belongs to bnge_ring_struct, a common struct
> shared by all ring types, so widening it to u32 applies uniformly
> across TX, RX, CP, and NQ rings but firmware assigns values within
> 16-bit range for all ring types except TX, which requires the wider
> field.
> 
> [...]

Here is the summary with links:
  - [net,v3] bnge/bng_re: fix ring ID widths
    https://git.kernel.org/netdev/net/c/b9e558976bb9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


