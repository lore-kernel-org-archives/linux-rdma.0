Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909E23DA7C0;
	Tue, 29 Sep 2026 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724608; cv=none; b=RWgPsZjGITsC3QQpOIUETkXXa20QXJoY4zA/qTyikqCkEwPN7P5TQ/2VSHTOJQWGcZ9eswSa3qDSpUHZPfK25BO4Tabx9ia1sz4M5C9GlJ0tI+GlXn/35EdRydnLdQymt4YUtxrzskVWP1fsyV0ra5Wm+wu6yP7IydtO2vFAh28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724608; c=relaxed/simple;
	bh=RHPuqFE5IUDPrgakQ3fxHw6p+rRP+Xbt1zn8Ao7TgxU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NqvHeDwqu2ZoEnXH7vNF1nk7LqNi7cti6PC7ahkdhLrAWb0Ks4Lzg9+tZ76mUb0Y8iPHQrHtvzsV3fnNk5lx1WsTu1hEkH7CbxFFdGpUzzT/XzhPbpSVJOV9kp/ybs/+XwklPvweyNnewIo5ZR7ENXDMgFVV+thJmS9AB7a6yAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dU+GEiP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dU+GEiP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EDD1F000FF;
	Tue, 29 Sep 2026 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790724607;
	bh=bSA6b464WlXu6Ekw0PNtTPL5nG6ksQQ9rTAML4hwcn8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dU+GEiP2phfHKJxD6+AtS0wR9UjCBfQPhV8FEQpgTXIgslHavPZk9YnOVe6efuwtc
	 X+Rdi9lQ8T4zF1yoEBtNSZxtgqZ28/5MBzNLnqxPdjAsVqOtBrIC69pDzKJ5fLPDmK
	 Cr8PP//Da2wQIYd/JnodoEoYd8Subb1//miTrCxcYcm9/FnrAM58t+UDKuR4iuTj8f
	 9jPxrguXpHn/2QyHg5mlEzEhAyb0W0XhXFtjYyb+bufMEqcokQTtGwk8StdgZNt42z
	 o6iQ5cvmduvR7M+UdTiBU6DRo+FuIlRabEyGYnJJ3YUNGICM3lj83EC8r3oxVMNAjD
	 H6joA+5T50/Kg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A5A039D5FDD;
	Tue, 29 Sep 2026 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [for-next v3 1/5] net: ionic: Fetch qid allocation and SRQ
 capability
 from firmware
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179072460594.1164319.7269061494393053569.git-patchwork-notify@kernel.org>
Date: Tue, 29 Sep 2026 23:30:05 +0000
References: <20260925082802.2675902-2-abhijit.gangurde@amd.com>
In-Reply-To: <20260925082802.2675902-2-abhijit.gangurde@amd.com>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, allen.hubbe@amd.com, a.k@amd.com,
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Abhijit Gangurde <abhijit.gangurde@amd.com>:

On Fri, 25 Sep 2026 13:57:58 +0530 you wrote:
> Read the qid allocation and SRQ capability from the RDMA LIF identity
> reported by firmware.
> 
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
> ---
>  .../net/ethernet/pensando/ionic/ionic_if.h    | 31 +++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [for-next,v3,1/5] net: ionic: Fetch qid allocation and SRQ capability from firmware
    https://git.kernel.org/netdev/net-next/c/c73a5f20bc78
  - [for-next,v3,2/5] RDMA/ionic: support firmware-assigned CQ IDs
    (no matching commit)
  - [for-next,v3,3/5] RDMA/ionic: segregate rq related fields from ionic_qp into a new ionic_rq struct
    (no matching commit)
  - [for-next,v3,4/5] RDMA/ionic: add Shared receive queue (SRQ) support
    (no matching commit)
  - [for-next,v3,5/5] RDMA/ionic: implement SRQ event handling support
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


