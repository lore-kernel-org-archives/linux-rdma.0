Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5303E9C16;
	Fri, 17 Jul 2026 10:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282437; cv=none; b=im3xSo5hmvr0O+SrBMC/5e6wlhNmqbGJi53FxPVfIoTh7nrB/h3NGtzkiaKBIERU5vGbppgTEi/xmcxBXopK2gUzc7chyeekjNAeqjikLBwhrc06fxUOBsJSFcA8FnI11jQ6ogtGW/oTnFyfrUoXiypoM7dFgo/WAsoSw7Tvdto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282437; c=relaxed/simple;
	bh=4jCBcRVrlaLOBYAzTmCWXlcxLi58obhrcv78JY6m11w=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=c5YPcMkkIAgtbUJfR1uxFfLiKYMjlXPAZGA7uFwjiU+kcVhoCsHoQS/PVDuJ3SLSM+m46+5h+bsYvbPpzX8UtAIcJwhEVRkTo4QuPSp/Aq62oTsR2eq6NjeMGJcFY9S7j0SQ810Ux+KRj2rm5KylSl1at3xFskzXorqyQ6I4Hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGy1Rgez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGy1Rgez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039571F00A3D;
	Fri, 17 Jul 2026 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784282436;
	bh=R169iEgJLSTU6BsFVGZtAdHBaDZjsfylReCCD0K+Uo4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kGy1Rgezx3zfwFJoiBo2kQErslDHZ6iRMb5LFAgsbZUwUqkoQ3JcSAOhXDnb1lqsK
	 vKWC6oemOyzJIy6KqhldbN7mEeesYY5c0QmWovmcc0zkkKlDGGBNGpvhxiJAzQv1mA
	 vE36Zl4/VFZIF6ZSNH2v3HS85/1p8ngO1Hqse83hDUBs1a2RBghAixtIKbZeosOLgv
	 4UDek3q4xdS8ZogKyKrK3st26sE1/qqIEFNAiIPHWeBNoPKxrlhOuGwpGZ28CsGe92
	 AnslXJLRQ4eSJpF7Hn/Zu4e5sCiRN4wFdSUgHURyLhGO7PVFTrjLTiReev+UqjexDn
	 fBqUmv6Mu7CZg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C1D34380CED1;
	Fri, 17 Jul 2026 10:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/mlx5: free mlx5_st_idx_data on final dealloc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178428240839.1642910.17157981121127705010.git-patchwork-notify@kernel.org>
Date: Fri, 17 Jul 2026 10:00:08 +0000
References: <20260702222507.1234467-1-zhipingz@meta.com>
In-Reply-To: <20260702222507.1234467-1-zhipingz@meta.com>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: jgg@ziepe.ca, leon@kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, michaelgur@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 2 Jul 2026 15:24:58 -0700 you wrote:
> Workloads that repeatedly allocate and release mkeys carrying TPH
> steering-tag hints (e.g. churning RDMA MRs) leak one
> struct mlx5_st_idx_data per cycle; kmemleak flags it as unreferenced
> and the kmalloc slab grows over time.
> 
> When the last reference to an ST table entry is dropped,
> mlx5_st_dealloc_index() removed the entry from idx_xa but the backing
> mlx5_st_idx_data allocation was never freed.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5: free mlx5_st_idx_data on final dealloc
    https://git.kernel.org/netdev/net/c/df6134b527a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


