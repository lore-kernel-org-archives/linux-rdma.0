Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792530608;
	b=pq1CW6voYX1KJtUvwYfEFKFnnvDWRnYOv5efFs5r+WbHUtswm6P7druB7MFSU65LrDfM
	 OFs7tM4iBJ10h+HXVeO5fS1ou2zSL9B7DAH506TfmIn8WFpFQeKi6XkcZ3Ks9BfDzn5/D
	 oo+2/MmQTzS0RIc6ty1iP/KUlmcZ5i2NAbv8I7YlKae3BKj/YZY8VRdeas+NwDvYqwHFU
	 2Q+NJ459jEBSdnFTvDsWFpjo0gsSYR5W8cnKso6OpbEgmCRHxJwu5TkwaRBaPIqqkOtTv
	 /nzfQ+HHLf3m9feYeYygz2MB46ZFLNtzlnzYnLLjwwy8ES/rcE+2NqQklb2BZtt8DOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530608;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=X0xBekH/PJ9gQjFX/Kapq3ypB5InSYa5yUK78tk9vTA=;
	b=tjliTORrR0PhT671F9/EicoWvsOzT6gw4acCtKRkqwkL7hafvAEvwhi9UWGYftaTnbcj
	 dPbet9y8imj6Yu8AdBYNGT8nSljSck97avl7wPXN2OznYayBUugvhLEz4wXLahxsueck0
	 jxdxZhHnDl6zvRpMx8Kb1qla+bIU72AYLFskrJrq/vlpDvUFx1gta3RdrMEW5BOM0cksf
	 0dj5F7G2OUwu5fBanqW1OLfZ6ANpXjnAPTNiilJ8mXUoibvthk9Q5jMHncTKLcrW/erDi
	 V9AK5t0Q/zMfB8dUI1DgRgKINSjMpG6OCvKi91aJ9LZ+PSoI6Aljm0iN74oJhZbDz3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPNQa97D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9E9606A31A;
	Tue, 20 Oct 2026 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPNQa97D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F7A1F000C9;
	Tue, 20 Oct 2026 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792530608;
	bh=X0xBekH/PJ9gQjFX/Kapq3ypB5InSYa5yUK78tk9vTA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dPNQa97DtfrVj0XNh52qGlFnxb165lQIMi8qaWHuZ5vLFIcyEHJMPVaikmpc/wZCb
	 Xaohi6BIwGUG4RsPo18DP0Tz7DLVoUNngGBUGFLb5nSV2dY9DWp4N4+kO735Q0DfNU
	 vTYhNvnfCHTTAQbsS1Yo2rcm0j9oGy1XuqOFeYPno+Jx/hoYGkWfPrWtq9cREd0EIB
	 IebA9nfD+l+iT1x9qhcPahxgZV4MOjCkTcupxybJMtnxCaXCmUeA5MI4mWff39U5aN
	 u/6a0tcxUoOSfIe06cvgNQv3j6FhKPupn1iOwAFc3Q2W99iH5atZzsDfriyzaHJhJP
	 iTQyBlQgNIBFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16363809A09;
	Tue, 20 Oct 2026 21:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/rds: ib: don't enable IRQs in rds_ib_conn_free()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179253060652.212662.1082879291044254668.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 21:10:06 +0000
References: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
In-Reply-To: <20261016161525.146537-1-ngocthang2710.1999@gmail.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: achender@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org,
 syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Oct 2026 23:15:25 +0700 you wrote:
> __rds_conn_create() calls trans->conn_free() with rds_conn_lock held
> and IRQs disabled when it loses the race to insert a connection.
> rds_ib_conn_free() takes the device list lock with spin_lock_irq() and
> releases it with spin_unlock_irq(), so IRQs are turned on while
> rds_conn_lock is still held:
> 
>   raw_local_irq_restore() called with IRQs enabled
>   WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0xc/0x20
>    _raw_spin_unlock_irqrestore+0x67/0x80
>    __rds_conn_create+0x1de5/0x2290
>    rds_conn_create_outgoing+0x43/0x60
>    rds_sendmsg+0xfca/0x20e0
>    __sys_sendto+0x408/0x5a0
> 
> [...]

Here is the summary with links:
  - net/rds: ib: don't enable IRQs in rds_ib_conn_free()
    https://git.kernel.org/netdev/net-next/c/f6fa1d60ec3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


