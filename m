Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6064133C518;
	Wed, 23 Sep 2026 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126479; cv=none; b=sttmaqY3eOxumqHg0fz4wPTjQLYq2+9yXzfC/krknXOOB1cg5h8kyM5l97G30cp+czw4faK2N/E5u67EVJAcKapDHH8cCY/5a4Zmn+C6Qp3/OwHD3FCrrp3pqcyXRaOV7W7Awsy6VZZq5mSHTXThCPiySACLauxbfFx7XujIKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126479; c=relaxed/simple;
	bh=Ci8Y0hYUeMX9BYCWLwUm7cDONXGORts/mymg36qNdiM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Z5VPvzH89JVhg6rsK+aG1Msr9K3vKqh3gq5MzKg1BtpZ7FPGXIMrVj8+0GHEGy2vd7PBlQ9o4QeCycIXnaBbx7DzIAvMTW/kP6Sqs8JV+acDrFi7xnWwo8FfPcsfTtYj5SUVowNMk6OyFY2MbZ6KuC0pj9avGNv9Bnw6Ctq/HO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mshf+jb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mshf+jb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A061F00893;
	Wed, 23 Sep 2026 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790126478;
	bh=tyU8Bb6+3K4VexGl/78COT58utvLuuESmJQNjxtWj0I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Mshf+jb0ybqiOOAZPG+HrDirz0fhi+UnHMla3r/69mNTTnpNmVIQ+Mnb99TpHK0Ft
	 /RNO0WozgnI/rnVFl5PJGiKT+LmIlh54FgB2P3Ckilb2aBKTu2CqEUgDlGTfFRmRN1
	 Ky2TYs0QM+XnCKAkW8h5T5Oi3fhn5lEIfT8HWWeojn1RhBInf2fU8nAq+OdLzsgYJ2
	 GR0WnP9UUtppnfYCDF9X7v88BC4HdpwzcymF4W5uXe2P9ggYkYDl41ddJysDACV9G+
	 Z6nuiDpPI8WQ3WKnEpkSp3PVZNsF2Vrjtc+o9oA+CXLnrhRqDj4EVF8fZ3QMnZ95yc
	 VFUwJbr9mLfaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A483924463;
	Wed, 23 Sep 2026 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/mlx5: Fix rev_entry reference leak in
 mlx5_tc_ct_shared_counter_get()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179012640839.161587.14121766119864884791.git-patchwork-notify@kernel.org>
Date: Wed, 23 Sep 2026 01:20:08 +0000
References: <20260917113131.2149024-1-vulab@iscas.ac.cn>
In-Reply-To: <20260917113131.2149024-1-vulab@iscas.ac.cn>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 ozsh@mellanox.com, pabeni@redhat.com, roid@nvidia.com, saeedm@nvidia.com,
 tariqt@nvidia.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Sep 2026 11:31:31 +0000 you wrote:
> When the reverse entry is found but its counter is already being
> released, refcount_inc_not_zero() fails and the reference taken by
> mlx5_tc_ct_entry_get() is never dropped before falling through to
> create_counter.  Drop it so the reverse entry is not kept alive forever
> by a shared counter lookup that did not use it.
> 
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()
    https://git.kernel.org/netdev/net/c/0bf6bb567f0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


