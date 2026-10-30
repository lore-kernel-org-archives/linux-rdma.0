Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793320171;
	b=Jio5695cZtc9UPphlOOq7FpP31HqYsvPLQHibWZR+SC+rFZzd8c4irfQF0MRMHL8FCvq
	 WsxwAFnxbKPtLAxNgDOvb7b1xMx1GjBntkgkS7O5mfzGmsLfpFJkHjyRzS6yT1eF8i0t8
	 KA93CTETLMXW/r/bvy8YeRH0IRF/cyVkHp00pl9bKwjYBKCHKZbVOitoO5L/G/6qreEBZ
	 p2JQvWJJnT6sKTL4nLH7kZM63+wfuOCUUKi1nAVLG66WibV5SwcPx54MrAFOReOVtdneF
	 EjOtgmugtDpN1lBU/NRu2c0uozRJCJwRHgxPEh3WxmNYTh2NjROYltswB/CNmZ/bLTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793320171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=QJvWMtvYfFPnhrVMH7py1PXmJ9ICJZwuIZfp9oOMNwMNExq/ZtJ2/RGO8KkKNk8kxNsv
	 Q18Nb2hnUT/LaLKuWinSHslcgnYmzwidCGsLMOCXuZRz/SObt7V11faSA0fUTCKpi5DQ5
	 498ZBLDBP3EcFMeelmvR8/SysAeFYpdp58/zakjN8RucgixgjYZrHrE00CAMSmoWgULoL
	 WPbax+3SBSbmQ41ptieU79SAFzYUTK/BRd/kYp3vow9yXG+JywDEknUA8wJs+G6WnttJB
	 8DvY0V1OXMjJzo0um9WL6pC9MOxmXk4LFLqgSEfKlOP/taePI+Tp65n02XNAGPMyLAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBASHjtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423F606A31A;
	Fri, 30 Oct 2026 00:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBASHjtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EB01F000C1;
	Fri, 30 Oct 2026 00:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793320170;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBASHjtMalyLYLtMdLmhhHvLK4681I+TAryxUAPBl/l7wk7PAW0BHEq5gQkIGMaD2
	 HI5n9JygD8NPQWO0ApHwaaIeTmA3EZ1VoEo0aMv9UfftPqx+BSKgGd7jjwR1W7KGzv
	 X+Z/rLPFUYIaOAU2Bbrv26CQGK4axfOljZ2uAg1YBII0sNSYtNx4eenhGQg+Dv5wBQ
	 qb/b09acSRHKffeCplNxXOIuQ0LUHg/XxBnXPQig6qd4qLrI6Sx+rSm2nwfllS81Gg
	 cHEqmJvHaEahGqwDsK+A5U5MMiBq05hlbuoeumXNMRmDKbYBgYeGgjDK+WQlwmkGWG
	 IxcskI+G/DmjA==
From: netdev-bot+sinfo@kernel.org
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Alex Vesker <valex@mellanox.com>,
 Erez Shitrit <erezsh@mellanox.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
Date: Fri, 30 Oct 2026 00:29:29 +0000
Message-ID: <179332016921.3327.55556569249842187@kernel.org>
In-Reply-To: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
References: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
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
