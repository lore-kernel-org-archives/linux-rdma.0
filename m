Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2E538837A;
	Thu, 12 Mar 2026 03:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773287415; cv=none; b=eknDQLh5oYOTwMaz7luTIDfy7OxW75dMruWg5BBsuZQd3u3RC+gMosw1IId+MuN1FGpO38QHTB/WI+UHUXn5LbKivbmjaN55LNrVwfmuScAj44SA51DiUJBlN9FYANVwhtVkw1KOFr9QPwVZ+jMRwazforTn9y0Pt2WKFuei6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773287415; c=relaxed/simple;
	bh=mfZMXjOK1O4bEylimGdllB3vbq7h2+dnktb6X2p0qkI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=atnOTxITgiSpRo8LS1C1LWKW/WsCil8AvICX7PUEdc21WsGTxeTZ1WCMZwCiI7R0gqzB/EOyzfERUseAHgk7HbZQrcA0T6f+hkNP1jHw+6Mhl8oLPEwPlFr4MNg+XNmZ2FjA0x5kzDahtgpHZkmJhG+vis31yxZzbY+Y99nrpj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1ILjKYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1ILjKYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38592C4CEF7;
	Thu, 12 Mar 2026 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773287415;
	bh=mfZMXjOK1O4bEylimGdllB3vbq7h2+dnktb6X2p0qkI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=j1ILjKYVRwz/YHYyBS2t2+H9CLkA9OYDsMJlcqq0sP1xCkjpsUZrSzHNdNpHwS+Bn
	 Wl3Rk6MkIv19bkxgzIRzaCxKOBNQ7x/7RxrHA3kZSsG44i8TehMMH74Me42JXJ8WkV
	 NTJ5IfjhoNEqb39292/ihvjbomu6X/1QFS9QNiIyejjtm1la5yUswhs2+/9Lxklx49
	 wLi0zMQ15Y8e/ooYexWEj/8JEVtX6IguUVJB7UQpegAxugDqBE8whA1ZTjrBmERn1r
	 4+LF75t/wwF0gSNPxVLMsf8UR5RUybCacahFEoAnJrcXvQ6xqSJTE50Cca2vkrktgK
	 nxATlGObLd+OA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDBD3808200;
	Thu, 12 Mar 2026 03:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mana: Null service_wq on setup error to prevent
 double destroy
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177328741079.3930157.1952705775351216679.git-patchwork-notify@kernel.org>
Date: Thu, 12 Mar 2026 03:50:10 +0000
References: <20260309172443.688392-1-kotaranov@linux.microsoft.com>
In-Reply-To: <20260309172443.688392-1-kotaranov@linux.microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: shirazsaleem@microsoft.com, kotaranov@microsoft.com, pabeni@redhat.com,
 haiyangz@microsoft.com, kys@microsoft.com, edumazet@google.com,
 kuba@kernel.org, davem@davemloft.net, decui@microsoft.com,
 wei.liu@kernel.org, longli@microsoft.com, jgg@ziepe.ca, leon@kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  9 Mar 2026 10:24:43 -0700 you wrote:
> From: Shiraz Saleem <shirazsaleem@microsoft.com>
> 
> In mana_gd_setup() error path, set gc->service_wq to NULL after
> destroy_workqueue() to match the cleanup in mana_gd_cleanup().
> This prevents a use-after-free if the workqueue pointer is checked
> after a failed setup.
> 
> [...]

Here is the summary with links:
  - [net] net/mana: Null service_wq on setup error to prevent double destroy
    https://git.kernel.org/netdev/net/c/87c2302813ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


