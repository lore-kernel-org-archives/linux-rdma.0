Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FC7385D9F;
	Thu, 14 May 2026 10:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778755261; cv=none; b=sbXtMxBnrSvAP+Zxw+KtqYT7qsQIkKCpLECwqjFcZusQlmCyBO3m6ezE7Tkt3e7enLiUx1owxwq2pDJ8rXIy3WiRmeA2RbJl1G8F2UvmUYVQrjuD1PI5gPC6aDfV1TZRo6RUfdG5SkVFLTG7R19cXxWQBbR5hmIoRvHnbnmUOAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778755261; c=relaxed/simple;
	bh=j4aeJ7hXLCW0IznM2rND+H9lSOsX/xzQ3lxoy3VVbRM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=V6WSH8QxSAAcr20hGdOoab2wwgrKomxJlMGbALWX1GV4Y8DDGcc8Xco/2+qT/j/b5cbGHV4UoZ1fIjjKB8CuAEk2kYqaKQzb78a1tBhNwsET+EpFRsFYYWTilqpIMLS9IXH2+XSH3SSnlmlyf7zyUOsFJlCsSLMjKUVKjV+Zr1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoC+8l/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoC+8l/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53C0C2BCB3;
	Thu, 14 May 2026 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778755260;
	bh=j4aeJ7hXLCW0IznM2rND+H9lSOsX/xzQ3lxoy3VVbRM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IoC+8l/7IR59VKZpjXx2e4VsFxFV1Ixw8dQabrjc2zDtvzaCYPNoN2zvkd8xHkyGH
	 fJd4RimnDPWJ4UYaDdfxV86xJvAVf8YbHP3kAbxcuNkFcPl25zufNw/kd5u+MvONC0
	 27f2oIHcaV2+UnG+YxRBF23kpA5DCT0b7uoyjPII/3x2EqoIZnjxzB9dP3ZFcJvTRM
	 4cQ5zQX6rpxuFkt7ogKNF4QoSrh1qo+2Tz7mv8lf6s3itgKfvgjkT3XU99XHTJXrAB
	 cy4nPTmXJecHsSPSZjy9gRuB6Q06toLUQ1P8R8eI61xuIArTjvPyWTmU6wWzCtsvfk
	 RK3haeaFMgqXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DAC3931095;
	Thu, 14 May 2026 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: reject CHID-0 ACCEPT that matches an empty
 ism_dev slot
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177875520580.4063424.14829510725858797644.git-patchwork-notify@kernel.org>
Date: Thu, 14 May 2026 10:40:05 +0000
References: <20260511062138.2839584-1-xmei5@asu.edu>
In-Reply-To: <20260511062138.2839584-1-xmei5@asu.edu>
To: Xiang Mei <xmei5@asu.edu>
Cc: netdev@vger.kernel.org, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 ubraun@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 bestswngs@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 10 May 2026 23:21:38 -0700 you wrote:
> On the SMC-D client, slot 0 of ini->ism_dev[]/ini->ism_chid[] is
> reserved for an SMC-Dv1 device. smc_find_ism_v2_device_clnt()
> populates V2 entries starting at index 1, so when no V1 device is
> selected slot 0 is left in its kzalloc()'ed state with ism_dev[0] ==
> NULL and ism_chid[0] == 0.
> 
> smc_v2_determine_accepted_chid() then matches the peer's CHID against
> the array starting from index 0 using the CHID alone. A malicious
> peer replying to a SMC-Dv2-only proposal with d1.chid == 0 matches
> the empty slot, ini->ism_selected becomes 0, and the subsequent
> ism_dev[0]->lgr_lock dereference in smc_conn_create() faults at
> offsetof(struct smcd_dev, lgr_lock) == 0x68:
> 
> [...]

Here is the summary with links:
  - [net] net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot
    https://git.kernel.org/netdev/net/c/277740023def

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


