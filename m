Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653F43B42EE;
	Sat, 10 Oct 2026 08:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621945; cv=none; b=Ursp2n1J82KbR/FAC/XEETMK9CCvaWBJrTeG3nx5TWmPeXzOkRhq6dGbN6G1/iRXzNAi8iRHLZjG1MnhY9k+2PcOHaRWdSsOH5wuEtsOUVrBTkJV7jlfvlA0vwQ61C954uoomzMS/R66Ly7y5iVITcZ9J74dolbzGZ8mC37Ez98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621945; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kz0Y9X8F+TmalQuBjxDNKx1/hvxzqXZpi5H/zG3+2DbtThbTDrjvS7BMgrshr3Hi/qcEBvessyTdNON1lGAfYLt3PEzWS+GT5B27fJLODQZec3hYEJOVew+3k15oqKGrvJwV9iHRXLB0jkZlAfFMzR+gpXfudyG4nnc1uAWyYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmxrwwAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmxrwwAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E061F000FF;
	Sat, 10 Oct 2026 08:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791621944;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmxrwwAHkkbhpqpJ0vWnoqOec6tV/YM7L+eowEOMvZ0rMPJNqIUxXQh24YZd8vYv+
	 mqeiCzvH63MZgtrHhNDAzsw3VeewlEE0ATK7BHscLN/pve0cfXcvtgRUV1s0vJzKca
	 LVMRI3p9RCxTvjo3kgyIukiz7mH/QrSJgautxOiRZYJYvTF4oMLjWXbX8SBhBwkv8k
	 gsXRds9Kz8wNa6FYK35CzKWOsqU+6b5T4+d+zeAUEkU2Ejl+Regx1fNtdVAEuM3Z9y
	 J7NzSyFa8rX0arwRi5heEd21wkJMnk0j3GMnhsgy4ItTuR612Aj+FgzynL/daUfe6s
	 6N3Qc0GubhT/Q==
From: netdev-bot+sinfo@kernel.org
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Tariq Toukan <tariqt@nvidia.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 John Fastabend <john.fastabend@gmail.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Eric Biggers <ebiggers@kernel.org>,
 Kees Cook <kees@kernel.org>, Michael Grzeschik <mgr@kernel.org>, Uwe 
 =?utf-8?q?Kleine-K=C3=B6nig?= =?utf-8?q?=28The?= Capable =?utf-8?q?Hub=29?=
 <u.kleine-koenig@baylibre.com>, Petr Machata <petrm@nvidia.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>,
 Jakub Raczynski <j.raczynski@samsung.com>
Subject: Re: [PATCH net-next v1 0/6] net: unify symmetric netmem and page_pool
 refcounting
Date: Sat, 10 Oct 2026 08:45:41 +0000
Message-ID: <179162194176.2527009.17837283221529280785@kernel.org>
In-Reply-To: <20261010083935.3274178-1-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
