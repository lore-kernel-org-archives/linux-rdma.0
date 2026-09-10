Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B13C4A5C4A;
	Thu, 10 Sep 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054268; cv=none; b=CiMdcK1BxIP8CWIWL+nSvAyj2kuHiiRoU8THikrFeirKHJ28npAEQkiw2dCO6rhKGL9t9RHdOF4WoChCZBZ84O+XHn/oYPZgiPVRhaFT3rhagMrxJ523HxSzfeP4vD+0oDWTSe8kC5sNQ8t3hgRka+pb2jqTCRBKZF1GXF6+JuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054268; c=relaxed/simple;
	bh=f1yVzWTtVeeT8SyrsjV5eY/chI2ENCt7jYNJrmu4prE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ft3eTLkg3UJqSulYJZEEcNgwj7l8AUAKv+dKYmCZbUDRRw9IElswsdGGK4FmIETSzKADJLHBHvN2IkZh3ZE8z73zEJf/6r5oV5F4ac4bDFC1hhkI0UNpRLQ6S/B6pyZlXHUXIENxPEAunATWh8DlgA0QwPiyq73DvI5MMY8CAvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UP7EHk+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UP7EHk+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6681F000FF;
	Thu, 10 Sep 2026 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054266;
	bh=R203kj4NwhLlXEEyQnbzDWHHyTZDyGq+LQZedwgw5R0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=UP7EHk+TGRUU95/lnVo6Cbg3UbaumvIyOPeU9H67yihg+pKQHiyG182z1pQP5Sr6i
	 pPaPHI2QewqxpkRMFzkiBEgDAD1hgd9uvx5r3aflZMKeMTK9wDy70+g1IAFbf7pBSc
	 9keqtnmXN+b754GEv1aDJW+aeG1yvT1YUG8uV03C2my8iFQlY+O7/2s/h3YpKhMTtc
	 56TuNxnecBUqf9Soqy4vpa5mhukfkD5zaH0e3NT1YOtlcG67lIt7MSWrcJOyo6wodo
	 6G3hV6JTezkYL+RwQLO5qhFgTp8Etu7TfJHSJb+RFcfmQzejh42V/CySquUC0tmFK7
	 66rbPQ4SketHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93853380CEF9;
	Thu, 10 Sep 2026 15:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/rds: fix tcp stream corruption with large pages
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178905420439.1498636.4544893733469196000.git-patchwork-notify@kernel.org>
Date: Thu, 10 Sep 2026 15:30:04 +0000
References: <apxJjxvStibPI0AS@oracle.com>
In-Reply-To: <apxJjxvStibPI0AS@oracle.com>
To: Greg Marsden <greg.marsden@oracle.com>
Cc: achender@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 5 Sep 2026 10:00:41 -0700 you wrote:
> rds_message_map_pages() assigns PAGE_SIZE bytes to every
> scatterlist entry, even when total_len ends in a partial page. The RDS
> congestion map is defined as 8192 bytes, so on systems with PAGE_SIZE
> greater than 8192 the scatterlist maps bytes beyond the end of the
> congestion map.  RDS-TCP transmits the SG contents according to those
> lengths, so the extra bytes become part of the TCP RDS stream and are
> interpreted as subsequent RDS message headers, corrupting the stream.
> 
> [...]

Here is the summary with links:
  - [net] net/rds: fix tcp stream corruption with large pages
    https://git.kernel.org/netdev/net/c/2ac09b5353fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


