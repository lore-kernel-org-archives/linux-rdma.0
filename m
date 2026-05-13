Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6CB306D2A;
	Wed, 13 May 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696251; cv=none; b=a7tULt5OF8rJMTvBT1Pvz8eXvjGhLPHPplxPTKQZ7DV914KPSIj/kqDoY0z8gBh56hKAfuY5e/fsZeBkV6U4rWGISx2gegOso4b8+i5Rs6RYVF4egTlRL9eNmiUKpTSHnYmgGNjT8+M02rpZi7/nc7l7O/8e2HPbKyJfEedIoL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696251; c=relaxed/simple;
	bh=A+lS4kpQ3qREzW5nwkuVUTFMRxyxOn25hGYCWkfLjQs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p7MHSGAB2ANrurNVKI8hX8dcK8Qe4ctnFipB/mHoJMyZXYdBmTzdWdSWfqgU2c2APVHKCIHQHfQetJ/3fpN0QtzCzxFIzjGiWNLEMpe3vbiZBv/luT4NjY9YIG4CtEoIB4LA9oAdfgVGUqMRIx33sq5NfhOl+oK3Yk2xRpUW5Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJOcb6wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJOcb6wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C9AC19425;
	Wed, 13 May 2026 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778696251;
	bh=A+lS4kpQ3qREzW5nwkuVUTFMRxyxOn25hGYCWkfLjQs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=HJOcb6wo01uuMXmwGcVKGZ7G1SHAoJCnFnwQbLaJH7oigEN6jxWBOGfcvtyD9SjQg
	 ui5aX6JaxaDPcj8AoQz496mgfEJhg4+0QQtARzur6vh619UG6bu/bromIFNpztIUlf
	 8FRT7NINDOt/WGWWPSDeaCasM1axFWAnAd/PDEMs80xpXBSwUGwZtHRO9p0xpJIPEU
	 FitvvV0LFHgq5rwz7bN03fJhuqzKtGmnQ48wx0jB3YiAloBZ/3SdKSDayshoEYG5rq
	 I1mT8CsCb5XYljsSzORMujrYLcRByCTxJpYbjavNW0Qtht3iHBd222scbFlu5WMos5
	 7QQVOacpRaxLw==
From: Leon Romanovsky <leon@kernel.org>
To: syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com, 
 Edward Adam Davis <eadavis@qq.com>
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, davem@davemloft.net, 
 dsahern@kernel.org, edumazet@google.com, hdanton@sina.com, horms@kernel.org, 
 jgg@ziepe.ca, kuba@kernel.org, kuniyu@google.com, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
 yanjun.zhu@linux.dev, zyjzyj2000@gmail.com, 
 Kuniyuki Iwashima <kuniyu@google.com>
In-Reply-To: <tencent_611BEB4B141B1A2526BAA3BBB2335F9E9108@qq.com>
References: <tencent_611BEB4B141B1A2526BAA3BBB2335F9E9108@qq.com>
Subject: Re: [PATCH] RDMA/nldev: add mutual exclusion in nldev_dellink()
Message-Id: <177869624862.2335447.16979087766093395765.b4-ty@kernel.org>
Date: Wed, 13 May 2026 14:17:28 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 07 May 2026 20:50:10 +0800, Edward Adam Davis wrote:
> We must serialize calls to nldev_dellink() or risk a crash as syzbot
> reported:
> 
> Call Trace:
>  udp_tunnel_sock_release+0x6d/0x80 net/ipv4/udp_tunnel_core.c:197
>  rxe_release_udp_tunnel drivers/infiniband/sw/rxe/rxe_net.c:294 [inline]
>  rxe_sock_put drivers/infiniband/sw/rxe/rxe_net.c:639 [inline]
>  rxe_net_del+0xfb/0x290 drivers/infiniband/sw/rxe/rxe_net.c:660
>  rxe_dellink+0x15/0x20 drivers/infiniband/sw/rxe/rxe.c:254
> 
> [...]

Applied, thanks!

[1/1] RDMA/nldev: add mutual exclusion in nldev_dellink()
      https://git.kernel.org/rdma/rdma/c/0b28000b64f40d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

