Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C85F3AAF62;
	Sat,  5 Sep 2026 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788640273; cv=none; b=sE06wdSUVeGngPf+CSQet7+imaWXixMGqxJu4YJqZA1ZWEdKdw4ner8EcQoNjG/vw1qwBrs2IJfVi8ovaOfCkV4gSFGRWOXBW6VV3akHchqFQzwN4lR+8JHPt6txAV7ely6wBzDSdtpAWQ/CYuCqzzfMi8367Bdw3+SD7/PB/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788640273; c=relaxed/simple;
	bh=J5abHtuB9NeV0IndTcI8H7iVZb9mfeAMgSHiruLi3N0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CsxBlviS3ybJ+u7V/wvNSxzb9f7EwYywzcDDLHQZz2O2Dvjs55cEI/TStPJJqaIz/ZoklwYHTSJLZ74oqLiTJmT76SXEzo4RndZbXEinAXA6PvFJRLMjGKvJH5uOPL/0jw3R9m9qgLCldLCrdleyX5qiMlXumkif/QK23akqF1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2vEcp2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2vEcp2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381DF1F00A3A;
	Sat,  5 Sep 2026 20:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640272;
	bh=jbSlT5NAs1eknPzS3r70rzaqbvNLexaGw5/MBBI/x08=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=C2vEcp2XzTXUHNMLItP6npJ/BMWJEw6j2evNv9RFy8iDHmwDwnCW+bKR146Xx73mf
	 4K2gmoLocuu59SgsTSi2HvXdGMbsSt5+MRrvVANidh/v6z+MRYN4glGSiFXYH5Ea6Z
	 w7IKjGLuFnWlwpXB8EumsRsCys/jY6OwcOa4ImqZ/hPqAyvzLysPxawUlygo3xLFzI
	 6oKJkayZDJ3U/J7Ks7d55K3NmjbGiX49LISM5XPiqlb24auR7lfwqFnk8Pw5uWjviS
	 8nM8d9Hl1bEHzqjSwsyJ0QWVXSjf6hKgSgxSwaw3DUAKAWT9aWRepKSj+exFbcOmyk
	 zLcF2D9ui731w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BC03924FED;
	Sat,  5 Sep 2026 20:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: E-Switch: fix use-after-free in
 mlx5_eswitch_termtbl_put
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178864021214.1345393.10049217548777927998.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:30:12 +0000
References: <20260902193514.3668880-1-tariqt@nvidia.com>
In-Reply-To: <20260902193514.3668880-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 dtatulea@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, ychemla@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:35:14 +0300 you wrote:
> From: Yael Chemla <ychemla@nvidia.com>
> 
> In mlx5_eswitch_termtbl_put(), the zero-ref cleanup check reads
> tt->ref_count after termtbl_mutex has been released.  Two concurrent
> callers on the same mlx5_termtbl_handle race: one decrements ref_count
> to zero, removes the hash entry, and calls kfree(tt) while the other
> has already dropped the mutex and is about to evaluate
> if (!tt->ref_count), producing a use-after-free.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put
    https://git.kernel.org/netdev/net/c/7ee07f601f8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


