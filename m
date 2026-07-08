Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA89409631;
	Wed,  8 Jul 2026 09:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503031; cv=none; b=LyBpZG+4Z6SkZrwjqsea10dKnXaD1fkE1DqGU4v6luPCiAiP9bhf0bOY6JMDgazHYRt6fY/2RtsI3zZfBBzq/cm1kQNa00wOv1Enoy37Fnxt21ttf0I8cgi7n5Vd4uC6vybq1n//Cm17hge7h+wlyR163k+PCMxfBqF2+vbCwZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503031; c=relaxed/simple;
	bh=/2j4cwYxuKWS4+udthx3B8WvhFnFUuf4/Mi2+zu589Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=o+2Px81sdDcjKh6SLwiPsX6FQBBSB/1K7h7a2tvaqQr+zbUKGNiNYxG0l4IjeVp2x34Dk2k5q0I+vZYT0xFujKtGQGGAOzsiqkxtOMSTudaIaYffqir6xFF9elwPvZl3sUjfwru+ilhrSmO5MxxX9F1FZzyAQAJt5349fU265O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2Qv3WY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2Qv3WY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F171F000E9;
	Wed,  8 Jul 2026 09:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783503029;
	bh=VOLjFkTtD2WeJzPh6YV7IO8zlHSCJPyGX+mnycJQSAU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=G2Qv3WY51e/EUcelScfmwcU6jqmBByjVehf8+5XpN3g9PwUwA8KLYl9ZoKsyuZ8jU
	 J/bvb9E8+jMLKe/RRZTjKbYsByknky8UNX2MdlcPbvCNNWbh1XD4i8ucUjnADo8lB0
	 56g8ufknvRkmPjVOBdVUEq5aSE3r3S1ItPaWo+ZlYKPtWKIMYtc5dDnvVcixy6BfdT
	 fQOCW6XKmDmRp5ZH8MtMfMazzN+LZT4S7zIxFc2sSgbejTRvAEpCtgWDfpl4KGEvaW
	 ntoCYHxb9/0RRkjvqYeWWodtH9dzsxJO9z1Xnty+iFS+jDoRjvPsGgK2OjUFgsmO1S
	 6DEFC+3E6TGwQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93CA539263BF;
	Wed,  8 Jul 2026 09:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] devlink: extend phys_port_name controller
 prefix
 to non-external ports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178350300814.2399537.7921578576105301581.git-patchwork-notify@kernel.org>
Date: Wed, 08 Jul 2026 09:30:08 +0000
References: <20260702111726.816985-1-tariqt@nvidia.com>
In-Reply-To: <20260702111726.816985-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 ajayachandra@nvidia.com, cmi@nvidia.com, danielj@nvidia.com,
 jiri@resnulli.us, corbet@lwn.net, kees@kernel.org, leon@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, parav@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com,
 skhan@linuxfoundation.org, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 2 Jul 2026 14:17:24 +0300 you wrote:
> Hi,
> 
> This series by Moshe includes the controller number in phys_port_name
> for non-external ports with a non-zero controller, and updates the mlx5
> driver to mark satellite PFs as non-external.
> 
> The controller prefix (c) in phys_port_name was previously only included
> for ports marked as external. However, newer devices can have multiple
> controllers within the DPU itself, even within a single host
> environment. For example, a SmartNIC may have additional local PCI
> physical functions that are managed by the eswitch but are not on an
> external host. These ports use a non-zero controller number to
> distinguish them from the eswitch manager's own functions, while the
> external flag remains unset.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] devlink: print controller prefix for non-zero controller
    https://git.kernel.org/netdev/net-next/c/f6ec46b7e2b2
  - [net-next,2/2] net/mlx5: Set satellite PF devlink ports as non-external
    https://git.kernel.org/netdev/net-next/c/a49ea2e042af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


