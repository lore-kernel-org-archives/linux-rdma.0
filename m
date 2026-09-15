Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3183A3921DD;
	Tue, 15 Sep 2026 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437670; cv=none; b=WNynTHrcxZFi3HpjTgjDWfIH6iruXPY3ORFHocYfwQFrcIsdDURgcNdZY/dZL7M0bhzVw7hExNOOtYsvJYqhSQCd8oSQ4Iv+jRcjXlYTo1CpxqZX825pHzh7yahMS3fp0XACUz/u0PjHrRUDE3zpBHc20EGnAW0lcfuAklYE/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437670; c=relaxed/simple;
	bh=CNB1j9znsAKX+BUDP3qyKWIubf54joh4nCuLrk4JQOA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Vge0Eu1jKo8fFyggCuiHmoTQQ21C0Jry+i4Ft6cP6DDlLStefTv+valEBvDaEKreCatKYkx1YhpmG3WVBm6KgLQKS+xXb5MFD1IXQpclNkyQTN3YP3Nke50n9KVJeiVQVTAo5RHXJvejHiwv2mp19gfB/WsUAid4N0Hks0N2x+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE/DRL2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE/DRL2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8031F000FF;
	Tue, 15 Sep 2026 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437668;
	bh=4lh1W9VdQPFV0L8yltPv56tTJGedtDr0bsiXFIkO6pw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hE/DRL2MNkQLXHiDakbKSqm0jHDVeCpY2Yf/WmC/kt1/sgsyM7Blum3kuUnlvH+lE
	 smLYbhG5UGFHmkV3OpR/YUUdE35cITt1XAyLYIM37pK+WOQw/i5o03/7hrFZWZZoPR
	 g/Ue0ICWZxjqOdM1VT5vlyB+B/BnrR8VoZkGDyE5ta3P9eNZhrYm1FInMCSh8spNaj
	 6j24yPdesjUw4r3ZUcihjAcA0FA1E0Nj6vOwl5bVcjBpQ8NorhgrIPx45EKL6VD/qs
	 hDr14HKADKOT20445NwdnQN1eEuDX8L2C3VpL6M1D36Y7kdeE4KI3l/lCFg756f8Vb
	 /XpsrpDCTDM7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A473924FFE;
	Tue, 15 Sep 2026 02:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: ib: use rds_conn_drop() on protocol version
 mismatch
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178943760364.1310948.17134501059854121249.git-patchwork-notify@kernel.org>
Date: Tue, 15 Sep 2026 02:00:03 +0000
References: <20260911073436.3542080-1-ljp1205831794@gmail.com>
In-Reply-To: <20260911073436.3542080-1-ljp1205831794@gmail.com>
To: Aohan Mei <ljp1205831794@gmail.com>
Cc: netdev@vger.kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, henrymei@tencent.com, corvus@tencent.com,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 11 Sep 2026 15:34:32 +0800 you wrote:
> From: Aohan Mei <henrymei@tencent.com>
> 
> rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
> conn->c_cm_lock held.  When the peer negotiates a protocol version
> older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
> rds_conn_destroy(), which is only safe in the rmmod path: it
> synchronously tears the connection down and flush_work()es the
> shutdown work cp_down_w.
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: ib: use rds_conn_drop() on protocol version mismatch
    https://git.kernel.org/netdev/net/c/f97d8c7bab78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


