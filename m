Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702073;
	b=L+PrzFGjVdeOpNqkhWF8ZVXOokG9Zzc7ivdi6awHtUMUZmaayFgnr8Dml+F5iua+fMMK
	 rTuBxgGVPobT9feD69I8tPK9UN3FkLHfKSbaCf1CXtQb26kCbUX/cZC0VJTMKuLui+tjX
	 NQ9cv202QGkkJVMmeA+iJ5kf2rb9FGaNm2BdCE+gf5ZQ9cLFBtkPrUe62D/VIz4jt1W4a
	 jH4x2wMEr3fIw6R7GPvqJmBqJCv9vwjAiA16xmkxqLcjELSuofDEYwYvQ4NfOe6W0RC6Q
	 /IgBL9gyt6uVjDXVYtwurnnygudN8TlPAnTn+XxdQcgHqQSNbsHquA2YBPhPNAqRtww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=EhPkBxrpINdpHC0tlTv8I/PU0LRnc0NMu+X0EgrkWJo1Pkz9d6gW4wok43Y2WHjlN3gE
	 UwWpf8vGSTEB37HpTcC45xHf82Y+PDDZHLPs68Wq6Ual6to8XvMoLsVddBirGSSxX27q5
	 oAl0kk+vblS37UIYs43YldOjPi4jN/r6viBlr4RNDaGFKzYMWty+GoYsSt3Sx5SZ426/v
	 CrYWyYMIjwKUtZ76lqHjYRknZkIKLsli9K/FqSZQJVxyfaGzVshFDQDZFgd/PVwSxTeo3
	 xqBfVWR9BnOxLW5virS7Xp0sWCulSW6IMgyUXsPAdOaVk1vHt9WeAUZFb2+gv4UHeAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFCaw5nb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBA26072BD1;
	Tue,  3 Nov 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NFCaw5nb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D101F00A16;
	Tue,  3 Nov 2026 10:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793702072;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFCaw5nb14ysgSgMvpct+lzB4oD240yoQWn9WN6O9vtS1TYdfmxkey4vulpeBPo76
	 9EbnWwBXdfY+XsGc1rQkt/HZpY5+XZFSJpx005rUmBVBpQqoO3t0hhTCHq04LJS8RS
	 Vj1dkJxLXEizXxnvsJHsaGjh/UvnHnB0rfZvcAFL5t80N/L2u81+mJHoPGJ20S9i1N
	 AXm9BvKaZh0PVRCEqhQQWV+rqbBWm6LgTGdtVsbJ/GM6KREqcwAXLTP3r2bSf/Kvb0
	 GBroYlvLWW95itIJRGFNdAFoUBl2fABoe/kpyHZb2IAq02B2PecQCOJgf/gZ4RXIp7
	 oQ6peepEOYlAg==
From: netdev-bot+sinfo@kernel.org
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: TC, release meter if rule offload fails
Date: Tue, 03 Nov 2026 10:34:31 +0000
Message-ID: <179370207119.488859.18377903425707726413@kernel.org>
In-Reply-To: <20261103102856.1340672-1-vulab@iscas.ac.cn>
References: <20261103102856.1340672-1-vulab@iscas.ac.cn>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
