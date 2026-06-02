Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD18431F9A3;
	Tue,  2 Jun 2026 20:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432804; cv=none; b=d4wc5EEzslaR9EeZ2fwn5Jv7G3dzTgXGWRvKed77paz8lTyllZeZ+Iy3/Ur6SSNfeNYyH1PaGnICGpw2FI3Tztbp6kcMKYKvenP96DmwfVWzOo3Is0rpjQym0X5DdX8OKI74d/0Bd0IEn+8cvXcndti7Bi0KQZIdefvBPh+fXSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432804; c=relaxed/simple;
	bh=BfLDQr9pt69S8MlWwDuy/Z+mVbeCcUXRj22h9jDPRSE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WT/YZr99qNCRHGISNa5amqIMJ/vZseZWsHQt6LDDi+KDuIr005JS1jqJyXZ1ixb2ZuZhqUiVgNhFWSRCNPe20wW5itmUauz2OKkMbsk0pWmDl4Z3g2zfYx0Y8uHphDjyA9ZRqQX8479EU8yy2wgxsHPd26NeLgWBCYvMDDcxvp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbCAVXTa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbCAVXTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FFC1F00893;
	Tue,  2 Jun 2026 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780432803;
	bh=FOpl/ZpM26+tD54wKWBy5O0+u1RCyEjX0Ylp6b3/Ybg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dbCAVXTa1jblXOpkluhoDXnzArjP+63aCEXBYvb9ccHtNXONNhK4cnwNyr2JtR5TB
	 Ru4fkcw4ieIU6akcYldRp36DiyMwu2V42fqKKLGZHjbl7xMyqVsDAQVyV0m8H+yyuN
	 Hjlwcbh1xcgoN0GTRkC3ahWHn6fuMpnSgxhV9aEPWwM/eaP4JFawVcki8B8XQv2oGn
	 KdGTLP75Tc4roMZ2TpTr6lYayJEs0priqyEXqqn1zIFX53sejxm9JoSVlVlatWcUU6
	 fkmcBYKS/zZo7RYnWY/tpE56M9CbReuDuGPLKx67aiJkPty9S9gqHAMNaOBo+oyNXb
	 MkkDIDnk8aJqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93CAE3811A72;
	Tue,  2 Jun 2026 20:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: rds: clear i_sends on setup unwind
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178043280517.1040770.3974828278309991048.git-patchwork-notify@kernel.org>
Date: Tue, 02 Jun 2026 20:40:05 +0000
References: 
 <5a0f7624bb9845a7b67d26166a150b59e7f394ce.1779632468.git.xuyq21@lenovo.com>
In-Reply-To: 
 <5a0f7624bb9845a7b67d26166a150b59e7f394ce.1779632468.git.xuyq21@lenovo.com>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, achender@kernel.org, yanjun.zhu@oracle.com,
 guanglei.li@oracle.com, davem@davemloft.net, santosh.shilimkar@oracle.com,
 junxiao.bi@oracle.com, yuantan098@gmail.com, zcliangcn@gmail.com,
 bird@lzu.edu.cn, xuyq21@lenovo.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 May 2026 21:01:44 +0800 you wrote:
> From: Yuqi Xu <xuyq21@lenovo.com>
> 
> The RDS IB connection teardown path is written so it can run during
> partial startup and on repeated shutdown attempts. It uses NULL
> pointers to distinguish resources that are still owned from resources
> that have already been released.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: rds: clear i_sends on setup unwind
    https://git.kernel.org/netdev/net/c/20cf0fb715c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


