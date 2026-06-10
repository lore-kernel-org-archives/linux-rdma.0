Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8B427A0C;
	Wed, 10 Jun 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104812; cv=none; b=FRQvNPCx+H4M6OZZcYKK31P2u0HQvU3txHGFEVFMv6/zp5KUnRqcFR2R12VJhrdnNPmeFsLNeYEkWBr+H7GzaMpQOCDUVhT0xCWB8ZvSQgJVUiB8lG0/PfT/+OHssG4WZv0JGqh4Q0cZP6HDcAw8jCEcxoPeapXaoUElWV2yCwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104812; c=relaxed/simple;
	bh=pLCpcmfWdOkh9vAt/shqdNS3cH7550n0VAxQhyMZ4lk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bQte5zy04sanr71wqrlc9nfRB/gYtvX20QuZM9v+64T+dxbSvUcmkOAT+QUWfcUK5VMGEQnWhoTx6xBXDqdp6iMyGe/e8PJsQHFwLiliiU2olezkBqkeCRdTxpCjt65RTeNR3cLOvaAiqW8ZljfBq/dBQaeoCyLic3zCUMktoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G70YDoVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G70YDoVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AB91F00899;
	Wed, 10 Jun 2026 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104811;
	bh=6i9Jm5okbfmlos5U23G4dUUUadPFjk0l2q7W1GIsH0Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=G70YDoVxLKzDElLXlSz++v14/zxFXPXqcoxYcHEC1HCdy3MTUn4WNEwMITXYWiDhw
	 Q35bcOiqnDg15yAaBLx5JBG3Ao+b1nZKYMNYuDq3P6tEen81Kw0efuN7+7YNwtBGZK
	 cX9vFCPBKfS9A4zTUxvWoCC4N7Z49aIeNtn+ii0RiJUpvbRrnFTmDzzljIACrE3U+s
	 LAsie0jHVF5zQEirKVMznjshrxHUFutMtuafgxwpwAS/voolPcuugmUXYJDqXwyRuV
	 c7k9WdV61ApUuQ/J77T1vfYat1m+QwZEf5cW5s+kA/Fmea9I+pu/en9FcooUVjwh7a
	 WGMpdLLfMoOfw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A323930D5F;
	Wed, 10 Jun 2026 15:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rds: mark snapshot pages dirty in
 rds_info_getsockopt()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178110480913.3089075.6318008330720525320.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 15:20:09 +0000
References: <20260608-rds_fix-v1-1-006c88543408@debian.org>
In-Reply-To: <20260608-rds_fix-v1-1-006c88543408@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andy.grover@oracle.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 08 Jun 2026 02:32:05 -0700 you wrote:
> rds_info_getsockopt() pins the destination user pages with FOLL_WRITE and
> the RDS_INFO_* producers memcpy the snapshot into them through
> kmap_atomic(). Because that copy goes through the kernel direct map, the
> dirty bit on the user PTE is never set, so unpin_user_pages() releases the
> pages without marking them dirty. A file-backed destination page can then
> be reclaimed without writeback, silently discarding the copied data.
> 
> [...]

Here is the summary with links:
  - [net] rds: mark snapshot pages dirty in rds_info_getsockopt()
    https://git.kernel.org/netdev/net/c/512db8267b73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


