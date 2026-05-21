Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88336DA08;
	Thu, 21 May 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375013; cv=none; b=SDc+Wlx6/+3Up9tVev+J7hRdiNwx8CqAjjXrug2RFwMmp91zMGv5/v+hENQ1f+yi6JGczLkLIASE+7a1bq1EfybL8bKaRljTYZAoZ83oSAhR7Chi/vxZhbT2qpwexjmKoXeqtL9yAnvK5QSvKCvr7X3P0xFL7x6eVWQ8dPHYlZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375013; c=relaxed/simple;
	bh=ACxOLhgOy0RwtqoNe4ttLJWQ2yRPrIuoz3oJPSrSK10=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jINdtBpVnqVAtryNwq7N81qLhLG63rVabv5n4hj61Ev4v7hTQ3bN282lKIhdBICqJfGC1f91bpsOVC5+03iW2acmDcw9+auhOQ3tRHxWvfz/SSceLSm0dwu1y0sNkHggBArhdYk30qHAc14JuflM42S81FEjsydvEIZTl7ULTZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxwKCgZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxwKCgZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85141F00A3B;
	Thu, 21 May 2026 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779375011;
	bh=PVVBxWQCUJefak/DxtwQ/miZmqOX2+wR3VVcsD2FSVk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=LxwKCgZjeh/MGnpRXHwIkHtxLUjaZy1LgYqcijN41qqc59gmUYdK1zuNYK3f1nPA/
	 rzApBvtYyZNp1nXr3sitwP1OJd7bb3aRNEyorWlgjddBo5ffl9PoDpmn8tgM9hk+PL
	 qyKenLYWFwqUhkJRgSrygGliZeyRgFtSaV3VsD8ZXegnCS2LjQFz7rSXg9LcvEDjQf
	 qtWXHl/M6qF8GD3e4/vYAj7yKJta4oKabYHlKk6nkrILLN2s/DQXYdQxKPxtTyj4br
	 aHIBgdjUjssHl/eFQ5Vxvds9keJA200EaEIQX5eOuNq43HdmHjxrpENXem8A6YhAXT
	 /9p2MC6ZpRj2Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A7A3930DF1;
	Thu, 21 May 2026 14:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: rds: config: disable modules
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177937502163.361786.132829360372655612.git-patchwork-notify@kernel.org>
Date: Thu, 21 May 2026 14:50:21 +0000
References: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
In-Reply-To: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
To: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 May 2026 11:34:43 +1000 you wrote:
> The run.sh script explicitly checks that CONFIG_MODULES is disabled.
> 
> By default, this config option is enabled. Explicitly disable it to be
> able to run the RDS tests.
> 
> Note that writing '# CONFIG_(...) is not set' is usually recommended to
> disable an option in the .config, but it looks like selftests usually
> set 'CONFIG_(...)=n', which looks clearer.
> 
> [...]

Here is the summary with links:
  - [net] selftests: rds: config: disable modules
    https://git.kernel.org/netdev/net/c/92cc6708f4a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


