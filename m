Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC30421F05;
	Thu, 13 Aug 2026 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786618867; cv=none; b=myjhvKBmm8vVn3UyXx1435Fq2bPjJVyN8qIqia799baZ1IOOQk4So43XC8KeI3yeh3UWM2JnpUpvRKIGHysdyGPDhg7E63CtRcNOCoEo60+3kvrMj1p4qCvyYfMTJfxBERuAFPaVYqZXViIurhtdmelGLcESQXh91/2tEfPuvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786618867; c=relaxed/simple;
	bh=kl5kT4WDoNqCd2TPK6QMq43uimaTfa9HZqU7CKSvPfk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Zmmf4pdUSPsojAXPUaP5u4G+UkSZ9t4kdhQf8U90GB8xJAz5zvFGMmc97mVp7RjdNYR86JKegbdqiEBAWlbyCDUezUIB8Mgjfj7eUCz2FhDe/40/WRRuFNkdwinQWD52gRREVXxXk3C6n0joHVjG5xukX5cwGHTambwwm+0kb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lxyhxctw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lxyhxctw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7339E1F00A3D;
	Thu, 13 Aug 2026 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786618857;
	bh=eLCpRmyGsHmsxYlvbmHnShpydqkpj4y+61ao7K8/fyM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Lxyhxctw/quM19nwYNEwRIFpQeYUNMMZEzf7tzUUPlNLyGIYQqcKAQ1rFO1Y+1Nyq
	 Ov0ZYtHRNe0jEJUB16SfdOGmmR6N5HxakbxIIB4yR/YmnQ+eKVDFK/Eak+H/V/wg08
	 azuF4O2AHp7bm/lHA5Z0aMZ3tFSc2VjcA65T/805NkNWYPOJn2FcSuSYfvMgD8ILkg
	 UrKXp0hNiO/BU2k7H40Pr3T+y7N7APAQT6ogJOEEZiRPtYAR2ueDhrKMHTXM7Glz1+
	 6/T542jjrjn4XAi4wp0d7/ocxL4oxh4m0BZFo6HTqsphYf/+3u+R/41IX2I+KIOGzK
	 cS7KhOuvg9uNw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 937ED380CFD7;
	Thu, 13 Aug 2026 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/rds: clear i_rx_lat_trace in
 rds_inc_path_init()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178661881213.2374993.12011037077966249761.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 11:00:12 +0000
References: <20260810055631.299558-1-achender@kernel.org>
In-Reply-To: <20260810055631.299558-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, jhubbard@nvidia.com,
 leon@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  9 Aug 2026 22:56:31 -0700 you wrote:
> The commit that introduced the receive-path latency trace added the
> clearing of inc->i_rx_lat_trace[] to rds_inc_init() only;
> rds_inc_path_init() never got it.
> 
> That asymmetry matters for the one caller that reuses memory:
> rds_tcp_data_recv() carves its rds_tcp_incoming out of a kmem_cache
> with no zeroing and no constructor, so after rds_inc_path_init() the
> array still holds the timestamps of whatever message previously
> occupied that slab object.  No stale value is user-visible today -
> every message that reaches the socket happens to overwrite all four
> slots (RX_HDR at allocation, RX_START when the header completes,
> RX_END at delivery, RX_CMSG at recvmsg time) before
> RDS_CMSG_RXPATH_LATENCY reads them back as deltas - but that is a
> property of the current writers, not of the init contract, and a
> future trace point or an early-exit path would expose another
> message's timestamps to userspace.
> 
> [...]

Here is the summary with links:
  - [net-next] net/rds: clear i_rx_lat_trace in rds_inc_path_init()
    https://git.kernel.org/netdev/net-next/c/68b3d4dbaf20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


