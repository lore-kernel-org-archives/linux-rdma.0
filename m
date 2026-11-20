Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161207;
	b=25f1cx5jz9NT9Q3ar0aqrRItJTS8hGw6m6qn6lLRd3i9+36S+vxbUsXVYh2l9PmaTgKu
	 ZIolQHCATeCDeTwxV0Bf7q2sVHlJ+C9ZxmjpKym+L0s+9pSt0oKzWRVHBLi+ZwDiGk8QI
	 0tyn6+rgcGwSn13ngknEiy1yLkr/Q0Sp72coRkxWSJTiqqMu7ng2HCS/q7QeLtbDfOGWJ
	 tQrX5dYflKbLvfx/dthjdyRU5QCBKXdd1s8hywm7PfTcKgRfnw+nz4DJt9DcJnJDJCYzP
	 fhKHpbGJCwgra8gchz7WkkjDmp0YawfjQ3JtiHxej1f6ZCREI2V+xaH83x++ueZHZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=MBnGN1+G7QKONvu/sppIkEqP3O8shLYIsU/k4MsJ54Y12RhWZpukgIQPgRXalL5qJfp7
	 Bz8RC6v/8ewDds1j+zvBjWnflQRuN7UfY/edLoUTLk/z/RGREMZIlHjmSlTOgzvtgFAut
	 +zASoJjtotY3X+cYxyMiSyRk/At09cUsnJtXwdp+USIou+eN25ZG6jLucklA/a05nYDFd
	 OKlX5gsBeQiok8NKc7HOTXUfj5ZhgHp1SE2q6QDqQvBFIBxtjxvwrAJIbpks79wE7F22/
	 S6CrdO0QpyPYlQNWzjO6bWJ9QWYXmQ/kdf97XT4Z30dkFfVATZJpINJtjI6D00TCEBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgPFHddU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E40606A325;
	Fri, 20 Nov 2026 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgPFHddU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD17B1F000C6;
	Fri, 20 Nov 2026 07:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795161206;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgPFHddUcaNfF8dEPJAqyQplvOKJ68SVVHMad5XQEcG62vhFE77Jwlzhy8w3TSjkH
	 GZJt/CrLP7/YJX4AH3Xx9J1lbZ8RX+KvgQfFb3OZ8TUVnCDjuQwsOYU+N+vZ6qmor3
	 7NT6a8AN+ZL6radLp9Q74Y7s9siFB2A1HVYq/WzE5UJE+MhhKyM6F8wBYq7s8DsmwC
	 PzOIXQBBerDk41Rg4xR271uT7notdWQ6UrbAbkU1ZFvNpAidDbGPB3Q/vTrRu42JLJ
	 XTZdAZSklCoQJvfSdYZDstrUjsU7m8/3xstk6tMy4p3nSeXNeNqTtb8C6VF7fclYCd
	 aB76Q8Yp3qjcw==
From: netdev-bot+sinfo@kernel.org
To: Aibing Chen <chenaibing@cmss.chinamobile.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH net] net/mlx5: fix a stack over-read in the QP debugfs files
Date: Fri, 20 Nov 2026 07:53:25 +0000
Message-ID: <179516120532.3291.16859269248680746966@kernel.org>
In-Reply-To: <20261120075005.843-1-chenaibing@cmss.chinamobile.com>
References: <20261120075005.843-1-chenaibing@cmss.chinamobile.com>
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
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
