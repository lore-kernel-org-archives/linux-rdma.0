Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643032D42B;
	Fri, 19 Jun 2026 01:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781833217; cv=none; b=CbnlAkrSs4NyZ01cIlu1lg9CO6fgnKTpPHLbulD1jG456ndsvtB/HRqViyIhDQD8eWRYKHWphCwwk/3pL1eKm4FiZMoWDKL8VbjJ5knL0FXcl66Xh5p7L9MwC7ZIRmIatsVxYxa4XL9A7L8RsassPx+U9U6uk/iz3HPDLp7Q9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781833217; c=relaxed/simple;
	bh=QfCBpncQlOOZXopSotaFNivUVhfGcsnqjDggUYrE81o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uRskHjRzc0p3Jgo589VA+ICJNl3mNWRAAckMeWdVbgUF82rbvhuqNER+vHEdTupQ6vHK0wQccgu91v7o9nInTOA9+qszVgDUOZ6WJKB/wJDD9vjpbwLk0FwxEEMJxTty3vFguaBL8a19DOfK7QcbIh+shbDbYboh4LOEIKtcwE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyC6G/+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyC6G/+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9168C1F000E9;
	Fri, 19 Jun 2026 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781833216;
	bh=rKZtTIE0EozqPiewpjLb1LvOAUGg7HQbicSGBApX/L4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=QyC6G/+GffRyHoR/dZN1eYrwkNyqNhnTnAkNCpnWy6Ij2zkAzNpL09uhkRI8WL5Mu
	 l0sjyKXHZycTt/kVk1S6e1LXHNMhSIunGfxliDi87fP5eniIqekrjRN81M06d8EQKR
	 49eOA/DHdF5Mta6lsCqQVXbapsA9gtROrX4/OmwKB9sN1ilfKZZMANtapE+Bb0wcOt
	 dINf4ejOr058EKFQqeKnm9RkjgpdkvFredlsudxVeK7v4pTyya9O9BP1oXq0xq5GwQ
	 shEOCO6c2KXz6xB58A3OcDJtz9KWNDF5o2YWDtJaoX5Dz5kl2NT0Z3C2aq4Hjd/Bkj
	 I/P53OLYxYYkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198553A78A7C;
	Fri, 19 Jun 2026 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: rds: check cmsg_len before reading
 rds_rdma_args in size pass
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178183320963.3155315.8392610577846056052.git-patchwork-notify@kernel.org>
Date: Fri, 19 Jun 2026 01:40:09 +0000
References: <20260617023146.2780077-1-michael.bommarito@gmail.com>
In-Reply-To: <20260617023146.2780077-1-michael.bommarito@gmail.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: achender@kernel.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Jun 2026 22:31:46 -0400 you wrote:
> rds_rm_size() handles RDS_CMSG_RDMA_ARGS after only CMSG_OK() and then
> calls rds_rdma_extra_size(), which reads args->local_vec_addr and
> args->nr_local without first checking that cmsg_len covers struct
> rds_rdma_args. The other two RDS_CMSG_RDMA_ARGS consumers already guard
> this: rds_rdma_bytes() in rds_sendmsg() and rds_cmsg_rdma_args() in
> rds_cmsg_send() both reject cmsg_len < CMSG_LEN(sizeof(struct
> rds_rdma_args)). Add the same check to rds_rm_size() so all three RDMA
> args passes are consistent.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: rds: check cmsg_len before reading rds_rdma_args in size pass
    https://git.kernel.org/netdev/net/c/e5c00023270e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


